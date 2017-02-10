-- Function: gpSelect_Object_GoodsGroupAnalyst()

DROP FUNCTION IF EXISTS gpSelect_Object_GoodsGroupAnalyst (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_GoodsGroupAnalyst(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, isErased boolean) AS
$BODY$
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_GoodsGroupAnalyst());

   RETURN QUERY 
   SELECT 
     Object.Id         AS Id 
   , Object.ObjectCode AS Code
   , Object.ValueData  AS Name
   , Object.isErased   AS isErased
   FROM Object
   WHERE Object.DescId = zc_Object_GoodsGroupAnalyst();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_GoodsGroupAnalyst (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 24.11.14         * 
*/

-- ����
-- SELECT * FROM gpSelect_Object_GoodsGroupAnalyst('2')