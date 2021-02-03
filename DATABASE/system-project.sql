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

SELECT COUNT(*), MIN (OperDate), min (Id) FROM MovementProtocol     -- 931 170;"2017-11-06 00:24:43.112443+02";107921868
SELECT COUNT(*), MIN (OperDate), max (Id) FROM MovementProtocol_arc -- 926 805;"2017-10-01 00:00:04.614108+03";107921867
SELECT COUNT(*) FROM MovementProtocol where OperDate >= CURRENT_DATE - INTERVAL '400 DAY' -- 4 780 0980
-- SELECT COUNT(*), MIN (OperDate), min (Id) FROM MovementProtocol where UserId = zc_Enum_Process_Auto_PrimeCost()

SELECT COUNT(*), MIN (OperDate), min (Id) FROM MovementItemProtocol     -- 1 761 320;"2017-11-06 00:24:43.172571+02";140397387
SELECT COUNT(*), MIN (OperDate), max (Id) FROM MovementItemProtocol_arc -- 2 300 499;"2017-10-01 00:00:12.521526+03";140397386
-- SELECT COUNT(*) FROM MovementItemProtocol where OperDate >= CURRENT_DATE - INTERVAL '400 DAY' -- 5 930 4965

SELECT COUNT(*) FROM Container -- 1 460 503
SELECT COUNT(*) FROM MovementItemContainer  -- 379 637 136 -- SELECT MAX (Id) FROM MovementItemContainer  -- 8 622 279 861
                                            -- 444 269 521                                                -- 9 985 067 045
SELECT COUNT(*) FROM MovementItem  --  91 517 138 -- !!! - 2 147 483 647
                                   -- 102 238 286
                                   -- 165 376 714
SELECT COUNT(*) FROM MovementItemFloat  -- 314 383 191
                                        -- 351 191 292
SELECT COUNT(*) FROM Object       -- 1 078 770
SELECT COUNT(*) FROM ObjectFloat  -- 1 087 193

integer 4 bytes -- -2147483648 to +2 147 483 647
bigint 8 bytes -- -9223372036854775808 to +9223372036854775807
serial    -- 1 to 2147483647
bigserial -- 1 to 9223372036854775807


-- !!!Перебрасываем в АРХИВ!!!
insert into MovementProtocol_arc
-- SELECT * FROM MovementProtocol ORDER BY id LIMIT 1 -- SELECT Max(Id) FROM MovementProtocol
 SELECT * FROM MovementProtocol where Id > (select max (Id) from MovementProtocol_arc) ORDER BY id LIMIT 8000000 ; -- TRUNCATE TABLE MovementProtocol;
-- SELECT * FROM MovementProtocol where Id < (select min (Id) from MovementProtocol_arc) ORDER BY id DESC LIMIT 400000;

insert into MovementItemProtocol_arc
-- SELECT * FROM MovementItemProtocol ORDER BY id LIMIT 1 -- SELECT Max(Id) FROM MovementProtocol
 SELECT * FROM MovementItemProtocol where Id > (select max (Id) from MovementItemProtocol_arc) ORDER BY id LIMIT 8000000 ; 
-- TRUNCATE TABLE MovementItemProtocol;

-- SELECT * FROM MovementProtocol_arc ORDER BY id LIMIT 100
-- select 2, max (Id) from MovementItemProtocol_arc union select 1, min (Id) from MovementItemProtocol
-- select 2, count(*) from MovementItemProtocol_arc union select 1, count(*) from MovementItemProtocol where Id <=419183741


--
-- delete FROM MovementProtocol_arc      where OperDate < '01.10.2017';
-- delete FROM MovementItemProtocol_arc  where OperDate < '01.10.2017';

