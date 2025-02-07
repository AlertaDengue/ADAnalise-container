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
docker run --env-file .env --volume ./output:/app/output -i adanalise --disease dengue --epiweek 202501 # --uf RS SC PR
