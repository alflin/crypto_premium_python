R Shiny Notes


# Installing packages as root:

sudo su - -c "R -e \"install.packages('reticulate', repos='http://cran.rstudio.com/')\""
sudo su - -c "R -e \"install.packages('readr', repos='http://cran.rstudio.com/')\""

# preserving logs:
https://stackoverflow.com/questions/39377437/accessing-error-log-in-shiny-server-deployed-on-aws-instance

options(shiny.sanitize.errors = FALSE)
sudo nano /etc/shiny-server/shiny-server.conf

cd /var/log/shiny-server/


# Resetting shiny server
$ sudo systemctl restart shiny-server



/srv/shiny-server/crypto_premium_python/crypto_premium_shiny


# other sources
https://deanattali.com/blog/advanced-shiny-tips/




