-- Function: gpSelect_Object_CommentCheck()

--DROP FUNCTION IF EXISTS gpSelect_Object_CommentCheck(boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_CommentCheck(boolean, integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_CommentCheck(
    IN inisShowAll   boolean,
    IN inUnitId      integer,
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , CommentTRId Integer, CommentTRCode Integer, CommentTRName TVarChar
             , isErased boolean) AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Area()());
  vbUserId:= lpGetUserBySession (inSession);

   -- ���� ������
   IF EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_CashierPharmacy())
   THEN
     inisShowAll := False;
   END IF;
  
  
   RETURN QUERY 
   WITH tmpBanCommentCheck AS (SELECT CommentCheckId
                              FROM gpSelect_Object_BanCommentCheck(inShowAll := 'False' ,  inSession := inSession) AS BanCommentCheck
                              WHERE BanCommentCheck.UnitId = inUnitId)
   
   SELECT Object_CommentCheck.Id                             AS Id 
        , Object_CommentCheck.ObjectCode                     AS Code
        , Object_CommentCheck.ValueData                      AS Name
        , Object_CommentTR.Id                               AS CommentTRId 
        , Object_CommentTR.ObjectCode                       AS CommentTRCode
        , Object_CommentTR.ValueData                        AS CommentTRName
        , Object_CommentCheck.isErased                       AS isErased
   FROM Object AS Object_CommentCheck

        LEFT JOIN ObjectLink AS ObjectLink_CommentCheck_CommentTR
                             ON ObjectLink_CommentCheck_CommentTR.ObjectId = Object_CommentCheck.Id
                            AND ObjectLink_CommentCheck_CommentTR.DescId = zc_ObjectLink_CommentCheck_CommentTR()
        LEFT JOIN Object AS Object_CommentTR ON Object_CommentTR.Id = ObjectLink_CommentCheck_CommentTR.ChildObjectId
        
        LEFT JOIN tmpBanCommentCheck ON tmpBanCommentCheck.CommentCheckId = Object_CommentCheck.Id

   WHERE Object_CommentCheck.DescId = zc_Object_CommentCheck()
     AND (Object_CommentCheck.isErased = False OR inisShowAll = True)
     AND COALESCE(tmpBanCommentCheck.CommentCheckId, 0) = 0;
  
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_CommentCheck(boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------

 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.04.23                                                       *
*/

-- ����
-- 

select * from gpSelect_Object_CommentCheck(inisShowAll := 'False' , inUnitId := 377594 , inSession := '3');