-- Function: gpGet_Object_RouteTT()

DROP FUNCTION IF EXISTS gpGet_Object_RouteTT(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_RouteTT(
    IN inId          Integer,       -- Основные средства 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , UnitId Integer, UnitName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , PositionId Integer, PositionName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_RouteTT());
   
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)    AS Id
           , lfGet_ObjectCode(0, zc_Object_RouteTT()) AS Code
           , CAST ('' as TVarChar)  AS Name  
           , 0     ::Integer  AS UnitId
           , ''    ::TVarChar AS UnitName
           , 0     ::Integer  AS PersonalId
           , ''    ::TVarChar AS PersonalName 
           , 0     ::Integer  AS PositionId
           , ''    ::TVarChar AS PositionName
           , 0     ::Integer  AS PersonalGroupId
           , ''    ::TVarChar AS PersonalGroupName
           , CAST ('' as TVarChar)  AS Comment
           , CAST (NULL AS Boolean) AS isErased
           ;
   ELSE
     RETURN QUERY 
     SELECT 
           Object_RouteTT.Id            AS Id 
         , Object_RouteTT.ObjectCode    AS Code
         , Object_RouteTT.ValueData     AS Name 

         , Object_Unit.Id                      ::Integer  AS UnitId
         , Object_Unit.ValueData               ::TVarChar AS UnitName
         , Object_Personal.Id                  ::Integer  AS PersonalId
         , Object_Personal.ValueData           ::TVarChar AS PersonalName 
         , Object_Position.Id                  ::Integer  AS PositionId
         , Object_Position.ValueData           ::TVarChar AS PositionName
         , Object_PersonalGroup.Id             ::Integer  AS PersonalGroupId
         , Object_PersonalGroup.ValueData      ::TVarChar AS PersonalGroupName

         , ObjectString_Comment.ValueData  AS Comment
         , Object_RouteTT.isErased      AS isErased
     FROM OBJECT AS Object_RouteTT
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
       WHERE Object_RouteTT.Id = inId;
   END IF;
   
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
-- SELECT * FROM gpGet_Object_RouteTT(0, '2')