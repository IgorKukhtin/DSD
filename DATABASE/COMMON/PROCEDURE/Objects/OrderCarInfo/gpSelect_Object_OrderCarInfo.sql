-- Function: gpSelect_Object_OrderCarInfo (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_OrderCarInfo (Boolean,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_OrderCarInfo(
    IN inIsShowAll        Boolean,   
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer 
             , RouteId Integer, RouteCode Integer, RouteName TVarChar
             , RetailId Integer, RetailCode Integer, RetailName TVarChar
             , OperDate TVarChar, OperDatePartner TVarChar
             , Days TFloat
             , Hour TFloat, Min TFloat
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_OrderCarInfo());
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Результат
     RETURN QUERY 
       SELECT 
             Object_OrderCarInfo.Id          AS Id

           , Object_Route.Id           AS RouteId
           , Object_Route.ObjectCode   AS RouteCode
           , Object_Route.ValueData    AS RouteName

           , Object_Retail.Id          AS RetailId
           , Object_Retail.ObjectCode  AS RetailCode
           , Object_Retail.ValueData   AS RetailName 

           , CASE WHEN COALESCE (ObjectFloat_OperDate.ValueData,0) = 1 THEN 'Пн' 
                  WHEN COALESCE (ObjectFloat_OperDate.ValueData,0) = 2 THEN 'Вт'
                  WHEN COALESCE (ObjectFloat_OperDate.ValueData,0) = 3 THEN 'Ср'
                  WHEN COALESCE (ObjectFloat_OperDate.ValueData,0) = 4 THEN 'Чт'
                  WHEN COALESCE (ObjectFloat_OperDate.ValueData,0) = 5 THEN 'Пт'
                  WHEN COALESCE (ObjectFloat_OperDate.ValueData,0) = 6 THEN 'Сб'
                  WHEN COALESCE (ObjectFloat_OperDate.ValueData,0) = 7 THEN 'Вс'
                  ELSE '???' 
             END    :: TVarChar AS OperDate
           , CASE WHEN COALESCE (ObjectFloat_OperDatePartner.ValueData,0) = 1 THEN 'Пн' 
                  WHEN COALESCE (ObjectFloat_OperDatePartner.ValueData,0) = 2 THEN 'Вт'
                  WHEN COALESCE (ObjectFloat_OperDatePartner.ValueData,0) = 3 THEN 'Ср'
                  WHEN COALESCE (ObjectFloat_OperDatePartner.ValueData,0) = 4 THEN 'Чт'
                  WHEN COALESCE (ObjectFloat_OperDatePartner.ValueData,0) = 5 THEN 'Пт'
                  WHEN COALESCE (ObjectFloat_OperDatePartner.ValueData,0) = 6 THEN 'Сб'
                  WHEN COALESCE (ObjectFloat_OperDatePartner.ValueData,0) = 7 THEN 'Вс'
                  ELSE '???' 
             END    :: TVarChar AS OperDatePartner 
           , COALESCE (ObjectFloat_Days.ValueData,0)            :: TFloat  AS Days
           , COALESCE (ObjectFloat_Hour.ValueData,0)            :: TFloat  AS Hour
           , COALESCE (ObjectFloat_Min.ValueData,0)             :: TFloat  AS Min

           , Object_OrderCarInfo.isErased  AS isErased
           
       FROM Object AS Object_OrderCarInfo
            
            LEFT JOIN ObjectLink AS OrderCarInfo_Route
                                 ON OrderCarInfo_Route.ObjectId = Object_OrderCarInfo.Id
                                AND OrderCarInfo_Route.DescId = zc_ObjectLink_OrderCarInfo_Route()
            LEFT JOIN Object AS Object_Route ON Object_Route.Id = OrderCarInfo_Route.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_OrderCarInfo_Retail 
                                 ON ObjectLink_OrderCarInfo_Retail.ObjectId = Object_OrderCarInfo.Id
                                AND ObjectLink_OrderCarInfo_Retail.DescId = zc_ObjectLink_OrderCarInfo_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_OrderCarInfo_Retail.ChildObjectId            

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
-- SELECT * FROM gpSelect_Object_OrderCarInfo (TRUE, zfCalc_UserAdmin())
