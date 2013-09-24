-- Function: gpSelect_Object_RateFuel()

--DROP FUNCTION gpSelect_Object_RateFuel();

CREATE OR REPLACE FUNCTION gpSelect_Object_RateFuel(
    IN inSession     TVarChar       -- ÒÂÒÒËˇ ÔÓÎ¸ÁÓ‚‡ÚÂÎˇ
)
RETURNS TABLE (Id Integer, 
             , Amount TFloat, Amount—oldHour TFloat, Amount—oldDistance TFloat
             , CarId integer, CarCode integer, CarName TVarChar
             , RouteKindId integer, RouteKindCode integer, RouteKindName TVarChar
             , RateFuelKindId integer, RateFuelKindCode integer, RateFuelKindName TVarChar
             , isErased boolean
             ) AS
$BODY$BEGIN
   -- ÔÓ‚ÂÍ‡ Ô‡‚ ÔÓÎ¸ÁÓ‚‡ÚÂÎˇ Ì‡ ‚˚ÁÓ‚ ÔÓˆÂ‰Û˚
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_RateFuel());

     RETURN QUERY 
       SELECT 
             Object_RateFuel.Id          AS Id
         
           , ObjectFloat_Amount.ValueData             AS Amount
           , ObjectFloat_Amount—oldHour.ValueData     AS Amount—oldHour
           , ObjectFloat_Amount—oldDistance.ValueData AS Amount—oldDistance
         
           , Object_Car.Id         AS CarId
           , Object_Car.ObjectCode AS CarCode
           , Object_Car.ValueData  AS CarName

           , Object_RouteKind.Id         AS RouteKindId
           , Object_RouteKind.ObjectCode AS RouteKindCode
           , Object_RouteKind.ValueData  AS RouteKindName

           , Object_RateFuelKind.Id         AS RateFuelKindId
           , Object_RateFuelKind.ObjectCode AS RateFuelKindCode
           , Object_RateFuelKind.ValueData  AS RateFuelKindName
 
           , Object.isErased AS isErased
           
       FROM Object AS Object_RateFuel
       
            LEFT JOIN ObjectFloat AS ObjectFloat_Amount ON ObjectFloat_Amount.ObjectId = Object_RateFuel.Id 
                                                       AND ObjectFloat_Amount.DescId = zc_ObjectFloat_RateFuel_Amount()
            LEFT JOIN ObjectFloat AS ObjectFloat_Amount—oldHour ON ObjectFloat_Amount—oldHour.ObjectId = Object_RateFuel.Id 
                                                               AND ObjectFloat_Amount—oldHour.DescId = zc_ObjectFloat_RateFuel_Amount—oldHour()
            LEFT JOIN ObjectFloat AS ObjectFloat_Amount—oldDistance ON ObjectFloat_Amount—oldDistance.ObjectId = Object_RateFuel.Id 
                                                                   AND ObjectFloat_Amount—oldDistance.DescId = zc_ObjectFloat_RateFuel_Amount—oldDistance()
                                                      
            LEFT JOIN ObjectLink AS ObjectLink_RateFuel_Car ON ObjectLink_RateFuel_Car.ObjectId = Object_RateFuel.Id
                                                AND ObjectLink_RateFuel_Car.DescId = zc_ObjectLink_RateFuel_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = ObjectLink_RateFuel_Car.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_RateFuel_RouteKind ON ObjectLink_RateFuel_RouteKind.ObjectId = Object_RateFuel.Id
                                                                 AND ObjectLink_RateFuel_RouteKind.DescId = zc_ObjectLink_RateFuel_RouteKind()
            LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = ObjectLink_RateFuel_RouteKind.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_RateFuel_RateFuelKind ON ObjectLink_RateFuel_RateFuelKind.ObjectId = Object_RateFuel.Id
                                                AND ObjectLink_RateFuel_RateFuelKind.DescId = zc_ObjectLink_RateFuel_RateFuelKind()
            LEFT JOIN Object AS Object_RateFuelKind ON Object_RateFuelKind.Id = ObjectLink_RateFuel_RateFuelKind.ChildObjectId
       
     WHERE Object_RateFuel.DescId = zc_Object_RateFuel();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RateFuel(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 24.09.13          *
*/

-- ÚÂÒÚ
-- SELECT * FROM gpSelect_Object_RateFuel('2')