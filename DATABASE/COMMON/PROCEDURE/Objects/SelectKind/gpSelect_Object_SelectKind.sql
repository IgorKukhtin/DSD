-- Function: gpSelect_Object_SelectKind (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_SelectKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_SelectKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_SelectKind());

   RETURN QUERY 
   SELECT
        Object_SelectKind.Id           AS Id 
      , Object_SelectKind.ObjectCode   AS Code
      , Object_SelectKind.ValueData    AS NAME
      
      , Object_SelectKind.isErased     AS isErased
      
   FROM OBJECT AS Object_SelectKind
                              
   WHERE Object_SelectKind.DescId = zc_Object_SelectKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_SelectKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.10.13         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_SelectKind('2')
