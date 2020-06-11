-- Author: Walerij Hrul

drop package shop_functionality;

create or replace package shop_functionality is
procedure addProductToCart(
    p_id_user integer,
    p_id_product integer,
    p_amount integer
);

procedure createOrder(
    p_id_user integer
);

procedure changeProductPrice(
    p_id_product integer,
    p_price number
);

function getMostExpensiveUserOrder(
    p_id_user integer
)
return "Order"%rowtype;

function getOrderStatus(
    p_id_order integer
)
return order_status.value%type;

function getUserWithMostExpOrdInMonth(
    p_month integer
)
return "User"%rowtype;

function getMonthProfit(
    p_month integer
)
return number;
end shop_functionality;

create or replace package body shop_functionality is
procedure addProductToCart(
    p_id_user integer,
    p_id_product integer,
    p_amount integer
)
as
    alreadyExist integer;
    idCart integer;
begin
    select id_cart into idCart from cart where user_id_user = p_id_user;
    select count(*) into alreadyExist from cart_product 
        where cart_id_cart = idCart and product_id_product = p_id_product;
    if alreadyExist = 0 then 
        insert into cart_product(cart_id_cart, product_id_product, amount)
            values(idCart, p_id_product, p_amount);
    else 
        update cart_product set amount = amount + p_amount 
            where cart_id_cart = idCart and 
                  product_id_product = p_id_product;
    end if;
    exception
        when no_data_found then
            return;
end;

procedure createOrder(
    p_id_user integer
)
as
    idDraftOrderStatus integer;
    totalCost number(10, 2);
    totalRowsInCart integer;
    idCart integer;
    idNewOrder integer;
    curPrice number(10, 2);
    totalDraftOrders integer;
    numOfAvailProducts integer;
    actualNumOfPr integer;
begin
    select id_status into idDraftOrderStatus from order_status where value = 'draft';
    select count(*) into totalDraftOrders from "Order" 
        where user_id_user = p_id_user and
            order_status_id_status = idDraftOrderStatus;
    if totalDraftOrders > 0 then
	return;
    end if;

    select id_cart into idCart from cart where user_id_user = p_id_user;
    select count(*) into totalRowsInCart from cart_product where cart_id_cart = idCart;
    if totalRowsInCart = 0 then
        return;
    end if;
    
    select order_pk_seq.nextVal into idNewOrder from dual;
    insert into "Order" (id_order, order_status_id_status, created_at, user_id_user, cost)
        values(idNewOrder,
                idDraftOrderStatus,
                sysdate,
                p_id_user,
                0);
    totalCost := 0;
    for rowInCart in (select product_id_product, amount from cart_product where cart_id_cart = idCart)
    loop
        select price into curPrice from product where id_product = rowInCart.product_id_product;
        select amount into numOfAvailProducts from product where id_product = rowInCart.product_id_product;
        actualNumOfPr := least(numOfAvailProducts, rowInCart.amount);
        insert into order_product(product_id_product, order_id_order, amount, cur_price_per_one)
             values(rowInCart.product_id_product,
                     idNewOrder,
                     actualNumOfPr ,
                     curPrice);    
        totalCost := totalCost + curPrice * actualNumOfPr;
        update product set amount = amount - actualNumOfPr where id_product = rowInCart.product_id_product;
    end loop;
    update "Order" set cost = totalCost where id_order = idNewOrder;
    delete from cart_product where cart_id_cart = idCart;
end createOrder;

procedure changeProductPrice(
    p_id_product integer,
    p_price number
)
as
begin
    if p_price >= 0 then
        update product set price = p_price where id_product = p_id_product;
    end if;
end changeProductPrice;

function getMostExpensiveUserOrder(
    p_id_user integer
)
return "Order"%rowtype
as
    idCart integer;
    mostExpensiveOrder "Order"%rowtype;
    idComplOrderStatus integer;
begin
    select id_status into idComplOrderStatus from order_status where value = 'delivered';
    
    select id_cart into idCart from cart where user_id_user = p_id_user;
    
    select * into mostExpensiveOrder from (select * from "Order"
        where user_id_user = p_id_user and
              order_status_id_status = idComplOrderStatus
              order by cost desc, created_at desc)
        where rownum <= 1;
    
    return mostExpensiveOrder;
    exception
        when no_data_found then
            return null;
end;
function getOrderStatus(
    p_id_order integer
)
return order_status.value%type
as
    orderStatus order_status.value%type;
begin
    select value into orderStatus from order_status
        where id_status = (select order_status_id_status from "Order" 
            where id_order = p_id_order);
    return orderStatus;
    exception
        when no_data_found then
            return null;
end;

function getUserWithMostExpOrdInMonth(
    p_month integer
)
return "User"%rowtype
as
    resultUser "User"%rowtype;
    startDate date;
    v_month integer;
    idComplOrderStatus integer;
begin
    select id_status into idComplOrderStatus from order_status where value = 'delivered';

    v_month := p_month;
    if v_month < 1 then
        v_month := 1;
    elsif v_month > 12 then
        v_month := 12;
    end if;
    
    startDate := trunc(sysdate, 'year');
    startDate := add_months(startDate, v_month - 1);
    
    select * into resultUser from "User" 
    where id_user = (select user_id_user from (select user_id_user from "Order" 
        where created_at >= startDate and 
        created_at < add_months(startDate, 1) and 
        order_status_id_status = idComplOrderStatus
        order by cost desc, created_at desc) 
        where rownum <= 1);
    
    return resultUser;
    
    exception
        when no_data_found then
            return null;
end;

function getMonthProfit(
    p_month integer
)
return number
as
    monthProfit number;
    numOfComplOrders integer;
    startDate date;
    v_month integer;
    idComplOrderStatus integer;
begin
    select id_status into idComplOrderStatus from order_status where value = 'delivered';

    v_month := p_month;
    if v_month < 1 then
        v_month := 1;
    elsif v_month > 12 then
        v_month := 12;
    end if;
    
    startDate := trunc(sysdate, 'year');
    startDate := add_months(startDate, v_month - 1);
    
    select count(*) into numOfComplOrders from "Order"
    where created_at >= startDate and 
          created_at < add_months(startDate, 1) and 
          order_status_id_status = idComplOrderStatus;
    if numOfComplOrders = 0 then 
        return 0;
    end if;
    select sum(cost) into monthProfit from "Order"
    where created_at >= startDate and 
          created_at < add_months(startDate, 1) and 
          order_status_id_status = idComplOrderStatus;
    return monthProfit;
end;
end shop_functionality;
