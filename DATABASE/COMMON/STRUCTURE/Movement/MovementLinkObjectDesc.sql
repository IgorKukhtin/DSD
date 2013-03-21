/*
  Создание 
    - таблицы MovementLinkObjectDesc (классы связей между классами перемещений и классами объектов)
    - связей
    - индексов
*/
-- Table: MovementLinkObjectDesc

-- DROP TABLE MovementLinkObjectDesc;

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementLinkObjectDesc
(
  Id                     Integer NOT NULL PRIMARY KEY,
  Code                   TVarChar NOT NULL UNIQUE,
  ItemName               TVarChar
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementLinkObjectDesc
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
*/
