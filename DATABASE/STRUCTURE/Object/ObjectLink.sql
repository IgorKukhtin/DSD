/*
  Создание 
    - таблицы ObjectLink (связи oбъектов)
    - связи
    - индексов
*/

/*-------------------------------------------------------------------------------*/
CREATE TABLE ObjectLink(
   DescId         INTEGER NOT NULL,
   ParentObjectId INTEGER NOT NULL,
   ChildObjectId  INTEGER,

   CONSTRAINT ObjectLink_DescId_ObjectLinkDesc FOREIGN KEY(DescId) REFERENCES ObjectLinkDesc(Id),
   CONSTRAINT ObjectLink_ParentObjectId_Object FOREIGN KEY(ParentObjectId) REFERENCES Object(Id),
   CONSTRAINT ObjectLink_ChildObjectId_Object FOREIGN KEY(ChildObjectId) REFERENCES Object(Id));
/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CREATE UNIQUE INDEX ObjectLink_All ON ObjectLink(DescId, ParentObjectId, ChildObjectId);
CLUSTER ObjectLink_All ON ObjectLink;

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
13.06.02                                      
*/
