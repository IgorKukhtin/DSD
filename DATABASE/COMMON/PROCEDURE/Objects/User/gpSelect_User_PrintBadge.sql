-- Function: gpSelect_User_PrintBadge()

DROP FUNCTION IF EXISTS gpSelect_User_PrintBadge (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_User_PrintBadge(
    IN inId          Integer,       -- пользователь 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Code Integer
             , Name TVarChar
             , BarCode TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY 
    SELECT 
          Object_User.Id                       AS Id
        , Object_User.ObjectCode               AS Code
        , COALESCE(Object_Member.ValueData, 
                   Object_User.ValueData)      AS NAME
        , (repeat('0', 10 - LENGTH(Object_User.Id::TVarChar))||Object_User.Id::TVarChar)::TVarChar  AS BarCode
    FROM Object AS Object_User
         LEFT JOIN ObjectLink AS ObjectLink_User_Member
                              ON ObjectLink_User_Member.ObjectId = Object_User.Id
                             AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

    WHERE Object_User.Id = inId;
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.02.24                                                       * 
*/

-- тест
-- aSELECT * FROM gpSelect_User_PrintBadge (5, zfCalc_UserAdmin())