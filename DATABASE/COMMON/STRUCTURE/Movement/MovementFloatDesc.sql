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
  Id integer NOT NULL,
  Code tvarchar,
  ItemName tvarchar,
  CONSTRAINT MovementFloatDesc_PKey PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementFloatDesc
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*                                  Индексы                                      */



CLUSTER MovementFloatDesc_PKey ON MovementFloatDesc 


/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.  
18.06.02                                                       
*/
