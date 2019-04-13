-- Function: gpGet_MIInventory_Partion_byBarcode()

DROP FUNCTION IF EXISTS gpGet_MIInventory_Partion_byBarcode (TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_MIInventory_Partion_byBarcode (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_MIInventory_Partion_byBarcode(
    IN inMovementId        Integer    , -- ���� ������� <��������>
    IN inBarCode           TVarChar   , --
    IN inSession           TVarChar     -- ������ ������������
)
RETURNS TABLE (Id                 Integer
             , PartionId          Integer
             , GoodsId            Integer
             , GoodsCode          Integer
             , GoodsName          TVarChar
             , GoodsGroupNameFull TVarChar
             , LabelId            Integer
             , LabelName          TVarChar
             , GoodsSizeId        Integer
             , GoodsSizeName      TVarChar
             , CompositionName    TVarChar
             , GoodsInfoName      TVarChar
             , LineFabricaName    TVarChar
             , PartnerId          Integer
             , PartnerName        TVarChar
             , OperCount          TFloat
             , TotalCount         TFloat
             , OperPriceList      TFloat
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbPartionId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);

     IF inBarCode = '' THEN RETURN; END IF;
     

     -- �����
     vbPartionId:= (SELECT tmp.PartionId FROM gpGet_MISale_Partion_byBarCode (inBarCode, inSession) AS tmp);

     -- ��������
     IF COALESCE (vbPartionId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������ � ��������� <%>.', inBarCode;
     END IF;


     -- ���������
     RETURN QUERY

       SELECT -1                               :: Integer AS Id
            , Object_PartionGoods.MovementItemId          AS PartionId
            , Object_Goods.Id                             AS GoodsId
            , Object_Goods.ObjectCode                     AS GoodsCode
            , Object_Goods.ValueData                      AS GoodsName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Label.Id                             AS LabelId
            , Object_Label.ValueData                      AS LabelName
            , Object_GoodsSize.Id                         AS GoodsSizeId
            , Object_GoodsSize.ValueData                  AS GoodsSizeName
            , Object_Composition.ValueData                AS CompositionName
            , Object_GoodsInfo.ValueData                  AS GoodsInfoName
            , Object_LineFabrica.ValueData                AS LineFabricaName
            , Object_Partner.ObjectCode                   AS PartnerId
            , Object_Partner.ValueData                    AS PartnerName
            , 1                                 :: TFloat AS OperCount
            , (1 + COALESCE ((SELECT SUM (MI.Amount) FROM MovementItem AS MI WHERE MI.MovementId = inMovementId AND MI.DescId = zc_MI_Master() AND MI.PartionId = vbPartionId AND MI.isErased = FALSE), 0)
              )                                 :: TFloat AS TotalCount
            , Object_PartionGoods.OperPriceList           AS OperPriceList

       FROM Object_PartionGoods

            LEFT JOIN Object AS Object_Label       ON Object_Label.Id        = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id        = Object_PartionGoods.GoodsId
            LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id    = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id  = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id    = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id  = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Partner     ON Object_Partner.Id      = Object_PartionGoods.PartnerId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_PartionGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

       WHERE Object_PartionGoods.MovementItemId = vbPartionId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 11.04.18         *
*/

-- ����
-- SELECT * FROM gpGet_MIInventory_Partion_byBarcode (inMovementId := 0, inBarCode:= '2210002798265'::TVarChar, inSession:= zfCalc_UserAdmin());
-- 2100002932717
-- 2100002798319
-- 2100002798326
-- 2100002798302