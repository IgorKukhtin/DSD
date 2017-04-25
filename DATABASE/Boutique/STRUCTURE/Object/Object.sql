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
   AccessKeyId           Integer,
   IsErased              Boolean NOT NULL DEFAULT FALSE,

   /* Связь с таблицей <ObjectDesc> - класс объекта */
   CONSTRAINT fk_Object_DescId FOREIGN KEY(DescId) REFERENCES ObjectDesc(Id));

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */
CREATE INDEX idx_Object_DescId ON Object(DescId);
CREATE INDEX idx_Object_DescId_ValueData ON Object(DescId, ValueData);
CREATE INDEX idx_Object_DescId_ObjectCode ON Object(DescId, ObjectCode);

CLUSTER object_pkey ON Object; 

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




