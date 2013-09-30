-- Function: gpSelect_Object_Personal (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Personal (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Personal(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               PositionId Integer, PositionCode Integer, PositionName TVarChar,
               UnitId Integer, UnitCode Integer, UnitName TVarChar,
               PersonalGroupId Integer, PersonalGroupCode Integer, PersonalGroupName TVarChar,
               DateIn TDateTime, DateOut TDateTime,
               isErased Boolean) AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Personal());

   RETURN QUERY 
     SELECT 
           View_Personal.PersonalId   AS Id
         , View_Personal.PersonalCode AS Code
         , View_Personal.PersonalName AS Name

         , Object_Position.Id         AS PositionId
         , Object_Position.ObjectCode AS PositionCode
         , Object_Position.ValueData  AS PositionName

         , Object_Unit.Id          AS UnitId
         , Object_Unit.ObjectCode  AS UnitCode
         , Object_Unit.ValueData   AS UnitName

         , Object_PersonalGroup.Id         AS PersonalGroupId
         , Object_PersonalGroup.ObjectCode AS PersonalGroupCode
         , Object_PersonalGroup.ValueData  AS PersonalGroupName
 
         , ObjectDate_DateIn.ValueData   AS DateIn
         , ObjectDate_DateOut.ValueData  AS DateOut
         
         , View_Personal.isErased      AS isErased
 
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
     ;
  
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_Personal (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.13                                        * add Object_Personal_View
 25.09.13         * add _PersonalGroup; remove _Juridical, _Business             
 19.07.13         *    rename zc_ObjectDate...               
 06.07.13                                        * error zc_ObjectLink_Personal_Juridical
 01.07.13         *              

*/

-- тест
-- SELECT * FROM gpSelect_Object_Personal ('2')