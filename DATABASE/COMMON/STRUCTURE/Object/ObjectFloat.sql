/*
  Создание 
    - таблицы ObjectFloat (свойства oбъектов типа TFloat)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectFloat(
   DescId     INTEGER NOT NULL,
   ObjectId   INTEGER NOT NULL,
   ValueData  TFloat,

   CONSTRAINT ObjectFloat_DescId_ObjectFloatDesc FOREIGN KEY(DescId) REFERENCES ObjectFloatDesc(Id),
   CONSTRAINT ObjectFloat_ObjectId_Object FOREIGN KEY(ObjectId) REFERENCES Object(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE UNIQUE INDEX ObjectFloat_ObjectId_DescId ON ObjectFloat(ObjectId, DescId); 
CLUSTER ObjectFloat_ObjectId_DescId ON ObjectFloat;

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В. 
14.06.02                                       
*/