-- Function: gpSelect_Object_RateFuel()

--DROP FUNCTION gpSelect_Object_RateFuel();

CREATE OR REPLACE FUNCTION gpSelect_Object_RateFuel(
    IN inSession     TVarChar       -- ÒÂÒÒËˇ ÔÓÎ¸ÁÓ‚‡ÚÂÎˇ
)
RETURNS TABLE (RateFuelId_Internal integer, RateFuelId_External integer,
             , CarId integer, CarCode integer, CarName TVarChar
             , Amount_Internal TFloat, Amount—oldHour_Internal TFloat, Amount—oldDistance_Internal TFloat
             , Amount_External TFloat, Amount—oldHour_External TFloat, Amount—oldDistance_External TFloat
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- ÔÓ‚ÂÍ‡ Ô‡‚ ÔÓÎ¸ÁÓ‚‡ÚÂÎˇ Ì‡ ‚˚ÁÓ‚ ÔÓˆÂ‰Û˚
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_RateFuel());

     RETURN QUERY 
       SELECT 
             tmpRateFuel.RateFuelId_Internal  AS RateFuelId_Internal
           , tmpRateFuel.RateFuelId_External  AS RateFuelId_External

           , Object_Car.Id         AS CarId
           , Object_Car.ObjectCode AS CarCode
           , Object_Car.ValueData  AS CarName
 
           , tmpRateFuel.Amount_Internal             AS Amount_Internal
           , tmpRateFuel.Amount—oldHour_Internal     AS Amount—oldHour_Internal
           , tmpRateFuel.Amount—oldDistance_Internal AS Amount—oldDistance_Internal
 
 
           , tmpRateFuel.Amount_External             AS Amount_External
           , tmpRateFuel.Amount—oldHour_External     AS Amount—oldHour_External
           , tmpRateFuel.Amount—oldDistance_External AS Amount—oldDistance_External

           , Object.isErased AS isErased
           
       FROM Object AS Object_Car
            
            LEFT JOIN ( SELECT ObjectLink_RateFuel_Car.ChildObjectId AS CarId
                              , MAX(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_Internal() THEN Object_RateFuel.Id ELSE 0 END) AS RateFuelId_Internal
                              , MAX(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_External() THEN Object_RateFuel.Id ELSE 0 END) AS RateFuelId_External
                              
                              , sum(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_Internal() THEN ObjectFloat_Amount.ValueData ELSE 0 END) AS Amount_Internal
							  , sum(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_Internal() THEN ObjectFloat_Amount—oldHour.ValueData ELSE 0 END) AS Amount—oldHour_Internal
							  , sum(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_Internal() THEN ObjectFloat_Amount—oldDistance.ValueData ELSE 0 END) AS Amount—oldDistance_Internal

							  , sum(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_External() THEN ObjectFloat_Amount.ValueData ELSE 0 END) AS Amount_External
							  , sum(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_External() THEN ObjectFloat_Amount—oldHour.ValueData ELSE 0 END) AS Amount—oldHour_External
							  , sum(CASE when ObjectLink_RateFuel_RouteKind	= zc_Enum_RouteKind_External() THEN ObjectFloat_Amount—oldDistance.ValueData ELSE 0 END) AS Amount—oldDistance_External
							  
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
                             LEFT JOIN ObjectFloat AS ObjectFloat_Amount—oldHour
                                                   ON ObjectFloat_Amount—oldHour.ObjectId = Object_RateFuel.Id 
                                                  AND ObjectFloat_Amount—oldHour.DescId = zc_ObjectFloat_RateFuel_Amount—oldHour()
                             LEFT JOIN ObjectFloat AS ObjectFloat_Amount—oldDistance
                                                   ON ObjectFloat_Amount—oldDistance.ObjectId = Object_RateFuel.Id 
                                                  AND ObjectFloat_Amount—oldDistance.DescId = zc_ObjectFloat_RateFuel_Amount—oldDistance()
                        WHERE Object_RateFuel.DescId = zc_Object_RateFuel()
                        GROUP BY ObjectLink_RateFuel_Car.ChildObjectId
                             ) tmpRateFuel ON tmpRateFuel.CarId = Object_Car.Id

     WHERE Object_Car.DescId = zc_Object_Car();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RateFuel(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 26.09.13          *
*/

-- ÚÂÒÚ
-- SELECT * FROM gpSelect_Object_RateFuel('2')