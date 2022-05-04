-- Function: gpSelect_Object_InfoMoney_Tree()

DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_Tree(TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_InfoMoney_Tree(Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_InfoMoney_Tree(
    IN inIsShowAll   Boolean,       -- ������� �������� ��������� �� / ���
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, 
               ParentId Integer, isErased boolean) AS
$BODY$
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_InfoMoney());

   RETURN QUERY 
       WITH tmpGroup AS (SELECT DISTINCT ObjectLink_Parent.ChildObjectId AS GroupId
                         FROM ObjectLink AS ObjectLink_Parent
                         WHERE ObjectLink_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
                           AND ObjectLink_Parent.ChildObjectId > 0
                        )
       SELECT
             Object_InfoMoney.Id                  AS Id
           , Object_InfoMoney.ObjectCode          AS Code
           , Object_InfoMoney.ValueData           AS Name
           , COALESCE (ObjectLink_InfoMoney_Parent.ChildObjectId, 0)   AS ParentId
           , Object_InfoMoney.isErased            AS isErased
       FROM Object AS Object_InfoMoney
            INNER JOIN tmpGroup ON tmpGroup.GroupId = Object_InfoMoney.Id
            LEFT JOIN ObjectLink AS ObjectLink_InfoMoney_Parent
                                 ON ObjectLink_InfoMoney_Parent.ObjectId = Object_InfoMoney.Id
                                AND ObjectLink_InfoMoney_Parent.DescId = zc_ObjectLink_InfoMoney_Parent()
       WHERE Object_InfoMoney.DescId = zc_Object_InfoMoney()
         AND (Object_InfoMoney.isErased = FALSE OR inIsShowAll = TRUE)
       UNION SELECT
             0 AS Id,
             0 AS Code,
             CAST('���' AS TVarChar) AS Name,
             0 AS ParentId,
             false AS isErased;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.22         *
*/

-- ����
-- SELECT * FROM gpSelect_Object_InfoMoney_Tree (true,'2')
