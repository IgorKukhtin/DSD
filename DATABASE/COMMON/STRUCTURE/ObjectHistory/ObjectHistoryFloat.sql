/*
  Создание 
    - таблицы ObjectHistoryFloat (свойства oбъектов типа TFloat)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectHistoryFloat(
   DescId                INTEGER NOT NULL,
   ObjectHistoryId       INTEGER NOT NULL,
   ValueData             TFloat,

   CONSTRAINT pk_ObjectHistoryFloat          PRIMARY KEY (ObjectHistoryId, DescId),
   CONSTRAINT fk_ObjectHistoryFloat_DescId   FOREIGN KEY(DescId)   REFERENCES ObjectHistoryFloatDesc(Id),
   CONSTRAINT fk_ObjectHistoryFloat_ObjectHistoryId FOREIGN KEY(ObjectHistoryId) REFERENCES ObjectHistory(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE UNIQUE INDEX idx_ObjectHistoryFloat_ObjectHistoryId_DescId_ValueData ON ObjectHistoryFloat(ObjectHistoryId, DescId, ValueData); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В. 
14.06.02                                       
*/