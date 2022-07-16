-- Function: gpSelect_Object_OrderCarInfo (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_OrderCarInfo (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderCarInfo(
    IN inIsShowAll        Boolean,
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , RouteId Integer, RouteCode Integer, RouteName TVarChar
             , RetailId Integer, RetailCode Integer, RetailName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , OperDate TVarChar, OperDatePartner TVarChar
             , Days TFloat
             , Hour TFloat, Min TFloat
             , OperDate_CarInfo TDateTime, OperDate_CarInfo_date TDateTime
             , DayOfWeekName_CarInfo TVarChar, DayOfWeekName_CarInfo_date TVarChar
             , OperDate_int Integer
             , OperDatePartner_int Integer
             , isErased boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_OrderCarInfo());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY
       WITH tmpRes AS (SELECT
                             Object_OrderCarInfo.Id          AS Id

                           , Object_Route.Id           AS RouteId
                           , Object_Route.ObjectCode   AS RouteCode
                           , Object_Route.ValueData    AS RouteName

                           , Object_Retail.Id          AS RetailId
                           , Object_Retail.ObjectCode  AS RetailCode
                           , Object_Retail.ValueData   AS RetailName

                           , Object_Unit.Id          AS UnitId
                           , Object_Unit.ObjectCode  AS UnitCode
                           , Object_Unit.ValueData   AS UnitName

                           , COALESCE (ObjectFloat_OperDate.ValueData, 0)        :: Integer AS OperDate
                           , COALESCE (ObjectFloat_OperDatePartner.ValueData, 0) :: Integer AS OperDatePartner

                           , COALESCE (ObjectFloat_Days.ValueData,0)            :: TFloat  AS Days
                           , COALESCE (ObjectFloat_Hour.ValueData,0)            :: TFloat  AS Hour
                           , COALESCE (ObjectFloat_Min.ValueData,0)             :: TFloat  AS Min

                             -- !!!Дата/время отгрузки - Расчет!!!
                           , (CURRENT_DATE - (zfCalc_DayOfWeekNumber (CURRENT_DATE) :: TVarChar || ' DAY') :: INTERVAL
                                           + ((ObjectFloat_OperDatePartner.ValueData :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                           + ((CASE WHEN ObjectFloat_Days.ValueData > 0 THEN  1 * ObjectFloat_Days.ValueData ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                           - ((CASE WHEN ObjectFloat_Days.ValueData < 0 THEN -1 * ObjectFloat_Days.ValueData ELSE 0 END :: Integer) :: TVarChar || ' DAY') :: INTERVAL
                                           + ((COALESCE (ObjectFloat_Hour.ValueData, 0) :: Integer) :: TVarChar || ' HOUR')   :: INTERVAL
                                           + ((COALESCE (ObjectFloat_Min.ValueData, 0)  :: Integer) :: TVarChar || ' MINUTE') :: INTERVAL
                             ) :: TDateTime AS OperDate_CarInfo

                           , Object_OrderCarInfo.isErased  AS isErased

                       FROM Object AS Object_OrderCarInfo

                            LEFT JOIN ObjectLink AS ObjectLink_Route
                                                 ON ObjectLink_Route.ObjectId = Object_OrderCarInfo.Id
                                                AND ObjectLink_Route.DescId = zc_ObjectLink_OrderCarInfo_Route()
                            LEFT JOIN Object AS Object_Route ON Object_Route.Id = ObjectLink_Route.ChildObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Retail
                                                 ON ObjectLink_Retail.ObjectId = Object_OrderCarInfo.Id
                                                AND ObjectLink_Retail.DescId = zc_ObjectLink_OrderCarInfo_Retail()
                            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Retail.ChildObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                 ON ObjectLink_Unit.ObjectId = Object_OrderCarInfo.Id
                                                AND ObjectLink_Unit.DescId = zc_ObjectLink_OrderCarInfo_Unit()
                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                            LEFT JOIN ObjectFloat AS ObjectFloat_OperDate
                                                  ON ObjectFloat_OperDate.ObjectId = Object_OrderCarInfo.Id
                                                 AND ObjectFloat_OperDate.DescId = zc_ObjectFloat_OrderCarInfo_OperDate()
                            LEFT JOIN ObjectFloat AS ObjectFloat_OperDatePartner
                                                  ON ObjectFloat_OperDatePartner.ObjectId = Object_OrderCarInfo.Id
                                                 AND ObjectFloat_OperDatePartner.DescId = zc_ObjectFloat_OrderCarInfo_OperDatePartner()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Days
                                                  ON ObjectFloat_Days.ObjectId = Object_OrderCarInfo.Id
                                                 AND ObjectFloat_Days.DescId = zc_ObjectFloat_OrderCarInfo_Days()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Hour
                                                  ON ObjectFloat_Hour.ObjectId = Object_OrderCarInfo.Id
                                                 AND ObjectFloat_Hour.DescId = zc_ObjectFloat_OrderCarInfo_Hour()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Min
                                                  ON ObjectFloat_Min.ObjectId = Object_OrderCarInfo.Id
                                                 AND ObjectFloat_Min.DescId = zc_ObjectFloat_OrderCarInfo_Min()

                     WHERE Object_OrderCarInfo.DescId = zc_Object_OrderCarInfo()
                       AND (Object_OrderCarInfo.isErased = inIsShowAll OR inIsShowAll = TRUE)
                    )
       -- Результат
       SELECT
             tmpRes.Id

           , tmpRes.RouteId
           , tmpRes.RouteCode
           , tmpRes.RouteName

           , tmpRes.RetailId
           , tmpRes.RetailCode
           , tmpRes.RetailName

           , tmpRes.UnitId
           , tmpRes.UnitCode
           , tmpRes.UnitName

           , CASE tmpRes.OperDate
                  WHEN 1 THEN '1-Пн'
                  WHEN 2 THEN '2-Вт'
                  WHEN 3 THEN '3-Ср'
                  WHEN 4 THEN '4-Чт'
                  WHEN 5 THEN '5-Пт'
                  WHEN 6 THEN '6-Сб'
                  WHEN 7 THEN '7-Вс'
                  ELSE '???'
             END    :: TVarChar AS OperDate
           , CASE tmpRes.OperDatePartner
                  WHEN 1 THEN '1-Пн'
                  WHEN 2 THEN '2-Вт'
                  WHEN 3 THEN '3-Ср'
                  WHEN 4 THEN '4-Чт'
                  WHEN 5 THEN '5-Пт'
                  WHEN 6 THEN '6-Сб'
                  WHEN 7 THEN '7-Вс'
                  ELSE '???'
             END    :: TVarChar AS OperDatePartner

           , tmpRes.Days
           , tmpRes.Hour
           , tmpRes.Min

             -- Дата/время отгрузки
           , tmpRes.OperDate_CarInfo
             -- Дата смены
           , CASE WHEN EXTRACT (HOUR FROM tmpRes.OperDate_CarInfo) < 8 THEN DATE_TRUNC ('DAY', tmpRes.OperDate_CarInfo) - INTERVAL '1 DAY'
                  ELSE DATE_TRUNC ('DAY', tmpRes.OperDate_CarInfo)
             END :: TDateTime AS OperDate_CarInfo_date

             -- День недели для Дата/время отгрузки факт
           , CASE EXTRACT (DOW FROM tmpRes.OperDate_CarInfo)
                  WHEN 1 THEN '1-Пн'
                  WHEN 2 THEN '2-Вт'
                  WHEN 3 THEN '3-Ср'
                  WHEN 4 THEN '4-Чт'
                  WHEN 5 THEN '5-Пт'
                  WHEN 6 THEN '6-Сб'
                  WHEN 0 THEN '7-Вс'
                  ELSE '???'
             END    :: TVarChar AS DayOfWeekName_CarInfo

             -- День недели для Дата смены
           , CASE EXTRACT (DOW FROM CASE WHEN EXTRACT (HOUR FROM tmpRes.OperDate_CarInfo) < 8 THEN DATE_TRUNC ('DAY', tmpRes.OperDate_CarInfo) - INTERVAL '1 DAY'
                                         ELSE DATE_TRUNC ('DAY', tmpRes.OperDate_CarInfo)
                                    END)
                  WHEN 1 THEN '1-Пн'
                  WHEN 2 THEN '2-Вт'
                  WHEN 3 THEN '3-Ср'
                  WHEN 4 THEN '4-Чт'
                  WHEN 5 THEN '5-Пт'
                  WHEN 6 THEN '6-Сб'
                  WHEN 0 THEN '7-Вс'
                  ELSE '???'
             END    :: TVarChar AS DayOfWeekName_CarInfo

           , tmpRes.OperDate        AS OperDate_int
           , tmpRes.OperDatePartner AS OperDatePartner_int

           , tmpRes.isErased

       FROM tmpRes
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.22         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_OrderCarInfo (FALSE, zfCalc_UserAdmin())
