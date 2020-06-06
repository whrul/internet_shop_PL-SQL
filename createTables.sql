drop trigger arc_fkarc_3_laptop;
drop trigger arc_fkarc_3_hardware;

drop table address cascade constraints;
drop table cart cascade constraints;
drop table cart_product cascade constraints;
drop table city cascade constraints;
drop table country cascade constraints;
drop table delivery cascade constraints;
drop table delivery_method cascade constraints;
drop table delivery_status cascade constraints;
drop table hardware cascade constraints;
drop table hardware_color cascade constraints;
drop table hardware_type cascade constraints;
drop table invoice cascade constraints;
drop table laptop cascade constraints;
drop table manufacturer cascade constraints;
drop table message cascade constraints;
drop table operating_system cascade constraints;
drop table "Order" cascade constraints;
drop table order_product cascade constraints;
drop table order_status cascade constraints;
drop table payment cascade constraints;
drop table payment_method cascade constraints;
drop table payment_status cascade constraints;
drop table product cascade constraints;
drop table "User" cascade constraints;
drop table user_status cascade constraints;

CREATE TABLE address (
    id_address           INTEGER NOT NULL,
    street               VARCHAR2(60) NOT NULL,
    house_num            VARCHAR2(10) NOT NULL,
    ap_num               VARCHAR2(10) NOT NULL,
    zip_code             VARCHAR2(20) NOT NULL,
    country_id_country   INTEGER NOT NULL,
    city_id_city         INTEGER NOT NULL
);

ALTER TABLE address ADD CONSTRAINT address_pk PRIMARY KEY ( id_address );

CREATE TABLE cart (
    id_cart        INTEGER NOT NULL,
    user_id_user   INTEGER NOT NULL
);

CREATE UNIQUE INDEX cart__idx ON
    cart (
        user_id_user
    ASC );

ALTER TABLE cart ADD CONSTRAINT cart_pk PRIMARY KEY ( id_cart );

CREATE TABLE cart_product (
    cart_id_cart         INTEGER NOT NULL,
    product_id_product   INTEGER NOT NULL,
    amount               integer not null
);

ALTER TABLE cart_product ADD CONSTRAINT cart_product_pk PRIMARY KEY ( cart_id_cart,
                                                                      product_id_product );

CREATE TABLE city (
    id_city   INTEGER NOT NULL,
    name      VARCHAR2(60) NOT NULL
);

ALTER TABLE city ADD CONSTRAINT city_pk PRIMARY KEY ( id_city );

CREATE TABLE country (
    id_country   INTEGER NOT NULL,
    name         VARCHAR2(60) NOT NULL
);

ALTER TABLE country ADD CONSTRAINT country_pk PRIMARY KEY ( id_country );

CREATE TABLE delivery (
    id_delivery                   INTEGER NOT NULL,
    order_id_order                INTEGER NOT NULL,
    delivery_status_id_status     INTEGER NOT NULL,
    delivery_method_id_method     INTEGER NOT NULL,
    address_id_address            INTEGER NOT NULL
);

CREATE UNIQUE INDEX delivery__idx ON
    delivery (
        order_id_order
    ASC );

ALTER TABLE delivery ADD CONSTRAINT delivery_pk PRIMARY KEY ( id_delivery );

CREATE TABLE delivery_method (
    id_method   INTEGER NOT NULL,
    value       VARCHAR2(40) NOT NULL
);

ALTER TABLE delivery_method ADD CONSTRAINT delivery_method_pk PRIMARY KEY ( id_method );

CREATE TABLE delivery_status (
    id_status   INTEGER NOT NULL,
    value       VARCHAR2(40) NOT NULL
);

ALTER TABLE delivery_status ADD CONSTRAINT delivery_status_pk PRIMARY KEY ( id_status );

CREATE TABLE hardware (
    id_product                INTEGER NOT NULL,
    hardware_type_id_type     INTEGER NOT NULL,
    hardware_color_id_color   INTEGER NOT NULL
);

ALTER TABLE hardware ADD CONSTRAINT hardware_pk PRIMARY KEY ( id_product );

CREATE TABLE hardware_color (
    id_color   INTEGER NOT NULL,
    value      VARCHAR2(40) NOT NULL
);

ALTER TABLE hardware_color ADD CONSTRAINT hardware_color_pk PRIMARY KEY ( id_color );