-- !!!Удаление ВСЕ - UserId = Auto!!!
-- delete FROM MovementProtocol_arc      where UserId IN (zc_Enum_Process_Auto_PrimeCost());
-- delete FROM MovementProtocol          where UserId IN (zc_Enum_Process_Auto_PrimeCost());
-- delete FROM MovementItemProtocol_arc  where UserId IN (zc_Enum_Process_Auto_PrimeCost(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_PartionClose(), zc_Enum_Process_Auto_ReturnIn());
-- delete FROM MovementItemProtocol      where UserId IN (zc_Enum_Process_Auto_PrimeCost(), zc_Enum_Process_Auto_Pack(), zc_Enum_Process_Auto_PartionClose(), zc_Enum_Process_Auto_ReturnIn());

-- Более 10 ДНЕЙ - zc_Movement_OrderInternal
-- delete FROM MovementItemProtocol_arc where Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol_arc AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_OrderInternal())
-- delete FROM MovementItemProtocol     where OperDate < CURRENT_DATE - INTERVAL '10 DAY' and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_OrderInternal())

-- !!!ALL - zc_Movement_Medoc + zc_Movement_TransportGoods + zc_Movement_RouteMember + zc_Movement_StoreReal!!!
-- delete FROM MovementProtocol_arc  where Id in (SELECT MovementProtocol.Id FROM MovementProtocol_arc AS MovementProtocol JOIN Movement ON Movement.Id = MovementId AND Movement.DescId IN (zc_Movement_Medoc(), zc_Movement_TransportGoods(), zc_Movement_RouteMember(), zc_Movement_StoreReal(), zc_Movement_Visit (), zc_Movement_Task(), zc_Movement_MobileBills()));
-- delete FROM MovementProtocol      where Id in (SELECT MovementProtocol.Id FROM MovementProtocol     AS MovementProtocol JOIN Movement ON Movement.Id = MovementId AND Movement.DescId IN (zc_Movement_Medoc(), zc_Movement_TransportGoods(), zc_Movement_RouteMember(), zc_Movement_StoreReal(), zc_Movement_Visit ()));
-- delete FROM MovementItemProtocol_arc  where Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol_arc AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId IN (zc_Movement_Medoc(), zc_Movement_TransportGoods(), zc_Movement_RouteMember(), zc_Movement_StoreReal(), zc_Movement_Visit (), zc_Movement_Task(), zc_Movement_MobileBills()));
-- delete FROM MovementItemProtocol      where Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol     AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId IN (zc_Movement_Medoc(), zc_Movement_TransportGoods(), zc_Movement_RouteMember(), zc_Movement_StoreReal(), zc_Movement_Visit ()));
 

-- !!!Упаковка АДМИН!!!
-- delete FROM MovementItemProtocol_arc  where UserId = 5 and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol_arc AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() JOIN MovementBoolean AS MB ON MB.MovementId = Movement.Id AND MB.DescId = zc_MovementBoolean_isAuto() AND MB.ValueData = TRUE);
-- delete FROM MovementItemProtocol      where UserId = 5 and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol     AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_ProductionUnion() JOIN MovementBoolean AS MB ON MB.MovementId = Movement.Id AND MB.DescId = zc_MovementBoolean_isAuto() AND MB.ValueData = TRUE);
-- !!!Заявка внутренняя АДМИН!!!
-- delete FROM MovementItemProtocol_arc  where UserId = 5 and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol_arc AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_OrderInternal());
-- delete FROM MovementItemProtocol      where UserId = 5 and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol     AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId = zc_Movement_OrderInternal());
-- !!!Производство + OrderInternal - zc_MILinkObject_Receipt - АДМИН!!!
-- delete FROM MovementItemProtocol_arc  where UserId = 5 and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol_arc AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId IN (zc_Movement_OrderInternal(), zc_Movement_ProductionUnion()));
-- delete FROM MovementItemProtocol      where UserId = 5 and Id in (SELECT MovementItemProtocol.Id FROM MovementItemProtocol     AS MovementItemProtocol JOIN MovementItem ON MovementItem.Id = MovementItemId JOIN Movement ON Movement.Id = MovementItem.MovementId AND Movement.DescId IN (zc_Movement_OrderInternal(), zc_Movement_ProductionUnion()));
-- !!!MEDOC - Федорец!!!
-- delete FROM MovementProtocol_arc  where UserId = 14610 and Id in (SELECT MovementProtocol.Id FROM MovementProtocol_arc AS MovementProtocol JOIN Movement ON Movement.Id = MovementId AND Movement.DescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_Medoc()));
-- delete FROM MovementProtocol      where UserId = 14610 and Id in (SELECT MovementProtocol.Id FROM MovementProtocol     AS MovementProtocol JOIN Movement ON Movement.Id = MovementId AND Movement.DescId IN (zc_Movement_Tax(), zc_Movement_TaxCorrective(), zc_Movement_Medoc()));

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


