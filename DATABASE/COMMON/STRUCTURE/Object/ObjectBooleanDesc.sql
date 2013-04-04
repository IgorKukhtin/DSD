/*
  Создание 
    - таблицы ObjectBooleanDesc (свойства классов oбъектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectBooleanDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY,
   DescId                INTEGER NOT NULL,
   Code                  TVarChar,
   ItemName              TVarChar,

   CONSTRAINT fk_ObjectBooleanDesc_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id) 
);

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
