FROM debian:buster

ARG PG_USER=postgres
ARG PG_HOME=/var/lib/postgresql
ARG DB_NAME=bradesco_enem3
ARG DB_PASS=zZ0kKDEEUQnY
ARG SQL_FILE=bradesco_enem3.sql.gz

# Install postgres and configure locale
RUN apt update && apt install -y gzip postgresql postgresql-contrib postgresql-client && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && locale -a

# Run the rest of the commands as the ``postgres`` user 
USER $PG_USER
WORKDIR $PG_HOME

# Load SQL
ADD $SQL_FILE .
ADD start.sh /usr/bin/start.sh

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
# And Start postgresql and create database
RUN	/bin/bash -c "echo \"host all  all    0.0.0.0/0  md5\" >> /etc/postgresql/*/main/pg_hba.conf" &&\
	/bin/bash -c "echo \"listen_addresses='*'\" >> /etc/postgresql/*/main/postgresql.conf" &&\
	/etc/init.d/postgresql start &&\
	psql --command "ALTER USER $PG_USER WITH PASSWORD 'zZ0kKDEEUQnY';" &&\
	createdb --encoding='UTF-8' --locale=en_US.utf8 -O $PG_USER --template=template0 $DB_NAME &&\
	gzip -d < $SQL_FILE | psql -d $DB_NAME
	
# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
#CMD ["service", "postgresql", "start"]
#ENTRYPOINT ["service", "postgresql", "start", "&&", "tail", "-f", "/var/log/postgresql/*"]
#CMD ["service", "postgresql", "start", "&&", "tail", "-f", "/var/log/postgresql/*"]
CMD ["/usr/bin/start.sh"]
