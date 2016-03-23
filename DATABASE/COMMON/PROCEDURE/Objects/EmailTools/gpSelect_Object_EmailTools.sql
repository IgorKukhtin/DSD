-- Function: gpSelect_Object_EmailTools (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_EmailTools (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_EmailTools(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_EmailTools());

   RETURN QUERY 
   SELECT
        Object_EmailTools.Id           AS Id 
      , Object_EmailTools.ObjectCode   AS Code
      , Object_EmailTools.ValueData    AS Name
      
      , Object_EmailTools.isErased     AS isErased
      
   FROM Object AS Object_EmailTools
                              
   WHERE Object_EmailTools.DescId = zc_Object_EmailTools();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.03.16         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_EmailTools('2')
