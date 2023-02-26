-- 5 table 1 fact 4 dimention
-- pk = fk
-- 3-5 queries
-- subquery / with 


CREATE TABLE dim_menu_list (
  menu_id TEXT primary key,
  menu_name TEXT,
  menu_price INT
) 
  ;

INSERT INTO dim_menu_list VALUES
  ('A001','fried-chicken',59),
  ('A002','somtum',80),
  ('A003','rice',20),
  ('A004','milk-shake',99),
  ('A005','cake',49)
  ;

CREATE TABLE dim_buyer_info (
  buyer_id TEXT primary key,
  buyer_name TEXT,
  buyer_phone TEXT
)
  ;

INSERT INTO dim_buyer_info values
  ('1001','Mint','085-985-7854'),
  ('1002','Gift','098-935-6471'),
  ('1003','Net','065-124-4523'),
  ('1004','Bia','092-384-7145'),
  ('1005','Nee','087-482-3485');


CREATE TABLE dim_payment (
  method_id TEXT primary key,
  payment_method TEXT
);
  

INSERT INTO dim_payment VALUES
  ('P01','Credit card'),
  ('P02','Debit card'),
  ('P03','Clash'),
  ('P04','E-wallet');
  
CREATE TABLE dim_satisfaction (
  sat_id TEXT primary key,
  sat_level TEXT
);

INSERT INTO dim_satisfaction VALUES
('S01','good'),
('S02','fair'),
('S03','poor');



CREATE TABLE fact_trd_order (
  order_id TEXT primary key,
  user_id TEXT,
  order_crate_date DATE,
  menu_id TEXT,
 
  sat_id INT,
  FOREIGN KEY (user_id) REFERENCES dim_buyer_info(buyer_id)
);

INSERT INTO fact_trd_order values
  ('OR1','1001','2022-11-11','A001','S01'),
  ('OR2','1002','2022-12-11','A004','S01'),
  ('OR3','1001','2022-12-11','A003','S01'),
  ('OR4','1004','2022-12-12','A002','S02') ;




with usr as ( select buyer_id ,
  buyer_name ,
  buyer_phone 
  from dim_buyer_info )
  , menu as ( select menu_id,
  menu_name ,
  menu_price 
  from dim_menu_list )
  , pm as ( select method_id,
  payment_method
  from dim_payment)
  , sat as (select sat_id,
  sat_level from dim_satisfaction)
  , trd as ( select order_id,
  user_id,
  order_crate_date,
  menu_id,
  sat_id 
  from fact_trd_order)

-- find total price
select distinct trd.menu_id
  ,menu_price
  ,order_id
  ,user_id
from trd left join menu on trd.menu_id = menu.menu_id;


-- find total  satisfaction
select count(trd.sat_id) as sat_cnt
,sat.sat_level
from trd left join sat on trd.sat_id = sat.sat_id
group by sat.sat_level;

-- find customer info from order_id
select order_id
,user_id
,buyer_name
,buyer_phone
from (select order_id, user_id from trd) trd left join (select * from usr) usr on trd.user_id = usr.buyer_id
