-- Function: gpSelect_Object_GoodsGroupProperty_Parent()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroupProperty_Parent(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroupProperty_Parent(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ParentId Integer, ParentName TVarChar
             , isErased boolean) AS
$BODY$BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroupProperty()());

   RETURN QUERY
   WITH
       tmpParent AS (SELECT ObjectLink_GoodsGroupProperty_Parent.ChildObjectId AS Id
                     FROM ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                     WHERE ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
                     )
   SELECT 
          Object.Id         AS Id 
        , Object.ObjectCode AS Code
        , Object.ValueData  AS Name  
        , 0      ::Integer  AS ParentId
        , ''     ::TVarChar AS ParentName
        , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_GoodsGroupProperty()
     AND Object.Id In (SELECT DISTINCT tmpParent.Id FROM tmpParent)
   ;
  
END;$BODY$


LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.23         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsGroupProperty_Parent('2')