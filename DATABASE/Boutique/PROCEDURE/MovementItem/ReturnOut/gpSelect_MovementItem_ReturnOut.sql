-- Function: gpSelect_MovementItem_ReturnOut()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnOut (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnOut(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , --
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PartionId Integer, InvNumber_Partion TVarChar, OperDate_Partion TDateTime
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeId Integer, GoodsSizeName TVarChar
             , Amount TFloat, Remains TFloat
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

  DECLARE vbUnitId         Integer;
  DECLARE vbPartnerId      Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_ReturnOut());
     --vbUserId:= lpGetUserBySession (inSession);


     -- данные из документа
     SELECT MLO_From.ObjectId             AS UnitId
          , MLO_To.ObjectId               AS PartnerId
          , MLO_CurrencyDocument.ObjectId AS CurrencyId_Doc
          , MF_CurrencyValue.ValueData    AS CurrencyValue
          , MF_ParValue.ValueData         AS ParValue
            INTO vbUnitId, vbPartnerId, vbCurrencyId_Doc, vbCurrencyValue, vbParValue
     FROM Movement
          LEFT JOIN MovementLinkObject AS MLO_From
                                       ON MLO_From.MovementId = Movement.Id
                                      AND MLO_From.DescId     = zc_MovementLinkObject_From()
          LEFT JOIN MovementLinkObject AS MLO_To
                                       ON MLO_To.MovementId = Movement.Id
                                      AND MLO_To.DescId     = zc_MovementLinkObject_To()
          LEFT JOIN MovementLinkObject AS MLO_CurrencyDocument
                                       ON MLO_CurrencyDocument.MovementId = Movement.Id
                                      AND MLO_CurrencyDocument.DescId     = zc_MovementLinkObject_CurrencyDocument()
          LEFT JOIN MovementFloat AS MF_CurrencyValue
                                  ON MF_CurrencyValue.MovementId = Movement.Id
                                 AND MF_CurrencyValue.DescId     = zc_MovementFloat_CurrencyValue()
          LEFT JOIN MovementFloat AS MF_ParValue
                                  ON MF_ParValue.MovementId = Movement.Id
                                 AND MF_ParValue.DescId     = zc_MovementFloat_ParValue()
     WHERE Movement.Id = inMovementId
    ;


     IF inShowAll = TRUE
     THEN
        -- Показываем ВСЕ
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
       , tmpPartion AS (SELECT Object_PartionGoods.MovementItemId AS PartionId
                             , Object_PartionGoods.MovementId
                             , Object_PartionGoods.GoodsId
                             , Object_PartionGoods.GoodsGroupId
                             , Object_PartionGoods.MeasureId
                             , Object_PartionGoods.CompositionId
                             , Object_PartionGoods.GoodsInfoId
                             , Object_PartionGoods.LineFabricaId
                             , Object_PartionGoods.LabelId
                             , Object_PartionGoods.GoodsSizeId
                             , Object_PartionGoods.OperPrice
                             , Object_PartionGoods.CountForPrice
                             , Object_PartionGoods.OperPriceList
                             , Container.Amount AS Remains
                        FROM Object_PartionGoods
                             INNER JOIN Container ON Container.PartionId     = Object_PartionGoods.MovementItemId
                                                 AND Container.WhereObjectId = vbUnitId
                                                 AND Container.DescId        = zc_Container_count()
                                                 AND Container.Amount        <> 0
                        WHERE Object_PartionGoods.PartnerId = vbPartnerId
                       )
         -- Последняя цена из Прайс-листа - zc_PriceList_Basis
       /*, tmpPriceList AS (SELECT tmp.GoodsId
                               , OHF_Value.ValueData AS OperPriceList
                          FROM (SELECT DISTINCT tmpPartion.GoodsId FROM tmpPartion) AS tmp
                               INNER JOIN ObjectLink AS OL_PriceListItem_Goods
                                                     ON OL_PriceListItem_Goods.ChildObjectId = tmp.GoodsId
                                                    AND OL_PriceListItem_Goods.DescId        = zc_ObjectLink_PriceListItem_Goods()
                               INNER JOIN ObjectLink AS OL_PriceListItem_PriceList
                                                     ON OL_PriceListItem_PriceList.ObjectId      = OL_PriceListItem_Goods.ObjectId
                                                    AND OL_PriceListItem_PriceList.ChildObjectId = zc_PriceList_Basis() -- !!!Базовай Прайс!!!
                                                    AND OL_PriceListItem_PriceList.DescId        = zc_ObjectLink_PriceListItem_Goods()

                               INNER JOIN ObjectHistory AS OH_PriceListItem
                                                        ON OH_PriceListItem.ObjectId = OL_PriceListItem_Goods.ObjectId
                                                       AND OH_PriceListItem.DescId   = zc_ObjectHistory_PriceListItem()
                                                       AND OH_PriceListItem.EndDate  = zc_DateEnd() -- !!!Последняя цена!!!
                               LEFT JOIN ObjectHistoryFloat AS OHF_Value
                                                            ON OHF_Value.ObjectHistoryId = OH_PriceListItem.Id
                                                           AND OHF_Value.DescId          = zc_ObjectHistoryFloat_PriceListItem_Value()
                         )
       */
        , tmpRemains AS (SELECT tmpMI.PartionId
                              , SUM (Container.Amount) AS Amount
                         FROM tmpMI 
                              LEFT JOIN Container ON Container.PartionId     = tmpMI.PartionId
                                                 AND Container.WhereObjectId = vbUnitId
                                                 AND Container.DescId        = zc_Container_count()
                          GROUP BY tmpMI.PartionId
                         )

       -- результат
       SELECT
             0                                    AS Id
           , tmpPartion.PartionId                 AS PartionId
           , Movement_Partion.InvNumber           AS InvNumber_Partion
           , Movement_Partion.OperDate            AS OperDate_Partion

           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData             AS MeasureName

           , Object_Composition.ValueData         AS CompositionName
           , Object_GoodsInfo.ValueData           AS GoodsInfoName
           , Object_LineFabrica.ValueData         AS LineFabricaName
           , Object_Label.ValueData               AS LabelName
           , Object_GoodsSize.Id                  AS GoodsSizeId
           , Object_GoodsSize.ValueData           AS GoodsSizeName

           , 0                          :: TFloat AS Amount
           , tmpPartion.Remains         :: TFloat AS Remains
           , tmpPartion.OperPrice       :: TFloat AS OperPrice
           , tmpPartion.CountForPrice   :: TFloat AS CountForPrice
           --, tmpPriceList.OperPriceList :: TFloat AS OperPriceList
           , tmpPartion.OperPriceList   :: TFloat AS OperPriceList
           , 0                          :: TFloat AS TotalSumm
           , 0                          :: TFloat AS TotalSummBalance
           , 0                          :: TFloat AS TotalSummPriceList

           , FALSE                                AS isErased

       FROM tmpPartion
            LEFT JOIN tmpMI        ON tmpMI.PartionId      = tmpPartion.PartionId
            --LEFT JOIN tmpPriceList ON tmpPriceList.GoodsId = tmpPartion.GoodsId
            LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id   = tmpPartion.MovementId
            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpPartion.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = tmpPartion.GoodsGroupId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = tmpPartion.MeasureId
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = tmpPartion.CompositionId
            LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = tmpPartion.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = tmpPartion.LineFabricaId
            LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = tmpPartion.LabelId
            LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = tmpPartion.GoodsSizeId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpPartion.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

       WHERE tmpMI.PartionId IS NULL

    UNION ALL
       -- Показываем только строки документа
       SELECT
             tmpMI.Id                             AS Id
           , tmpMI.PartionId                      AS PartionId
           , Movement_Partion.InvNumber           AS InvNumber_Partion
           , Movement_Partion.OperDate            AS OperDate_Partion
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData             AS MeasureName

           , Object_Composition.ValueData         AS CompositionName
           , Object_GoodsInfo.ValueData           AS GoodsInfoName
           , Object_LineFabrica.ValueData         AS LineFabricaName
           , Object_Label.ValueData               AS LabelName
           , Object_GoodsSize.Id                  AS GoodsSizeId
           , Object_GoodsSize.ValueData           AS GoodsSizeName

           , tmpMI.Amount               :: TFloat AS Amount
           , Container.Amount           :: TFloat AS Remains
           , tmpMI.OperPrice            :: TFloat AS OperPrice
           , tmpMI.CountForPrice        :: TFloat AS CountForPrice
           , tmpMI.OperPriceList        :: TFloat AS OperPriceList
           , tmpMI.TotalSumm            :: TFloat AS TotalSumm
           , CASE WHEN vbCurrencyId_Doc = zc_Currency_Basis()
                        THEN tmpMI.TotalSumm
                  ELSE CAST (CASE WHEN vbParValue > 0 THEN tmpMI.TotalSumm * vbCurrencyValue / vbParValue ELSE tmpMI.TotalSumm * vbCurrencyValue
                             END AS NUMERIC (16, 2))
             END :: TFloat AS TotalSummBalance
           , tmpMI.TotalSummPriceList   :: TFloat AS TotalSummPriceList

           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId
            LEFT JOIN tmpRemains AS Container ON Container.PartionId     = tmpMI.PartionId
                               --AND Container.WhereObjectId = vbUnitId
                               --AND Container.DescId        = zc_Container_count()
            LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id   = Object_PartionGoods.MovementId
            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpMI.GoodsId                    -- Object_PartionGoods.GoodsId - тоже самое
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId -- Object_PartionGoods.GoodsId - тоже самое
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
       ;

     ELSE

     -- Результат такой - Показываем только строки документа
     RETURN QUERY
        WITH tmpMI AS (SELECT MovementItem.Id
                            , MovementItem.ObjectId AS GoodsId
                            , MovementItem.PartionId
                            , MovementItem.Amount
                            , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                            , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                            , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                            , CAST (CASE WHEN MIFloat_CountForPrice.ValueData <> 0
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

        , tmpRemains AS (SELECT tmpMI.PartionId
                              , SUM (Container.Amount) AS Amount
                         FROM tmpMI 
                              LEFT JOIN Container ON Container.PartionId     = tmpMI.PartionId
                                                 AND Container.WhereObjectId = vbUnitId
                                                 AND Container.DescId        = zc_Container_count()
                          GROUP BY tmpMI.PartionId
                         )

       -- результат
       SELECT
             tmpMI.Id                             AS Id
           , tmpMI.PartionId                      AS PartionId
           , Movement_Partion.InvNumber           AS InvNumber_Partion
           , Movement_Partion.OperDate            AS OperDate_Partion
           , Object_Goods.Id                      AS GoodsId
           , Object_Goods.ObjectCode              AS GoodsCode
           , Object_Goods.ValueData               AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData             AS MeasureName

           , Object_Composition.ValueData         AS CompositionName
           , Object_GoodsInfo.ValueData           AS GoodsInfoName
           , Object_LineFabrica.ValueData         AS LineFabricaName
           , Object_Label.ValueData               AS LabelName
           , Object_GoodsSize.Id                  AS GoodsSizeId
           , Object_GoodsSize.ValueData           AS GoodsSizeName

           , tmpMI.Amount               :: TFloat AS Amount
           , Container.Amount           :: TFloat AS Remains
           , tmpMI.OperPrice            :: TFloat AS OperPrice
           , tmpMI.CountForPrice        :: TFloat AS CountForPrice
           , tmpMI.OperPriceList        :: TFloat AS OperPriceList
           , tmpMI.TotalSumm            :: TFloat AS TotalSumm
           , CASE WHEN vbCurrencyId_Doc = zc_Currency_Basis()
                        THEN tmpMI.TotalSumm
                  ELSE CAST (CASE WHEN vbParValue > 0 THEN tmpMI.TotalSumm * vbCurrencyValue / vbParValue ELSE tmpMI.TotalSumm * vbCurrencyValue
                             END AS NUMERIC (16, 2))
             END :: TFloat AS TotalSummBalance
           , tmpMI.TotalSummPriceList   :: TFloat AS TotalSummPriceList

           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId
            LEFT JOIN tmpRemains AS Container ON Container.PartionId     = tmpMI.PartionId
                               --AND Container.WhereObjectId = vbUnitId
                               --AND Container.DescId        = zc_Container_count()
            LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id   = Object_PartionGoods.MovementId
            LEFT JOIN Object AS Object_Goods       ON Object_Goods.Id       = tmpMI.GoodsId -- Object_PartionGoods.GoodsId - тоже самое
            LEFT JOIN Object AS Object_GoodsGroup  ON Object_GoodsGroup.Id  = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure     ON Object_Measure.Id     = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition ON Object_Composition.Id = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_GoodsInfo   ON Object_GoodsInfo.Id   = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica ON Object_LineFabrica.Id = Object_PartionGoods.LineFabricaId
            LEFT JOIN Object AS Object_Label       ON Object_Label.Id       = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize   ON Object_GoodsSize.Id   = Object_PartionGoods.GoodsSizeId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId -- Object_PartionGoods.GoodsId - тоже самое
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
       ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.04.18         *
 21.06.17         *
 24.04.17         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 7, inShowAll:= TRUE,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 7, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin());
