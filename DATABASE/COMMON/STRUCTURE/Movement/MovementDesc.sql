/*
  Создание 
    - таблицы MovementDesc (классы перемещений)
    - cвязей
    - индексов
*/
 

-- Table: MovementDesc

-- DROP TABLE MovementDesc;

/*-------------------------------------------------------------------------------*/
CREATE TABLE MovementDesc
(
  Id                     Integer NOT NULL PRIMARY KEY, 
  Code                   TVarChar NOT NULL UNIQUE,
  ItemName               TVarChar
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementDesc
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
19.09.02                                         
*/
