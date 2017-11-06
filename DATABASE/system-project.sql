462GB
446GB

SELECT COUNT(*) FROM LoginProtocol -- 309 841
SELECT COUNT(*) FROM UserProtocol  -- 243 115 -- SELECT * FROM UserProtocol order by id desc limit 1000

SELECT COUNT(*) FROM ObjectProtocol -- 26 583 053
-- SELECT COUNT(*) FROM ObjectProtocol_arc -- 0
SELECT COUNT(*) FROM ObjectProtocol where OperDate >= CURRENT_DATE - INTERVAL '400 DAY' -- 4 739 375

SELECT COUNT(*) FROM MovementProtocol -- 54 242 840
SELECT COUNT(*), MIN (OperDate) FROM MovementProtocol_arc -- 0
SELECT COUNT(*) FROM MovementProtocol where OperDate >= CURRENT_DATE - INTERVAL '400 DAY' -- 4 780 0980

SELECT COUNT(*) FROM MovementItemProtocol -- 64 883 175
SELECT COUNT(*), MIN (OperDate) FROM MovementItemProtocol_arc -- 
SELECT COUNT(*) FROM MovementItemProtocol where OperDate >= CURRENT_DATE - INTERVAL '400 DAY' -- 5 930 4965

 
SELECT COUNT(*) FROM Container -- 1 460 503
SELECT COUNT(*) FROM MovementItemContainer  -- 379 637 136 -- SELECT MAX (Id) FROM MovementItemContainer  -- 8 622 279 861
SELECT COUNT(*) FROM MovementItem  -- 91 517 138 -- !!! - 2 147 483 647
SELECT COUNT(*) FROM MovementItemFloat  -- 314 383 191
SELECT COUNT(*) FROM Object  -- 1 078 770

integer 4 bytes -- -2147483648 to +214 748 3647
bigint 8 bytes -- -9223372036854775808 to +9223372036854775807
serial    -- 1 to 2147483647
bigserial -- 1 to 9223372036854775807


insert into MovementProtocol_arc
-- SELECT * FROM MovementProtocol ORDER BY id DESC LIMIT 1 -- SELECT Max(Id) FROM MovementProtocol
-- SELECT * FROM MovementProtocol where Id > (select max (Id) from MovementProtocol_arc); TRUNCATE TABLE MovementProtocol;
SELECT * FROM MovementProtocol where Id < (select min (Id) from MovementProtocol_arc) ORDER BY id DESC LIMIT 400000;

insert into MovementItemProtocol_arc
-- SELECT * FROM MovementItemProtocol ORDER BY id DESC LIMIT 1; -- SELECT Max(Id) FROM MovementItemProtocol
-- SELECT * FROM MovementItemProtocol where Id > (select max (Id) from MovementItemProtocol_arc); TRUNCATE TABLE MovementItemProtocol;
SELECT * FROM MovementItemProtocol where Id < (select min (Id) from MovementItemProtocol_arc) ORDER BY id DESC LIMIT 400000; -- SELECT Max(Id) FROM MovementItemProtocol







-- insert into MovementProtocol_arc
-- SELECT * FROM MovementProtocol ORDER BY id DESC LIMIT 1 -- SELECT Max(Id) FROM MovementProtocol
-- SELECT * FROM MovementProtocol where Id > 107906385 /*and UserId <> 444873*/ order by id DESC LIMIT 20000; -- (select max (Id) from MovementProtocol_arc) ;
-- TRUNCATE TABLE MovementProtocol;
-- SELECT * FROM MovementProtocol where Id < (select min (Id) from MovementProtocol_arc) ORDER BY id DESC LIMIT 400000;

insert into MovementItemProtocol_arc
-- SELECT * FROM MovementItemProtocol ORDER BY id DESC LIMIT 1; -- SELECT Max(Id) FROM MovementItemProtocol
 SELECT * FROM MovementItemProtocol where Id > 140381645 /*and UserId <> 5*/ order by id DESC LIMIT 20000 ; -- (select max (Id) from MovementItemProtocol_arc); 
TRUNCATE TABLE MovementItemProtocol;
-- SELECT * FROM MovementItemProtocol where Id < (select min (Id) from MovementItemProtocol_arc) ORDER BY id DESC LIMIT 400000; -- SELECT Max(Id) FROM MovementItemProtocol

-- select * from object where Id =  1162887

