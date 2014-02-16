-- Function: gpSelect_Object_RouteKind (TVarChar)

-- DROP FUNCTION gpSelect_Object_RouteKind (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RouteKind(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               isErased Boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_RouteKind());

   RETURN QUERY 
   SELECT
        Object_RouteKind.Id                   AS Id 
      , Object_RouteKind.ObjectCode           AS Code
      , Object_RouteKind.ValueData            AS NAME
       
      , Object_RouteKind.isErased   AS isErased
   FROM OBJECT AS Object_RouteKind
   WHERE Object_RouteKind.DescId = zc_Object_RouteKind();
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RouteKind (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.09.13          *

*/

-- ����
-- SELECT * FROM gpSelect_Object_RouteKind('2')
