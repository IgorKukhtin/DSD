/*
  Создание 
    - таблицы _replica.MovementItemContainer_Rewiring (Данные для перепроводки по MovementItemContainer)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE IF NOT EXISTS _replica.MovementItemContainer_Rewiring(
   Id             BIGSERIAL NOT NULL PRIMARY KEY, 
   Transaction_Id BIGINT,

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

   CONSTRAINT fk_MovementItemContainer_Rewiring_DescId FOREIGN KEY(DescId) REFERENCES MovementItemContainerDesc(Id),
   CONSTRAINT fk_MovementItemContainer_Rewiring_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT fk_MovementItemContainer_Rewiring_ContainerId FOREIGN KEY(ContainerId) REFERENCES Container(Id),
   CONSTRAINT fk_MovementItemContainer_Rewiring_MovementItemId FOREIGN KEY (MovementItemId) REFERENCES MovementItem(id),
   CONSTRAINT fk_MovementItemContainer_Rewiring_MovementDescId FOREIGN KEY(MovementDescId) REFERENCES MovementDesc(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX IF NOT EXISTS idx_MovementItemContainer_Rewiring_MovementId_DescId ON _replica.MovementItemContainer_Rewiring (MovementId, DescId);
CREATE INDEX IF NOT EXISTS idx_MovementItemContainer_Rewiring_Transaction_Id ON _replica.MovementItemContainer_Rewiring (Transaction_Id);


/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Шаблий О.В.
 19.09.23                                          * 
*/