define :ri_django_reset_db do
  Chef::Log.debug("django : init data: resetdb, syncdb, load")

  ri_django_reset_static_db do
  end

  ri_django_reset_user_db do
  end

end