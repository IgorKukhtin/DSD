-- Function: gpGet_OlapSoldReportBusiness (TVarChar)

DROP FUNCTION IF EXISTS gpGet_OlapSoldReportBusiness (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_OlapSoldReportBusiness(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (BusinessId Integer, BusinessName TVarChar)
AS
$BODY$
  DECLARE vbUserId     Integer;
  DECLARE vbBusinessId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     IF vbUserId = 1058530 -- Няйко В.И.
        --OR vbUserId = 5
     THEN
         vbBusinessId:= 8371; -- Мясо
     END IF;


     -- Результат
     RETURN QUERY 
       SELECT Object_Business.Id        AS BusinessId
            , Object_Business.ValueData AS BusinessName
       FROM Object AS Object_Business
       WHERE Object_Business.Id = vbBusinessId;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.04.22                                        * all
*/

-- тест
-- SELECT * FROM gpGet_OlapSoldReportBusiness (zfCalc_UserAdmin())
-- SELECT * FROM gpGet_OlapSoldReportBusiness ('1058530')
