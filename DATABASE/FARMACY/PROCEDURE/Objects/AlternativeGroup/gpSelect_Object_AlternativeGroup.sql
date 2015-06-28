DROP FUNCTION IF EXISTS gpSelect_Object_AlternativeGroup(Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AlternativeGroup(
    IN inIsShowDel   Boolean,       --Показывать 0 - только рабочие группы / 1 - так же удаленные
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Name TVarChar, isErased boolean) 
AS
$BODY$
DECLARE
  vbUserId Integer;
BEGIN
  vbUserId:= lpGetUserBySession (inSession);
  -- Результат
  RETURN QUERY
    SELECT
      Object_AlternativeGroup_View.Id
     ,Object_AlternativeGroup_View.Name
     ,Object_AlternativeGroup_View.isErased
    FROM Object_AlternativeGroup_View
	WHERE
	  (
	    inIsShowDel = True
		or
		Object_AlternativeGroup_View.isErased = False
	  )
    ORDER BY
      Name;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_AlternativeGroup(Boolean,TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 28.06.15                                                        *

*/

-- тест
-- SELECT * FROM gpSelect_Object_AlternativeGroup (True,'3');