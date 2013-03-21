/*
  Создание 
    - таблицы ContainerLinkObjectDesc ()
    - связей
    - индексов
*/

/*-------------------------------------------------------------------------------*/

-- Table: ContainerLinkObjectDesc

-- DROP TABLE ContainerLinkObjectDesc;

CREATE TABLE ContainerLinkObjectDesc
(
  Id                     INTEGER NOT NULL PRIMARY KEY,
  Code                   TVarChar NOT NULL UNIQUE,
  ItemName               TVarChar
)
WITH (
  OIDS=FALSE
);
ALTER TABLE ContainerLinkObjectDesc
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
11.07.02                                         
*/