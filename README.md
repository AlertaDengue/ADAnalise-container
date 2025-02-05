# r-script-container
docker template to run R scripts

## Create & populate .env file
See .env.tpl to check the required env variables in .env file

## Building the container
```bash
docker build -t adanalise .
```

## Running the container (all UFs)
```bash
docker run --env-file .env --network infodengue-dev_infodengue -i adanalise --epiweek 202022
```
