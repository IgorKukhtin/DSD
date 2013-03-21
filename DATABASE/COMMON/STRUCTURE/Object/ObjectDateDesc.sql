/*
  Создание 
    - таблицы ObjectDateDesc (свойства классов oбъектов типа TDate)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectDateDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY,
   ObjectDescId          INTEGER NOT NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectDateDesc_ObjectDescId FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id) );



/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
14.06.02                                         
*/
