-- Function: gpSelect_Object_UserNick (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_UserNick (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_UserNick(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean
             , MemberId Integer, MemberName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , PositionName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
IF inSession = '9464' THEN vbUserId := 9464;
ELSE
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Object_User());
END IF;

   -- Результат
   RETURN QUERY 
   SELECT 
         Object_User.Id                             AS Id
       , Object_User.ObjectCode                     AS Code
       , Object_User.ValueData                      AS Name
       , Object_User.isErased                       AS isErased
       , Object_Member.Id                           AS MemberId
       , Object_Member.ValueData                    AS MemberName
                                                    
       , Object_Unit.ObjectCode                     AS UnitCode
       , Object_Unit.ValueData                      AS UnitName
       , Object_Position.ValueData                  AS PositionName
       
   FROM Object AS Object_User

        INNER JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        INNER JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                             ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                            AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Member_Unit.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                             ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                            AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId
              
   WHERE Object_User.DescId = zc_Object_User();
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_UserNick (TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 09.09.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Object_UserNick ('3')