-- !!!!INSERT !!!
DO $$
DECLARE  vbId Integer;
-- DECLARE  vbId_mi Integer;
BEGIN

-- -- SELECT COUNT(*), MIN (OperDate), min (Id), max (Id) FROM MovementProtocol
-- -- SELECT COUNT(*), Max (OperDate), min (Id), max (Id) FROM MovementProtocol_arc
-- -- 18 864 570;"2017-12-02 20:51:16.312647+02";111 684 391;130 568 553
-- --  1 861 459;"2017-12-02 20:48:11.284402+02";111 684 384;103 355 077
vbId := (select max(Id) FROM MovementProtocol_arc);
insert into MovementProtocol_arc
SELECT * FROM MovementProtocol where id between vbId + 1 and vbId + 3000000 and id < 130568553;



-- -- SELECT COUNT(*), MIN (OperDate), min (Id), max (Id) FROM MovementItemProtocol
-- -- SELECT COUNT(*), MAX (OperDate), min (Id), max (Id) FROM MovementItemProtocol_arc
-- -- 23 357 060;"2017-12-02 20:51:16.421357+02";146 256 246;169 629 650
-- --  4 066 356;"2017-12-02 20:48:54.51985+02" ;146 256 243;134 035 646
-- vbId_mi := (select max(Id) FROM MovementItemProtocol_arc);
-- insert into MovementItemProtocol_arc
-- SELECT * FROM MovementItemProtocol where id between vbId_mi + 1 and vbId_mi + 3000000 and id < 169629650;

END $$;

-- !!!!TRUNCATE + LOCK !!!
DO $$
BEGIN

-- -- SELECT COUNT(*), MIN (OperDate), min (Id), max (Id) FROM MovementProtocol where id >= 130568553;
LOCK TABLE MovementProtocol IN SHARE UPDATE EXCLUSIVE MODE;
insert into MovementProtocol_arc
SELECT * FROM MovementProtocol where id >= 130568553;
TRUNCATE TABLE MovementProtocol;

-- -- SELECT COUNT(*), MIN (OperDate), min (Id), max (Id) FROM MovementItemProtocol where id >= 169629650;
-- LOCK TABLE MovementItemProtocol IN SHARE UPDATE EXCLUSIVE MODE;
-- insert into MovementItemProtocol_arc
-- SELECT * FROM MovementItemProtocol where id >= 169629650;
-- TRUNCATE TABLE MovementItemProtocol;

END $$;



-- 
-- TRUNCATE TABLE MovementItemContainer;
-- TRUNCATE TABLE SoldTable;
CREATE INDEX idx_MovementProtocol_MovementId ON MovementProtocol (MovementId);
CREATE INDEX idx_MovementProtocol_UserId ON MovementProtocol (UserId);
CREATE INDEX idx_MovementProtocol_OperDate ON MovementProtocol (OperDate);
update Object set ValueData = 'http://project-vds.vds.colocall.com/project_arc/index.php' where Id = zc_Enum_GlobalConst_ConnectParam();
select * from Object where Id = zc_Enum_GlobalConst_ConnectParam();
