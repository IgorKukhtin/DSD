/*
  Создание 
    - таблицы ObjectLink (связи oбъектов)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectLink(
   DescId         INTEGER NOT NULL,
   ObjectId       INTEGER NOT NULL,
   ChildObjectId  INTEGER,

   CONSTRAINT pk_ObjectLink                PRIMARY KEY (ObjectId, DescId),
   CONSTRAINT fk_ObjectLink_DescId         FOREIGN KEY(DescId) REFERENCES ObjectLinkDesc(Id),
   CONSTRAINT fk_ObjectLink_ObjectId       FOREIGN KEY(ObjectId) REFERENCES Object(Id),
   CONSTRAINT fk_ObjectLink_ChildObjectId  FOREIGN KEY(ChildObjectId) REFERENCES Object(Id));
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE UNIQUE INDEX idx_ObjectLink_ObjectId_DescId_ChildObjectId  ON ObjectLink(ObjectId, DescId, ChildObjectId);
CREATE UNIQUE INDEX idx_ObjectLink_ChildObjectId_DescId_ObjectId  ON ObjectLink(ChildObjectId, DescId, ObjectId);
CREATE INDEX idx_ObjectLink_DescId ON ObjectLink(DescId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
13.06.02                                      
*/
