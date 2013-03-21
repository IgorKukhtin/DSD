/*
  Создание 
    - таблицы ObjectLinkDesc (связи классов oбъектов)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectLinkDesc(
   Id                    INTEGER NOT NULL PRIMARY KEY,
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar,
   ObjectDescId          Integer NOT NULL,
   ChildObjectDescId     Integer,

   CONSTRAINT fk_ObjectLinkDesc_ObjectDescId       FOREIGN KEY(ObjectDescId) REFERENCES ObjectDesc(Id),
   CONSTRAINT fk_ObjectLinkDesc_ChildObjectDescId  FOREIGN KEY(ChildObjectDescId)  REFERENCES ObjectDesc(Id));

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
