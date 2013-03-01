/*
  Создание 
    - таблицы ObjectBLOB (свойства объектов типа TBLOB)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectBLOB(
   DescId     INTEGER NOT NULL,
   ObjectId   INTEGER NOT NULL,
   ValueData  TBLOB,

   CONSTRAINT ObjectBLOB_PKey PRIMARY KEY (ObjectId, DescId),
   CONSTRAINT ObjectBLOB_DescId_ObjectBLOBDesc FOREIGN KEY(DescId) REFERENCES ObjectBLOBDesc(Id),
   CONSTRAINT ObjectBLOB_ObjectId_Object FOREIGN KEY(ObjectId) REFERENCES Object(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE INDEX ObjectBLOB_Claster ON ObjectBLOB
  (ObjectId, DescId);
CLUSTER ObjectBLOB_Claster ON ObjectBLOB; 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
14.06.02
*/