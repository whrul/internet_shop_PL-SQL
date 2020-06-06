--PK sequences with triggers for calling them
drop trigger address_pk_tr;
drop sequence address_pk_seq;
drop trigger cart_pk_tr;
drop sequence cart_pk_seq;
drop trigger city_pk_tr;
drop sequence city_pk_seq;
drop trigger country_pk_tr;
drop sequence country_pk_seq;
drop trigger delivery_pk_tr;
drop sequence delivery_pk_seq;
drop trigger delivery_method_pk_tr;
drop sequence delivery_method_pk_seq;
drop trigger delivery_status_pk_tr;
drop sequence delivery_status_pk_seq;
drop trigger hardware_color_pk_tr;
drop sequence hardware_color_pk_seq;
drop trigger hardware_type_pk_tr;
drop sequence hardware_type_pk_seq;
drop trigger invoice_pk_tr;
drop sequence invoice_pk_seq;
drop trigger manufacturer_pk_tr;
drop sequence manufacturer_pk_seq;
drop trigger message_pk_tr;
drop sequence message_pk_seq;
drop trigger operating_system_pk_tr;
drop sequence operating_system_pk_seq;
drop sequence order_pk_seq;
drop trigger order_status_pk_tr;
drop sequence order_status_pk_seq;
drop trigger payment_pk_tr;
drop sequence payment_pk_seq;
drop trigger payment_method_pk_tr;
drop sequence payment_method_pk_seq;
drop trigger payment_status_pk_tr;
drop sequence payment_status_pk_seq;
drop sequence product_pk_seq;
drop sequence user_pk_seq;
drop trigger user_status_pk_tr;
drop sequence user_status_pk_seq;

create sequence address_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger address_pk_tr
before insert on address
for each row
begin
:new.id_address := address_pk_seq.nextVal;
end;

create sequence cart_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger cart_pk_tr
before insert on cart
for each row
begin
:new.id_cart := cart_pk_seq.nextVal;
end;

create sequence city_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger city_pk_tr
before insert on city
for each row
begin
:new.id_city := city_pk_seq.nextVal;
end;

create sequence country_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger country_pk_tr
before insert on country
for each row
begin
:new.id_country := country_pk_seq.nextVal;
end;

create sequence delivery_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger delivery_pk_tr
before insert on delivery
for each row
begin
:new.id_delivery := delivery_pk_seq.nextVal;
end;

create sequence delivery_method_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger delivery_method_pk_tr
before insert on delivery_method
for each row
begin
:new.id_method := delivery_method_pk_seq.nextVal;
end;

create sequence delivery_status_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger delivery_status_pk_tr
before insert on delivery_status
for each row
begin
:new.id_status := delivery_status_pk_seq.nextVal;
end;

create sequence hardware_color_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger hardware_color_pk_tr
before insert on hardware_color
for each row
begin
:new.id_color := hardware_color_pk_seq.nextVal;
end;

create sequence hardware_type_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger hardware_type_pk_tr
before insert on hardware_type
for each row
begin
:new.id_type := hardware_type_pk_seq.nextVal;
end;

create sequence invoice_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger invoice_pk_tr
before insert on invoice
for each row
begin
:new.id_invoice := invoice_pk_seq.nextVal;
end;

create sequence manufacturer_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger manufacturer_pk_tr
before insert on manufacturer
for each row
begin
:new.id_manufacturer := manufacturer_pk_seq.nextVal;
end;

create sequence message_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger message_pk_tr
before insert on message
for each row
begin
:new.id_message := message_pk_seq.nextVal;
end;

create sequence operating_system_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger operating_system_pk_tr
before insert on operating_system
for each row
begin
:new.id_os := operating_system_pk_seq.nextVal;
end;

create sequence order_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;

create sequence order_status_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger order_status_pk_tr
before insert on order_status
for each row
begin
:new.id_status := order_status_pk_seq.nextVal;
end;

create sequence payment_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger payment_pk_tr
before insert on payment
for each row
begin
:new.id_payment := payment_pk_seq.nextVal;
end;

create sequence payment_method_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger payment_method_pk_tr
before insert on payment_method
for each row
begin
:new.id_method := payment_method_pk_seq.nextVal;
end;

create sequence payment_status_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger payment_status_pk_tr
before insert on payment_status
for each row
begin
:new.id_status := payment_status_pk_seq.nextVal;
end;

create sequence product_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;

create sequence user_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;

create sequence user_status_pk_seq
 start with 1
 nomaxvalue
 increment by 1
 cache 20;
create or replace trigger user_status_pk_tr
before insert on user_status
for each row
begin
:new.id_status := user_status_pk_seq.nextVal;
end;















