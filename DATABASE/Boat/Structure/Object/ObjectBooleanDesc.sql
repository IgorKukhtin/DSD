/*
  Создание 
    - таблицы ObjectBooleanDesc (свойства классов oбъектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectBooleanDesc(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectBooleanDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id) 
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
