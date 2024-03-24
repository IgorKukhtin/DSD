/*
  Создание 
    - таблицы Container_data ()
    - связей
    - индексов
*/

-- DROP TABLE Container_data;

/*-------------------------------------------------------------------------------*/

CREATE TABLE Container_data(
   StartDate             TDateTime NOT NULL, 
   VerId                 Integer NOT NULL, 
   Id                    SERIAL NOT NULL, 
   DescId                INTEGER NOT NULL, 
   ObjectId              Integer NOT NULL, -- Счет
   Amount                TFloat  NOT NULL DEFAULT 0,
   Amount_data_real      TFloat  NOT NULL DEFAULT 0,
   ParentId              Integer NULL,  

   KeyValue              TVarChar,
   MasterKeyValue        BigInt,
   ChildKeyValue         BigInt,
   WhereObjectId         Integer,
   
   CONSTRAINT fk_Container_data_DescId_ContainerDesc FOREIGN KEY(DescId) REFERENCES ContainerDesc(Id),
   -- !!!
   -- CONSTRAINT fk_Container_data_ObjectId_Object FOREIGN KEY(ObjectId) REFERENCES Object(Id),
   -- !!!
   CONSTRAINT fk_Container_data_ParentId_Container_data FOREIGN KEY(ParentId) REFERENCES Container(Id)
);

/*                                  Индексы                                      */

CREATE UNIQUE INDEX idx_Container_data_UNIQUE ON Container_data (VerId, StartDate, Id);

CREATE INDEX idx_Container_data_MasterKeyValue_ChildKeyValue ON Container_data (masterkeyvalue, childkeyvalue);
CREATE INDEX idx_Container_data_WhereObjectId_Amount ON Container_data (whereobjectid, descid, amount, objectid);
CREATE INDEX idx_Container_data_ObjectId_DescId ON Container_data (ObjectId, DescId);

CREATE INDEX idx_Container_data_WhereObjectId_Amount_all ON Container_data (VerId, StartDate, whereobjectid, descid, amount, objectid);
CREATE INDEX idx_Container_data_ObjectId_DescId_all ON Container_data (VerId, StartDate, ObjectId, DescId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
22.03.24              *
*/
