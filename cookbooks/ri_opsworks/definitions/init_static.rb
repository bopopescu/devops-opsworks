define :init_static do
	ri_django_reset_static_db do
		cookbook "ri_python_django"
	end
end