-- Function: gpSelect_Object_StaffListSummKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StaffListSummKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffListSummKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StaffListSummKind());

   RETURN QUERY 
   SELECT
        Object_StaffListSummKind.Id           AS Id 
      , Object_StaffListSummKind.ObjectCode   AS Code
      , Object_StaffListSummKind.ValueData    AS NAME
      
      , ObjectString_Comment.ValueData        AS Comment
      
      , Object_StaffListSummKind.isErased     AS isErased
      
   FROM OBJECT AS Object_StaffListSummKind
        LEFT JOIN ObjectString AS ObjectString_Comment ON ObjectString_Comment.ObjectId = Object_StaffListSummKind.Id 
                                                      AND ObjectString_Comment.DescId = zc_ObjectString_StaffListSummKind_Comment()   
                              
   WHERE Object_StaffListSummKind.DescId = zc_Object_StaffListSummKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_StaffListSummKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.11.13         * add Comment              
 30.10.13         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_StaffListSummKind('2')
