-- Function: gpSelect_Object_AccommodationLincGoodsLog(Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_AccommodationLincGoodsLog (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_AccommodationLincGoodsLog(
    IN inUnitId      Integer,
    IN inGoodsId     Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (AccommodationID Integer
             , AccommodationCode Integer
             , AccommodationName TVarChar
             , UserID Integer
             , UserName TVarChar
             , OperDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Account());
   
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY 
       SELECT
              Object_Accommodation.Id                         AS AccommodationID
            , Object_Accommodation.ObjectCode                 AS AccommodationCode
            , Object_Accommodation.ValueData                  AS AccommodationName
            , Object_User.ID                                  AS UserID
            , Object_User.ValueData                           AS UserName
            , AccommodationLincGoodsLog.OperDate              AS OperDate
            , AccommodationLincGoodsLog.isErased              AS isErased
       FROM AccommodationLincGoodsLog
       
            INNER JOIN Object AS Object_Accommodation ON Object_Accommodation.ID = AccommodationLincGoodsLog.AccommodationId

            LEFT JOIN Object AS Object_User ON Object_User.ID = AccommodationLincGoodsLog.UserId
            
       WHERE AccommodationLincGoodsLog.UnitId = inUnitId 
         AND AccommodationLincGoodsLog.GoodsId = inGoodsId
       ORDER BY AccommodationLincGoodsLog.OperDate;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  ALTER FUNCTION gpSelect_Object_AccommodationLincGoodsLog (Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 30.11.21                                                      * 
*/

-- тест
-- 
select * from gpSelect_Object_AccommodationLincGoodsLog(inUnitId := 375627 , inGoodsId := 23746 ,  inSession := '3');