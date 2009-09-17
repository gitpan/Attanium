CREATE DATABASE myapp1_dev;
USE myapp1_dev;

CREATE TABLE customer(
   id integer not null auto_increment PRIMARY KEY,
   last_name varchar(25) null,
   first_name varchar(25) not null
)engine=InnoDB;

CREATE TABLE orders(
  id integer not null auto_increment PRIMARY KEY,
  customer integer not null,
  order_status varchar(10) default "OPEN" not null,	
  order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP not null,
  CONSTRAINT orders_customer_fk FOREIGN KEY (customer) REFERENCES customer(id)
)engine=InnoDB;

INSERT INTO customer (last_name, first_name) VALUES("Doe","John");

INSERT INTO orders (customer) VALUES(  1 );
INSERT INTO orders (customer) VALUES(  1 );
INSERT INTO orders (customer) VALUES(  1 );

