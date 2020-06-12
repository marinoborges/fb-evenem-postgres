#!/bin/bash
service postgresql start
sleep 5;
tail -f /var/log/postgresql/*
