![](https://i.goopics.net/nI.png)

### What is this ?

Rainloop is a simple, modern & fast web-based client. More details on the [official website](http://www.rainloop.net/).

### Features

- Lightweight & secure image (no root process)
- Based on Alpine
- Latest Rainloop **Community Edition** (stable)
- Contacts (DB) : sqlite, or mysql (server not built-in)
- With Nginx and PHP7

### Build-time variables

- **GPG_FINGERPRINT** : fingerprint of signing key

### Ports

- **80**

### Environment variables

| Variable | Description | Type | Default value |
| -------- | ----------- | ---- | ------------- |
| **UID** | rainloop user id | *optional* | 991
| **GID** | rainloop group id | *optional* | 991


### Docker-compose

#### Docker-compose.yml
```
rainloop:
  image: hardware/rainloop
  container_name: rainloop
  volumes:
    - /mnt/docker/rainloop:/rainloop/data



#### Run !

```
docker-compose up -d
```
