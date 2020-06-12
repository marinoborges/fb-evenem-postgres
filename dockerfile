FROM debian:buster

# Install postgres and configure locale
RUN apt update && apt install -y postgresql postgresql-contrib postgresql-client && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen && locale -a

# Run the rest of the commands as the ``postgres`` user 
USER postgres

# Load SQL
ADD bradesco_enem3.sql /tmp/bradesco_enem3.sql
ADD start.sh /usr/bin/start.sh

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
# And add ``listen_addresses`` to ``/etc/postgresql/9.3/main/postgresql.conf``
# And Start postgresql and create database
RUN	/bin/bash -c "echo \"host all  all    0.0.0.0/0  md5\" >> /etc/postgresql/*/main/pg_hba.conf" &&\
	/bin/bash -c "echo \"listen_addresses='*'\" >> /etc/postgresql/*/main/postgresql.conf" &&\
	/etc/init.d/postgresql start &&\
	psql --command "ALTER USER postgres WITH PASSWORD 'zZ0kKDEEUQnY';" &&\
	createdb --encoding='UTF-8' --locale=en_US.utf8 -O postgres --template=template0 bradesco_enem3 &&\
	psql -d bradesco_enem3 -f /tmp/bradesco_enem3.sql
	
# Expose the PostgreSQL port
EXPOSE 5432

# Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]

# Set the default command to run when starting the container
#CMD ["service", "postgresql", "start"]
#ENTRYPOINT ["service", "postgresql", "start", "&&", "tail", "-f", "/var/log/postgresql/*"]
#CMD ["service", "postgresql", "start", "&&", "tail", "-f", "/var/log/postgresql/*"]
CMD ["/usr/bin/start.sh"]
