create database if not exists ri_memcached_plugin;

create table if not exists ri_memcached_plugin.mc_container (
	mc_key varchar(64) PRIMARY KEY NOT NULL,
	mc_value varchar(1024) NOT NULL
) engine=innodb;

commit;


update innodb_memcache.containers
set name = concat("default_", db_table)
where name = "default";

insert into innodb_memcache.containers
  (name, db_schema, db_table, key_columns, value_columns,
   flags, cas_column, expire_time_column, 
   unique_idx_name_on_key)
values
  ('default', 'ri_memcached_plugin', 'mc_container', 'mc_key', 'mc_value',
   'notUsed', 'notUsed', 'notUsed',
   'PRIMARY');

commit;