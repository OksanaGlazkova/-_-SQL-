На удалённом сервере:

create schema flower_shop

CREATE TABLE flower_shop.payments (
	payment_id serial PRIMARY KEY,
	payment_amount numeric(10, 2) NOT NULL,
	payment_date timestamp NULL DEFAULT now()
	)
	
insert into flower_shop.payments (payment_amount)
values
		(12000),
		(15000)

CREATE TABLE flower_shop.orders_1 (
	orders_id serial PRIMARY KEY,
	customer_id integer NOT null,
	payment_id integer null references payments(payment_id),
	order_date timestamp NOT NULL,
	date_and_time_of_order_completion_plan timestamp NULL,
	date_and_time_of_order_completion_fact timestamp NULL
	);

insert into orders_1 (customer_id, payment_id, order_date)
values
		(4, 4, now())
		
На локальном:
	
create extension postgres_fdw


--drop server outer_postgres11 cascade

--drop extension postgres_fdw cascade

create server outer_postgres11
	foreign data wrapper postgres_fdw
	options(host '84.201.165.42', dbname 'dvd-rental', port '19001');

create user mapping for postgres
        server outer_postgres11
        options (user 'netology', password 'NetoSQL2019'); 
        
create foreign table orders_1 (
	orders_id serial,
	customer_id integer NOT null,
	payment_id integer NOT null,
	order_date date NOT NULL,
	date_and_time_of_order_completion_plan timestamp NULL,
	date_and_time_of_order_completion_fact timestamp NULL
	) 
server outer_postgres11
options(schema_name 'flower_shop', table_name 'orders_1')

create foreign table flower_shop.payments1 (
	payment_id serial,
	payment_amount numeric(10, 2) NOT NULL,
	payment_date timestamp NULL DEFAULT now()
	) 
server outer_postgres11
options(schema_name 'flower_shop', table_name 'payments')

select *
from orders_1

select *
from payments1

select *
from payments1
left join orders_1 using(payment_id)

update payments1
set payment_amount = '20000'
where payment_id = 1

update orders_1
set order_date = '2021-09-10'
where orders_id = 5
