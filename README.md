# -SQL_Создание магазина цветов + удалённый доступ-
**Диаграмма:**
![image](https://user-images.githubusercontent.com/85709710/180164857-e5be3d25-8ed5-4425-9f67-1154e0fb4f0e.png)

**Описание:**
Таблицы:
1) Продукты (products) – хранится информация о наименовании (product_name), стоимости (product_amount), цвет (product_color) описание (product_description), фото (photo), идентификатора производителя (producer_id), количество в магазине (product_count_store) и количество на складе (product_count_store).
Таблица создана с учётом роста магазина и возможности хранения на складе продукции. Описание и фото - удобство как для внутреннего пользования, так и для возможности открытия интернет-магазина или расширения точек продаж.
Таблица имеет внешний ключ со ссылкой на идентификатор производителя.
2) Магазины (stores) – содержит данные: наименование магазина (store_title), телефон (phone), адрес (address).
3) Сотрудники (workers) – хранится информация о сотрудниках: фамилия (last_name), имя (first_name), возраст (age), телефон (phone), электронная почта (email), адрес (address), место работы (location) и занимаемая должность (job).
4) Информация о затратах: налоги, аренда, заработная плата (expenses) – содержит сведения о типе затрат (expense_type), сумме (expense_amount) и дате (expense_date), 
5) Закупки (purchases) – содержит в себе: наименование закупки (purchase_name), стоимость (purchase_amount), цвет (purchase_color), количество (purchase_count), дату платежа (payment_date), идентификатор производителя (producer_id).
Таблица имеет внешний ключ со ссылкой на идентификатор производителя.
6)  Поставщики (producer) – содержит данные: наименование производителя (producer_name), телефон (phone), адрес (address).
7) Информация о продажах (payments) – данные о сумме (payment_amount) и дате платежа (payment_amount).
8) Заказы на доставку (orders) – содержит данные, полученные из других таблиц: идентификатор покупателя (customer_id), идентификатор продукта (product_id), идентификатор платежа (payment_id) и дата заказа (order_date), а так же сведения о дате и времени выполнения заказа (план), дате и времени выполнения заказа (факт), отзыв.
Ссылки (внешние ключи) на информацию из таблиц: customer, product, payment и order. 
9) Зарплата (salary) – данные об идентификаторе сотрудника (worker_id), сумме (salary) и дате транзакции (date).
Для интернет-магазина мы добавим таблицы:
10) Покупатель (customers) - с данными: фамилия (first_name), имя (last_name), телефон (phone), электронная почта (email), адресс (address).
11) Продукция склада (warehouse_product) – содержит данные: идентификатор склада (warehouse_id), идентификатор закупки (purchase_id), сумма (ammount),  время поступления (insert_time).
Имеет внешний ключ к таблице закупок и таблице склада.
12) Склады (warehouses) – содержит данные: наименование склада (warehouse_name), телефон склада (phone), адрес (address).

**Скрипты создания:**

```
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
  ```
  **Подключение к удалённому серверу:**
  
  ![image](https://user-images.githubusercontent.com/85709710/180166554-918c529e-b6e4-425d-a09c-71fc675e3cf9.png)
  
```
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
```

![image](https://user-images.githubusercontent.com/85709710/180166930-b861d661-04f2-4293-aa1a-9db95c4b66d6.png)

![image](https://user-images.githubusercontent.com/85709710/180167004-e0c28cd3-7bd5-40d1-b95b-3ad16238911c.png)

![image](https://user-images.githubusercontent.com/85709710/180167050-67b39fbd-96ab-4505-ab86-1d98e7f49dcc.png)
