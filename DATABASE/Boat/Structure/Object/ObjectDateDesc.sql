/*
  Создание 
    - таблицы ObjectDateDesc (свойства классов oбъектов типа TDate)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectDateDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NOT NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectDateDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id) );



/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */



/*-------------------------------------------------------------------------------
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 27.06.13             * SERIAL
*/