CREATE TABLE hardware_type (
    id_type   INTEGER NOT NULL,
    value     VARCHAR2(80) NOT NULL
);

ALTER TABLE hardware_type ADD CONSTRAINT hardware_type_pk PRIMARY KEY ( id_type );

CREATE TABLE invoice (
    id_invoice       INTEGER NOT NULL,
    paid_at          DATE NOT NULL,
    created_at       DATE NOT NULL,
    order_id_order   INTEGER
);

ALTER TABLE invoice ADD CONSTRAINT invoice_pk PRIMARY KEY ( id_invoice );

CREATE TABLE laptop (
    id_product               INTEGER NOT NULL,
    display                  VARCHAR2(20) NOT NULL,
    memory                   VARCHAR2(20) NOT NULL,
    cpu                      VARCHAR2(60) NOT NULL,
    gpu                      VARCHAR2(60) NOT NULL,
    operating_system_id_os   INTEGER NOT NULL
);

ALTER TABLE laptop ADD CONSTRAINT laptop_pk PRIMARY KEY ( id_product );

CREATE TABLE manufacturer (
    id_manufacturer   INTEGER NOT NULL,
    name              VARCHAR2(60) NOT NULL
);

ALTER TABLE manufacturer ADD CONSTRAINT manufacturer_pk PRIMARY KEY ( id_manufacturer );

CREATE TABLE message (
    id_message     INTEGER NOT NULL,
    text           VARCHAR2(500) NOT NULL,
    user_id_user   INTEGER
);

ALTER TABLE message ADD CONSTRAINT message_pk PRIMARY KEY ( id_message );

CREATE TABLE operating_system (
    id_os   INTEGER NOT NULL,
    name    VARCHAR2(20) NOT NULL
);

ALTER TABLE operating_system ADD CONSTRAINT operating_system_pk PRIMARY KEY ( id_os );

CREATE TABLE "Order" (
    id_order                 INTEGER NOT NULL,
    order_status_id_status   INTEGER NOT NULL,
    payment_id_payment       INTEGER,
    delivery_id_delivery     INTEGER,
    created_at               DATE NOT NULL,
    paid_at                  DATE,
    user_id_user             INTEGER NOT NULL,
    cost                     NUMBER(10, 2) NOT NULL
);

CREATE UNIQUE INDEX order__idx ON
    "Order" (
        payment_id_payment
    ASC );

CREATE UNIQUE INDEX order__idxv1 ON
    "Order" (
        delivery_id_delivery
    ASC );

ALTER TABLE "Order" ADD CONSTRAINT order_pk PRIMARY KEY ( id_order );

CREATE TABLE order_product (
    product_id_product   INTEGER NOT NULL,
    order_id_order       INTEGER NOT NULL,
    amount               integer not null,
    cur_price_per_one    number(10, 2) not null
);

ALTER TABLE order_product ADD CONSTRAINT order_product_pk PRIMARY KEY ( product_id_product,
                                                                        order_id_order );

CREATE TABLE order_status (
    id_status   INTEGER NOT NULL,
    value       VARCHAR2(40) NOT NULL
);

ALTER TABLE order_status ADD CONSTRAINT order_status_pk PRIMARY KEY ( id_status );

CREATE TABLE payment (
    id_payment                 INTEGER NOT NULL,
    order_id_order             INTEGER NOT NULL,
    payment_method_id_method   INTEGER NOT NULL,
    payment_status_id_status   INTEGER NOT NULL
);

CREATE UNIQUE INDEX payment__idx ON
    payment (
        order_id_order
    ASC );

ALTER TABLE payment ADD CONSTRAINT payment_pk PRIMARY KEY ( id_payment );

CREATE TABLE payment_method (
    id_method   INTEGER NOT NULL,
    value       VARCHAR2(40) NOT NULL
);

ALTER TABLE payment_method ADD CONSTRAINT payment_method_pk PRIMARY KEY ( id_method );

CREATE TABLE payment_status (
    id_status   INTEGER NOT NULL,
    value       VARCHAR2(40) NOT NULL
);

ALTER TABLE payment_status ADD CONSTRAINT payment_status_pk PRIMARY KEY ( id_status );

CREATE TABLE product (
    id_product                     INTEGER NOT NULL,
    name                           VARCHAR2(60) NOT NULL,
    price                          NUMBER(10, 2) NOT NULL,
    manufacturer_id_manufacturer   INTEGER NOT NULL,
    amount                         INTEGER NOT NULL,
    selector                       VARCHAR2(8) NOT NULL
);

