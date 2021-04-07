-- Function: gpSelect_Object_ReturnKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ReturnKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ReturnKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , EnumName TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ReturnKind());

   RETURN QUERY
   SELECT
        Object_ReturnKind.Id           AS Id 
      , Object_ReturnKind.ObjectCode   AS Code
      , Object_ReturnKind.ValueData    AS Name
      , ObjectString_Enum.ValueData    AS EnumName
      , Object_ReturnKind.isErased     AS isErased
      
   FROM Object AS Object_ReturnKind
        LEFT JOIN ObjectString AS ObjectString_Enum
                               ON ObjectString_Enum.ObjectId = Object_ReturnKind.Id
                              AND ObjectString_Enum.DescId = zc_ObjectString_Enum()
   WHERE Object_ReturnKind.DescId = zc_Object_ReturnKind();

END;$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.04.21         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ReturnKind('2')