#DOCKER-H5AI

##RUN with a basic nginx configuration file



```
$ sudo docker run -d 
  -p 80:80 \ 
  -v $PWD:/var/www \
  -v $PWD/nginx_config_examples/basic_h5ai.nginx.conf:/etc/nginx/sites-enabled/h5.conf
  paulvalla/h5ai
```

##In order to enable https

1. Generate a password file
2. Create nginx conf file
3. HTTPS3. 

