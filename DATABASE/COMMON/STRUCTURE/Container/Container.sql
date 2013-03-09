/*
  Создание 
    - таблицы Container ()
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

CREATE TABLE Container(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   DescId                INTEGER, 
   Amount                TFloat,

   CONSTRAINT Container_DescId_ContainerDesc FOREIGN KEY(DescId) REFERENCES ContainerDesc(Id));


/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */


CREATE INDEX Container_DescId ON Container(DescId); 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
11.07.02                                         
*/
