# gitea-docker-compose

### Project Setup

Setup a user define docker bridge network and volumes:

```
docker network create \
--subnet 172.20.20.0/24 \
--gateway 172.20.20.1 \
--opt com.docker.network.bridge.name=docker-network \
--opt com.docker.network.bridge.enable_icc=true \
--opt com.docker.network.bridge.enable_ip_masquerade=true \
--driver bridge \
docker-network

docker volume create \
--driver local \
--opt type=none \
--opt device=$HOME/project/appdata/mariadb \
--opt o=bind \
mariadb

docker volume create \
--driver local \
--opt type=none \
--opt device=$HOME/project/appdata/code-server \
--opt o=bind \
code-server

docker volume create \
--driver local \
--opt type=none \
--opt device=$HOME/project/appdata/gitea \
--opt o=bind \
gitea

docker volume create \
--driver local \
--opt type=none \
--opt device=$HOME/project/appdata/traefik \
--opt o=bind \
traefik
```

