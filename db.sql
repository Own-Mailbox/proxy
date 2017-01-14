CREATE DATABASE IF NOT EXISTS proxy;
USE proxy;

CREATE TABLE IF NOT EXISTS
    Association (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        hostname VARCHAR(256) NOT NULL,
        torservice VARCHAR(256) NOT NULL);

CREATE TABLE IF NOT EXISTS
    Customers (
        ID int(11) NOT NULL AUTO_INCREMENT,
        passphrase varchar(2048) NOT NULL,
        domain_omb varchar(256) NOT NULL,
        tor_hidden varchar(256) NOT NULL,
        PRIMARY KEY (`ID`))
    ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4;

CREATE DATABASE postfix ;
USE postfix;

CREATE TABLE IF NOT EXISTS transport (
        ID int(11) NOT NULL AUTO_INCREMENT,
        transportation varchar(2048) NOT NULL,
        address varchar(1024) NOT NULL,
        PRIMARY KEY (`ID`)
        )
    ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=12;
