-- Function: gpSelect_Object_Juridical_Tree()

--DROP FUNCTION gpSelect_Object_Juridical_Tree();

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical_Tree(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, ParentId Integer, isErased boolean) AS
$BODY$BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_JuridicalGroup());

     RETURN QUERY 
     SELECT 
         Object.Id         AS Id 
       , Object.ObjectCode AS Code
       , Object.ValueData  AS Name
       , COALESCE(ObjectLink.ChildObjectId, 0) AS ParentId
       , Object.isErased   AS isErased
     FROM Object
LEFT JOIN ObjectLink 
       ON ObjectLink.ObjectId = Object.Id
      AND ObjectLink.DescId = zc_ObjectLink_JuridicalGroup_Parent()
    WHERE Object.DescId = zc_Object_JuridicalGroup()
UNION SELECT
          0 AS Id,
          0 AS Code,
          CAST('���' AS TVarChar) AS Name,
          NULL AS ParentId,
          false AS isErased;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Juridical_Tree(TVarChar)
  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.07.13          
*/

-- ����
-- SELECT * FROM gpSelect_Object_JuridicalGroup('2')