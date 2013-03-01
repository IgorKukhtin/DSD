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
  Id integer NOT NULL,
  Code TVarChar,
  ItemName TVarChar,
  CONSTRAINT MovementDesc_PKey PRIMARY KEY (Id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementDesc
  OWNER TO postgres;



/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */


CREATE UNIQUE INDEX MovementDesc_Code ON MovementDesc(Code);
CLUSTER MovementDesc_Code ON MovementDesc;


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
18.06.02                                         
19.09.02                                         
*/
