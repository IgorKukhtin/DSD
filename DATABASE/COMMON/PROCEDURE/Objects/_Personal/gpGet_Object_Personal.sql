-- Function: gpGet_Object_Personal(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Personal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Personal(
    IN inId          Integer,       -- Сотрудники 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MemberId Integer, MemberCode Integer, MemberName TVarChar,
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
             CAST (0 as Integer)   AS MemberId
           , CAST (0 as Integer)   AS MemberCode
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
           View_Personal.MemberId     AS MemberId
         , View_Personal.PersonalCode AS MemberCode
         , View_Personal.PersonalName AS MemberName
 
         , Object_Position.Id         AS PositionId
         , Object_Position.ValueData  AS PositionName

         , Object_Unit.Id          AS UnitId
         , Object_Unit.ValueData   AS UnitName

         , Object_PersonalGroup.Id         AS PersonalGroupId
         , Object_PersonalGroup.ValueData  AS PersonalGroupName

         , ObjectDate_DateIn.ValueData   AS DateIn
         , ObjectDate_DateOut.ValueData  AS DateOut
     FROM Object_Personal_View AS View_Personal
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                               ON ObjectLink_Personal_Position.ObjectId = View_Personal.PersonalId
                              AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Personal_Position.ChildObjectId
 
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                               ON ObjectLink_Personal_Unit.ObjectId = View_Personal.PersonalId
                              AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                               ON ObjectLink_Personal_PersonalGroup.ObjectId = View_Personal.PersonalId
                              AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
          LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId
           
          LEFT JOIN ObjectDate AS ObjectDate_DateIn
                               ON ObjectDate_DateIn.ObjectId = View_Personal.PersonalId
                              AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()
          LEFT JOIN ObjectDate AS ObjectDate_DateOut
                               ON ObjectDate_DateOut.ObjectId = View_Personal.PersonalId
                              AND ObjectDate_DateOut.DescId = zc_ObjectDate_Personal_Out()          
                
     WHERE View_Personal.PersonalId = inId;

  END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Personal(Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13                                        * add Object_Personal_View
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business
 03.09.14                        *                                
 19.07.13         *    rename zc_ObjectDate...
 01.07.13         *              

*/

-- тест
-- SELECT * FROM gpGet_Object_Personal (100, '2')