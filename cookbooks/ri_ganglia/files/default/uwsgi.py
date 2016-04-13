#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import traceback
import os
import threading
import time
import socket
import select

try:
    import simplejson as json
except ImportError:
    import json


descriptors = list()
Desc_Skel   = {}
_Worker_Thread = None
_Lock = threading.Lock() # synchronization lock
Debug = False


def dprint(f, *v):
    if Debug:
        print >>sys.stderr, "DEBUG: "+f % v

def floatable(str):
    try:
        float(str)
        return True
    except:
        return False

def socket_family(addr):
    if ':' in addr:
        return socket.AF_INET
    else:
        return socket.AF_UNIX

def socket_address(addr):
    addr_tuple = ()
    if ':' in addr:
        addr_parts = addr.split(':')
        addr_tuple = (addr_parts[0], int(addr_parts[1]))
    else:
        addr_tuple = addr
    return addr_tuple


class UpdateMetricThread(threading.Thread):

    def __init__(self, params):
        threading.Thread.__init__(self)
        self.running      = False
        self.shuttingdown = False
        self.refresh_rate = int(params["refresh_rate"])
        self.metric      = {}
        self.last_metric = {}
        self.timeout     = 2

        self.socket_address = params["socket_address"]
        self.socket_family = params["socket_family"]

        self.type = params["type"]
        self.mp = params["metrix_prefix"]

        self.metric[self.mp+"_time"] = time.time()


    def shutdown(self):
        self.shuttingdown = True
        if not self.running:
            return
        self.join()

    def run(self):
        self.running = True

        while not self.shuttingdown:
            _Lock.acquire()
            self.update_metric()
            _Lock.release()
            time.sleep(self.refresh_rate)

        self.running = False


    def _update_queue_metrics(self, metrics):
        if not 'listen_queue' in metrics:
            self.metric[self.mp+"_"+"listen_queue"] = 0
            return

        self.metric[self.mp+"_"+"listen_queue"] = metrics['listen_queue']


    def _update_request_metrics(self, metrics):
        if not 'workers' in metrics:
            self.metric[self.mp+"_"+"total_requests"] = 0
            self.metric[self.mp+"_"+"requests"] = 0
            return
                   
        workers = metrics['workers']
        self.metric[self.mp+"_"+"total_requests"] = sum([worker['requests'] for worker in workers])
                                                   
        if (self.mp+"_"+"total_requests") in self.last_metric:
            self.metric[self.mp+"_"+"requests"] = max( 0, self.metric[self.mp+"_"+"total_requests"] 
                                                    - self.last_metric[self.mp+"_"+"total_requests"] )
        else:
            self.metric[self.mp+"_"+"requests"] = 0


    def _reset_latency_metrics(self):
        self.metric[self.mp+"_"+"average_response_time"] = 0
        self.metric[self.mp+"_"+"max_response_time"] = 0

    def _update_latency_metrics(self, metrics):
        if not 'workers' in metrics:
            self._reset_latency_metrics()
            return
        
        if self.metric[self.mp+"_"+"requests"] < 1:
            self._reset_latency_metrics()
            return

        workers = metrics['workers']
        self.metric[self.mp+"_"+"average_response_time"] = sum( [(worker['avg_rt']/1000) for worker in workers] ) / len(workers)
        self.metric[self.mp+"_"+"max_response_time"] = max( [(worker['avg_rt']/1000) for worker in workers] )


    def _read_stats(self):
        sock = socket.socket(self.socket_family, socket.SOCK_STREAM)
        msg  = ""
        try:
            dprint("%s", "connecting")
            sock.connect(self.socket_address)

            while True:
                data = sock.recv(4096)
                if len(data) < 1:
                    break
                msg += data

        except socket.error, e:
            print >>sys.stderr, "ERROR: %s" % e
        finally:
            sock.close()
        return msg        

    def update_metric(self):
        msg = self._read_stats()
        self.last_metric = self.metric.copy()
        self.metric[self.mp+"_time"] = time.time()
        try:
            metrics = json.loads(msg)
            if metrics:
                self._update_request_metrics(metrics)
                self._update_latency_metrics(metrics)
                self._update_queue_metrics(metrics)
        except Exception as e:
            print >>sys.stderr, "ERROR: %s" % e

    def _calc_rate(self, mp, name):
        if (self.metric[name] - self.last_metric[name]) < 0:
            return 0

        val = 0
        num = self.metric[name]-self.last_metric[name]
        period = self.metric[mp+"_time"]-self.last_metric[mp+"_time"]
        try:
            val = num/period
        except ZeroDivisionError:
            val = 0
        return val

    def metric_of(self, name):
        val = 0
        mp = name.split("_")[0]
        if name.rsplit("_",1)[1] == "rate" and name.rsplit("_",1)[0] in self.metric:
            _Lock.acquire()
            name = name.rsplit("_",1)[0]
            val = self._calc_rate(mp, name)
            _Lock.release()
        elif name in self.metric:
            _Lock.acquire()
            val = self.metric[name]
            _Lock.release()
        return val