ALTER TABLE product
    ADD CONSTRAINT ch_inh_product CHECK ( selector IN (
        'Hardware',
        'Laptop',
        'Product'
    ) );

ALTER TABLE product ADD CONSTRAINT product_pk PRIMARY KEY ( id_product );

CREATE TABLE "User" (
    id_user                 INTEGER NOT NULL,
    login                   VARCHAR2(40) NOT NULL,
    password                VARCHAR2(40) NOT NULL,
    name                    VARCHAR2(40),
    age                     INTEGER NOT NULL,
    created_at              DATE NOT NULL,
    administrator           CHAR(1) NOT NULL,
    user_status_id_status   INTEGER NOT NULL,
    cart_id_cart            INTEGER
);

CREATE UNIQUE INDEX user__idx ON
    "User" (
        cart_id_cart
    ASC );

ALTER TABLE "User" ADD CONSTRAINT user_pk PRIMARY KEY ( id_user );

CREATE TABLE user_status (
    id_status   INTEGER NOT NULL,
    value       VARCHAR2(40) NOT NULL
);

ALTER TABLE user_status ADD CONSTRAINT user_status_pk PRIMARY KEY ( id_status );

ALTER TABLE address
    ADD CONSTRAINT address_city_fk FOREIGN KEY ( city_id_city )
        REFERENCES city ( id_city );

ALTER TABLE address
    ADD CONSTRAINT address_country_fk FOREIGN KEY ( country_id_country )
        REFERENCES country ( id_country );

ALTER TABLE cart_product
    ADD CONSTRAINT cart_product_cart_fk FOREIGN KEY ( cart_id_cart )
        REFERENCES cart ( id_cart ) on delete cascade;

ALTER TABLE cart_product
    ADD CONSTRAINT cart_product_product_fk FOREIGN KEY ( product_id_product )
        REFERENCES product ( id_product );

ALTER TABLE cart
    ADD CONSTRAINT cart_user_fk FOREIGN KEY ( user_id_user )
        REFERENCES "User" ( id_user ) on delete cascade;

ALTER TABLE delivery
    ADD CONSTRAINT delivery_address_fk FOREIGN KEY ( address_id_address )
        REFERENCES address ( id_address );

ALTER TABLE delivery
    ADD CONSTRAINT delivery_delivery_method_fk FOREIGN KEY ( delivery_method_id_method )
        REFERENCES delivery_method ( id_method );

ALTER TABLE delivery
    ADD CONSTRAINT delivery_delivery_status_fk FOREIGN KEY ( delivery_status_id_status )
        REFERENCES delivery_status ( id_status );

ALTER TABLE delivery
    ADD CONSTRAINT delivery_order_fk FOREIGN KEY ( order_id_order )
        REFERENCES "Order" ( id_order ) on delete cascade;

ALTER TABLE hardware
    ADD CONSTRAINT hardware_hardware_color_fk FOREIGN KEY ( hardware_color_id_color )
        REFERENCES hardware_color ( id_color );

ALTER TABLE hardware
    ADD CONSTRAINT hardware_hardware_type_fk FOREIGN KEY ( hardware_type_id_type )
        REFERENCES hardware_type ( id_type );

ALTER TABLE hardware
    ADD CONSTRAINT hardware_product_fk FOREIGN KEY ( id_product )
        REFERENCES product ( id_product ) on delete cascade;

ALTER TABLE invoice
    ADD CONSTRAINT invoice_order_fk FOREIGN KEY ( order_id_order )
        REFERENCES "Order" ( id_order ) on delete set null;

ALTER TABLE laptop
    ADD CONSTRAINT laptop_operating_system_fk FOREIGN KEY ( operating_system_id_os )
        REFERENCES operating_system ( id_os );

ALTER TABLE laptop
    ADD CONSTRAINT laptop_product_fk FOREIGN KEY ( id_product )
        REFERENCES product ( id_product ) on delete cascade;

ALTER TABLE message
    ADD CONSTRAINT message_user_fk FOREIGN KEY ( user_id_user )
        REFERENCES "User" ( id_user ) on delete set null;

ALTER TABLE "Order"
    ADD CONSTRAINT order_delivery_fk FOREIGN KEY ( delivery_id_delivery )
        REFERENCES delivery ( id_delivery );

