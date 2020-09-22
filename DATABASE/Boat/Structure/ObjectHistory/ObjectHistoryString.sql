/*
  Создание 
    - таблицы ObjectHistoryString (свойства oбъектов типа TString)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectHistoryString(
   DescId                INTEGER NOT NULL,
   ObjectHistoryId       INTEGER NOT NULL,
   ValueData             TVarChar,

   CONSTRAINT pk_ObjectHistoryString          PRIMARY KEY (ObjectHistoryId, DescId),
   CONSTRAINT fk_ObjectHistoryString_DescId   FOREIGN KEY(DescId)   REFERENCES ObjectHistoryStringDesc(Id),
   CONSTRAINT fk_ObjectHistoryString_ObjectHistoryId FOREIGN KEY(ObjectHistoryId) REFERENCES ObjectHistory(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE UNIQUE INDEX idx_ObjectHistoryString_ObjectHistoryId_DescId_ValueData ON ObjectHistoryString(ObjectHistoryId, DescId, ValueData); 
CREATE INDEX idx_ObjectHistoryString_ValueData_DescId_ObjectHistoryId ON ObjectHistoryString (ValueData, DescId, ObjectHistoryId);

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В. 
14.06.02                                       
*/