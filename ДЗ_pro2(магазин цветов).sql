create schema flower_shop

create table cities (
	city_id serial primary key,
	city varchar(50),
	country_id integer)

create table address (
	address_id serial primary key,
	district varchar(50) not null,
	city_id integer not null,
	street varchar(100) not null,
	building varchar(10),
	appartament varchar(10),
	foreign key (city_id) references cities(city_id)
	)
	
CREATE TABLE customers (
	customer_id serial,
	first_name varchar(100) NOT NULL,
	last_name varchar(100) NOT NULL,
	phone _text NULL,
	email varchar(100) NULL,
	address_id integer NOT NULL,
	CONSTRAINT customers_email_key UNIQUE (email),
	CONSTRAINT customers_pkey PRIMARY KEY (customer_id),
	foreign key (address_id) references address(address_id)
);


CREATE TABLE expenses (
	expense_id serial PRIMARY KEY,
	expense_type varchar(50) NOT NULL,
	expense_amount numeric(10, 2) NOT NULL,
	expense_date timestamp NULL
	);

CREATE TABLE payments (
	payment_id serial PRIMARY KEY,
	payment_amount numeric(10, 2) NOT NULL,
	payment_date timestamp NULL DEFAULT now()
	);

CREATE TABLE orders (
	orders_id serial PRIMARY KEY,
	customer_id integer NOT null,
	payment_id integer null references payments(payment_id),
	order_date timestamp NOT NULL,
	date_and_time_of_order_completion_plan timestamp NULL,
	date_and_time_of_order_completion_fact timestamp NULL
	);


CREATE TABLE producer (
	producer_id serial PRIMARY KEY,
	producer_name varchar(100) NOT NULL,
	phone _text NULL,
	address_id integer not null,
	CONSTRAINT producer_producer_name_key UNIQUE (producer_name),
	foreign key (address_id) references address(address_id)
);

CREATE TABLE products (
	product_id serial PRIMARY KEY,
	product_name varchar(50) NOT NULL,
	product_amount numeric(10, 2) NOT NULL,
	product_color varchar(30) NOT NULL,
	product_description varchar(1000) NULL,
	photo _bytea NULL,
	product_count_store integer NOT NULL,
	product_count_warehouse integer NOT NULL,
	producer_id integer references producer(producer_id),
	CONSTRAINT products_product_name_key UNIQUE (product_name)
);

CREATE table "order"(
	orders_id integer references orders(orders_id),
	product_id integer references products(product_id),
	quantity integer NOT null
	)

CREATE TABLE purchases (
	purchase_id serial PRIMARY KEY,
	purchase_name varchar(50) NOT NULL,
	purchase_amount numeric(10, 2) NOT NULL,
	purchase_color varchar(30) NOT NULL,
	purchase_count integer NOT NULL,
	payment_date timestamp NULL,
	CONSTRAINT purchases_purchase_name_key UNIQUE (purchase_name)
);


CREATE TABLE stores (
	store_id serial PRIMARY KEY,
	store_title varchar(100) NOT NULL,
	phone _text NULL,
	address_id integer not null,
	CONSTRAINT stores_store_title_key UNIQUE (store_title),
	foreign key (address_id) references address(address_id)
);

CREATE TABLE warehouses (
	warehouse_id serial,
	warehouse_name varchar(100) NOT NULL,
	phone _text NULL,
	address_id integer not null,
	CONSTRAINT warehouses_pkey PRIMARY KEY (warehouse_id),
	foreign key (address_id) references address(address_id)
);

CREATE TABLE warehouse_product (
	id serial PRIMARY KEY,
	product_id integer NOT null references products(product_id),
	warehouse_id integer NOT null references warehouses(warehouse_id),
	purchase_id integer NOT null references purchases(purchase_id),
	ammount integer NOT NULL,
	insert_time time NOT NULL
	);

	
CREATE TABLE workers (
	worker_id serial PRIMARY KEY,
	last_name varchar(50) NOT NULL,
	first_name varchar(30) NOT NULL,
	birthday timestamp NOT NULL,
	phone _text NULL,
	email varchar(100) NULL,
	address_id integer references address(address_id) not null,
	address_job_id integer references address(address_id) NOT NULL,
	job varchar(50) NOT NULL,
	expense_id integer references expenses (expense_id),
	CONSTRAINT workers_email_key UNIQUE (email)
	);
