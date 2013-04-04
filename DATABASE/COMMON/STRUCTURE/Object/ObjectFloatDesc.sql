/*
  Создание 
    - таблицы ObjectFloatDesc (свойства классов oбъектов типа TFloat)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectFloatDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY,
   DescId                INTEGER NOT NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectFloatDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id) );



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
