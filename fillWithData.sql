-- compile sequnces before - file PKSequencesTriggers.sql

-- use block for generating data located after package body

alter session set nls_date_format = 'dd-mon-yyyy hh:mi:ss pm';

drop package fill_with_data;

create or replace package fill_with_data is
procedure fillAddresses;
procedure fillUsers;
procedure fillProducts;
procedure fillOrders;
procedure fillMessages;
procedure fillInvoices;
procedure fillCartProduct;
procedure fillAllData;
procedure dropAllData;
end fill_with_data;

create or replace package body fill_with_data is
 procedure fillAddresses
 as
    type streetsArray IS VARRAY(20) OF VARCHAR2(60); 
    type houseNumsArray IS VARRAY(20) OF VARCHAR2(10);
    type apNumsArray IS VARRAY(26) OF VARCHAR2(10);
    type zipsArray IS VARRAY(12) OF VARCHAR2(20);
    type citiesArray IS VARRAY(6) OF VARCHAR2(20);
    type countriesArray IS VARRAY(1) OF VARCHAR2(20);
    streets streetsArray := streetsArray('Baranowska', 'Lipkowska', 'Zasieki', 'Mlynska', 'Malwowa', 'Lazienkowska', 'Czarnoleska', 'Malej Zabki', 'Szawelska', 'Borowika', 'Szachowa', 'Choinkowa', 'Spadkowa', 'Kolibrow', 'Panska', 'Wodna', 'Konopacka','Domowa', 'Marmurowa');
    houseNums houseNumsArray := houseNumsArray('1', '2', '3', '4', '5', '6', '7', '13', '15', '19', '22', '25', '28', '31', '35', '37', '47', '51', '53', '57');
    apNums apNumsArray := apNumsArray('1', '2', '3', '4', '5', '6', '7', '13', '15', '19', '22', '25', '28', '31', '35', '37', '47', '51', '53', '57', '75', '96', '103', '250', '314', '456');
    zips zipsArray := zipsArray('00-001', '00-006', '00-010', '00-014', '00-018', '00-019', '00-022', '00-024', '00-026', '00-031', '00-034', '00-036');
    cities citiesArray := citiesArray('Warsaw', 'Krakow', 'Lodz', 'Gdansk', 'Wroclaw', 'Poznan');
    countries countriesArray := countriesArray('Poland');
    idCountry integer;
    idCity integer;
    indStreet integer;
    indHouseNum integer;
    indApNum integer;
    indZip integer;
    totalCountries integer;
    totalCities integer;
    tmp integer;
 begin
    for counter in 1..(countries.count)
    loop
        insert into country(name) values (countries(counter));
    end loop;
    
    for counter in 1..(cities.count)
    loop
        insert into city(name) values (cities(counter));
    end loop;
    
    select count(*) into totalCountries from country;
    select count(*) into totalCities from city;
    
    for counter in 1..100
    loop
        tmp := floor(dbms_random.value * totalCountries) + 1;
        select id_country into idCountry
            from (select t.id_country, rownum r_num
                from (select id_country from country order by id_country asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
         
        tmp := floor(dbms_random.value * totalCities) + 1;
        select id_city into idCity
            from (select t.id_city, rownum r_num
                from (select id_city from city order by id_city asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
         
        indStreet := floor(dbms_random.value * streets.count) + 1;
        indHouseNum := floor(dbms_random.value * houseNums.count) + 1;
        indApNum := floor(dbms_random.value * apNums.count) + 1;
        indZip := floor(dbms_random.value * zips.count) + 1;
         
        insert into address(street, house_num, ap_num, zip_code, country_id_country, city_id_city)
            values (streets(indStreet), 
                    houseNums(indHouseNum),
                    apNums(indApNum),
                    zips(indZip),
                    idCountry,
                    idCity);
    end loop;
 end fillAddresses;
 
 procedure fillUsers
 as
    type namesArray IS VARRAY(26) OF VARCHAR2(40); 
    names namesArray := namesArray('Ada', 'Adamina', 'Adela', 'Adria', 'Adrianna', 'Agata', 'Agnieszka', 'Aida', 'Alberta', 'Alicja', 'Alojza', 'Amanda', 'Dalia', 'Diana', 'Felicja', 'Kinga', 'Klaudia', 'Adam', 'Andrzej', 'Bogdan', 'Bogusz', 'Denis', 'Derwit', 'Florian', 'Lukasz', 'Marcel');
    type loginSufArray IS VARRAY(4) OF VARCHAR2(10);
    loginSuf loginSufArray := loginSufArray('@gmail.com', '@yahoo.com', '@pw.edu.pl', '@dev.org');
    type symbolsArray IS VARRAY(31) OF VARCHAR2(1);
    symbols symbolsArray := symbolsArray('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5');
    login varchar2(40);
    pswd varchar2(40);
    age_v integer;
    indNames integer;
    idStatus integer;
    totalStatus integer;
    tmp integer;
    idNewUser integer;
 begin
    insert into user_status(value) values ('active');
    insert into user_status(value) values ('blocked');
    
    select count(*) into totalStatus from user_status;
    
    for counter in 1..500
    loop
        login := '';
        for i in 1..10
        loop
            login := login || symbols(floor(dbms_random.value * symbols.count) + 1);
        end loop;
        login := login || loginSuf(floor(dbms_random.value * loginSuf.count) + 1);
        
        pswd := '';
        for i in 1..15
        loop
            pswd := pswd || symbols(floor(dbms_random.value * symbols.count) + 1);
        end loop;
        
        indNames := floor(dbms_random.value * names.count) + 1;
        
        age_v := floor(dbms_random.value * 50) + 16;
        
        tmp := floor(dbms_random.value * totalStatus) + 1;
        select id_status into idStatus
            from (select t.id_status, rownum r_num
                from (select id_status from user_status order by id_status asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        select user_pk_seq.nextVal into idNewUser from dual;
        insert into "User"(id_user, login, password, name, age, created_at, administrator, user_status_id_status)
            values(idNewUser,
                   login,
                   pswd,
                   names(indNames),
                   age_v,
                   sysdate - floor(dbms_random.value * 500) - 30,
                   '0',
                   idStatus);
        
        insert into cart (user_id_user) values (idNewUser);
        
        update "User" set 
            cart_id_cart = (select id_cart from cart where user_id_user = idNewUser) 
            where id_user = idNewUser;
            
    end loop;
    
    update "User" set administrator = '1' 
        where id_user = (select min(id_user) from "User");    
 end fillUsers;
 
 procedure fillProducts
 as
    totalHardwType integer;
    idType integer;
    totalHardwColor integer;
    idColor integer;
    name_v varchar(60);
    totalMan integer;
    idMan integer;
    type displaysArray IS VARRAY(5) OF VARCHAR2(40);
    displays displaysArray := displaysArray('15.6 (1920 x 1080 (Full HD))', '14 (1920 x 1080 (Full HD))', '15.6 (1366 x 768 (HD))', '13 (2160 x 1440)', '13.3 (2560 x 1600)');
    type memoriesArray IS VARRAY(4) OF VARCHAR2(20);
    memories memoriesArray := memoriesArray('4 GB DDR4', '8 GB DDR4', '4 GB DDR3', '8 GB DDR3'); 
    type graphsArray IS VARRAY(4) OF VARCHAR2(60);
    graphs graphsArray := graphsArray(' Intel UHD 605', 'AMD Radeon Vega 8', 'Intel HD', 'NVIDIA GeForce GTX 1660Ti');
    type procsArray IS VARRAY(5) OF VARCHAR2(60);
    procs procsArray := procsArray('AMD Ryzen 5 3550H', 'Intel Pentium Silver N5000', 'Intel Celeron N3060', 'AMD Ryzen 5 3500U', 'Intel Core i5');
    totalOS integer;
    idOS integer;
    indDisplay integer;
    indMemory integer;
    indGraph integer;
    indProc integer;
    tmp integer;    
    idNewProduct integer;
 begin
    insert into hardware_color(value) values ('black');
    insert into hardware_color(value) values ('white');
    insert into hardware_color(value) values ('orange');
    
    insert into hardware_type(value) values ('headphones');
    insert into hardware_type(value) values ('USB stick');
    insert into hardware_type(value) values ('optical mouse');
    insert into hardware_type(value) values ('keyboard');
    insert into hardware_type(value) values ('wireless keyboard');
    
    insert into manufacturer(name) values ('SONY');
    insert into manufacturer(name) values ('JBL');
    insert into manufacturer(name) values ('Logitech');
    insert into manufacturer(name) values ('HP');
    insert into manufacturer(name) values ('Dell');
    insert into manufacturer(name) values ('Asus');
    insert into manufacturer(name) values ('Acer');
    insert into manufacturer(name) values ('Apple');
    insert into manufacturer(name) values ('Lenovo');
    
    insert into operating_system(name) values ('Windows 10 Home PL');
    insert into operating_system(name) values ('macOS Mojave');
    insert into operating_system(name) values ('macOS Sierra');
    insert into operating_system(name) values ('none');
    

    select count(*) into totalHardwType from hardware_type;
    select count(*) into totalHardwColor from hardware_color;
    select count(*) into totalOS from operating_system;
    select count(*) into totalMan from manufacturer;

--   counter should be > 5 - fillOrders()
    for counter in 1..500   
    loop
        name_v := 'hardware ' || counter;
               
        tmp := floor(dbms_random.value * totalHardwType) + 1;
        select id_type into idType
            from (select t.id_type, rownum r_num
                from (select id_type from hardware_type order by id_type asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        
        tmp := floor(dbms_random.value * totalHardwColor) + 1;
        select id_color into idColor
            from (select t.id_color, rownum r_num
                from (select id_color from hardware_color order by id_color asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        
        tmp := floor(dbms_random.value * totalMan) + 1;
        select id_manufacturer into idMan
            from (select t.id_manufacturer, rownum r_num
                from (select id_manufacturer from manufacturer order by id_manufacturer asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        
        select product_pk_seq.nextVal into idNewProduct from dual;
        
        insert into product(id_product, name, price, manufacturer_id_manufacturer, amount, selector)
        values (idNewProduct,
                name_v,
                dbms_random.value * 200 + 50,
                idMan,
                floor(dbms_random.value * 200),
                'Hardware');
                
        insert into hardware(id_product, hardware_type_id_type, hardware_color_id_color)
        values (idNewProduct,
                idType,
                idColor);
    end loop;
  
--   counter should be > 5 - fillOrders()
    for counter in 501..1000 
    loop
        name_v := 'laptop ' || counter;
        
        indDisplay := floor(dbms_random.value * displays.count) + 1;
        indMemory := floor(dbms_random.value * memories.count) + 1;
        indGraph := floor(dbms_random.value * graphs.count) + 1;
        indProc := floor(dbms_random.value * procs.count) + 1;
        
        tmp := floor(dbms_random.value * totalOS) + 1;
        select id_os into idOS
            from (select t.id_os, rownum r_num
                from (select id_os from operating_system order by id_os asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        
        tmp := floor(dbms_random.value * totalMan) + 1;
        select id_manufacturer into idMan
            from (select t.id_manufacturer, rownum r_num
                from (select id_manufacturer from manufacturer order by id_manufacturer asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        
        select product_pk_seq.nextVal into idNewProduct from dual;
        
        insert into product(id_product, name, price, manufacturer_id_manufacturer, amount, selector)
        values (idNewProduct,
                name_v,
                dbms_random.value * 10000 + 1000,
                idMan,
                floor(dbms_random.value * 200),
                'Laptop');
                
        insert into laptop(id_product, display , memory, cpu, gpu, operating_system_id_os)
        values (idNewProduct,
                displays(indDisplay),
                memories(indMemory),
                procs(indProc),
                graphs(indGraph),
                idOS);
    end loop;
 end fillProducts;
 
  procedure fillOrders
 as
    totalStatus integer;
    userAccCreate date;
    orderCreate date;
    tmp integer;
    idOrderCompSt integer;
    idOrderFailSt integer;
    idPayCompSt integer;
    idPayFailSt integer;
    idZam integer;
    totalPayMeth integer;
    idPayMeth integer;
    totalDelMeth integer;
    idDelMeth integer;
    idDelCompSt integer;
    totalAddresses integer;
    idAddress integer;
    idUser integer;
    totalUsers integer;
    idProduct integer;
    totalProducts integer;
    costOrder number(10,2);
    costOrderHelp1 number(10,2);
    costOrderHelp2 number(10,2);
    idNewOrder integer;
 begin
    select count(*) into totalAddresses from address;
    select count(*) into totalUsers from "User";
    select count(*) into totalProducts from product;
    
    insert into order_status(value) values('draft');
    insert into order_status(value) values('failure');
    insert into order_status(value) values('in progress');
    insert into order_status(value) values('delivered');
    select count(*) into totalStatus from order_status;
    select id_status into idOrderCompSt from order_status where value = 'delivered';
    select id_status into idOrderFailSt from order_status where value = 'failure';
    
    insert into delivery_status(value) values('preparing');
    insert into delivery_status(value) values('during');
    insert into delivery_status(value) values('finished');
    select id_status into idDelCompSt from delivery_status where value = 'finished';

    insert into delivery_method(value) values('own address');
    insert into delivery_method(value) values('firm address');
    select count(*) into totalDelMeth from delivery_method;
    
    insert into payment_status(value) values('failure');
    insert into payment_status(value) values('during');
    insert into payment_status(value) values('success');
    select id_status into idPayCompSt from payment_status where value = 'success';
    select id_status into idPayFailSt from payment_status where value = 'failure';

    insert into payment_method(value) values('pay pal');
    insert into payment_method(value) values('credit card');
    select count(*) into totalPayMeth from payment_method;
    
    for counter in 1..750
    loop
        tmp := floor(dbms_random.value * totalPayMeth) + 1;
        select id_method into idPayMeth
            from (select t.id_method, rownum r_num
                from (select id_method from payment_method order by id_method asc) t
                    where rownum <= tmp)
        where r_num >= tmp;

        tmp := floor(dbms_random.value * totalDelMeth) + 1;
        select id_method into idDelMeth
            from (select t.id_method, rownum r_num
                from (select id_method from delivery_method order by id_method asc) t
                    where rownum <= tmp)
        where r_num >= tmp;

        tmp := floor(dbms_random.value * totalAddresses) + 1;
        select id_address into idAddress
            from (select t.id_address, rownum r_num
                from (select id_address from address order by id_address asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        
        tmp := floor(dbms_random.value * totalUsers) + 1;
        select id_user into idUser
            from (select t.id_user, rownum r_num
                from (select id_user from "User" order by id_user asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        
        select created_at into userAccCreate from "User" where id_user = idUser;
        orderCreate := userAccCreate + floor(dbms_random.value * (sysdate - userAccCreate));
        
        select order_pk_seq.nextVal into idNewOrder from dual;
        
        insert into "Order"(id_order, order_status_id_status, created_at, paid_at, user_id_user, cost)
        values (idNewOrder,
                idOrderCompSt,
                orderCreate,
                orderCreate,
                idUser,
                1);
        
        insert into payment (order_id_order, payment_method_id_method, payment_status_id_status)
            values(idNewOrder,
                    idPayMeth,
                    idPayCompSt);
         
         insert into delivery (order_id_order, delivery_method_id_method, delivery_status_id_status, address_id_address)
            values(idNewOrder,
                    idDelMeth,
                    idDelCompSt,
                    idAddress);    
                
         update "Order" set 
            payment_id_payment = (select id_payment from payment where order_id_order = idNewOrder) 
            where id_order = idNewOrder;
        
        update "Order" set 
            delivery_id_delivery = (select id_delivery from delivery where order_id_order = idNewOrder) 
            where id_order = idNewOrder;
        
        costOrder := 0;
        tmp := floor(dbms_random.value * (totalProducts - 5)) + 1;  
        select id_product into idProduct
            from (select t.id_product, rownum r_num
                from (select id_product from Product order by id_product asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        for orderItem in 1..(floor(dbms_random.value * 5) + 1)
        loop
            insert into order_product(product_id_product, order_id_order, amount, cur_price_per_one)
                values(idProduct,
                        idNewOrder,
                        floor(dbms_random.value * 4) + 1,
                        (select price from product where id_product = idProduct));
            select price into costOrderHelp1 from product where id_product = idProduct;
            select amount into costOrderHelp2 from order_product where order_id_order = idNewOrder and product_id_product = idProduct;
            costOrder := costOrder + costOrderHelp1 * costOrderHelp2;
            idProduct := idProduct + 1;
        end loop;
        update "Order" set 
            cost = costOrder 
            where id_order = idNewOrder;
        
    end loop;
    

    for counter in 751..1000
    loop
        tmp := floor(dbms_random.value * totalUsers) + 1;
        select id_user into idUser
            from (select t.id_user, rownum r_num
                from (select id_user from "User" order by id_user asc) t
                    where rownum <= tmp)
        where r_num >= tmp;

        tmp := floor(dbms_random.value * totalPayMeth) + 1;
        select id_method into idPayMeth
            from (select t.id_method, rownum r_num
                from (select id_method from payment_method order by id_method asc) t
                    where rownum <= tmp)
        where r_num >= tmp;

        select created_at into userAccCreate from "User" where id_user = idUser;
        orderCreate := userAccCreate + floor(dbms_random.value * (sysdate - userAccCreate));
        
        select order_pk_seq.nextVal into idNewOrder from dual;
        
        insert into "Order"(id_order, order_status_id_status, created_at, paid_at, user_id_user, cost)
        values (idNewOrder,
                idOrderFailSt,
                orderCreate,
                orderCreate,
                idUser,
                1);
        
       insert into payment (order_id_order, payment_method_id_method, payment_status_id_status)
            values(idNewOrder,
                    idPayMeth,
                    idPayFailSt);
                
         update "Order" set 
            payment_id_payment = (select id_payment from payment where order_id_order = idNewOrder) 
            where id_order = idNewOrder;
            
            
        costOrder := 0;
        tmp := floor(dbms_random.value * (totalProducts - 5)) + 1;  
        select id_product into idProduct
            from (select t.id_product, rownum r_num
                from (select id_product from Product order by id_product asc) t
                    where rownum <= tmp)
        where r_num >= tmp;
        for orderItem in 1..(floor(dbms_random.value * 5) + 1)
        loop
            insert into order_product(product_id_product, order_id_order, amount, cur_price_per_one)
                values(idProduct,
                        idNewOrder,
                        floor(dbms_random.value * 4) + 1,
                        (select price from product where id_product = idProduct));
            select price into costOrderHelp1 from product where id_product = idProduct;
            select amount into costOrderHelp2 from order_product where order_id_order = idNewOrder and product_id_product = idProduct;
            costOrder := costOrder + costOrderHelp1 * costOrderHelp2;
            idProduct := idProduct + 1;
        end loop;
        update "Order" set 
            cost = costOrder 
            where id_order = idNewOrder;
            
            
    end loop;
 end fillOrders;
 
 procedure fillMessages
 as
  totalUsers integer;
  idUser integer;
  totalAdmins integer;
  idAdmin integer;
  tmp integer;
 begin
 
    select count(*) into totalAdmins from "User" where administrator = 1;
    
    if totalAdmins = 0 then
        return;
    end if;
    
    select count(*) into totalUsers from "User";
    
    if totalUsers = 0 then
        return;
    end if;
    
    
    for counter in 1..100
    loop
        tmp := floor(dbms_random.value * totalUsers) + 1;
        select id_user into idUser
             from (select t.id_user, rownum r_num
                 from (select id_user from "User" order by id_user asc) t
                     where rownum <= tmp)
            where r_num >= tmp;
            
        tmp := floor(dbms_random.value * totalAdmins) + 1;
        select id_user into idAdmin
             from (select t.id_user, rownum r_num
                 from (select id_user from "User" where administrator = '1' order by id_user asc) t
                     where rownum <= tmp)
            where r_num >= tmp;
            
        insert into message(text, to_id_user, from_id_user) values('message' || counter, idUser, idAdmin);
    end loop;
 end fillMessages;
 
 procedure fillInvoices
 as
  totalOrders integer;
  tmp integer;
  idOrder integer;
  paid_at_v date;
  created_at_v date;
 begin
    select count(*) into totalOrders from "Order";
    
    for counter in 1..250
    loop
        tmp := floor(dbms_random.value * totalOrders) + 1;
        select id_order into idOrder
             from (select t.id_order, rownum r_num
                 from (select id_order from "Order" order by id_order asc) t
                     where rownum <= tmp)
            where r_num >= tmp;
        
        select paid_at into paid_at_v from "Order" where id_order = idOrder;
        
        if paid_at_v is not null then
            
            select created_at into created_at_v from "Order" where id_order = idOrder;
            created_at_v := created_at_v + floor(dbms_random.value * (sysdate - created_at_v));
            
            insert into invoice(paid_at, created_at, order_id_order) 
                values(paid_at_v,
                       created_at_v, 
                       idOrder);
        end if;        
    end loop;
 end fillInvoices; 
 
 procedure fillCartProduct
 as
    totalCarts integer;
    totalProducts integer;
    idCart integer;
    idProduct integer;
    tmp integer;
    maxAmount integer;
begin
    select count(*) into totalCarts from cart;
    select count(*) into totalProducts from product; 
    
    for counter in 1..250
    loop
        tmp := floor(dbms_random.value * totalCarts) + 1;
        select id_cart into idCart
             from (select t.id_cart, rownum r_num
                 from (select id_cart from cart order by id_cart asc) t
                     where rownum <= tmp)
            where r_num >= tmp;
            
        tmp := floor(dbms_random.value * totalProducts) + 1;
        select id_product into idProduct
             from (select t.id_product, rownum r_num
                 from (select id_product from product order by id_product asc) t
                     where rownum <= tmp)
            where r_num >= tmp;
         
        select amount into maxAmount from product where id_product = idProduct;
        
        if maxAmount != 0 then
            select count(*) into tmp  from cart_product
                where cart_id_cart = idCart and
                    product_id_product = idProduct;
            if tmp = 0 then
                insert into cart_product(cart_id_cart, product_id_product, amount)
                    values(idCart,
                            idProduct,
                            least(floor(dbms_random.value * maxAmount) + 1, 5));
            end if;
        end if;
    end loop;
end fillCartProduct;

procedure fillAllData
as
begin
fillAddresses();
fillUsers();
fillProducts();
fillOrders();
fillMessages();
fillInvoices();
fillCartProduct();
end fillAllData;

procedure dropAllData
as
begin
delete from invoice where id_invoice > 0;
delete from message where id_message > 0;
delete from "Order" where id_order > 0; -- will also delete delivery and payment
delete from order_status where id_status > 0;
delete from delivery_status where id_status > 0;
delete from delivery_method where id_method > 0;
delete from payment_status where id_status > 0;
delete from payment_method where id_method > 0;
delete from "User" where id_user > 0; -- will also delete cart and cart_product
delete from user_status where id_status > 0;
delete from address where id_address > 0;
delete from country where id_country > 0;
delete from city where id_city > 0;
delete from product where id_product > 0; -- will also delete laptop and hardware
delete from hardware_color where id_color > 0;
delete from hardware_type where id_type > 0;
delete from manufacturer where id_manufacturer > 0;
delete from operating_system where id_os > 0;
end dropAllData;
end fill_with_data;

begin
    fill_with_data.dropAllData();
    fill_with_data.fillAllData();
end;

