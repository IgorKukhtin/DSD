-- Function: gpSelect_Object_ExportKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ExportKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ExportKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ExportKind());

   RETURN QUERY 
   SELECT
        Object_ExportKind.Id           AS Id 
      , Object_ExportKind.ObjectCode   AS Code
      , Object_ExportKind.ValueData    AS Name
      
      , Object_ExportKind.isErased     AS isErased
      
   FROM Object AS Object_ExportKind
                              
   WHERE Object_ExportKind.DescId = zc_Object_ExportKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.03.16         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_ExportKind('2')
