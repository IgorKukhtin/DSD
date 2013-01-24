/*
  Создание 
    - таблицы Object (oбъекты)
    - связей
    - индексов
*/


/*-------------------------------------------------------------------------------*/

CREATE TABLE Object(
   Id         SERIAL NOT NULL PRIMARY KEY, 
   DescId     INTEGER NOT NULL,
   ObjectCode INTEGER,
   ValueData  TVarChar,
   isErased   TVarChar,

   /* Связь с таблицей <ObjectDesc> - класс объекта */
   CONSTRAINT Object_DescId_ObjectDesc FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id));

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE INDEX Object_DescId ON Object(DescId);

CLUSTER Object_DescId ON Object; 


/*-------------------------------------------------------------------------------*/


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
13.06.02              *                *
*/
