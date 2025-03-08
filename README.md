# r-script-container
docker template to run R scripts

## Create & populate .env file
See .env.tpl to check the required env variables in .env file
```sh
envsubst < .env.tpl > .env
```

## Building the container
```bash
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t adanalise .
```

## Running the container (all UFs)
```bash
docker run \
  --env-file .env \
  --user $(id -u):$(id -g) \
  --volume ./output:/app/output \
  --network infodengue-dev_infodengue \
  -i adanalise --disease dengue --epiweek 202452 # --uf RS SC PR
```
[NOTE]
You can ignore the `--network` flag if the database container's IP is in the DB_URI variable

