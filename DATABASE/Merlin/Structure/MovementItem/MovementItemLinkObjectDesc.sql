/*
  Создание 
    - таблицы MovementItemLinkObjectDesc (классы связей между классами перемещений и классами объектов)
    - связей
    - индексов
*/
-- Table: MovementItemLinkObjectDesc

-- DROP TABLE MovementItemLinkObjectDesc;

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementItemLinkObjectDesc
(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
  Code                   TVarChar NOT NULL UNIQUE,
  ItemName               TVarChar
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementItemLinkObjectDesc
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */



/*-------------------------------------------------------------------------------
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 29.06.13             * SERIAL
*/
