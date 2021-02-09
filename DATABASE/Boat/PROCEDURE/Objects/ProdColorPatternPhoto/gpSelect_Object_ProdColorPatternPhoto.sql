-- Function: gpSelect_Object_ProdColorPatternPhoto(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ProdColorPatternPhoto(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ProdColorPatternPhoto(
    IN inProdColorPatternId      Integer, 
    IN inSession                 TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , FileName TVarChar) AS
$BODY$
   DECLARE vbGoodsId  Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ProdColorPatternPhoto());

   -- ��������� Goods
   vbGoodsId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdColorPattern_Goods() AND ObjectLink.ObjectId = inProdColorPatternId);

   RETURN QUERY 
     SELECT 
           Object_ProdColorPatternPhoto.Id        AS Id,
           Object_ProdColorPatternPhoto.ValueData AS FileName
     FROM Object AS Object_ProdColorPatternPhoto
          JOIN ObjectLink AS ObjectLink_ProdColorPatternPhoto_ProdColorPattern
            ON ObjectLink_ProdColorPatternPhoto_ProdColorPattern.ObjectId = Object_ProdColorPatternPhoto.Id
           AND ObjectLink_ProdColorPatternPhoto_ProdColorPattern.DescId = zc_ObjectLink_ProdColorPatternPhoto_ProdColorPattern()
           AND ObjectLink_ProdColorPatternPhoto_ProdColorPattern.ChildObjectId = inProdColorPatternId
     WHERE Object_ProdColorPatternPhoto.DescId = zc_Object_ProdColorPatternPhoto()
         UNION
     SELECT 
           Object_GoodsPhoto.Id        AS Id,
           Object_GoodsPhoto.ValueData AS FileName
     FROM Object AS Object_GoodsPhoto
          JOIN ObjectLink AS ObjectLink_GoodsPhoto_Goods
            ON ObjectLink_GoodsPhoto_Goods.ObjectId = Object_GoodsPhoto.Id
           AND ObjectLink_GoodsPhoto_Goods.DescId = zc_ObjectLink_GoodsPhoto_Goods()
           AND ObjectLink_GoodsPhoto_Goods.ChildObjectId = vbGoodsId
     WHERE Object_GoodsPhoto.DescId = zc_Object_GoodsPhoto()
     ;  
    
          
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.21         *
*/

-- ����
--