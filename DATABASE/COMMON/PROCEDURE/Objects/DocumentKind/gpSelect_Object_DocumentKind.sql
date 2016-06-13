-- Function: gpSelect_Object_DocumentKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_DocumentKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_DocumentKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_DocumentKind());

   RETURN QUERY 
   SELECT
        Object_DocumentKind.Id           AS Id 
      , Object_DocumentKind.ObjectCode   AS Code
      , Object_DocumentKind.ValueData    AS Name
      
      , Object_DocumentKind.isErased     AS isErased
      
   FROM Object AS Object_DocumentKind
                              
   WHERE Object_DocumentKind.DescId = zc_Object_DocumentKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.06.16         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_DocumentKind('2')
