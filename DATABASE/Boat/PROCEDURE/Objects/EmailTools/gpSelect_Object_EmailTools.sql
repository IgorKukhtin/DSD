-- Function: gpSelect_Object_EmailTools (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_EmailTools (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_EmailTools(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_EmailTools());

   RETURN QUERY 
   SELECT
        Object_EmailTools.Id           AS Id 
      , Object_EmailTools.ObjectCode   AS Code
      , Object_EmailTools.ValueData    AS Name
      , ObjectString_Enum.ValueData    ::TVarChar AS EnumName
      , Object_EmailTools.isErased     AS isErased
      
   FROM Object AS Object_EmailTools
       LEFT JOIN ObjectString AS ObjectString_Enum
                              ON ObjectString_Enum.ObjectId = Object_EmailTools.Id 
                             AND ObjectString_Enum.DescId = zc_ObjectString_Enum()                              
   WHERE Object_EmailTools.DescId = zc_Object_EmailTools();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.02.24         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_EmailTools('2')
