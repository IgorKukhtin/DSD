-- Function: gpSelect_Object_StaffPaidKind()

DROP FUNCTION IF EXISTS gpSelect_Object_StaffPaidKind(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffPaidKind(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_StaffPaidKind());

     RETURN QUERY 
     SELECT 
           Object_StaffPaidKind.Id              AS Id
         , Object_StaffPaidKind.ObjectCode      AS Code
         , Object_StaffPaidKind.ValueData       AS Name
         , ObjectString_Comment.ValueData AS Comment
         , Object_StaffPaidKind.isErased        AS isErased
     FROM Object AS Object_StaffPaidKind
          LEFT JOIN ObjectString AS ObjectString_Comment
                                 ON ObjectString_Comment.ObjectId = Object_StaffPaidKind.Id
                                AND ObjectString_Comment.DescId = zc_ObjectString_StaffPaidKind_Comment()  
     WHERE Object_StaffPaidKind.DescId = zc_Object_StaffPaidKind()

      UNION ALL
       SELECT
           0         :: Integer  AS Id 
         , NULL      :: Integer  AS Code
         , '<�����>' :: TVarChar AS Name
         , ''        :: TVarChar AS Comment
         , FALSE                 AS isErased
       ;  

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.08.25         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_StaffPaidKind (zfCalc_UserAdmin())