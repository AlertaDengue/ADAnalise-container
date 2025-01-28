# r-script-container
docker template to run R scripts

## Building the container
```bash
docker build -t r-script-container .
```

## Running the container in an interactive terminal
```bash
docker run -v $(pwd):/app -it r-script-container Rscript /app/your_script.R arg1 arg2 arg3
```

## Running the container without a terminal
```bash
docker run  r-script-container arg1 arg2 arg3
```
