/*
  Создание 
    - таблицы MovementLinkMovementDesc (классы связей между классами перемещений)
    - связей
    - индексов
*/
-- Table: MovementLinkMovementDesc

-- DROP TABLE MovementLinkMovementDesc;

/*-------------------------------------------------------------------------------*/

CREATE TABLE MovementLinkMovementDesc
(
   Id                    SERIAL NOT NULL PRIMARY KEY, 
   Code                  TVarChar NOT NULL UNIQUE,
   ItemName              TVarChar
)
WITH (
  OIDS=FALSE
);
ALTER TABLE MovementLinkMovementDesc
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/

/*                                  Индексы                                      */



/*-------------------------------------------------------------------------------
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.   
 12.02.14                             * 
*/
