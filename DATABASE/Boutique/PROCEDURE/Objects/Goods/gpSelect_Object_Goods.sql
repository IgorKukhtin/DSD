-- Function: gpSelect_Object_Goods (Bolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_Goods (Bolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Goods(
    IN inIsShowAll   Boolean,       --  ������� �������� ��������� ��/���
    IN inSession     TVarChar       --  ������ ������������
)
RETURNS TABLE (
             Id                   Integer
           , Code                 Integer
           , Name                 TVarChar
           , GoodsGroupName       TVarChar
           , CountryBrandName     TVarChar
           , MeasureName          TVarChar
           , GoodsSizeName        TVarChar
           , ValutaName           TVarChar
           , CompositionName      TVarChar
           , GoodsInfoName        TVarChar
           , LineFabricaName      TVarChar
           , isErased             boolean
 ) 
  AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_Goods());
     vbUserId:= lpGetUserBySession (inSession);
     -- ������������ - ����� �� ���������� ������ ���� ����������
     -- vbAccessKeyAll:= zfCalc_AccessKey_GuideAll (vbUserId);

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_Goods.Id               AS Id
           , Object_Goods.ObjectCode       AS Code
           , Object_Goods.ValueData        AS Name
           , Object_GoodsGroup.ValueData   AS GoodsGroupName
           , Object_CountryBrand.ValueData AS CountryBrandName
           , Object_Measure.ValueData      AS MeasureName    
           , Object_GoodsSize.ValueData    AS GoodsSizeName
           , Object_Valuta.ValueData       AS ValutaName
           , Object_Composition.ValueData  AS CompositionName
           , Object_GoodsInfo.ValueData    AS GoodsInfoName
           , Object_LineFabrica.ValueData  AS LineFabricaName
           , Object_Goods.isErased         AS isErased
           
       FROM Object AS Object_Goods
            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroup
                                 ON ObjectLink_Goods_GoodsGroup.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsGroup.DescId = zc_ObjectLink_Goods_GoodsGroup()
            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = ObjectLink_Goods_GoodsGroup.ChildObjectId


            LEFT JOIN ObjectLink AS ObjectLink_Goods_CountryBrand
                                 ON ObjectLink_Goods_CountryBrand.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_CountryBrand.DescId = zc_ObjectLink_Goods_CountryBrand()
            LEFT JOIN Object AS Object_CountryBrand ON Object_CountryBrand.Id = ObjectLink_Goods_CountryBrand.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsSize
                                 ON ObjectLink_Goods_GoodsSize.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsSize.DescId = zc_ObjectLink_Goods_GoodsSize()
            LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = ObjectLink_Goods_GoodsSize.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Valuta
                                 ON ObjectLink_Goods_Valuta.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Valuta.DescId = zc_ObjectLink_Goods_Valuta()
            LEFT JOIN Object AS Object_Valuta ON Object_Valuta.Id = ObjectLink_Goods_Valuta.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Composition
                                 ON ObjectLink_Goods_Composition.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Composition.DescId = zc_ObjectLink_Goods_Composition()
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = ObjectLink_Goods_Composition.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsInfo
                                 ON ObjectLink_Goods_GoodsInfo.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_GoodsInfo.DescId = zc_ObjectLink_Goods_GoodsInfo()
            LEFT JOIN Object AS Object_GoodsInfo ON Object_GoodsInfo.Id = ObjectLink_Goods_GoodsInfo.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_LineFabrica
                                 ON ObjectLink_Goods_LineFabrica.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_LineFabrica.DescId = zc_ObjectLink_Goods_LineFabrica()
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = ObjectLink_Goods_LineFabrica.ChildObjectId


     WHERE Object_Goods.DescId = zc_Object_Goods()
              AND (Object_Goods.isErased = FALSE OR inIsShowAll = TRUE)

    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
24.02.17                                                           *
*/

-- ����
-- SELECT * FROM gpSelect_Object_Goods (TRUE, zfCalc_UserAdmin())