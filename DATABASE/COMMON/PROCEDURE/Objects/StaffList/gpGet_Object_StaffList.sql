-- Function: gpGet_Object_StaffList(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_StaffList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_StaffList(
    IN inId          Integer,       -- Составляющие рецептур 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , HoursPlan TFloat, HoursDay TFloat, PersonalCount TFloat
             , isPositionLevel Boolean
             , Comment TVarChar
             , UnitId Integer, UnitName TVarChar                
             , PositionId Integer, PositionName TVarChar                
             , PositionLevelId Integer, PositionLevelName TVarChar                
             , isErased boolean
               ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_StaffList());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_StaffList()) AS Code
           
           , CAST (NULL as TFloat) AS HoursPlan
           , CAST (NULL as TFloat) AS HoursDay
           , CAST (NULL as TFloat) AS PersonalCount
           , False                 AS isPositionLevel
	   , CAST ('' as TVarChar) AS Comment
                                                        
           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName

           , CAST (0 as Integer)   AS PositionId
           , CAST ('' as TVarChar) AS PositionName

           , CAST (0 as Integer)   AS PositionLevelId
           , CAST ('' as TVarChar) AS PositionLevelName

           , CAST (NULL AS Boolean) AS isErased

       --FROM Object 
       --WHERE Object.DescId = zc_Object_StaffList()
;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_StaffList.Id         AS Id
         , Object_StaffList.ObjectCode AS Code
         
         , ObjectFloat_HoursPlan.ValueData     AS HoursPlan
         , ObjectFloat_HoursDay.ValueData      AS HoursDay
         , ObjectFloat_PersonalCount.ValueData AS PersonalCount
         , Coalesce(ObjectBoolean_PositionLevel.ValueData,False)  AS isPositionLevel
         , ObjectString_Comment.ValueData      AS Comment
                                                        
         , Object_Unit.Id          AS UnitId
         , Object_Unit.ValueData   AS UnitName

         , Object_Position.Id         AS PositionId
         , Object_Position.ValueData  AS PositionName

         , Object_PositionLevel.Id          AS PositionLevelId
         , Object_PositionLevel.ValueData   AS PositionLevelName

         , Object_StaffList.isErased AS isErased
         
     FROM OBJECT AS Object_StaffList
          LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                               ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                              AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_StaffList_Unit.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_StaffList_Position
                               ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                              AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_StaffList_Position.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                               ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                              AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()
          LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = ObjectLink_StaffList_PositionLevel.ChildObjectId
           
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursPlan 
                                ON ObjectFloat_HoursPlan.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_HoursPlan.DescId = zc_ObjectFloat_StaffList_HoursPlan()
          LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
          
          LEFT JOIN ObjectFloat AS ObjectFloat_PersonalCount 
                                ON ObjectFloat_PersonalCount.ObjectId = Object_StaffList.Id 
                               AND ObjectFloat_PersonalCount.DescId = zc_ObjectFloat_StaffList_PersonalCount()
                               
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_StaffList.Id 
                                AND ObjectString_Comment.DescId = zc_ObjectString_StaffList_Comment()

          LEFT JOIN ObjectBoolean AS ObjectBoolean_PositionLevel
                                  ON ObjectBoolean_PositionLevel.ObjectId = Object_StaffList.Id 
                                 AND ObjectBoolean_PositionLevel.DescId = zc_ObjectBoolean_StaffList_PositionLevel()
                               
     WHERE Object_StaffList.Id = inId;
     
  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_StaffList (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.03.16         * add isPositionLevel
 30.11.13                                        * add zc_ObjectFloat_StaffList_HoursDay
 31.10.13         * add Code 
 18.10.13         * add FundPayMonth, FundPayTurn, Comment                
 17.10.13         *              
*/

-- тест
-- SELECT * FROM gpGet_Object_StaffList (100, '2')