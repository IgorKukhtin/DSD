/*
  Создание 
    - таблицы MovementFloatDesc (свойства классов перемещений типа TFloat)
    - связей
    - индексов
*/

-- Table: MovementFloatDesc

-- DROP TABLE MovementFloatDesc;

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementFloatDesc(
  Id                     Integer NOT NULL PRIMARY KEY,
  Code                   TVarChar NOT NULL UNIQUE,
  ItemName               TVarChar
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementFloatDesc
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
