/*
  Создание 
    - таблицы ObjectDateDesc (свойства классов oбъектов типа TFloat)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectDateDesc(
   Id           INTEGER NOT NULL PRIMARY KEY,
   ObjectDescId INTEGER NOT NULL,
   Code         TVarChar,
   ItemName     TVarChar,
   isErased     TVarChar,

   CONSTRAINT ObjectDateDesc_ObjectDescId_ObjectDesc FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id) );



/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE UNIQUE INDEX ObjectDateDesc_Code ON ObjectDateDesc(Code);
CLUSTER ObjectDateDesc_Code ON ObjectDateDesc;

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
14.06.02                                         
*/
