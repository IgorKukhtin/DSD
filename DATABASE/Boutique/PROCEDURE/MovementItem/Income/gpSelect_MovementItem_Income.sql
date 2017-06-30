-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income(
    IN inMovementId       Integer      , -- ���� ���������
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, PartionId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , JuridicalName TVarChar
             , CompositionGroupName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , Amount TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
             , TotalSumm TFloat, TotalSummBalance TFloat, TotalSummPriceList TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId         Integer;
  DECLARE vbCurrencyId_Doc Integer;
  DECLARE vbCurrencyValue  TFloat;
  DECLARE vbParValue       TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������� ���� � ���������
     SELECT MLO_CurrencyDocument.ObjectId AS CurrencyId_Doc
          , MF_CurrencyValue.ValueData    AS CurrencyValue
          , MF_ParValue.ValueData         AS ParValue
            INTO vbCurrencyId_Doc, vbCurrencyValue, vbParValue
     FROM MovementLinkObject AS MLO_CurrencyDocument
          LEFT JOIN MovementFloat AS MF_CurrencyValue
                                  ON MF_CurrencyValue.MovementId = MLO_CurrencyDocument.MovementId
                                 AND MF_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
          LEFT JOIN MovementFloat AS MF_ParValue
                                  ON MF_ParValue.MovementId = MLO_CurrencyDocument.MovementId
                                 AND MF_ParValue.DescId     = zc_MovementFloat_ParValue()
     WHERE MLO_CurrencyDocument.MovementId = inMovementId
       AND MLO_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
    ;

     -- ���������
     RETURN QUERY
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                                             THEN MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0) / MIFloat_CountForPrice.ValueData
                                         ELSE MovementItem.Amount * COALESCE (MIFloat_OperPrice.ValueData, 0)
                                   END AS NUMERIC (16, 2)) AS TotalSumm
                           , CAST (MovementItem.Amount * COALESCE (MIFloat_OperPriceList.ValueData, 0) AS NUMERIC (16, 2)) AS TotalSummPriceList

                           , MovementItem.isErased

                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId         = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId         = zc_MIFloat_OperPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId         = zc_MIFloat_OperPriceList()
                     )
       -- ���������
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData AS MeasureName
           , Object_Juridical.ValueData as JuridicalName
           , Object_CompositionGroup.ValueData   AS CompositionGroupName
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.Id            AS GoodsSizeId
           , Object_GoodsSize.ValueData     AS GoodsSizeName

           , tmpMI.Amount
           , tmpMI.OperPrice           :: TFloat AS OperPrice
           , tmpMI.CountForPrice       :: TFloat AS CountForPrice
           , tmpMI.OperPriceList       :: TFloat AS OperPriceList
           , tmpMI.TotalSumm           :: TFloat AS TotalSumm
           , (CASE WHEN vbCurrencyId_Doc = zc_Currency_Basis()
                        THEN tmpMI.TotalSumm
                   ELSE CAST (CASE WHEN vbParValue > 0 THEN tmpMI.TotalSumm * vbCurrencyValue / vbParValue ELSE tmpMI.TotalSumm * vbCurrencyValue
                              END AS NUMERIC (16, 2))
              END) :: TFloat AS TotalSummBalance
           , tmpMI.TotalSummPriceList  :: TFloat AS TotalSummPriceList

           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object_PartionGoods               ON Object_PartionGoods.MovementItemId = tmpMI.PartionId

            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id       = tmpMI.GoodsId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id     = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId

            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id       = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId
            LEFT JOIN Object AS Object_Juridical        ON Object_Juridical.Id   = Object_PartionGoods.JuridicalId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   =  zc_ObjectString_Goods_GroupNameFull()
           ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.04.17         *
*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_Income (inMovementId:= 1, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
