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
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar,
   FormId                Integer,
   CONSTRAINT fk_MovementDesc_FormId FOREIGN KEY(FormId) REFERENCES Object(Id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementDesc
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
