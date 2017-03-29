-- Function: gpSelect_Object_Personal (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Personal (Bolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Personal(
    IN inIsShowAll   Boolean,       --  признак показать удаленные да/нет
    IN inSession     TVarChar       --  сессия пользователя
)
RETURNS TABLE (
             Id                   Integer
           , Code                 Integer
           , Name                 TVarChar
           , MemberName           TVarChar
           , PositionName         TVarChar
           , UnitName             TVarChar
           , isErased             boolean
 ) 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Personal());
     vbUserId:= lpGetUserBySession (inSession);
     -- определяется - может ли пользовать видеть весь справочник
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- Результат
     RETURN QUERY 
       SELECT 
             Object_Personal.Id                AS Id
           , Object_Personal.ObjectCode        AS Code
           , Object_Personal.ValueData         AS Name
           , Object_Member.ValueData           AS MemberName
           , Object_Position.ValueData         AS PositionName
           , Object_Unit.ValueData             AS UnitName
           , Object_Personal.isErased          AS isErased
           
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

     WHERE Object_Personal.DescId = zc_Object_Personal()
              AND (Object_Personal.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятыкин А.А.
28.03.17                                                           *
*/

-- тест
-- SELECT * FROM gpSelect_Object_Personal (TRUE, zfCalc_UserAdmin())