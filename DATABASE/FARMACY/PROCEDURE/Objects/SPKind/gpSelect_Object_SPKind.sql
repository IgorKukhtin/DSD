-- Function: gpSelect_Object_SPKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_SPKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SPKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , Tax      TFloat
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_SPKind());

   RETURN QUERY 
   SELECT
        Object_SPKind.Id           AS Id 
      , Object_SPKind.ObjectCode   AS Code
      , Object_SPKind.ValueData    AS Name
      , ObjectString.ValueData     AS EnumName
      , COALESCE (ObjectFloat_Tax.ValueData, 0) :: TFLoat AS Tax 
      
      , Object_SPKind.isErased     AS isErased
      
   FROM Object AS Object_SPKind
        LEFT JOIN ObjectString ON ObjectString.ObjectId = Object_SPKind.Id
                              AND ObjectString.DescId = zc_ObjectString_Enum()
        LEFT JOIN ObjectFloat AS ObjectFloat_Tax
                              ON ObjectFloat_Tax.ObjectId = Object_SPKind.Id
                             AND ObjectFloat_Tax.DescId = zc_ObjectFloat_SPKind_Tax()
                              
   WHERE Object_SPKind.DescId = zc_Object_SPKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.05.17         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_SPKind('2')