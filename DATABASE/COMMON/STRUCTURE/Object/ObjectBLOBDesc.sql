/*
  Создание 
    - таблицы ObjectBLOBDesc (свойства классов oбъектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectBLOBDesc(
   Id         INTEGER NOT NULL PRIMARY KEY,
   ObjectDescId  INTEGER NOT NULL,
   Code       TVarChar,
   ItemName   TVarChar,
   isErased   TVarChar,
   CONSTRAINT ObjectBLOBDesc_ObjectDescId_ObjectDesc FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

CREATE UNIQUE INDEX ObjectBLOBDesc_Code ON ObjectBLOBDesc(Code);
CLUSTER ObjectBLOBDesc_Code ON ObjectBLOBDesc;


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
14.06.02                                      
*/
