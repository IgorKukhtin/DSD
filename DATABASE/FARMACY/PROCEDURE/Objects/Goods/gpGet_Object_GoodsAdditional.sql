-- Function: gpGet_Object_GoodsAdditional()

DROP FUNCTION IF EXISTS gpGet_Object_GoodsAdditional(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_GoodsAdditional(
    IN inId          Integer,       -- ��� ������
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsMainId Integer, Code Integer, Name TVarChar
             , isErased Boolean
             , NameUkr TVarChar
             , MakerName TVarChar
             , MakerNameUkr TVarChar
             , FormDispensingId Integer
             , FormDispensingName TVarChar
             , NumberPlates Integer
             , QtyPackage Integer
             , Dosage TVarChar
             , Volume TVarChar
             , GoodsWhoCanList TVarChar
             , GoodsMethodApplId integer, GoodsMethodApplName TVarChar
             , GoodsSignOriginId  integer, GoodsSignOriginName TVarChar
             , isRecipe boolean
              ) AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_User());
   vbUserId:= lpGetUserBySession (inSession);

   RETURN QUERY
     -- ������������� ��������

      SELECT Object_Goods_Retail.Id
           , Object_Goods_Retail.GoodsMainId
           , Object_Goods_Main.ObjectCode                                             AS GoodsCodeInt
           , Object_Goods_Main.Name                                                   AS GoodsName
           , Object_Goods_Retail.isErased
           , Object_Goods_Main.NameUkr

           , Object_Goods_Main.MakerName
           , Object_Goods_Main.MakerNameUkr
           , Object_Goods_Main.FormDispensingId
           , Object_FormDispensing.ValueData                                          AS FormDispensingName
           , Object_Goods_Main.NumberPlates
           , Object_Goods_Main.QtyPackage
           , Object_Goods_Main.Dosage 
           , Object_Goods_Main.Volume
           , Object_Goods_Main.GoodsWhoCanList                                        AS GoodsWhoCanList
           , Object_Goods_Main.GoodsMethodApplId
           , Object_GoodsMethodAppl.ValueData                                         AS GoodsMethodApplName
           , Object_Goods_Main.GoodsSignOriginId
           , Object_GoodsSignOrigin.ValueData                                         AS GoodsSignOriginName
           , Object_Goods_Main.isRecipe

      FROM Object_Goods_Retail

           LEFT JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

           LEFT JOIN Object AS Object_FormDispensing ON Object_FormDispensing.Id = Object_Goods_Main.FormDispensingId
           LEFT JOIN Object AS Object_GoodsMethodAppl ON Object_GoodsMethodAppl.Id = Object_Goods_Main.GoodsMethodApplId
           LEFT JOIN Object AS Object_GoodsSignOrigin ON Object_GoodsSignOrigin.Id = Object_Goods_Main.GoodsSignOriginId
           
      WHERE Object_Goods_Retail.Id = inId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Goods_Retail(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 30.09.21                                                      *
*/

-- ����

select * from gpGet_Object_GoodsAdditional(inId := 55120 ,  inSession := '3');