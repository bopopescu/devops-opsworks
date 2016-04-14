# Custom Chef Recipes for Amazon Opsworks

In case you use ELB as a loadbalancer and a fixed number of database servers these scripts are of little help.

Or as a picture, if your stack looks like this:
```
                   ELB
                    |
    -------------------------------------
    |          |            |           |
 AppServer   AppServer    AppServer    AppServer
    |          |            |           |
    ------------------------------------- 
                   |
             Database Server                 
```

* These scripts were coded to load test various infrastructure configurations.
For example *Nginx* as a Loadbalancer, or *Basho-Riak* as a database server.
* The application servers run Python-Django.
* _cookbooks_ are written as wrappers around the underlying cookbooks from [Supermarket](https://supermarket.chef.io/).

#### Features
* elastic scaling - add and remove any instance in any layer without the need of manual changes in configuration files and re-deploy of those files
* restart all instances in a layer
* drop all data and re-create the databases with fixtures
* deploy *Gatling* for Stress- and Loadtest - for example *Gatling* uses the configured Loadbalancer

#### Not supported
* rolling deploy - zero downtime when deploying a new version of the application
* seamless transition during add/remove of any instances - for example an app server instance is shutdown before the loadbalancer removed the instance from its inventory

#### How it works
1. Opsworks has the concept of *life cycle events* which trigger *custom Chef recipes*.
In Opsworks *custom Chef recipes* can be called for every *life cycle event*.

2. Information about the *layers* and *instances* is provided at runtime by Opsworks.
```ruby
layers = node[:cloud][:layers]
this_instance = node[:cloud][:instance]
this_node = node[:cloud][:this_node]
my_layer = node[:cloud][:my_layer]
```

The solution combines the two.
Whenever a *life cycle event* occurs on a *layer* a *custom recipe* is called on each *instance* of the *layer*.
The *custom recipe* reads the information of the current instances in all layers and for example uses this information to re-write a configuration file, to deploy the file and to restart an application server.


## Get Started

### Configure Opsworks Layers

### Configure Custom Recipes
configuration of the recipes is done using *custom json* in the *Stack Settings* and *attributes* of the cookbooks.

in the `ri_base attributes`

change *default.rb*
* &lt;your-domain&gt;
* &lt;your-s3-folder&gt;

#### Python-Django Services
change *services.rb*


### Opsworks Cookbooks
clone the cookbooks from [opsworks-cookbooks](https://github.com/aws/opsworks-cookbooks)
```
git clone git@github.com:aws/opsworks-cookbooks.git
```

### Run and test on Vagrant
create the vagrant box for *Chef Solo* provisions
```
vagrant up
```

edit the *Vagrantfile* to either run a defined *runlist* from *runlist.rb* or a single *custom recipe*.
start the provision with
```
vagrant provision
```

### Run on Opsworks
Configure the *layers* such that the appropriate *custom recipes* are called for all of the *life cycle events*.
