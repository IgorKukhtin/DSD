/*
  Создание 
    - таблицы ObjectDesc (классы oбъектов)
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar,
   MainCode              TVarChar,
   MainCodeItemName      TVarChar,
   ValueDataCode         TVarChar,
   ValueDataItemName     TVarChar,
   isErased              TVarChar);


/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE UNIQUE INDEX ObjectDesc_Code ON ObjectDesc(Code);

CLUSTER ObjectDesc_Code ON ObjectDesc; 


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
13.06.02                                         
*/
