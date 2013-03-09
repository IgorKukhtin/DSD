/*
  Создание 
    - таблицы ObjectDate (свойства объектов типа TDateTime)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectDate(
   DescId     INTEGER NOT NULL,
   ObjectId   INTEGER NOT NULL,
   ValueData  TDateTime,

   CONSTRAINT ObjectDate_DescId_ObjectDateDesc FOREIGN KEY(DescId) REFERENCES ObjectDateDesc(Id),
   CONSTRAINT ObjectDate_ObjectId_Object FOREIGN KEY(ObjectId) REFERENCES Object(Id) )


/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE NONCLUSTERED INDEX ObjectDate_DescId ON ObjectDate(DescId)
CREATE NONCLUSTERED INDEX ObjectDate_ObjectId ON ObjectDate(ObjectId)
CREATE UNIQUE NONCLUSTERED INDEX ObjectDate_ObjectId_DescId ON ObjectDate(ObjectId,DescId) 


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
14.06.02                                                         
*/
