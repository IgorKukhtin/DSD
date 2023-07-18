-- Function: gpSelect_Object_RateFuel (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_RateFuel (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RateFuel(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (RateFuelId_Internal Integer, RateFuelId_External Integer
             , CarId Integer, CarCode Integer, CarName TVarChar, CarModelName TVarChar
             , Amount_Internal TFloat, AmountColdHour_Internal TFloat, AmountColdDistance_Internal TFloat
             , Amount_External TFloat, AmountColdHour_External TFloat, AmountColdDistance_External TFloat
             , isErased Boolean
             )
AS
$BODY$
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_RateFuel());

     RETURN QUERY 
       SELECT 
             CAST (tmpRateFuel.RateFuelId_Internal AS Integer)  AS RateFuelId_Internal
           , CAST (tmpRateFuel.RateFuelId_External AS Integer)  AS RateFuelId_External

           , Object_Car.Id             AS CarId
           , Object_Car.ObjectCode     AS CarCode
           , Object_Car.ValueData      AS CarName
           , (COALESCE (Object_CarModel.ValueData,'') || COALESCE (' ' || Object_CarType.ValueData, '') ) ::TVarChar AS CarModelName

           , CAST (tmpRateFuel.Amount_Internal AS TFloat)             AS Amount_Internal
           , CAST (tmpRateFuel.AmountColdHour_Internal AS TFloat)     AS AmountColdHour_Internal
           , CAST (tmpRateFuel.AmountColdDistance_Internal AS TFloat) AS AmountColdDistance_Internal
 
 
           , CAST (tmpRateFuel.Amount_External AS TFloat)             AS Amount_External
           , CAST (tmpRateFuel.AmountColdHour_External AS TFloat)     AS AmountColdHour_External
           , CAST (tmpRateFuel.AmountColdDistance_External AS TFloat) AS AmountColdDistance_External

           , Object_Car.isErased AS isErased
           
       FROM Object AS Object_Car
            
            LEFT JOIN (SELECT ObjectLink_RateFuel_Car.ChildObjectId AS CarId
                             , MAX(CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_Internal() THEN Object_RateFuel.Id ELSE 0 END) AS RateFuelId_Internal
                             , MAX(CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_External() THEN Object_RateFuel.Id ELSE 0 END) AS RateFuelId_External

                             , MAX (CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_Internal() THEN ObjectFloat_Amount.ValueData ELSE 0 END) AS Amount_Internal
                             , MAX (CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_Internal() THEN ObjectFloat_AmountColdHour.ValueData ELSE 0 END) AS AmountColdHour_Internal
                             , MAX (CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_Internal() THEN ObjectFloat_AmountColdDistance.ValueData ELSE 0 END) AS AmountColdDistance_Internal

                             , MAX (CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_External() THEN ObjectFloat_Amount.ValueData ELSE 0 END) AS Amount_External
                             , MAX (CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_External() THEN ObjectFloat_AmountColdHour.ValueData ELSE 0 END) AS AmountColdHour_External
                             , MAX (CASE when ObjectLink_RateFuel_RouteKind.ChildObjectId = zc_Enum_RouteKind_External() THEN ObjectFloat_AmountColdDistance.ValueData ELSE 0 END) AS AmountColdDistance_External
                       FROM Object AS Object_RateFuel
                            LEFT JOIN ObjectLink AS ObjectLink_RateFuel_Car
                                                 ON ObjectLink_RateFuel_Car.ObjectId = Object_RateFuel.Id
                                                AND ObjectLink_RateFuel_Car.DescId = zc_ObjectLink_RateFuel_Car()
                            LEFT JOIN ObjectLink AS ObjectLink_RateFuel_RouteKind
                                                 ON ObjectLink_RateFuel_RouteKind.ObjectId = Object_RateFuel.Id
                                                AND ObjectLink_RateFuel_RouteKind.DescId = zc_ObjectLink_RateFuel_RouteKind()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Amount
                                                  ON ObjectFloat_Amount.ObjectId = Object_RateFuel.Id 
                                                 AND ObjectFloat_Amount.DescId = zc_ObjectFloat_RateFuel_Amount()
                            LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdHour
                                                  ON ObjectFloat_AmountColdHour.ObjectId = Object_RateFuel.Id 
                                                 AND ObjectFloat_AmountColdHour.DescId = zc_ObjectFloat_RateFuel_AmountColdHour()
                            LEFT JOIN ObjectFloat AS ObjectFloat_AmountColdDistance
                                                  ON ObjectFloat_AmountColdDistance.ObjectId = Object_RateFuel.Id 
                                                 AND ObjectFloat_AmountColdDistance.DescId = zc_ObjectFloat_RateFuel_AmountColdDistance()
                       WHERE Object_RateFuel.DescId = zc_Object_RateFuel()
                       GROUP BY ObjectLink_RateFuel_Car.ChildObjectId
                      ) tmpRateFuel ON tmpRateFuel.CarId = Object_Car.Id

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarModel ON ObjectLink_Car_CarModel.ObjectId = Object_Car.Id
                                                           AND ObjectLink_Car_CarModel.DescId = zc_ObjectLink_Car_CarModel()
            LEFT JOIN Object AS Object_CarModel ON Object_CarModel.Id = ObjectLink_Car_CarModel.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Car_CarType
                                 ON ObjectLink_Car_CarType.ObjectId = Object_Car.Id
                                AND ObjectLink_Car_CarType.DescId = zc_ObjectLink_Car_CarType()
            LEFT JOIN Object AS Object_CarType ON Object_CarType.Id = ObjectLink_Car_CarType.ChildObjectId

     WHERE Object_Car.DescId = zc_Object_Car();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RateFuel (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.09.13                                        *
 26.09.13          *
*/

-- тест
-- SELECT * FROM gpSelect_Object_RateFuel('2')