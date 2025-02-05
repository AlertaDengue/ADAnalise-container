# r-script-container
docker template to run R scripts

## Install git submodules
```sh
git submodule update --init --recursive
```

## Create & populate .env file
See .env.tpl to check the required env variables in .env file


## Building the container
```bash
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t adanalise .
```

## Running the container (all UFs)
```bash
docker run --env-file .env --network infodengue-dev_infodengue -i adanalise --epiweek 202022
```
