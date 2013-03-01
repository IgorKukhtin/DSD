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
  Id integer NOT NULL,
  Code tvarchar,
  ItemName tvarchar,
  CONSTRAINT MovementLinkObjectDesc_PKey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementLinkObjectDesc
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */

CLUSTER MovementLinkObjectDesc_PKey ON MovementLinkObjectDesc 

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   Тараненко А.Е.   Беленогов С.Б.
18.06.02                                              *
*/
