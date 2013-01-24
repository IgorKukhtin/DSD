/*
  Создание 
    - таблицы ObjectString (свойства объектов типа TVarChar)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE ObjectString(
   DescId     INTEGER NOT NULL,
   ObjectId   INTEGER NOT NULL,
   ValueData  TVarChar,

   CONSTRAINT ObjectString_DescId_ObjectStringDesc FOREIGN KEY(DescId) REFERENCES ObjectStringDesc(Id),
   CONSTRAINT ObjectString_ObjectId_Object FOREIGN KEY(ObjectId) REFERENCES Object(Id) );

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

CREATE UNIQUE INDEX ObjectString_PKey ON ObjectString(DescId, ObjectId);
CLUSTER ObjectString_PKey ON ObjectString; 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
14.06.02
*/