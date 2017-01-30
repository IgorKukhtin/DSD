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
   ObjectCode            Integer NOT NULL,
   ValueData             TVarChar NOT NULL,
   IsErased              Boolean NOT NULL DEFAULT false,

   /* Связь с таблицей <ObjectDesc> - класс объекта */
   CONSTRAINT fk_Object_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id));

/*-------------------------------------------------------------------------------*/


/*-------------------------------------------------------------------------------*/
/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 30.10.13             * NOT NULL: ObjectCode, ValueData
 27.06.13             *
*/
