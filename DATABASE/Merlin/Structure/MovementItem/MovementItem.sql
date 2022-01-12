-- Создание - таблицы MovementItem + связей + индексов

-------------------------------------------------------------------------------

CREATE TABLE MovementItem(
   Id           SERIAL  NOT NULL PRIMARY KEY, 
   DescId       Integer NOT NULL,
   MovementId   Integer NOT NULL,
   ObjectId     Integer NOT NULL,
   Amount       TFloat  NOT NULL, 
   isErased     Boolean NOT NULL DEFAULT FALSE,
   ParentId     Integer     NULL,

   CONSTRAINT fk_MovementItem_DescId     FOREIGN KEY (DescId)     REFERENCES MovementItemDesc(Id),
   CONSTRAINT fk_MovementItem_MovementId FOREIGN KEY (MovementId) REFERENCES Movement(Id),
   CONSTRAINT fk_MovementItem_ObjectId   FOREIGN KEY (ObjectId)   REFERENCES Object(Id),
   CONSTRAINT fk_MovementItem_ParentId   FOREIGN KEY (ParentId)   REFERENCES MovementItem(Id)      
);

-------------------------------------------------------------------------------

-- Индексы
-- CREATE INDEX idx_MovementItem_Id ON MovementItem (Id);
CREATE INDEX idx_MovementItem_ParentId ON MovementItem (ParentId);
CREATE INDEX idx_MovementItem_MovementId ON MovementItem (MovementId);
CREATE INDEX idx_MovementItem_ObjectId ON MovementItem (ObjectId); -- констрейнт
-- CREATE INDEX idx_MovementItem_MovementId_DescId ON MovementItem (MovementId, DescId);

-- !!! CLUSTER !!!
CLUSTER idx_MovementItem_MovementId ON MovementItem;

/*-------------------------------------------------------------------------------
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.       Фелонюк И.В.
11.04.17                                                *
06.11.13              * add idx_MovementItem_Id
29.06.13              *
*/
