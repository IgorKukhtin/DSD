DROP FUNCTION IF EXISTS gpGet_Object_PaidType (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_PaidType(
    IN inId          Integer,       -- ключ объекта <>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PaidTypeCode Integer, PaidTypeName TVarChar)
AS
$BODY$
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Price());

  IF COALESCE (inId, 0) = 0
  THEN
    RETURN QUERY
      SELECT
        CAST (0 as Integer)     AS Id
       ,CAST (Null as Integer)  AS PaidTypeCode
       ,CAST (Null as TVarChar) AS PaidTypeName;
  ELSE
    RETURN QUERY
      SELECT
        Object_PaidType_View.Id
       ,Object_PaidType_View.PaidTypeCode
       ,Object_PaidType_View.PaidTypeName
      FROM Object_PaidType_View
      WHERE Object_PaidType_View.Id = inId;
   END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_PaidType (Integer, TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 06.07.15                                                          *
*/

-- тест
-- SELECT * FROM gpGet_Object_PaidType (0, '')
