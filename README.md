# README


# Prerequirement:

- Docker

# How to start application

#### How to build application
```
docker build -t rubyapp .
```
#### How to see docker images
```
docker images
```

#### To create a container from this image, run
```
docker run -p 3000:3000 rubyapp
```

#### Using docker compose
```
docker compose up
docker compose run app rails [rails commands]
docker compose build
docker compose run app rails db:create
docker compose run app rails db:migrate
docker compose run app rails db:seed
docker compose run app rails assets:precompile

```
### nuke docker commands
```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
```