define :init_data do
	ri_django_reset_db do
		cookbook "ri_python_django"
	end
end
