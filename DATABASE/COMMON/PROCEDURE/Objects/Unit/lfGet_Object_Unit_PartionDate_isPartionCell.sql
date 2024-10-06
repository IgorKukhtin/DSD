-- Function: lfGet_Object_Unit_isPartionCell()

DROP FUNCTION IF EXISTS lfGet_Object_Unit_PartionDate_isPartionCell ();

CREATE OR REPLACE FUNCTION lfGet_Object_Unit_PartionDate_isPartionCell(
)
RETURNS TDateTime
AS
$BODY$
BEGIN

     RETURN '01.10.2024';


END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.24                                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_Unit_PartionDate_isPartionCell()