def metric_init(params):
    global descriptors, Desc_Skel, _Worker_Thread, Debug

    if "type" not in params:
        params["type"] = "uwsgi"

    if "metrix_prefix" not in params:
        params["metrix_prefix"] = "uwsgi"

    if "refresh_rate" not in params:
        params["refresh_rate"] = 10

    if "debug" in params:
        Debug = params["debug"]
    else:
        Debug = False

    if "socket_address" in params:
        params["socket_address"] = socket_address(params["socket_address"])
    else:
        params["socket_address"] = "/var/log/uwsgi/sstat.socket"
    
    params["socket_family"] = socket_family(params["socket_address"])

  
    print '[uwsgi] uwsgi protocol "stats"'
    if Debug:
        dprint("%s", "Debug mode on")
        print params


    _Worker_Thread = UpdateMetricThread(params)
    _Worker_Thread.start()


    # initialize skeleton of descriptors
    Desc_Skel = {
        'name'        : 'XXX',
        'call_back'   : metric_of,
        'time_max'    : 60,
        'value_type'  : 'uint',
        'format'      : '%d',
        'units'       : 'XXX',
        'slope'       : 'XXX', # zero|positive|negative|both
        'description' : 'XXX',
        'groups'      : params["type"],
        }

    # IP:HOSTNAME
    if "spoof_host" in params:
        Desc_Skel["spoof_host"] = params["spoof_host"]

    mp = params["metrix_prefix"]

    descriptors.append(create_desc(Desc_Skel, {
                "name"       : mp+"_requests",
                "units"      : "requests",
                "slope"      : "both",
                "description": "Number of requests",
                }))
    descriptors.append(create_desc(Desc_Skel, {
                "name"       : mp+"_total_requests_rate",
                "units"      : "requests/sec",
                "value_type" : 'float',
                "format"     : '%.0f',
                "slope"      : "both",
                "description": "Request rate",
                }))
    descriptors.append(create_desc(Desc_Skel, {
                "name"       : mp+"_listen_queue",
                "units"      : "length",
                "slope"      : "both",
                "description": "Number of requests waiting in queue",
                }))
    descriptors.append(create_desc(Desc_Skel, {
                "name"       : mp+"_average_response_time",
                "units"      : "ms",
                "slope"      : "both",
                "description": "Average response time in ms",
                }))
    descriptors.append(create_desc(Desc_Skel, {
                "name"       : mp+"_max_response_time",
                "units"      : "ms",
                "slope"      : "both",
                "description": "Max response time in ms",
                }))

    return descriptors


def create_desc(skel, prop):
    d = skel.copy()
    for k,v in prop.iteritems():
        d[k] = v
    return d

def metric_of(name):
    return _Worker_Thread.metric_of(name)

def metric_cleanup():
    _Worker_Thread.shutdown()



if __name__ == '__main__':
    try:
        params = {
            "socket_address" : "/var/log/uwsgi/sstat.socket",
            "refresh_rate" : 4,
            "debug" : True,
            }
        metric_init(params)

        while True:
            for d in descriptors:
                v = d['call_back'](d['name'])
                print ('value for %s is '+d['format']) % (d['name'],  v)
            time.sleep(5)
    except KeyboardInterrupt:
        time.sleep(0.2)
        os._exit(1)
    except:
        traceback.print_exc()
        os._exit(1)