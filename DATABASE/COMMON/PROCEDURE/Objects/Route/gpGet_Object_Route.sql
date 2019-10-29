-- Function: gpGet_Object_Route (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Route (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Route(
    IN inId             Integer,       -- ключ объекта <Маршрут>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , RateSumma Tfloat, RatePrice Tfloat, TimePrice Tfloat
             , RateSummaAdd Tfloat, RateSummaExp Tfloat
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , RouteKindId Integer, RouteKindCode Integer, RouteKindName TVarChar
             , FreightId Integer, FreightCode Integer, FreightName TVarChar
             , RouteGroupId Integer, RouteGroupCode Integer, RouteGroupName TVarChar
             , StartRunPlan TDateTime, EndRunPlan TVarChar
             , HoursPlan TFloat, MinutePlan TFloat
             , isNotPayForWeight Boolean
             , isErased Boolean
             ) AS
$BODY$BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_Route());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_Route()) AS Code
           , CAST ('' as TVarChar)  AS Name

           , CAST (0 as TFloat)   AS RateSumma
           , CAST (0 as TFloat)   AS RatePrice
           , CAST (0 as TFloat)   AS TimePrice
           , CAST (0 as TFloat)   AS RateSummaAdd
           , CAST (0 as TFloat)   AS RateSummaExp
                      
           , CAST (0 as Integer)   AS UnitId 
           , CAST (0 as Integer)   AS UnitCode
           , CAST ('' as TVarChar) AS UnitName
           
           , CAST (0 as Integer)   AS BranchId 
           , CAST (0 as Integer)   AS BranchCode
           , CAST ('' as TVarChar) AS BranchName


           , CAST (0 as Integer)   AS RouteKindId 
           , CAST (0 as Integer)   AS RouteKindCode
           , CAST ('' as TVarChar) AS RouteKindName

           , CAST (0 as Integer)   AS FreightId 
           , CAST (0 as Integer)   AS FreightCode
           , CAST ('' as TVarChar) AS FreightName
  
           , CAST (0 as Integer)   AS RouteGroupId 
           , CAST (0 as Integer)   AS RouteGroupCode
           , CAST ('' as TVarChar) AS RouteGroupName           

           , NULL   :: TDateTime   AS StartRunPlan
           , NULL   :: TVarChar    AS EndRunPlan 
           , CAST (0 as TFloat)    AS HoursPlan
           , CAST (0 as TFloat)    AS MinutePlan

           , FALSE  ::Boolean       AS isNotPayForWeight
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
       RETURN QUERY 
       SELECT
             Object_Route.Id         AS Id
           , Object_Route.ObjectCode AS Code
           , Object_Route.ValueData  AS NAME

           , ObjectFloat_RateSumma.ValueData    AS RateSumma
           , ObjectFloat_RatePrice.ValueData    AS RatePrice
           , ObjectFloat_TimePrice.ValueData    AS TimePrice
           , ObjectFloat_RateSummaAdd.ValueData AS RateSummaAdd
           , ObjectFloat_RateSummaExp.ValueData AS RateSummaExp
                      
           , Object_Unit.Id         AS UnitId 
           , Object_Unit.ObjectCode AS UnitCode
           , Object_Unit.ValueData  AS UnitName

           , Object_Branch.Id         AS BranchId 
           , Object_Branch.ObjectCode AS BranchCode
           , Object_Branch.ValueData  AS BranchName
           
           , Object_RouteKind.Id         AS RouteKindId 
           , Object_RouteKind.ObjectCode AS RouteKindCode
           , Object_RouteKind.ValueData AS RouteKindName

           , Object_Freight.Id         AS FreightId 
           , Object_Freight.ObjectCode AS FreightCode
           , Object_Freight.ValueData  AS FreightName
  
           , Object_RouteGroup.Id         AS RouteGroupId 
           , Object_RouteGroup.ObjectCode AS RouteGroupCode
           , Object_RouteGroup.ValueData  AS RouteGroupName              

           , COALESCE (ObjectDate_StartRunPlan.ValueData, NULL)   :: TDateTime AS StartRunPlan
           --, COALESCE (ObjectDate_EndRunPlan.ValueData, NULL)     :: TDateTime AS EndRunPlan 
           , CASE WHEN (COALESCE (ObjectDate_StartRunPlan.ValueData ::Time,'00:00') <> '00:00' OR COALESCE (ObjectDate_EndRunPlan.ValueData ::Time,'00:00') <> '00:00') AND ObjectDate_StartRunPlan.ValueData <> ObjectDate_EndRunPlan.ValueData
                  THEN CASE WHEN DATE_PART ('DAY', (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) <> 0
                            THEN  DATE_PART ('DAY', (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) || CASE WHEN DATE_PART ('DAY', (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) = 1 THEN ' день '
                                                                                                                                    WHEN DATE_PART ('DAY', (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) > 4 THEN ' дней '
                                                                                                                                    ELSE ' дня '
                                                                                                                               END 
                            ELSE '' 
                       END
                       || (ObjectDate_EndRunPlan.ValueData ::Time) ::TVarChar
                  ELSE ''
             END :: TVarChar AS EndRunPlan

           , CASE WHEN COALESCE (ObjectDate_StartRunPlan.ValueData ::Time,'00:00') <> '00:00' OR COALESCE (ObjectDate_EndRunPlan.ValueData ::Time,'00:00') <> '00:00'
                  THEN (DATE_PART ('DAY', (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData))::TFloat * 24 )
                      + DATE_PART ('HOUR', (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)):: TFloat
                  ELSE 0
             END                   :: TFloat AS HoursPlan

           , CASE WHEN COALESCE (ObjectDate_StartRunPlan.ValueData ::Time,'00:00') <> '00:00' OR COALESCE (ObjectDate_EndRunPlan.ValueData ::Time,'00:00') <> '00:00'
                  THEN DATE_PART ('MINUTE', (ObjectDate_EndRunPlan.ValueData - ObjectDate_StartRunPlan.ValueData)) :: TFloat
                  ELSE 0
             END                   :: TFloat AS MinutePlan
             
           , COALESCE (ObjectBoolean_NotPayForWeight.ValueData, FALSE) ::Boolean AS isNotPayForWeight
           , Object_Route.isErased   AS isErased
           
       FROM Object AS Object_Route
            LEFT JOIN ObjectFloat AS ObjectFloat_RateSumma
                                  ON ObjectFloat_RateSumma.ObjectId = Object_Route.Id
                                 AND ObjectFloat_RateSumma.DescId = zc_ObjectFloat_Route_RateSumma()

            LEFT JOIN ObjectFloat AS ObjectFloat_RatePrice
                                  ON ObjectFloat_RatePrice.ObjectId = Object_Route.Id
                                 AND ObjectFloat_RatePrice.DescId = zc_ObjectFloat_Route_RatePrice()
            LEFT JOIN ObjectFloat AS ObjectFloat_TimePrice
                                  ON ObjectFloat_TimePrice.ObjectId = Object_Route.Id
                                 AND ObjectFloat_TimePrice.DescId = zc_ObjectFloat_Route_TimePrice()

            LEFT JOIN ObjectFloat AS ObjectFloat_RateSummaAdd
                                  ON ObjectFloat_RateSummaAdd.ObjectId = Object_Route.Id
                                 AND ObjectFloat_RateSummaAdd.DescId = zc_ObjectFloat_Route_RateSummaAdd()
            LEFT JOIN ObjectFloat AS ObjectFloat_RateSummaExp
                                  ON ObjectFloat_RateSummaExp.ObjectId = Object_Route.Id
                                 AND ObjectFloat_RateSummaExp.DescId = zc_ObjectFloat_Route_RateSummaExp()

            LEFT JOIN ObjectDate AS ObjectDate_StartRunPlan
                                 ON ObjectDate_StartRunPlan.ObjectId = Object_Route.Id
                                AND ObjectDate_StartRunPlan.DescId = zc_ObjectDate_Route_StartRunPlan()
    
            LEFT JOIN ObjectDate AS ObjectDate_EndRunPlan
                                 ON ObjectDate_EndRunPlan.ObjectId = Object_Route.Id
                                AND ObjectDate_EndRunPlan.DescId = zc_ObjectDate_Route_EndRunPlan()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotPayForWeight
                                    ON ObjectBoolean_NotPayForWeight.ObjectId = Object_Route.Id
                                   AND ObjectBoolean_NotPayForWeight.DescId   = zc_ObjectBoolean_Route_NotPayForWeight()

            LEFT JOIN ObjectLink AS ObjectLink_Route_Unit ON ObjectLink_Route_Unit.ObjectId = Object_Route.Id
                                                         AND ObjectLink_Route_Unit.DescId = zc_ObjectLink_Route_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Route_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_Branch ON ObjectLink_Route_Branch.ObjectId = Object_Route.Id
                                                           AND ObjectLink_Route_Branch.DescId = zc_ObjectLink_Route_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Route_Branch.ChildObjectId
                       
            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteKind ON ObjectLink_Route_RouteKind.ObjectId = Object_Route.Id
                                                              AND ObjectLink_Route_RouteKind.DescId = zc_ObjectLink_Route_RouteKind()
            LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = ObjectLink_Route_RouteKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Route_Freight ON ObjectLink_Route_Freight.ObjectId = Object_Route.Id
                                                            AND ObjectLink_Route_Freight.DescId = zc_ObjectLink_Route_Freight()
            LEFT JOIN Object AS Object_Freight ON Object_Freight.Id = ObjectLink_Route_Freight.ChildObjectId
  
            LEFT JOIN ObjectLink AS ObjectLink_Route_RouteGroup ON ObjectLink_Route_RouteGroup.ObjectId = Object_Route.Id
                                                               AND ObjectLink_Route_RouteGroup.DescId = zc_ObjectLink_Route_RouteGroup()
            LEFT JOIN Object AS Object_RouteGroup ON Object_RouteGroup.Id = ObjectLink_Route_RouteGroup.ChildObjectId            
            
       WHERE Object_Route.Id = inId;
   END IF;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Route (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.10.19         *
 18.04.19         * 
 29.01.19         * add RateSummaExp
 24.10.17         * add RateSummaAdd
 24.05.16         * add TimePrice
 20.04.15         * RouteGroup                
 13.12.13         * add             
 24.09.13         * add Unit, RouteKind, Freight            
 03.06.13         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Route (2, '')
