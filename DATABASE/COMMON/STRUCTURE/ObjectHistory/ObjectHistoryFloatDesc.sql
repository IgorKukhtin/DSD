/*
  Создание 
    - таблицы ObjectFloatHistoryDesc (свойства классов oбъектов типа TFloat)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectHistoryFloatDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY,
   DescId                INTEGER NOT NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectHistoryFloatDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectHistoryDesc(Id) );

                                     

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
