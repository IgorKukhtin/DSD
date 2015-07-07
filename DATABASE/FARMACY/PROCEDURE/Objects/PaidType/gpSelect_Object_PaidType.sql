-- Function: gpSelect_Object_Street (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_PaidType(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_PaidType(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PaidTypeCode Integer, PaidTypeName TVarChar) 
AS
$BODY$
DECLARE
  vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Street());
  vbUserId:= lpGetUserBySession (inSession);
  -- Ограничение на просмотр товарного справочника
  -- Результат
  RETURN QUERY
    SELECT 
      PaidType.Id
     ,PaidType.PaidTypeCode
     ,PaidType.PaidTypeName
    FROM Object_PaidType_View AS PaidType
    ORDER BY
      PaidType.PaidTypeCode;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_PaidType(TVarChar) OWNER TO postgres;
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А
 06.07.15                                                          *

*/

-- тест
-- SELECT * FROM gpSelect_Object_PaidType ('3');