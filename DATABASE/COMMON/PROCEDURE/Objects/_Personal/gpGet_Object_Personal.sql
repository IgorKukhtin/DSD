-- Function: gpGet_Object_Personal(integer, TVarChar)

--DROP FUNCTION gpGet_Object_Personal(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Personal(
    IN inId          Integer,       -- Сотрудники 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Code Integer, Name TVarChar,
               MemberId Integer, MemberName TVarChar, 
               PositionId Integer, PositionName TVarChar,
               UnitId Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupName TVarChar,
               DateIn TDateTime, DateOut TDateTime) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Personal());
  
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             lfGet_ObjectCode(0, zc_Object_Personal()) AS Code
           , CAST ('' as TVarChar)  AS Name
           
           , CAST (0 as Integer)   AS MemberId
           , CAST ('' as TVarChar) AS MemberName

           , CAST (0 as Integer)   AS PositionId
           , CAST ('' as TVarChar) AS PositionName

           , CAST (0 as Integer)   AS UnitId
           , CAST ('' as TVarChar) AS UnitName

           , CAST (0 as Integer)   AS PersonalGroupId
           , CAST ('' as TVarChar) AS PersonalGroupName

           , CAST (CURRENT_TIMESTAMP as TDateTime)   AS DateIn
           , CAST (CURRENT_TIMESTAMP as TDateTime)   AS DateOut;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_Personal.ObjectCode AS Code
         , Object_Personal.ValueData  AS NAME
         
         , Object_Member.Id         AS MemberId
         , Object_Member.ValueData  AS MemberName
 
         , Object_Position.Id         AS PositionId
         , Object_Position.ValueData  AS PositionName

         , Object_Unit.Id          AS UnitId
         , Object_Unit.ValueData   AS UnitName

         , Object_PersonalGroup.Id         AS PersonalGroupId
         , Object_PersonalGroup.ValueData  AS PersonalGroupName

         , ObjectDate_DateIn.ValueData   AS DateIn
         , ObjectDate_DateOut.ValueData  AS DateOut
     FROM OBJECT AS Object_Personal
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                 ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id
                AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()
          LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_Personal_Member.ChildObjectId
           
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                 ON ObjectLink_Personal_Position.ObjectId = Object_Personal.Id
                AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                 ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                 ON ObjectLink_Personal_PersonalGroup.ObjectId = Object_Personal.Id
                AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
          LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
           
          LEFT JOIN ObjectDate AS ObjectDate_DateIn ON ObjectDate_DateIn.ObjectId = Object_Personal.Id 
                AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
                
          LEFT JOIN ObjectDate AS ObjectDate_DateOut ON ObjectDate_DateOut.ObjectId = Object_Personal.Id 
                AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()
                
     WHERE Object_Personal.Id = inId;
  END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Personal(integer, TVarChar) OWNER TO postgres;



/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business
 03.09.14                        *                                
 19.07.13         *    rename zc_ObjectDate...
 01.07.13         *              

*/

-- тест
-- SELECT * FROM gpGet_Object_Personal (100, '2')