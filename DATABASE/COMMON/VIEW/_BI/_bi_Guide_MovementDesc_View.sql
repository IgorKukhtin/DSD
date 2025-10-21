-- View: _bi_Guide_MovementDesc_View

 DROP VIEW IF EXISTS _bi_Guide_MovementDesc_View;

-- Справочник Вид документа
/*
Id
Name
*/


CREATE OR REPLACE VIEW _bi_Guide_MovementDesc_View
AS
     SELECT
            MovementDesc.Id         AS Id
          , MovementDesc.ItemName   AS Name
     FROM MovementDesc
    ;

ALTER TABLE _bi_Guide_MovementDesc_View  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC._bi_Guide_MovementDesc_View TO admin;
GRANT ALL ON TABLE PUBLIC._bi_Guide_MovementDesc_View TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_MovementDesc_View
