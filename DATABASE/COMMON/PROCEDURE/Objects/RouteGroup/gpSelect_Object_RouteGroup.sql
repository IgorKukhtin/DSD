-- Function: gpSelect_Object_RouteGroup()

DROP FUNCTION IF EXISTS gpSelect_Object_RouteGroup (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_RouteGroup(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_RouteGroup());

   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS Name
   , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_RouteGroup();
  
END;
$BODY$


LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_RouteGroup (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
20.04.15          *
*/

-- ����
-- SELECT * FROM gpSelect_Object_RouteGroup('2')