-- Function: gpSelect_Object_CommentSend()

--DROP FUNCTION IF EXISTS gpSelect_Object_CommentSend(boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_CommentSend(boolean, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommentSend(
    IN inisShowAll   boolean,
    IN inUnitId      integer,
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
   WITH tmpBanCommentSend AS (SELECT CommentSendId
                              FROM gpSelect_Object_BanCommentSend(inShowAll := 'False' ,  inSession := inSession) AS BanCommentSend
                              WHERE BanCommentSend.UnitId = inUnitId)
   
   SELECT Object_CommentSend.Id                             AS Id 
        , Object_CommentSend.ObjectCode                     AS Code
        , Object_CommentSend.ValueData                      AS Name
        , Object_CommentTR.Id                               AS CommentTRId 
        , Object_CommentTR.ObjectCode                       AS CommentTRCode
        , Object_CommentTR.ValueData                        AS CommentTRName
        , Object_CommentSend.isErased                       AS isErased
   FROM Object AS Object_CommentSend

        LEFT JOIN ObjectLink AS ObjectLink_CommentSend_CommentTR
                             ON ObjectLink_CommentSend_CommentTR.ObjectId = Object_CommentSend.Id
                            AND ObjectLink_CommentSend_CommentTR.DescId = zc_ObjectLink_CommentSend_CommentTR()
        LEFT JOIN Object AS Object_CommentTR ON Object_CommentTR.Id = ObjectLink_CommentSend_CommentTR.ChildObjectId
        
        LEFT JOIN tmpBanCommentSend ON tmpBanCommentSend.CommentSendId = Object_CommentSend.Id

   WHERE Object_CommentSend.DescId = zc_Object_CommentSend()
     AND (Object_CommentSend.isErased = False OR inisShowAll = True)
     AND COALESCE(tmpBanCommentSend.CommentSendId, 0) = 0;
  
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CommentSend(boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.08.20                                                       *
*/

-- тест
-- 

select * from gpSelect_Object_CommentSend(inisShowAll := 'False' , inUnitId := 377594 , inSession := '3');