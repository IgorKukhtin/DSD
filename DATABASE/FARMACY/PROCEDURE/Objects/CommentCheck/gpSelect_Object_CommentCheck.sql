-- Function: gpSelect_Object_CommentCheck()

--DROP FUNCTION IF EXISTS gpSelect_Object_CommentCheck(boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_CommentCheck(boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommentCheck(
    IN inisShowAll   boolean,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CommentTRId Integer, CommentTRCode Integer, CommentTRName TVarChar
             , isErased boolean) AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());
  vbUserId:= lpGetUserBySession (inSession);

   -- Если кассир
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_CashierPharmacy())
   THEN
     inisShowAll := False;
   END IF;
  
  
   RETURN QUERY 
   SELECT Object_CommentCheck.Id                             AS Id 
        , Object_CommentCheck.ObjectCode                     AS Code
        , Object_CommentCheck.ValueData                      AS Name
        , Object_CommentTR.Id                                AS CommentTRId 
        , Object_CommentTR.ObjectCode                        AS CommentTRCode
        , Object_CommentTR.ValueData                         AS CommentTRName
        , Object_CommentCheck.isErased                       AS isErased
   FROM Object AS Object_CommentCheck

        LEFT JOIN ObjectLink AS ObjectLink_CommentCheck_CommentTR
                             ON ObjectLink_CommentCheck_CommentTR.ObjectId = Object_CommentCheck.Id
                            AND ObjectLink_CommentCheck_CommentTR.DescId = zc_ObjectLink_CommentCheck_CommentTR()
        LEFT JOIN Object AS Object_CommentTR ON Object_CommentTR.Id = ObjectLink_CommentCheck_CommentTR.ChildObjectId
        
   WHERE Object_CommentCheck.DescId = zc_Object_CommentCheck()
     AND (Object_CommentCheck.isErased = False OR inisShowAll = True);
  
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CommentCheck(boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.04.23                                                       *
*/

-- тест
-- 

select * from gpSelect_Object_CommentCheck(inisShowAll := 'False', inSession := '3');