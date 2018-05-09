# crypto_premium_python_script

Pulling crypto premiums from okex using python.
This script will be a baseline for building some data viz later on...most likely will build it in flask.

Also thinking of doing the same thing in R, just to test out the R + shiny performance.


# crypto_premium_shiny_frontend

Biggest pain in the world [link](https://github.com/rstudio/reticulate/issues/194).
I spent all day trying to figure out why my reticulate package wasn't working.....then I realized I can't use python3!!!!!


I just quickly created a python 2.7 virtualenv from this [link](http://docs.python-guide.org/en/latest/dev/virtualenvs/)
and got it all working 




# development notes:


## Reticulate usages

Run 1 file at a time:  `py_run_file("okex_shiny.py")`

Run 1 file, but execute one of the functions: 
```
okex <- import_from_path('okex', path = ".", convert = TRUE)
okex$csv_data()
```

Import the modulem, then have another script that references it
```
	okex <- import_from_path('okex', path = ".", convert = TRUE)
	py_run_file("okex_shiny.py")
```

