-- Function: gpGet_Object_DiscountExternalTools()

DROP FUNCTION IF EXISTS gpGet_Object_DiscountExternalTools (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_DiscountExternalTools(
    IN inId          Integer,       -- ключ объекта <Учредители>
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , DiscountExternalId Integer, DiscountExternalName TVarChar
             , UnitId Integer, UnitName TVarChar
             , UserName TVarChar
             , Password TVarChar
             , ExternalUnit TVarChar  
             , Token TVarChar  
              )
AS
$BODY$
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_DiscountExternalTools());

      IF COALESCE (inId, 0) = 0
      THEN
           RETURN QUERY
             SELECT CAST (0 AS Integer)    AS Id
                  , lfGet_ObjectCode(0, zc_Object_DiscountExternalTools()) AS Code
                 
                  , NULL :: Integer        AS DiscountExternalId
                  , CAST ('' AS TVarChar)  AS DiscountExternalName
                  , NULL :: Integer        AS UnitId
                  , CAST ('' AS TVarChar)  AS UnitName
                  , CAST ('' AS TVarChar)  AS UserName
                  , CAST ('' AS TVarChar)  AS Password
                  , ''::TVarChar           AS ExternalUnit
                  , ''::TVarChar           AS Token;
      ELSE
           RETURN QUERY
             SELECT Object_DiscountExternalTools.Id         AS Id
                  , Object_DiscountExternalTools.ObjectCode AS Code
                  , Object_DiscountExternal.Id              AS DiscountExternalId
                  , Object_DiscountExternal.ValueData       AS DiscountExternalName
                  , Object_Unit.Id                          AS UnitId
                  , Object_Unit.ValueData                   AS UnitName
                  , ObjectString_User.ValueData             AS UserName
                  , ObjectString_Password.ValueData         AS Password
                  , ObjectString_ExternalUnit.ValueData     AS ExternalUnit
                  , ObjectString_Token.ValueData            AS Token

             FROM Object AS Object_DiscountExternalTools
                  LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                       ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                      AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                  LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
                  LEFT JOIN ObjectLink AS ObjectLink_Unit
                                       ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                      AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                  LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

                  LEFT JOIN ObjectString AS ObjectString_User
                                         ON ObjectString_User.ObjectId = Object_DiscountExternalTools.Id 
                                        AND ObjectString_User.DescId = zc_ObjectString_DiscountExternalTools_User()
                  LEFT JOIN ObjectString AS ObjectString_Password
                                         ON ObjectString_Password.ObjectId = Object_DiscountExternalTools.Id 
                                        AND ObjectString_Password.DescId = zc_ObjectString_DiscountExternalTools_Password()

                  LEFT JOIN ObjectString AS ObjectString_ExternalUnit
                                         ON ObjectString_ExternalUnit.ObjectId = Object_DiscountExternalTools.Id 
                                        AND ObjectString_ExternalUnit.DescId = zc_ObjectString_DiscountExternalTools_ExternalUnit()
                
                  LEFT JOIN ObjectString AS ObjectString_Token
                                         ON ObjectString_Token.ObjectId = Object_DiscountExternalTools.Id 
                                        AND ObjectString_Token.DescId = zc_ObjectString_DiscountExternalTools_Token()

             WHERE Object_DiscountExternalTools.Id = inId;
      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_DiscountExternalTools (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Ярошенко Р.Ф.
 16.05.17                                                        * 
 20.07.16         * 
*/

-- тест
-- SELECT * FROM gpGet_Object_DiscountExternalTools (2915395, zfCalc_UserAdmin())
