-- Function: gpSelect_Object_RouteTT()

DROP FUNCTION IF EXISTS gpSelect_Object_RouteTT (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RouteTT(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , UnitId_personal Integer, UnitCode_personal Integer, UnitName_personal TVarChar
             , PositionId Integer, PositionCode Integer, PositionName TVarChar
             , PersonalGroupId Integer, PersonalGroupCode Integer, PersonalGroupName TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_RouteTT());

     RETURN QUERY 
     SELECT 
           Object_RouteTT.Id           AS Id
         , Object_RouteTT.ObjectCode   AS Code
         , Object_RouteTT.ValueData    AS Name

         , Object_Unit.Id                      ::Integer  AS UnitId
         , Object_Unit.ObjectCode              ::Integer  AS UnitCode
         , Object_Unit.ValueData               ::TVarChar AS UnitName
         
         , Object_Personal.Id                  ::Integer  AS PersonalId
         , Object_Personal.ObjectCode          ::Integer  AS PersonalCode
         , Object_Personal.ValueData           ::TVarChar AS PersonalName 
         , Object_Unit_Personal.Id             ::Integer  AS UnitId_Personal
         , Object_Unit_Personal.ObjectCode     ::Integer  AS UnitCode_Personal
         , Object_Unit_Personal.ValueData      ::TVarChar AS UnitName_Personal
         
         , Object_Position.Id                  ::Integer  AS PositionId
         , Object_Position.ObjectCode          ::Integer  AS PositionCode
         , Object_Position.ValueData           ::TVarChar AS PositionName
         , Object_PersonalGroup.Id             ::Integer  AS PersonalGroupId
         , Object_PersonalGroup.ObjectCode     ::Integer  AS PersonalGroupCode
         , Object_PersonalGroup.ValueData      ::TVarChar AS PersonalGroupName

         , ObjectString_Comment.ValueData AS Comment
         , Object_RouteTT.isErased     AS isErased
     FROM Object AS Object_RouteTT
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_RouteTT.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_RouteTT_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_RouteTT_Unit
                               ON ObjectLink_RouteTT_Unit.ObjectId = Object_RouteTT.Id
                              AND ObjectLink_RouteTT_Unit.DescId = zc_ObjectLink_RouteTT_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_RouteTT_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_RouteTT_Personal
                               ON ObjectLink_RouteTT_Personal.ObjectId = Object_RouteTT.Id
                              AND ObjectLink_RouteTT_Personal.DescId = zc_ObjectLink_RouteTT_Personal()
          LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = ObjectLink_RouteTT_Personal.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_RouteTT_Position
                               ON ObjectLink_RouteTT_Position.ObjectId = Object_RouteTT.Id
                              AND ObjectLink_RouteTT_Position.DescId = zc_ObjectLink_RouteTT_Position()
          LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_RouteTT_Position.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_RouteTT_PersonalGroup
                               ON ObjectLink_RouteTT_PersonalGroup.ObjectId = Object_RouteTT.Id
                              AND ObjectLink_RouteTT_PersonalGroup.DescId = zc_ObjectLink_RouteTT_PersonalGroup()
          LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_RouteTT_PersonalGroup.ChildObjectId

          --информативно подразделения для сотрудника, тк.к может не совпадать с zc_ObjectLink_RouteTT_Unit 
          LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                               ON ObjectLink_Personal_Unit.ObjectId = Object_Personal.Id
                              AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
          LEFT JOIN Object AS Object_Unit_Personal ON Object_Unit_Personal.Id = ObjectLink_Personal_Unit.ChildObjectId
     WHERE Object_RouteTT.DescId = zc_Object_RouteTT()
       AND (Object_RouteTT.isErased = FALSE OR inIsErased = TRUE)

      UNION ALL
       SELECT
           0         :: Integer  AS Id 
         , NULL      :: Integer  AS Code
         , '<ПУСТО>' :: TVarChar AS Name

         , 0     ::Integer  AS UnitId
         , 0     ::Integer  AS UnitCode
         , ''    ::TVarChar AS UnitName
         , 0     ::Integer  AS PersonalId
         , 0     ::Integer  AS PersonalCode
         , ''    ::TVarChar AS PersonalName 
         , 0     ::Integer  AS UnitId_Personal
         , 0     ::Integer  AS UnitCode_Personal
         , ''    ::TVarChar AS UnitName_Personal
         , 0     ::Integer  AS PositionId
         , 0     ::Integer  AS PositionCode
         , ''    ::TVarChar AS PositionName
         , 0     ::Integer  AS PersonalGroupId
         , 0     ::Integer  AS PersonalGroupCode
         , ''    ::TVarChar AS PersonalGroupName

         , ''        :: TVarChar AS Comment
         , FALSE                 AS isErased
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.05.26         *
 21.05.26         *
*/

-- тест
-- SELECT * FROM gpSelect_Object_RouteTT (FALSE, zfCalc_UserAdmin())