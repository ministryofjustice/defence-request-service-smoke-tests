# Running locally in Docker

## Installing Docker

* Install boot2docker and docker-compose (See https://docs.docker.com/installation/mac/ and http://docs.docker.com/compose/install/ for details)
* Run ```boot2docker ip``` to get the IP address of the docker server
* You may need to run ```boot2docker up`` to get the VM running
* Run ```boot2docker shellinit`` to display the environment variables you should set. You may need to edit your ~/.bash_profile (or equivalent)
	and set these variables, as well as open a new shell

## First time Running the Containers

The **first time** you want to run things in Docker (or each time you adjust your Gemfile) you will need to do the following:

* Build your local containers:
```
cd defence-request-service && make production_container && cd ..
cd defence-request-service-auth && make production_container && cd ..
cd defence-request-service-rota && make production_container && cd ..
cd defence-request-service-smoke-tests && make && cd ..
```

## Running in the Tests

Note that docker-compose.yml assumes you have the other projects (auth, service, and rota) in the parent directory:

```
your-mac-name:ministryofjustice you$ ls -lad defence-request-service*
drwxr-xr-x  34 you  staff  1156 21 Apr 23:55 defence-request-service
drwxr-xr-x  34 you  staff  1156 23 Apr 11:21 defence-request-service-auth
drwxr-xr-x  31 you  staff  1054 22 Apr 17:08 defence-request-service-rota
drwxr-xr-x  12 you  staff   408 23 Apr 11:29 defence-request-service-smoke-tests
your-mac-name:ministryofjustice you$
```

Once initialised, running the tests should be as simple as the
following:

``` cd defence-request-service-smoke-tests && ./bin/smoke-tests ```

## Running Against Browsersstack

You will need to have built the containers as per the instructions above.

``` cd defence-request-service-smoke-tests && BROWSERSTACK_USERNAME=username BROWSERSTACK_PASSWORD=password ./bin/smoke-tests bundle exec rake browserstack:run```

## Test Run Order
* the test order is not randomised
* the 'log-in' test (named 01_*) and the 'log-out' test (named 99_*) should be run first and last respectively
