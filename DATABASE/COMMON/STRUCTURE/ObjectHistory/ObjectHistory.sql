/*
  Создание 
    - таблицы ObjectHistory (oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectHistory(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                Integer NOT NULL,
   StartDate             TDateTime NOT NULL,
   EndDate               TDateTime NOT NULL,
   ObjectId              Integer NOT NULL,

   /* Связь с таблицей <ObjectDesc> - класс объекта */
   CONSTRAINT fk_ObjectHistory_DescId FOREIGN KEY(DescId) REFERENCES ObjectHistoryDesc(Id),
   CONSTRAINT fk_ObjectHistory_ObjectId FOREIGN KEY(ObjectId) REFERENCES Object(Id)
);

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE UNIQUE INDEX idx_ObjectHistory_ObjectId_DescId_StartDate_EndDate ON ObjectHistory(ObjectId, DescId, StartDate, EndDate);
CREATE UNIQUE INDEX idx_ObjectHistory_ObjectId_DescId_StartDate ON ObjectHistory(ObjectId, DescId, StartDate);
CREATE UNIQUE INDEX idx_ObjectHistory_EndDate_DescId_ObjectId ON ObjectHistory(EndDate, DescId, ObjectId);

-- Farmacy
CREATE UNIQUE INDEX idx_ObjectHistory_ObjectId_StartDate_DescId ON ObjectHistory(ObjectId, StartDate, DescId);
CREATE UNIQUE INDEX idx_ObjectHistory_ObjectId_EndDate_DescId ON ObjectHistory(ObjectId, EndDate, DescId);

CREATE INDEX idx_ObjectHistory_ObjectId ON ObjectHistory(ObjectId);
CREATE INDEX idx_ObjectHistory_DescId ON ObjectHistory(DescId);

/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
13.06.02              *                *
*/
