-- Author: Walerij Hrul

-- info about order
select z1.id_order, z1.id_user, z2.value as order_status, z1.created_at, z1.total_cost,  
       z1.product_name, z1.cur_price_per_one, z1.amount, z1.selector
from (select t1.id_order, t1.order_status_id_status, t1.user_id_user as id_user, t1.created_at, t1.cost as total_cost,  
         t2.name as product_name, t2.cur_price_per_one, t2.amount, t2.selector 
       from "Order" t1 
       left outer join 
         (select tt2.name, tt2.selector, tt1.amount, tt1.cur_price_per_one, tt1.order_id_order 
          from order_product tt1 
          left join product tt2 
          on tt1.product_id_product = tt2.id_product) t2 
       on t1.id_order = t2.order_id_order
       where id_order = (select min(id_order) from "Order")) z1
left outer join order_status z2 
on z1.order_status_id_status = z2.id_status;
    
-- info about amount of orders
select u.id_user, count(*) as number_of_orders 
from "User" u
inner join "Order" o
on u.id_user = o.user_id_user
group by u.id_user
order by number_of_orders desc, id_user asc;
    
-- info about current status of orders
select t2.value as status_of_order, count(*) as num_of_orders from "Order" t1
left outer join order_status t2
    on t1.order_status_id_status = t2.id_status
group by t2.value
order by num_of_orders desc, status_of_order asc;

--info about products' sales - popular products
select z1.product_id_product as id_product,
       z1.num_of_sales as num_of_delivered_orders,
       z2.name,
       z2.price as current_price,
       z2.amount as num_of_available_products,
       z2.selector
from (select t1.product_id_product, count(*) as num_of_sales 
      from order_product t1 
      left outer join "Order" t2 on t1.order_id_order = t2.id_order 
      left outer join order_status t3 on t2.order_status_id_status = t3.id_status where t3.value = 'delivered'
      group by t1.product_id_product
      having count(*) > 1
      order by num_of_sales desc, t1.product_id_product asc) z1
left outer join product z2
on z1.product_id_product = z2.id_product
order by num_of_delivered_orders desc, id_product asc;

-- filter for searching products
select t1.id_product, t1.name, t2.name as manufacturer, t1.price, t1.amount, t1.selector from product t1
left outer join manufacturer t2
on t1.manufacturer_id_manufacturer = t2.id_manufacturer
where t1.name like '%apto%' and
t1.price < 15000
order by id_product asc;


-- eaxamples are using id_product = 1 and id_user = 1

-- addProductToCart
-- Adding the same product will not add new line in cart_product table, just increace amount field
-- Func do not check if there is enough products at the store
-- func(user, product, ammount)
delete from cart_product where cart_id_cart = (select id_cart from cart where user_id_user = 1);
begin
    shop_functionality.addProductToCart(1, 1, 2);
end;
select * from cart_product where cart_id_cart = (select id_cart from cart where user_id_user = 1);
begin
    shop_functionality.addProductToCart(1, 1, 2);
end;
select * from cart_product where cart_id_cart = (select id_cart from cart where user_id_user = 1);

-- createOrder
-- create order without payment and delivery - status draft
-- order contains total price of order
-- remove products from cart
-- decrease number of available products at the shop by value = min(amount in user's cart, available acmount at the store)
-- will not create order if already exist order with status draft
-- func(user)
delete from "Order" where user_id_user = 1;
begin
    shop_functionality.addProductToCart(1, 1, 50000);
end;
select * from product where id_product = 1;
begin
    shop_functionality.createOrder(1);
end;
select * from "Order" where user_id_user = 1;
select * from order_product where order_id_order = (select id_order from "Order" where user_id_user = 1);
select * from cart_product where cart_id_cart = (select id_cart from cart where user_id_user = 1);
select * from product where id_product = 1;

-- changeProductPrice
-- will not change the price if new value is negative
-- func(product, price)
select * from product where id_product = 1;
begin
    shop_functionality.changeProductPrice(1, 10000);
end;
select * from product where id_product = 1;
begin
    shop_functionality.changeProductPrice(1, -5000);
end;
select * from product where id_product = 1;

-- getMostExpensiveUserOrder
-- order should has deliveried status
-- func(user)
declare
  myrow "Order"%rowtype;
begin
  myrow := shop_functionality.getMostExpensiveUserOrder(1); 
  dbms_output.put_line('id_order: ' || myrow.id_order || ' cost: ' || myrow.cost);
end;                                                       

-- getOrderStatus
-- func(order)
begin
    dbms_output.put_line(shop_functionality.getOrderStatus(1));
end;

-- getUserWithMostExpOrdInMonth
-- return user row of user with most expensive delivered order in certain month(1-12)
-- func(month)
begin
    dbms_output.put_line(shop_functionality.getUserWithMostExpOrdInMonth(5).id_user);
end;

-- getMonthProfit
-- return sum of all costs of delivered orders in certain month(1-12)
-- func(month)
begin
    dbms_output.put_line(shop_functionality.getMonthProfit(3));
end;