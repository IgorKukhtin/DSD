/*
  Создание 
    - таблицы Object (oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                Integer NOT NULL,
   ObjectCode            Integer,
   ValueData             TVarChar,
   IsErased              Boolean NOT NULL DEFAULT false,

   /* Связь с таблицей <ObjectDesc> - класс объекта */
   CONSTRAINT fk_Object_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id));

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE INDEX idx_Object_DescId ON Object(DescId);

CLUSTER idx_Object_DescId ON Object; 


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
13.06.02              *                *
*/
