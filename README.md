# fb-evenem-postgresql
Build:
``
docker build -t fb-evenem-postgresql .
``
Create Volumes:
``
docker volume create --name fb-evenem-postgresql-etc --opt type=none --opt o=bind --opt device=/docker-vol/fb-evenem-postgresql/etc
docker volume create --name fb-evenem-postgresql-log --opt type=none --opt o=bind --opt device=/docker-vol/fb-evenem-postgresql/log
docker volume create --name fb-evenem-postgresql-lib --opt type=none --opt o=bind --opt device=/docker-vol/fb-evenem-postgresql/lib
``
Run:
``
docker run -d --name fb-evenem-postgresql -p 5432:5432 -v fb-evenem-postgresql-etc:/etc/postgresql -v fb-evenem-postgresql-log:/var/log/postgresql -v fb-evenem-postgresql-lib:/var/lib/postgresql -it fb-evenem-postgresql
``
Create Service:
``
docker service create --name fb-evenem-postgresql --replicas=1 -p 5432:5432 --mount type=volume,source=fb-evenem-postgresql-etc,destination=/etc/postgresql --mount type=volume,source=fb-evenem-postgresql-log,destination=/var/log/postgresql --mount type=volume,source=fb-evenem-postgresql-lib,destination=/var/lib/postgresql fb-evenem-postgresql
``
