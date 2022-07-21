-- Function: gpGet_Object_OrderCarInfo (Integer,TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_OrderCarInfo (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Object_OrderCarInfo (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_OrderCarInfo(
    IN inId          Integer,       -- ключ объекта <Автомобиль> 
    IN inMaskId      Integer,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer 
             , RouteId Integer, RouteCode Integer, RouteName TVarChar
             , RetailId Integer, RetailCode Integer, RetailName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , OperDate TFloat, OperDatePartner TFloat, Days TFloat
             , Hour TFloat, Min TFloat
             ) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_OrderCarInfo());

   IF COALESCE (inId, 0) = 0 AND COALESCE (inMaskId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , CAST (0 as Integer)    AS RouteId  
           , CAST (0 as Integer)    AS RouteCode
           , CAST ('' as TVarChar)  AS RouteName
          
           , CAST (0 as Integer)    AS RetailId  
           , CAST (0 as Integer)    AS RetailCode
           , CAST ('' as TVarChar)  AS RetailName

           , CAST (0 as Integer)    AS UnitId  
           , CAST (0 as Integer)    AS UnitCode
           , CAST ('' as TVarChar)  AS UnitName

           , CAST (0 AS TFloat)     AS OperDate
           , CAST (0 AS TFloat)     AS OperDatePartner 
           , CAST (0 AS TFloat)     AS Days
           , CAST (0 AS TFloat)     AS Hour
           , CAST (0 AS TFloat)     AS Min
;
   ELSE
       RETURN QUERY 
       SELECT 
             CASE WHEN inMaskId <> 0 THEN 0 ELSE Object_OrderCarInfo.Id END :: Integer AS Id
           , Object_Route.Id           AS RouteId
           , Object_Route.ObjectCode   AS RouteCode
           , Object_Route.ValueData    AS RouteName

           , Object_Retail.Id          AS RetailId
           , Object_Retail.ObjectCode  AS RetailCode
           , Object_Retail.ValueData   AS RetailName 

           , Object_Unit.Id          AS UnitId
           , Object_Unit.ObjectCode  AS UnitCode
           , Object_Unit.ValueData   AS UnitName 

           , COALESCE (ObjectFloat_OperDate.ValueData,0)        :: TFloat  AS OperDate
           , COALESCE (ObjectFloat_OperDatePartner.ValueData,0) :: TFloat  AS OperDatePartner 
           , COALESCE (ObjectFloat_Days.ValueData,0)            :: TFloat  AS Days
           , COALESCE (ObjectFloat_Hour.ValueData,0)            :: TFloat  AS Hour
           , COALESCE (ObjectFloat_Min.ValueData,0)             :: TFloat  AS Min
           
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

       WHERE Object_OrderCarInfo.Id = CASE WHEN COALESCE (inId, 0) = 0 THEN inMaskId ELSE inId END;
      
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.07.22         *
 12.07.22         *
*/

-- тест
-- SELECT * FROM gpGet_Object_OrderCarInfo (2, '')
