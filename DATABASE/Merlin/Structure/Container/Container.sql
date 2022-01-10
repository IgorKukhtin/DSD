-- Создание - таблицы Container + связей + индексов

-------------------------------------------------------------------------------

CREATE TABLE Container(
   Id                    SERIAL   NOT NULL PRIMARY KEY, 
   DescId                Integer  NOT NULL, 
   ObjectId              Integer  NOT NULL, -- Счет
   PartionId             Integer      NULL,
   Amount                TFloat   NOT NULL DEFAULT 0,
   ParentId              Integer      NULL,  
   KeyValue              TVarChar NOT NULL,
   WhereObjectId         Integer      NULL,
   isReserve             Boolean  NOT NULL,
   
   CONSTRAINT fk_Container_DescId    FOREIGN KEY (DescId)    REFERENCES ContainerDesc(Id),
   CONSTRAINT fk_Container_ObjectId  FOREIGN KEY (ObjectId)  REFERENCES Object(Id),
   CONSTRAINT fk_Container_PartionId FOREIGN KEY (PartionId) REFERENCES Object_PartionGoods (MovementItemId),
   CONSTRAINT fk_Container_ParentId  FOREIGN KEY (ParentId)  REFERENCES Container(Id),
   CONSTRAINT fk_Container_WhereObjectId FOREIGN KEY (WhereObjectId) REFERENCES Object(Id)
);

-------------------------------------------------------------------------------
-- CREATE INDEX idx_Container_WhereObjectId_ObjectId1   ON Container (WhereObjectId, DescId, Amount);
-- CREATE INDEX idx_Container_WhereObjectId_ObjectId2   ON Container (WhereObjectId, DescId);

-- Индексы
CREATE INDEX idx_Container_KeyValue                 ON Container (KeyValue);
CREATE INDEX idx_Container_WhereObjectId_ObjectId   ON Container (WhereObjectId, DescId, Amount, ObjectId);
CREATE INDEX idx_Container_WhereObjectId_PartionId  ON Container (WhereObjectId, DescId, Amount, PartionId);
CREATE INDEX idx_Container_ObjectId_DescId          ON Container (ObjectId, DescId);
CREATE INDEX idx_Container_PartionId_DescId         ON Container (PartionId, DescId);
CREATE INDEX idx_Container_DescId                   ON Container (DescId);
CREATE INDEX idx_Container_ParentId                 ON Container (ParentId); 
CREATE INDEX idx_Container_isReserve                ON Container (isReserve);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
19.09.02              * chage index
18.06.02                                         
11.07.02                                         
*/
