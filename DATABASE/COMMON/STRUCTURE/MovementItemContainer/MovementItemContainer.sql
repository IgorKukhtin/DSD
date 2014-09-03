/*
  Создание 
    - таблицы MovementItemContainer (перемещения)
    - связей
    - индексов
*/
/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemContainer(
   Id             SERIAL NOT NULL PRIMARY KEY, 
   DescId         INTEGER,
   MovementId     INTEGER,
   ContainerId    INTEGER,
   Amount         TFloat, 
   OperDate       TDateTime,
   MovementItemId Integer,
   ParentId       Integer,
   isActive       Boolean,  

   CONSTRAINT fk_MovementItemContainer_DescId FOREIGN KEY(DescId) REFERENCES MovementItemContainerDesc(Id),
   CONSTRAINT fk_MovementItemContainer_MovementId FOREIGN KEY(MovementId) REFERENCES Movement(Id),
   CONSTRAINT fk_MovementItemContainer_ContainerId FOREIGN KEY(ContainerId) REFERENCES Container(Id),
   CONSTRAINT fk_MovementItemContainer_ParentId FOREIGN KEY(ParentId) REFERENCES MovementItemContainer(Id),
   CONSTRAINT fk_MovementItemContainer_MovementItemId FOREIGN KEY (MovementItemId) REFERENCES MovementItem(id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE INDEX idx_MovementItemContainer_MovementId_DescId ON MovementItemContainer(MovementId, DescId);
CREATE INDEX idx_MovementItemContainer_ContainerId_DescId_OperDate_Amount ON MovementItemContainer(ContainerId, DescId, OperDate, Amount);
CREATE INDEX idx_MovementItemContainer_ParentId ON MovementItemContainer(ParentId);
CREATE INDEX idx_MovementItemContainer_MovementItemId ON MovementItemContainer(MovementItemId);
                                                                         

/*-------------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.08.13                                        * 1251Cyr
*/
