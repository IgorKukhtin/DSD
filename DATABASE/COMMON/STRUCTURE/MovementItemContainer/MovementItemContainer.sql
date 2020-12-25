/*
  Создание 
    - таблицы MovementItemContainer (перемещения)
    - связей
    - индексов
*/
/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemContainer(
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
   AccountId_analyzer integer,

   CONSTRAINT fk_MovementItemContainer_DescId FOREIGN KEY(DescId) REFERENCES MovementItemContainerDesc(Id),
   CONSTRAINT fk_MovementItemContainer_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT fk_MovementItemContainer_ContainerId FOREIGN KEY(ContainerId) REFERENCES Container(Id),
   CONSTRAINT fk_MovementItemContainer_ParentId FOREIGN KEY(ParentId) REFERENCES MovementItemContainer(Id),
   CONSTRAINT fk_MovementItemContainer_MovementItemId FOREIGN KEY (MovementItemId) REFERENCES MovementItem(id),
   CONSTRAINT fk_MovementItemContainer_MovementDescId FOREIGN KEY(MovementDescId) REFERENCES MovementDesc(Id)
   CONSTRAINT fk_MovementItemContainer_MovementDescId FOREIGN KEY(MovementDescId) REFERENCES MovementDesc(Id),
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_MovementItemContainer_MovementId_DescId ON MovementItemContainer (MovementId, DescId);
CREATE INDEX idx_MovementItemContainer_ContainerId_Analyzer_OperDate ON MovementItemContainer (ContainerId_Analyzer, OperDate);
CREATE INDEX idx_MovementItemContainer_AnalyzerId_OperDate ON MovementItemContainer (AnalyzerId, OperDate);
CREATE INDEX idx_MovementItemContainer_ContainerId_OperDate ON MovementItemContainer (ContainerId, OperDate);
-- "idx_movementitemcontainer_operdate_descid_movementdescid_whereo"
CREATE INDEX idx_MovementItemContainer_OperDate_DescId_MovementDescId_WhereObjectId_Analyzer ON MovementItemContainer (OperDate,DescId,MovementDescId,WhereObjectId_Analyzer);
-- !!! CREATE INDEX idx_MovementItemContainer_ContainerId_OperDate_DescId ON MovementItemContainer (ContainerId, OperDate, DescId);
-- !!! CREATE INDEX idx_MovementItemContainer_ContainerId_DescId_OperDate ON MovementItemContainer (ContainerId, DescId, OperDate);
CREATE INDEX idx_MovementItemContainer_MovementItemId ON MovementItemContainer (MovementItemId);
CREATE INDEX idx_MovementItemContainer_ParentId ON MovementItemContainer (ParentId);
-- CREATE INDEX idx_MovementItemContainer_ContainerId_DescId_OperDate_Amount ON MovementItemContainer (ContainerId, DescId, OperDate, Amount);
-- 15.05.2016
CREATE INDEX idx_MovementItemContainer_ObjectId_Analyzer_AnalyzerId ON MovementItemContainer (ObjectId_Analyzer, AnalyzerId);
-- ???18.05.2016???
-- CREATE INDEX idx_MovementItemContainer_ObjectId_Analyzer_OperDate_AnalyzerId ON MovementItemContainer (ObjectId_Analyzer_OperDate, AnalyzerId);
-- 
-- !!!FARMACY!!!!
-- CREATE INDEX idx_MovementItemContainer_ObjectIntId_analyzer ON MovementItemContainer (ObjectIntId_analyzer);
-- !!!FARMACY!!!!
-- CREATE INDEX idx_MovementItemContainer_AnalyzerId ON MovementItemContainer (AnalyzerId);
-- 

                                                                         
DO $$ 
    BEGIN

      IF       (EXISTS(SELECT c.relname 
                       FROM pg_catalog.pg_class AS c 
                  LEFT JOIN pg_catalog.pg_namespace AS n ON n.oid = c.relnamespace
                      WHERE c.relkind = 'i' AND n.nspname NOT IN ('pg_catalog', 'pg_toast')
                        AND c.relname = lower('idx_movementitemcontainer_containerid_descid_operdate_amount'))) THEN
             DROP INDEX idx_movementitemcontainer_containerid_descid_operdate_amount;
      END IF;
    END;
$$;
   
/*-------------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.03.15                                        * add idx_MovementItemContainer_OperDate_DescId_MovementDescId_WhereObjectId_Analyzer
 20.12.14                                        * add idx_MovementItemContainer_ContainerId_Analyzer_OperDate
 18.12.14                                        * add idx_MovementItemContainer_AnalyzerId_OperDate
 18.12.14                                        * add idx_MovementItemContainer_ContainerId_OperDate + del idx_MovementItemContainer_ContainerId_OperDate_DescId + del idx_MovementItemContainer_ContainerId_DescId_OperDate
 26.10.14                                        * add idx_MovementItemContainer_ContainerId_OperDate_DescId AND idx_MovementItemContainer_ContainerId_DescId_OperDate
 26.10.14                                        * add index ???idx_MovementItemContainer_MovementItemId???
 26.10.14                                        * drop index idx_movementitemcontainer_containerid_descid_operdate_amount
 30.08.13                                        * 1251Cyr
*/

/*
-- test - 07.12.2018
insert into tmpMIContainer_test(
Id       , 
   DescId   ,
   MovementId,
   ContainerId,
   Amount     , 
   OperDate   ,
   MovementItemId ,
   ParentId       ,
   isActive       ,

   MovementDescId ,
   AnalyzerId ,
   AccountId ,
   ObjectId_analyzer ,
   WhereObjectId_analyzer ,
   ContainerId_analyzer ,

   ObjectIntId_analyzer ,
   ObjectExtId_analyzer ,

   ContainerIntId_analyzer ,
   AccountId_analyzer 
)
select 
   Id       , 
   DescId   ,
   MovementId,
   ContainerId,
   Amount     , 
   OperDate   ,
   MovementItemId ,
   ParentId       ,
   isActive       ,

   MovementDescId ,
   AnalyzerId ,
   AccountId ,
   ObjectId_analyzer ,
   WhereObjectId_analyzer ,
   ContainerId_analyzer ,

   ObjectIntId_analyzer ,
   ObjectExtId_analyzer ,

   ContainerIntId_analyzer ,
   AccountId_analyzer 

from MovementItemContainer
where MovementId IN (11295799 , 11196706 , 11081354, 11000691)
*/
