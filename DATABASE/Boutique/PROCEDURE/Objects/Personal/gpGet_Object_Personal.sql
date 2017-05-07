-- Function: gpGet_Object_Personal(Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Object_Personal (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Personal(
    IN inId          Integer,       -- Сотрудники
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, MemberId Integer, MemberName TVarChar, PositionId Integer, PositionName TVarChar, UnitId Integer, UnitName TVarChar) 
AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Personal());

  IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY
       SELECT
              0 :: Integer                              AS Id
           , NEXTVAL ('Object_Personal_seq') :: Integer AS Code
           , '' :: TVarChar                            AS Name
           ,  0 :: Integer                             AS MemberId        
           , '' :: TVarChar                            AS MemberName      
           ,  0 :: Integer                             AS PositionId           
           , '' :: TVarChar                            AS PositionName         
           ,  0 :: Integer                             AS UnitId       
           , '' :: TVarChar                            AS UnitName     
        ;
   ELSE
       RETURN QUERY
      SELECT 
             Object_Personal.Id               AS Id
           , Object_Personal.ObjectCode       AS Code
           , Object_Personal.ValueData        AS Name
           , Object_Member.Id                 AS MemberId
           , Object_Member.ValueData          AS MemberName
           , Object_Position.Id               AS PositionId
           , Object_Position.ValueData        AS PositionName
           , Object_Unit.Id                   AS UnitId
           , Object_Unit.ValueData            AS UnitName
           
       FROM Object AS Object_Personal
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

      WHERE Object_Personal.Id = inId;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
28.03.17                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Personal (1,'2')
