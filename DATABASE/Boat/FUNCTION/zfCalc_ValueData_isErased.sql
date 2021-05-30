-- Function: zfCalc_ValueData_isErased (TVarChar, Boolean)

DROP FUNCTION IF EXISTS zfCalc_ValueData_isErased (TVarChar, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_ValueData_isErased (inValueData TVarChar, inIsErased Boolean)
RETURNS TVarChar
AS
$BODY$
BEGIN
      RETURN (CASE WHEN inIsErased = TRUE THEN '---'
                   ELSE ''
              END
           || inValueData
             );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.21                                        *
*/

-- тест
-- SELECT zfCalc_ValueData_isErased ('123', TRUE)
