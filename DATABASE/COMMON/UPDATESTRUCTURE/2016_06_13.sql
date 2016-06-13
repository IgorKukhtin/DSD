-- Временно сохраняем данные по ошибкам
CREATE TABLE _Container_13_06_16(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NOT NULL, 
   ObjectId              Integer NOT NULL, -- Счет
   Amount                TFloat  NOT NULL DEFAULT 0,
   ParentId              Integer NULL  ,

   KeyValue              TVarChar,
   MasterKeyValue        BigInt,
   ChildKeyValue         BigInt,
   WhereObjectId         Integer
);

CREATE TABLE _MI_Container_13_06_16(
   Id             BIGSERIAL NOT NULL PRIMARY KEY, 
   DescId         INTEGER,
   MovementId     INTEGER,
   ContainerId    INTEGER,
   Amount         TFloat, 
   OperDate       TDateTime,
   MovementItemId Integer,
   ParentId       BigInt,
   isActive       Boolean,  

   MovementDescId integer,
   AnalyzerId integer,
   AccountId integer,
   ObjectId_analyzer integer,
   WhereObjectId_analyzer integer,
   ContainerId_analyzer integer,

   ObjectIntId_analyzer integer,
   ObjectExtId_analyzer integer,

   ContainerIntId_analyzer integer,

   AccountId_analyzer integer
   
);

/*
-- 1
-- delete from _Container_13_06_16;
insert into _Container_13_06_16
select Container.*
from Container
where Container.DescId = zc_Container_Count()
  and Container.Amount < 0;

-- 2.1.
-- delete from _MI_Container_13_06_16;
insert into _MI_Container_13_06_16 (Id, DescId, MovementId, ContainerId, Amount, OperDate, MovementItemId, ParentId, isActive
, MovementDescId, AnalyzerId, AccountId, ObjectId_analyzer, WhereObjectId_analyzer, ContainerId_analyzer
, ObjectIntId_analyzer, ObjectExtId_analyzer, ContainerIntId_analyzer, AccountId_analyzer)
select MIC.Id, MIC.DescId, MIC.MovementId, MIC.ContainerId, MIC.Amount, MIC.OperDate, MIC.MovementItemId, MIC.ParentId, MIC.isActive
, MIC.MovementDescId, MIC.AnalyzerId, MIC.AccountId, MIC.ObjectId_analyzer, MIC.WhereObjectId_analyzer, MIC.ContainerId_analyzer
, MIC.ObjectIntId_analyzer, MIC.ObjectExtId_analyzer, MIC.ContainerIntId_analyzer, MIC.AccountId_analyzer
from MovementItemContainer AS MIC join _Container_13_06_16 on _Container_13_06_16.Id = MIC.ContainerId;

-- 2.2.
insert into _MI_Container_13_06_16 (Id, DescId, MovementId, ContainerId, Amount, OperDate, MovementItemId, ParentId, isActive
, MovementDescId, AnalyzerId, AccountId, ObjectId_analyzer, WhereObjectId_analyzer, ContainerId_analyzer
, ObjectIntId_analyzer, ObjectExtId_analyzer, ContainerIntId_analyzer, AccountId_analyzer)
select MIC.Id, MIC.DescId, MIC.MovementId, MIC.ContainerId, MIC.Amount, MIC.OperDate, MIC.MovementItemId, MIC.ParentId, MIC.isActive
, MIC.MovementDescId, MIC.AnalyzerId, MIC.AccountId, MIC.ObjectId_analyzer, MIC.WhereObjectId_analyzer, MIC.ContainerId_analyzer
, MIC.ObjectIntId_analyzer, MIC.ObjectExtId_analyzer, MIC.ContainerIntId_analyzer, MIC.AccountId_analyzer
from MovementItemContainer AS MIC join (select distinct MovementId from _MI_Container_13_06_16) as tmp on tmp.MovementId = MIC.MovementId
    left join _MI_Container_13_06_16 on _MI_Container_13_06_16.Id = MIC.Id
where _MI_Container_13_06_16.Id is null;

-- 3.
CREATE TABLE _err_13_06_16 as 
select Movement.InvNumber, Movement.OperDate, Object_From.Id As UnitId, Object_From.ValueData :: TVarChar as UnitName, MIFloat_Price.ValueData as Price, tmp.MovementId, tmp.Id_mi, GoodsId, Amount, calcAmount, Object.ObjectCode as goodsCode, Object.ValueData :: TVarChar as goodsName 
   -- , gpReComplete_Movement_Check (Movement.Id, '3')
from (select Movement_Check.InvNumber, MI_Check.Id as Id_mi, MI_Check.ObjectId as GoodsId, MI_Check.Amount, coalesce (-1 * SUM (MIContainer.Amount), 0) as calcAmount , Movement_Check.Id as MovementId
      FROM (select distinct MovementId from MIContainer_13_06_16 where MovementDescId = zc_Movement_Check()) as tmp
          INNER JOIN Movement AS Movement_Check on Movement_Check.Id = tmp.MovementId 
          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement_Check.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                       -- AND MovementLinkObject_Unit.ObjectId = 183292 -- Аптека_1 пр_Правды_6
            INNER JOIN MovementItem AS MI_Check
                                    ON MI_Check.MovementId = Movement_Check.Id
                                   AND MI_Check.DescId = zc_MI_Master()
                                   AND MI_Check.isErased = FALSE
            LEFT OUTER JOIN MovementItemContainer AS MIContainer
                                                  ON MIContainer.MovementItemId = MI_Check.Id
                                                 AND MIContainer.DescId = zc_MIContainer_Count() 

--    where Movement_Check.OperDate >= '01.01.2016' and Movement_Check.OperDate < '01.02.2016'
--    where Movement_Check.OperDate >= '01.02.2016' and Movement_Check.OperDate < '01.03.2016'
/*   where Movement_Check.Id = 1695311
        and Movement_Check.DescId = zc_Movement_Check()
        AND Movement_Check.StatusId = zc_Enum_Status_Complete()*/
      group by Movement_Check.InvNumber, MI_Check.Id, MI_Check.Amount , Movement_Check.Id, MI_Check.ObjectId
       having MI_Check.Amount <> coalesce (-1 * SUM (MIContainer.Amount), 0)
      ) as tmp 
             LEFT JOIN Object on Object.Id = tmp.GoodsId
             LEFT JOIN Movement on  Movement.Id = tmp.MovementId
             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN Object AS Object_From on Object_From.Id = MovementLinkObject_From.ObjectId
             LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                               ON MIFloat_Price.MovementItemId =  tmp.Id_mi
                                              AND MIFloat_Price.DescId = zc_MIFloat_Price()
order by 2 desc;


*/