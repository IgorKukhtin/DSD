-- Function: gpSelect_Object_Unit_Tree()

DROP FUNCTION IF EXISTS gpSelect_Object_Unit_Tree(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Unit_Tree(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Unit_Tree(
    IN inisShowAll   Boolean,
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
       WHERE inisShowAll = True 
          OR (COALESCE (Object_Unit_View.ParentId, 0) IN 
             (SELECT DISTINCT U.Id FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) = 0) 
          OR COALESCE (Object_Unit_View.ParentId, 0) = 0 AND Object_Unit_View.isErased = False AND
             EXISTS(SELECT 1 FROM Object_Unit_View AS U WHERE U.isErased = False AND COALESCE (U.ParentId, 0) =  Object_Unit_View.Id ))
       UNION SELECT
             0 AS Id,
             0 AS Code,
             CAST('���' AS TVarChar) AS Name,
             0 AS ParentId,
             false AS isErased;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.05.19                                                      * inisShowAll
 21.12.13                                        * ParentId
 04.07.13          * ���������� ����� �����������              
 03.06.13          

*/

-- ����
-- SELECT * FROM gpSelect_Object_Unit_Tree (False, '2')