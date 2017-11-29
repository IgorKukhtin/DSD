462GB
446GB
-- Movement
SELECT COUNT(*), MIN (OperDate), MAX (OperDate), UserId, Object_User.ValueData
FROM MovementProtocol AS MovementProtocol_arc
     inner join Object AS Object_User ON Object_User.Id = UserId
GROUP BY UserId, Object_User.ValueData
ORDER BY 1 DESC
-- MovementItem
SELECT COUNT(*), MIN (OperDate), MAX (OperDate), UserId, Object_User.ValueData
FROM MovementItemProtocol -- AS MovementItemProtocol_arc
     inner join Object AS Object_User ON Object_User.Id = UserId
GROUP BY UserId, Object_User.ValueData
ORDER BY 1 DESC
--
-- Movement - User
SELECT COUNT(*), MIN (MovementProtocol.OperDate), MAX (MovementProtocol.OperDate), MovementDesc.Code, MovementDesc.ItemName
FROM MovementProtocol -- AS MovementProtocol_arc
     inner join Movement     ON Movement.Id     = MovementId
     inner join MovementDesc ON MovementDesc.Id = Movement.DescId
WHERE UserId = 1129982 -- "Шумейко А.В."
-- WHERE UserId = 14610   -- "Федорец В.А."
GROUP BY MovementDesc.Code, MovementDesc.ItemName
ORDER BY 1 DESC
-- MovementItem - User
SELECT COUNT(*), MIN (MovementItemProtocol.OperDate), MAX (MovementItemProtocol.OperDate), MovementDesc.Code, MovementDesc.ItemName
     , max(Movement.InvNumber), min(Movement.InvNumber), max(Movement.Id), min(Movement.Id)
FROM MovementItemProtocol -- AS MovementItemProtocol_arc
     inner join MovementItem ON MovementItem.Id = MovementItemId
     inner join Movement     ON Movement.Id     = MovementId
     inner join MovementDesc ON MovementDesc.Id = Movement.DescId
WHERE UserId = 5 -- "Админ"
-- WHERE UserId = 59961   -- "Рыбалко В.В."
GROUP BY MovementDesc.Code, MovementDesc.ItemName
ORDER BY 1 DESC



SELECT COUNT(*) FROM LoginProtocol -- 309 841
SELECT COUNT(*) FROM UserProtocol  -- 243 115 -- SELECT * FROM UserProtocol order by id desc limit 1000

SELECT COUNT(*) FROM ObjectProtocol -- 26 583 053
-- SELECT COUNT(*) FROM ObjectProtocol_arc -- 0
SELECT COUNT(*) FROM ObjectProtocol where OperDate >= CURRENT_DATE - INTERVAL '400 DAY' -- 4 739 375

SELECT COUNT(*), MIN (OperDate), min (Id) FROM MovementProtocol -- 54 242 840
SELECT COUNT(*), MIN (OperDate), max (Id) FROM MovementProtocol_arc -- 0
SELECT COUNT(*) FROM MovementProtocol where OperDate >= CURRENT_DATE - INTERVAL '400 DAY' -- 4 780 0980
-- SELECT COUNT(*), MIN (OperDate), min (Id) FROM MovementProtocol where UserId = zc_Enum_Process_Auto_PrimeCost()

SELECT COUNT(*), MIN (OperDate), min (Id) FROM MovementItemProtocol -- 64 883 175
SELECT COUNT(*), MIN (OperDate), max (Id) FROM MovementItemProtocol_arc -- 
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


-- !!!Перебрасываем в АРХИВ!!!
insert into MovementProtocol_arc
-- SELECT * FROM MovementProtocol ORDER BY id DESC LIMIT 1 -- SELECT Max(Id) FROM MovementProtocol
-- SELECT * FROM MovementProtocol where Id > (select max (Id) from MovementProtocol_arc); TRUNCATE TABLE MovementProtocol;
SELECT * FROM MovementProtocol where Id < (select min (Id) from MovementProtocol_arc) ORDER BY id DESC LIMIT 400000;

insert into MovementItemProtocol_arc
-- SELECT * FROM MovementItemProtocol ORDER BY id DESC LIMIT 1; -- SELECT Max(Id) FROM MovementItemProtocol
-- SELECT * FROM MovementItemProtocol where Id > (select max (Id) from MovementItemProtocol_arc); TRUNCATE TABLE MovementItemProtocol;
SELECT * FROM MovementItemProtocol where Id < (select min (Id) from MovementItemProtocol_arc) ORDER BY id DESC LIMIT 400000; -- SELECT Max(Id) FROM MovementItemProtocol


-- !!!Удаление ВСЕ!!!
-- delete FROM MovementProtocol_arc where UserId IN (zc_Enum_Process_Auto_PrimeCost());
-- delete FROM MovementProtocol     where UserId IN (zc_Enum_Process_Auto_PrimeCost());
--
-- delete FROM MovementProtocol_arc      where OperDate < '01.10.2017';
-- delete FROM MovementItemProtocol_arc  where OperDate < '01.10.2017';
-- !!!Удаление ВСЕ!!!
-- delete FROM MovementItemProtocol_arc  where UserId IN (zc_Enum_Process_Auto_PrimeCost(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_PartionClose(), zc_Enum_Process_Auto_ReturnIn());
-- delete FROM MovementItemProtocol      where UserId IN (zc_Enum_Process_Auto_PrimeCost(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_PartionClose(), zc_Enum_Process_Auto_ReturnIn());

-- delete FROM MovementItemProtocol_arc  where Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol_arc AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_OrderInternal())
-- delete FROM MovementItemProtocol  where OperDate < CURRENT_DATE - INTERVAL '10 DAY' and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_OrderInternal())

-- delete FROM MovementProtocol_arc  where Id in (SELECT MovementProtocol.Id FROM MovementProtocol_arc AS MovementProtocol JOIN Movement ON Movement.Id = MovementId AND Movement.DescId IN (zc_Movement_RouteMember(), zc_Movement_Medoc()));
-- delete FROM MovementProtocol      where Id in (SELECT MovementProtocol.Id FROM MovementProtocol     AS MovementProtocol JOIN Movement ON Movement.Id = MovementId AND Movement.DescId IN (zc_Movement_RouteMember(), zc_Movement_Medoc()));
-- delete FROM MovementItemProtocol_arc  where Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol_arc AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId IN (zc_Movement_RouteMember(), zc_Movement_Medoc()));
-- delete FROM MovementItemProtocol      where Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol     AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId IN (zc_Movement_RouteMember(), zc_Movement_Medoc()));
 

-- !!!Упаковка АДМИН!!!
-- delete FROM MovementItemProtocol_arc  where UserId = 5 and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol_arc AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() JOIN MovementBoolean AS MB ON MB.MovementId = Movement.Id AND MB.DescId = zc_MovementBoolean_isAuto() AND MB.ValueData = TRUE);
-- delete FROM MovementItemProtocol      where UserId = 5 and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol     AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() JOIN MovementBoolean AS MB ON MB.MovementId = Movement.Id AND MB.DescId = zc_MovementBoolean_isAuto() AND MB.ValueData = TRUE);


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

