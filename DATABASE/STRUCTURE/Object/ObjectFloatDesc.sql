/*
  Создание 
    - таблицы ObjectFloatDesc (свойства классов oбъектов типа TFloat)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectFloatDesc(
   Id           INTEGER NOT NULL PRIMARY KEY,
   ObjectDescId INTEGER NOT NULL,
   Code         TVarChar,
   ItemName     TVarChar,
   isErased     TVarChar,

   CONSTRAINT ObjectFloatDesc_ObjectDescId_ObjectDesc FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id) );



/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE UNIQUE INDEX ObjectFloatDesc_Code ON ObjectFloatDesc(Code);
CLUSTER ObjectFloatDesc_Code ON ObjectFloatDesc;

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
14.06.02                                         
*/
