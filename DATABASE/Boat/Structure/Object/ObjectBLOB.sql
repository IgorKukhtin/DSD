/*
  Создание 
    - таблицы ObjectBLOB (свойства объектов типа TBLOB)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectBLOB(
   DescId                INTEGER NOT NULL,
   ObjectId              INTEGER NOT NULL,
   ValueData             TBLOB,

   CONSTRAINT pk_ObjectBLOB           PRIMARY KEY (ObjectId, DescId),
   CONSTRAINT fk_ObjectBLOB_DescId    FOREIGN KEY(DescId) REFERENCES ObjectBLOBDesc(Id),
   CONSTRAINT fk_ObjectBLOB_ObjectId  FOREIGN KEY(ObjectId) REFERENCES Object(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.


*/