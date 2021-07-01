-- Function: gpSelectMobile_Object_Route (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpSelectMobile_Object_Route (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelectMobile_Object_Route (
    IN inSyncDateIn TDateTime, -- Дата/время последней синхронизации - когда "успешно" загружалась входящая информация - актуальные справочники, цены, акции, долги, остатки и т.д
    IN inSession    TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , ObjectCode Integer  -- Код
             , ValueData  TVarChar -- Название
             , isErased   Boolean  -- Удаленный ли элемент
             , isSync     Boolean  -- Синхронизируется (да/нет)
              )
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbPersonalId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      vbPersonalId:= (SELECT PersonalId FROM gpGetMobile_Object_Const (inSession));

      -- Результат
      IF vbPersonalId IS NOT NULL 
      THEN
           RETURN QUERY
             WITH tmpProtocol AS (SELECT ObjectProtocol.ObjectId AS RouteId, MAX(ObjectProtocol.OperDate) AS MaxOperDate
                                  FROM ObjectProtocol
                                       JOIN Object AS Object_Route
                                                   ON Object_Route.Id = ObjectProtocol.ObjectId
                                                  AND Object_Route.DescId = zc_Object_Route() 
                                  WHERE inSyncDateIn > zc_DateStart()
                                    AND ObjectProtocol.OperDate > inSyncDateIn
                                  GROUP BY ObjectProtocol.ObjectId
                                 )
                , tmpRoute AS (SELECT DISTINCT ObjectLink_Partner_Route.ChildObjectId AS RouteId
                               FROM ObjectLink AS ObjectLink_Partner_PersonalTrade
                                    JOIN ObjectLink AS ObjectLink_Partner_Route
                                                    ON ObjectLink_Partner_Route.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                   AND ObjectLink_Partner_Route.DescId = zc_ObjectLink_Partner_Route()
                               WHERE ObjectLink_Partner_PersonalTrade.ChildObjectId = vbPersonalId
                                 AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                 AND ObjectLink_Partner_Route.ChildObjectId IS NOT NULL
                              ) 
                , tmpFilter AS (SELECT tmpProtocol.RouteId FROM tmpProtocol
                                UNION
                                SELECT tmpRoute.RouteId FROM tmpRoute WHERE inSyncDateIn <= zc_DateStart()
                               )
             SELECT Object_Route.Id
                  , Object_Route.ObjectCode
                  , Object_Route.ValueData
                  , Object_Route.isErased
                  , (tmpRoute.RouteId IS NOT NULL) AS isSync
             FROM Object AS Object_Route
                  JOIN tmpFilter ON tmpFilter.RouteId = Object_Route.Id
                  LEFT JOIN tmpRoute ON tmpRoute.RouteId = Object_Route.Id
             WHERE Object_Route.DescId = zc_Object_Route()
             LIMIT CASE WHEN vbUserId = zfCalc_UserMobile_limit0() THEN 0 ELSE 500000 END
            ;

      END IF;

END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 17.02.17                                                         *
*/

-- тест
-- SELECT * FROM gpSelectMobile_Object_Route(inSyncDateIn := zc_DateStart(), inSession := zfCalc_UserAdmin())
