# r-script-container
docker template to run R scripts

## Install git submodules
```sh
git submodule update --init --recursive
```

## Building the container
```bash
docker build -t adanalise .
```

## Running the container in an interactive terminal
```bash
docker run -v $(pwd):/app -it adanalise Rscript /app/your_script.R arg1 arg2 arg3
```

## Running the container without a terminal
```bash
docker run adanalise arg1 arg2 arg3
```
