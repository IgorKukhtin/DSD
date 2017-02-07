-- Function: gpGet_DefaultValue()

DROP FUNCTION IF EXISTS lpGetMovementLinkObjectCodeById(Integer);

CREATE OR REPLACE FUNCTION lpGetMovementLinkObjectCodeById(
    IN inId      Integer        
)
RETURNS TVarChar AS
$BODY$
BEGIN
  
  RETURN
  COALESCE((SELECT Code FROM MovementLinkObjectDesc WHERE Id = inId), '');
    
END;
$BODY$

LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION lpGetMovementLinkObjectCodeById(Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.12.13                         *

*/

-- тест
-- SELECT * FROM gpSelect_Role('2')
