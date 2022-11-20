-- Function: lfGet_Object_ValueData_pcp()

DROP FUNCTION IF EXISTS lfGet_Object_ValueData_pcp (Integer);

CREATE OR REPLACE FUNCTION lfGet_Object_ValueData_pcp(
    IN inId              Integer 
)
RETURNS TVarChar
AS
$BODY$
BEGIN
     RETURN (SELECT gpSelect.Name_all
             FROM gpSelect_Object_ProdColorPattern (inColorPatternId:= 0, inIsErased:= FALSE, inIsShowAll := FALSE, inSession:= zfCalc_UserAdmin()) AS gpSelect
             WHERE gpSelect.Id = inId
            );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.11.22                                        *
*/

-- тест
-- SELECT * FROM lfGet_Object_ValueData_pcp (2315)
