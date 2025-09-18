-- Function: gpSelect_Object_StaffListKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_StaffListKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_StaffListKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , Comment TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_StaffListKind());

   RETURN QUERY 
   SELECT
        Object_StaffListKind.Id           AS Id 
      , Object_StaffListKind.ObjectCode   AS Code
      , Object_StaffListKind.ValueData    AS Name
      , ObjectString_Enum.ValueData       AS EnumName
      , ObjectString_Comment.ValueData    AS Comment 
      , Object_StaffListKind.isErased     AS isErased
      
   FROM OBJECT AS Object_StaffListKind
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object_StaffListKind.Id
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_StaffListKind.Id
                              AND ObjectString_Comment.DescId = zc_objectString_StaffListKind_Comment()
                              
   WHERE Object_StaffListKind.DescId = zc_Object_StaffListKind()
   ;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.25         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_StaffListKind('2')
