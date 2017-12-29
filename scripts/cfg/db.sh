#!/bin/bash -x
### create the database and user

### get $DBUSER and $DBPASS
source /host/settings.sh

### create database proxy
mysql -e "
    DROP DATABASE IF EXISTS proxy;
    CREATE DATABASE proxy;
    USE proxy;

    CREATE TABLE Association (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        hostname VARCHAR(256) NOT NULL,
        torservice VARCHAR(256) NOT NULL);

    CREATE TABLE Customers (
        ID int(11) NOT NULL AUTO_INCREMENT,
        passphrase varchar(2048) NOT NULL,
        domain_omb varchar(256) NOT NULL,
        tor_hidden varchar(256) NOT NULL,
        PRIMARY KEY (ID))
    ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4;

    GRANT ALL ON proxy.* TO $DBUSER@localhost IDENTIFIED BY '$DBPASS';
"

### create database postfix
mysql -e "
    DROP DATABASE IF EXISTS postfix;
    CREATE DATABASE postfix ;
    USE postfix;

    CREATE TABLE transport (
        ID int(11) NOT NULL AUTO_INCREMENT,
        transportation varchar(2048) NOT NULL,
        address varchar(1024) NOT NULL,
        PRIMARY KEY (ID))
    ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12;

    GRANT ALL ON postfix.* TO $DBUSER@localhost IDENTIFIED BY '$DBPASS';
"
