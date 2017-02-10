-- Function: gpSelect_Object_Unit_Tree()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_Tree(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_Tree(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, isErased boolean) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_Unit());

   RETURN QUERY 
       SELECT 
             Object_Unit_View.Id
           , Object_Unit_View.Code
           , Object_Unit_View.Name
           , COALESCE (Object_Unit_View.ParentId, 0) AS ParentId
           , Object_Unit_View.isErased
       FROM Object_Unit_View
       UNION SELECT
             0 AS Id,
             0 AS Code,
             CAST('���' AS TVarChar) AS Name,
             0 AS ParentId,
             false AS isErased;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Unit(TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.12.13                                        * ParentId
 04.07.13          * ���������� ����� �����������              
 03.06.13          

*/

-- ����
-- SELECT * FROM gpSelect_Object_Unit ('2')