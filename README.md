# gitea-docker-compose

### Project Setup



Git Clone this repo and setup a user define docker bridge network and volumes:

```
git clone https://github.com/practical-engelbart/gitea-docker-compose.git 

docker network create \
--subnet 172.20.20.0/24 \
--gateway 172.20.20.1 \
--opt com.docker.network.bridge.name=docker-network \
--opt com.docker.network.bridge.enable_icc=true \
--opt com.docker.network.bridge.enable_ip_masquerade=true \
--driver bridge \
docker-network

mkdir -p /opt/project/appdata/{mariadb,nginx,code-server,gitea,traefik,drawio}
chown -R $USER:$USER /opt/project

docker volume create \
--driver local \
--opt type=none \
--opt device=$HOME/project/appdata/mariadb \
--opt o=bind \
mariadb

docker volume create \
--driver local \
--opt type=none \
--opt device=$HOME/project/appdata/nginx \
--opt o=bind \
nginx

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

