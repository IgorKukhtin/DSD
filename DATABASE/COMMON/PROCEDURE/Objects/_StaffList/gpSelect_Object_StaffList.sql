-- Function: gpSelect_Object_StaffList()

DROP FUNCTION IF EXISTS gpSelect_Object_StaffList (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_StaffList (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffList(
    IN inUnitId      Integer,       -- Подразделение
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , HoursPlan TFloat, HoursDay TFloat, PersonalCount TFloat
             , Comment TVarChar
             , UnitId Integer, UnitName TVarChar                
             , PositionId Integer, PositionName TVarChar                
             , PositionLevelId Integer, PositionLevelName TVarChar                
             , isErased boolean
             ) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_StaffList());
  CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    
  IF inUnitId <> 0 
  THEN 
      INSERT INTO _tmpUnit(UnitId)
                 SELECT inUnitId;
  ELSE 
      INSERT INTO _tmpUnit (UnitId)
                 SELECT OBJECT.Id FROM OBJECT
                 WHERE OBJECT.DescId = zc_Object_Unit();
  END IF;
 

   RETURN QUERY 
     SELECT 
           Object_StaffList.Id         AS Id
         , Object_StaffList.ObjectCode AS Code
 
         , ObjectFloat_HoursPlan.ValueData     AS HoursPlan  
         , ObjectFloat_HoursDay.ValueData      AS HoursDay
         , ObjectFloat_PersonalCount.ValueData AS PersonalCount
         
         , ObjectString_Comment.ValueData      AS Comment
                                                        
         , Object_Unit.Id          AS UnitId
         , Object_Unit.ValueData   AS UnitName

         , Object_Position.Id         AS PositionId
         , Object_Position.ValueData  AS PositionName

         , Object_PositionLevel.Id          AS PositionLevelId
         , Object_PositionLevel.ValueData   AS PositionLevelName

         , Object_StaffList.isErased AS isErased
         
     FROM _tmpUnit
          LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                               ON ObjectLink_StaffList_Unit.ChildObjectId = _tmpUnit.UnitId
                              AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_StaffList_Unit.ChildObjectId
                                
          LEFT JOIN OBJECT AS Object_StaffList ON Object_StaffList.Id = ObjectLink_StaffList_Unit.ObjectId
         
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

     WHERE Object_StaffList.DescId = zc_Object_StaffList();
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_StaffList (Integer,TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.11.13                                        * add zc_ObjectFloat_StaffList_HoursDay
 22.11.13                                        * Cyr1251
 31.10.13         * add Code
 18.10.13         * add FundPayMonth, FundPayTurn, Comment  
 17.10.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_StaffList (0,'2')