ALTER TABLE "Order"
    ADD CONSTRAINT order_order_status_fk FOREIGN KEY ( order_status_id_status )
        REFERENCES order_status ( id_status );

ALTER TABLE "Order"
    ADD CONSTRAINT order_payment_fk FOREIGN KEY ( payment_id_payment )
        REFERENCES payment ( id_payment );

ALTER TABLE order_product
    ADD CONSTRAINT order_product_order_fk FOREIGN KEY ( order_id_order )
        REFERENCES "Order" ( id_order ) on delete cascade;

ALTER TABLE order_product
    ADD CONSTRAINT order_product_product_fk FOREIGN KEY ( product_id_product )
        REFERENCES product ( id_product );

ALTER TABLE "Order"
    ADD CONSTRAINT order_user_fk FOREIGN KEY ( user_id_user )
        REFERENCES "User" ( id_user ) on delete set null;

ALTER TABLE payment
    ADD CONSTRAINT payment_order_fk FOREIGN KEY ( order_id_order )
        REFERENCES "Order" ( id_order ) on delete cascade;

ALTER TABLE payment
    ADD CONSTRAINT payment_payment_method_fk FOREIGN KEY ( payment_method_id_method )
        REFERENCES payment_method ( id_method );

ALTER TABLE payment
    ADD CONSTRAINT payment_payment_status_fk FOREIGN KEY ( payment_status_id_status )
        REFERENCES payment_status ( id_status );

ALTER TABLE product
    ADD CONSTRAINT product_manufacturer_fk FOREIGN KEY ( manufacturer_id_manufacturer )
        REFERENCES manufacturer ( id_manufacturer );

ALTER TABLE "User"
    ADD CONSTRAINT user_cart_fk FOREIGN KEY ( cart_id_cart )
        REFERENCES cart ( id_cart );

ALTER TABLE "User"
    ADD CONSTRAINT user_user_status_fk FOREIGN KEY ( user_status_id_status )
        REFERENCES user_status ( id_status );


CREATE OR REPLACE TRIGGER arc_fkarc_3_hardware BEFORE
    INSERT OR UPDATE OF id_product ON hardware
    FOR EACH ROW
DECLARE
    d VARCHAR2(8);
BEGIN
    SELECT
        a.selector
    INTO d
    FROM
        product a
    WHERE
        a.id_product = :new.id_product;

    IF ( d IS NULL OR d <> 'Hardware' ) THEN
        raise_application_error(-20223, 'FK Hardware_Product_FK in Table Hardware violates Arc constraint on Table Product - discriminator column selector doesn''t have value ''Hardware'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;

CREATE OR REPLACE TRIGGER arc_fkarc_3_laptop BEFORE
    INSERT OR UPDATE OF id_product ON laptop
    FOR EACH ROW
DECLARE
    d VARCHAR2(8);
BEGIN
    SELECT
        a.selector
    INTO d
    FROM
        product a
    WHERE
        a.id_product = :new.id_product;

    IF ( d IS NULL OR d <> 'Laptop' ) THEN
        raise_application_error(-20223, 'FK Laptop_Product_FK in Table Laptop violates Arc constraint on Table Product - discriminator column selector doesn''t have value ''Laptop'''
        );
    END IF;

EXCEPTION
    WHEN no_data_found THEN
        NULL;
    WHEN OTHERS THEN
        RAISE;
END;




---- Changes

alter table laptop modify (display varchar(40));

alter table message
    rename column user_id_user to to_id_user;
    
alter table message
    add from_id_user integer not null;
    
alter table message
    add constraint msg_from_user_fk foreign key (from_id_user)
        references "User" (id_user) on delete set null;


---- Uniques

alter table city
    add constraint city_name_unique unique (name);
alter table country
    add constraint country_name_unique unique (name);
alter table delivery_method
    add constraint delivery_method_unique unique (value);
alter table delivery_status
    add constraint delivery_status_unique unique (value);
alter table hardware_color
    add constraint hardware_color_unique unique (value);
alter table hardware_type
    add constraint hardware_type_unique unique (value);
alter table manufacturer
    add constraint manufacturer_name_unique unique (name);
alter table operating_system
    add constraint os_name_unique unique (name);
alter table order_status
    add constraint order_status_unique unique (value);
alter table payment_method
    add constraint payment_method_unique unique (value);
alter table payment_status
    add constraint payment_status_unique unique (value);
