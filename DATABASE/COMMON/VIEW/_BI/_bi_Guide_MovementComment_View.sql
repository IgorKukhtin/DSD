-- View: _bi_Guide_MovementComment_View

 DROP VIEW IF EXISTS _bi_Guide_MovementComment_View;

-- Справочник Вид документа
/*
Id
Name
*/


CREATE OR REPLACE VIEW _bi_Guide_MovementComment_View
AS
     SELECT
            MovementString.MovementId  AS Id
          , MovementString.ValueData   AS Name
     FROM MovementString
     WHERE MovementString.DescId = zc_MovementString_Comment()
       AND MovementString.ValueData <> ''
    ;

ALTER TABLE _bi_Guide_MovementComment_View  OWNER TO postgres;

GRANT ALL ON TABLE PUBLIC._bi_Guide_MovementComment_View TO admin;
GRANT ALL ON TABLE PUBLIC._bi_Guide_MovementComment_View TO project;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.10.25                                        *
*/

-- тест
-- SELECT * FROM _bi_Guide_MovementComment_View
