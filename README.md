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

## Running the Tests

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

## Test Run Order

* the test order is not randomised
* the 'log-in' test (named 01_*) and the 'log-out' test (named 99_*) should be run first and last respectively

## Running Against Browsersstack

You will need to have built the containers as per the instructions above. Once
that's done, you can run the full test suite as follows:

```cd defence-request-service-smoke-tests && BROWSERSTACK_USERNAME=username BROWSERSTACK_PASSWORD=password ./bin/smoke-tests bundle exec rake browserstack:run```

# Running a Single Browser Test, or Making Live Test Changes

Sometimes you will want to make edits against the spec/*_spec.rb files and run
tests immediately, without rebuilding docker containers.

Additionally, you might want to run a test against a single browser while you
diagnose problems with only a failing browser test.

*NOTE* You will need to have built the containers as per the instructions above.

You will need two terminal windows to be able

### In the first terminal:

Run the main containers, and leave them running the foreground to view logs:

```shell
$ docker-compose up
Recreating defencerequestservicesmoketests_db_1...
Recreating defencerequestservicesmoketests_auth_1...
[...]
```

### In the second terminal, run a container for the tests

```shell
$ docker run -t -i -v `pwd`:/usr/src \ --link defencerequestservicesmoketests_auth_1:auth \ --link defencerequestservicesmoketests_srv_1:srv \ --link defencerequestservicesmoketests_rota_1:rota \ defence-request-service-smoke:test_localbuild /bin/bash
```

Once in the container, you can list the browsers - and their associated JSON setup strings:

```shell
root@c5fcf1b33ff1:/usr/src# bundle exec rake browserstack:browsers
1: 7.0 ie XP  Windows - {"browser_version":"7.0","browser":"ie","os_version":"XP","device":null,"os":"Windows"}
2: ie 7 8.0  Windows - {"browser":"ie","os_version":"7","browser_version":"8.0","device":null,"os":"Windows"}
...
```

You can then run an individual browser test as follows:

```shell
root@c5fcf1b33ff1:/usr/src# BUILD_NUMBER=build_`date +%s` BROWSERSTACK_USERNAME=SET_THIS_TO_YOUR_USERNAME BROWSERSTACK_PASSWORD=SET_THIS_TO_YOUR_PASSWORD BROWSERSTACK_BROWSER='{"browser":"ie","os_version":"7","browser_version":"9.0","os":"Windows"}' bundle exec rspec
```

Once done, type 'exit', and press control-c in the docker-compose terminal
window.
