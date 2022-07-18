-- Function: zfCalc_ProdColorPattern_isErased (TVarChar, Boolean)

DROP FUNCTION IF EXISTS zfCalc_ProdColorPattern_isErased (TVarChar, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_ProdColorPattern_isErased (inProdColorGroupName TVarChar, inValueData TVarChar, inModelName TVarChar, inIsErased Boolean)
RETURNS TVarChar
AS
$BODY$
BEGIN
      RETURN (zfCalc_ValueData_isErased (inProdColorGroupName
                                    --|| CASE WHEN inValueData         <> '1' THEN ' ' || inValueData ELSE '' END
                                      || CASE WHEN LENGTH (inValueData) >  1  THEN ' ' || inValueData ELSE '' END
                                      || CASE WHEN inModelName <> '' THEN ' (' || inModelName || ')' ELSE '' END
                                       , inIsErased)
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
-- SELECT zfCalc_ProdColorPattern_isErased ('Hypalon', 'primary', '280', TRUE)
