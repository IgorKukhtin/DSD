-- Function: gpSelect_Object_BarCode()

DROP FUNCTION IF EXISTS gpSelect_Object_BarCode(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BarCode(
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, BarCodeName TVarChar,
               GoodsId Integer, GoodsName TVarChar,
               ObjectId Integer, ObjectName TVarChar,
               isErased boolean) AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BarCode());

   RETURN QUERY 
       SELECT 
             Object_BarCode.Id           AS Id
           , Object_BarCode.ObjectCode   AS Code
           , Object_BarCode.ValueData    AS BarCodeName
         
           , Object_Goods.Id             AS GoodsId
           , Object_Goods.ValueData      AS GoodsName 
                     
           , Object_Object.Id            AS ObjectId
           , Object_Object.ValueData     AS ObjectName 
           
           , Object_BarCode.isErased     AS isErased
           
       FROM Object AS Object_BarCode
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_BarCode_Goods.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                               AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
           LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

       WHERE Object_BarCode.DescId = zc_Object_BarCode();
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.07.16         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_BarCode ('2')