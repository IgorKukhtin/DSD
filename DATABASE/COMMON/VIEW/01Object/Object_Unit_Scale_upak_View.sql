-- View: Object_Unit_Scale_upak_View

-- DROP VIEW IF EXISTS Object_Unit_Scale_upak_View;

CREATE OR REPLACE VIEW Object_Unit_Scale_upak_View AS

   SELECT Object_From.Id         AS FromId
        , Object_From.ObjectCode AS Code_from
        , Object_From.ValueData  AS Name_from
        , Object_To.Id           AS ToId
        , Object_To.ObjectCode   AS Code_to
        , Object_To.ValueData    AS Name_to
   FROM Object AS Object_From
        LEFT JOIN Object AS Object_To ON Object_To.Id = 8451 -- ЦЕХ упаковки
   WHERE Object_From.Id = 8459 -- Розподільчий комплекс
    --AND 1=0
   ;

ALTER TABLE Object_Unit_Scale_upak_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.09.14                                        *
*/

-- тест
-- SELECT * FROM Object_Unit_Scale_upak_View
