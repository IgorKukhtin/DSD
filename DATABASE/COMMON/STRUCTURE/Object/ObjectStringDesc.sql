/*
  Создание 
    - таблицы ObjectStringDesc (свойства классов oбъектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectStringDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectStringDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id) 
);

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
