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

   CONSTRAINT pk_ObjectFloat          PRIMARY KEY (ObjectId, DescId),
   CONSTRAINT fk_ObjectFloat_DescId   FOREIGN KEY(DescId)   REFERENCES ObjectFloatDesc(Id),
   CONSTRAINT fk_ObjectFloat_ObjectId FOREIGN KEY(ObjectId) REFERENCES Object(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

CREATE UNIQUE INDEX idx_ObjectFloat_ObjectId_DescId_ValueData ON ObjectFloat(ObjectId, DescId, ValueData); 
CREATE INDEX idx_ObjectFloat_ValueData_DescId_ObjectId ON ObjectFloat(ValueData, DescId, ObjectId); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В. 
14.06.02                                       
*/