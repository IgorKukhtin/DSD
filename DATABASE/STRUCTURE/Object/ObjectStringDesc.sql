/*
  Создание 
    - таблицы ObjectStringDesc (свойства классов oбъектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectStringDesc(
   Id         INTEGER NOT NULL PRIMARY KEY,
   ObjectDescId  INTEGER NOT NULL,
   Code       TVarChar,
   ItemName   TVarChar,
   isErased   TVarChar,
   CONSTRAINT ObjectStringDesc_ObjectDescId_ObjectDesc FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

CREATE UNIQUE INDEX ObjectStringDesc_Code ON ObjectStringDesc(Code);
CLUSTER ObjectStringDesc_Code ON ObjectStringDesc;


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Тараненко А.Е.   Беленогов С.Б.
14.06.02                                              *
*/
