/*
  Создание 
    - таблицы ObjectDateHistoryDesc (свойства классов oбъектов типа TDate)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectHistoryDateDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY,
   DescId                INTEGER NOT NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectHistoryDateDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectHistoryDesc(Id) );

                                     

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
