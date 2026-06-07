-- Function: gpSelect_Object_CommercLocal()

DROP FUNCTION IF EXISTS gpSelect_Object_CommercLocal (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommercLocal(
    IN inIsErased    Boolean ,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , PositionId_1 Integer, PositionCode_1 Integer, PositionName_1 TVarChar
             , PersonalGroupId_1 Integer, PersonalGroupCode_1 Integer, PersonalGroupName_1 TVarChar
             , PositionId_2 Integer, PositionCode_2 Integer, PositionName_2 TVarChar
             , PersonalGroupId_2 Integer, PersonalGroupCode_2 Integer, PersonalGroupName_2 TVarChar
             , PositionId_3 Integer, PositionCode_3 Integer, PositionName_3 TVarChar
             , PositionId_4 Integer, PositionCode_4 Integer, PositionName_4 TVarChar
             , PositionId_5 Integer, PositionCode_5 Integer, PositionName_5 TVarChar
             , PositionId_6 Integer, PositionCode_6 Integer, PositionName_6 TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_CommercLocal());

     RETURN QUERY 
     SELECT 
           Object_CommercLocal.Id           AS Id
         , Object_CommercLocal.ObjectCode   AS Code
         --, Object_CommercLocal.ValueData    AS Name

         , Object_Unit.Id                      ::Integer  AS UnitId
         , Object_Unit.ObjectCode              ::Integer  AS UnitCode
         , Object_Unit.ValueData               ::TVarChar AS UnitName
         
         , Object_Position_1.Id                ::Integer  AS PositionId_1
         , Object_Position_1.ObjectCode        ::Integer  AS PositionCode_1
         , Object_Position_1.ValueData         ::TVarChar AS PositionName_1 
         , Object_PersonalGroup_1.Id           ::Integer  AS PersonalGroupId_1
         , Object_PersonalGroup_1.ObjectCode   ::Integer  AS PersonalGroupCode_1
         , Object_PersonalGroup_1.ValueData    ::TVarChar AS PersonalGroupName_1

         , Object_Position_2.Id                ::Integer  AS PositionId_2
         , Object_Position_2.ObjectCode        ::Integer  AS PositionCode_2
         , Object_Position_2.ValueData         ::TVarChar AS PositionName_2 
         , Object_PersonalGroup_2.Id           ::Integer  AS PersonalGroupId_2
         , Object_PersonalGroup_2.ObjectCode   ::Integer  AS PersonalGroupCode_2
         , Object_PersonalGroup_2.ValueData    ::TVarChar AS PersonalGroupName_2

         , Object_Position_3.Id                ::Integer  AS PositionId_3
         , Object_Position_3.ObjectCode        ::Integer  AS PositionCode_3
         , Object_Position_3.ValueData         ::TVarChar AS PositionName_3
         , Object_Position_4.Id                ::Integer  AS PositionId_4
         , Object_Position_4.ObjectCode        ::Integer  AS PositionCode_4
         , Object_Position_4.ValueData         ::TVarChar AS PositionName_4
         , Object_Position_5.Id                ::Integer  AS PositionId_5
         , Object_Position_5.ObjectCode        ::Integer  AS PositionCode_5
         , Object_Position_5.ValueData         ::TVarChar AS PositionName_5
         , Object_Position_6.Id                ::Integer  AS PositionId_6
         , Object_Position_6.ObjectCode        ::Integer  AS PositionCode_6
         , Object_Position_6.ValueData         ::TVarChar AS PositionName_6

         , ObjectString_Comment.ValueData AS Comment
         , Object_CommercLocal.isErased     AS isErased
     FROM Object AS Object_CommercLocal
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_CommercLocal.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_CommercLocal_Comment()  

          LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Unit
                               ON ObjectLink_CommercLocal_Unit.ObjectId = Object_CommercLocal.Id
                              AND ObjectLink_CommercLocal_Unit.DescId = zc_ObjectLink_CommercLocal_Unit()
          LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_CommercLocal_Unit.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_1
                               ON ObjectLink_CommercLocal_Position_1.ObjectId = Object_CommercLocal.Id
                              AND ObjectLink_CommercLocal_Position_1.DescId = zc_ObjectLink_CommercLocal_Position_1()
          LEFT JOIN Object AS Object_Position_1 ON Object_Position_1.Id = ObjectLink_CommercLocal_Position_1.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_PersonalGroup_1
                               ON ObjectLink_CommercLocal_PersonalGroup_1.ObjectId = Object_CommercLocal.Id
                              AND ObjectLink_CommercLocal_PersonalGroup_1.DescId = zc_ObjectLink_CommercLocal_PersonalGroup_1()
          LEFT JOIN Object AS Object_PersonalGroup_1 ON Object_PersonalGroup_1.Id = ObjectLink_CommercLocal_PersonalGroup_1.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_2
                               ON ObjectLink_CommercLocal_Position_2.ObjectId = Object_CommercLocal.Id
                              AND ObjectLink_CommercLocal_Position_2.DescId = zc_ObjectLink_CommercLocal_Position_2()
          LEFT JOIN Object AS Object_Position_2 ON Object_Position_2.Id = ObjectLink_CommercLocal_Position_2.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_PersonalGroup_2
                               ON ObjectLink_CommercLocal_PersonalGroup_2.ObjectId = Object_CommercLocal.Id
                              AND ObjectLink_CommercLocal_PersonalGroup_2.DescId = zc_ObjectLink_CommercLocal_PersonalGroup_2()
          LEFT JOIN Object AS Object_PersonalGroup_2 ON Object_PersonalGroup_2.Id = ObjectLink_CommercLocal_PersonalGroup_2.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_3
                               ON ObjectLink_CommercLocal_Position_3.ObjectId = Object_CommercLocal.Id
                              AND ObjectLink_CommercLocal_Position_3.DescId = zc_ObjectLink_CommercLocal_Position_3()
          LEFT JOIN Object AS Object_Position_3 ON Object_Position_3.Id = ObjectLink_CommercLocal_Position_3.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_4
                               ON ObjectLink_CommercLocal_Position_4.ObjectId = Object_CommercLocal.Id
                              AND ObjectLink_CommercLocal_Position_4.DescId = zc_ObjectLink_CommercLocal_Position_4()
          LEFT JOIN Object AS Object_Position_4 ON Object_Position_4.Id = ObjectLink_CommercLocal_Position_4.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_5
                               ON ObjectLink_CommercLocal_Position_5.ObjectId = Object_CommercLocal.Id
                              AND ObjectLink_CommercLocal_Position_5.DescId = zc_ObjectLink_CommercLocal_Position_5()
          LEFT JOIN Object AS Object_Position_5 ON Object_Position_5.Id = ObjectLink_CommercLocal_Position_5.ChildObjectId

          LEFT JOIN ObjectLink AS ObjectLink_CommercLocal_Position_6
                               ON ObjectLink_CommercLocal_Position_6.ObjectId = Object_CommercLocal.Id
                              AND ObjectLink_CommercLocal_Position_6.DescId = zc_ObjectLink_CommercLocal_Position_6()
          LEFT JOIN Object AS Object_Position_6 ON Object_Position_6.Id = ObjectLink_CommercLocal_Position_6.ChildObjectId


     WHERE Object_CommercLocal.DescId = zc_Object_CommercLocal()
       AND (Object_CommercLocal.isErased = FALSE OR inIsErased = TRUE)

      UNION ALL
       SELECT
           0         :: Integer  AS Id 
         , NULL      :: Integer  AS Code
        -- , '<ПУСТО>' :: TVarChar AS Name

         , 0     ::Integer  AS UnitId
         , 0     ::Integer  AS UnitCode
         , ''    ::TVarChar AS UnitName
         , 0     ::Integer  AS PositionId_1
         , 0     ::Integer  AS PositionCode_1
         , ''    ::TVarChar AS PositionName_1 
         , 0     ::Integer  AS PersonalGroupId_1
         , 0     ::Integer  AS PersonalGroupCode_1
         , ''    ::TVarChar AS PersonalGroupName_1

         , 0     ::Integer  AS PositionId_2
         , 0     ::Integer  AS PositionCode_2
         , ''    ::TVarChar AS PositionName_2 
         , 0     ::Integer  AS PersonalGroupId_2
         , 0     ::Integer  AS PersonalGroupCode_2
         , ''    ::TVarChar AS PersonalGroupName_2

         , 0     ::Integer  AS PositionId_3
         , 0     ::Integer  AS PositionCode_3
         , ''    ::TVarChar AS PositionName_3
         , 0     ::Integer  AS PositionId_4
         , 0     ::Integer  AS PositionCode_4
         , ''    ::TVarChar AS PositionName_4
         , 0     ::Integer  AS PositionId_5
         , 0     ::Integer  AS PositionCode_5
         , ''    ::TVarChar AS PositionName_5
         , 0     ::Integer  AS PositionId_6
         , 0     ::Integer  AS PositionCode_6
         , ''    ::TVarChar AS PositionName_6


         , '<ПУСТО>' :: TVarChar AS Comment
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
-- SELECT * FROM gpSelect_Object_CommercLocal (FALSE, zfCalc_UserAdmin())