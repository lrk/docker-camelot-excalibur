# docker-camelot-excalibur

Camelot/Excalibur docker image

![docker-ci](https://github.com/lrk/docker-camelot-excalibur/workflows/docker-ci/badge.svg)

# How to use

```
docker pull 3lr1ck/excalibur:latest

docker run --rm -p 5000:5000 3lr1ck/excalibur:latest
```

## Configurations

| Env variable         | Usage                                                               | Default value        |
| -------------------- | ------------------------------------------------------------------- | -------------------- |
| HOST                 | configure which network interface is used for incomming connections | 0.0.0.0              |
| PORT                 | configure which port is used for incomming connections              | 5000                 |
| EXCALIBUR_HOME       | configure excalibur home directory                                  | /excalibur           |
| EXCALIBUR_SECRET_KEY | configure flask secret_key                                          | random 64 char value |

Each variable is overridable from docker command line.

Exemple: change container listenning port

```
docker run --rm -e PORT=80 -p 80:80 3lr1ck/excalibur:latest
```

# References

- [https://github.com/camelot-dev/camelot](camelot)
- [https://github.com/camelot-dev/excalibur](excalibur)
