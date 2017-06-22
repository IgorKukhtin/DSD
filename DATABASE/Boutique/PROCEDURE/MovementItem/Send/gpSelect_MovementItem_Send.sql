-- Function: gpSelect_MovementItem_Send()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Send (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Send(
    IN inMovementId       Integer      , -- ключ Документа
    IN inIsErased         Boolean      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PartionId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , CompositionGroupName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeName TVarChar
             , Amount TFloat, Remains TFloat
             , OperPrice TFloat, CountForPrice TFloat
             , OperPriceList TFloat
             , TotalSumm TFloat
             , TotalSummPriceList TFloat
             , TotalSummBalance TFloat
             , CurrencyValue TFloat, ParValue TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbUnitId Integer;
  DECLARE vbPriceListId Integer;
  DECLARE vbPartnerId Integer;
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Send());
     vbUserId:= lpGetUserBySession (inSession);

     -- данные из шапки
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
    INTO vbOperDate, vbUnitId
     FROM Movement 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

      -- Результат такой
     RETURN QUERY 
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_CurrencyValue.ValueData, 0)   AS CurrencyValue
                           , COALESCE (MIFloat_ParValue.ValueData, 0)        AS ParValue
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
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
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                            LEFT JOIN MovementItemFloat AS MIFloat_CurrencyValue
                                                        ON MIFloat_CurrencyValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CurrencyValue.DescId         = zc_MIFloat_CurrencyValue()    
                            LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                        ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                       AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue() 
                       )
   , tmpContainer AS (SELECT Container.PartionId
                           , Container.ObjectId                                        AS GoodsId
                           , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Remains
                      FROM tmpMI AS tmpMI_Master
                           INNER JOIN Container ON Container.ObjectId = tmpMI_Master.GoodsId
                                               AND Container.PartionId = tmpMI_Master.PartionId
                                               AND Container.DescId = zc_Container_count()
                                               AND Container.WhereObjectId = vbUnitId
                           LEFT JOIN MovementItemContainer AS MIContainer 
                                                           ON MIContainer.ContainerId = Container.Id
                                                          AND MIContainer.OperDate >= vbOperDate
                      GROUP BY Container.PartionId 
                             , Container.Amount 
                             , Container.ObjectId
                      HAVING (Container.Amount - SUM (COALESCE (MIContainer.Amount, 0))) <> 0
                    )

       -- результат
       SELECT
             tmpMI.Id
           , tmpMI.PartionId
           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData       AS MeasureName

           , Object_CompositionGroup.ValueData   AS CompositionGroupName  
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.ValueData     AS GoodsSizeName 

           , tmpMI.Amount
           , tmpContainer.Remains      ::TFloat
           , tmpMI.OperPrice           ::TFloat 
           , tmpMI.OperPriceList       ::TFloat
           , tmpMI.CountForPrice       ::TFloat
           , tmpMI.TotalSumm           ::TFloat
           , tmpMI.TotalSummPriceList  ::TFloat
          , (CAST (tmpMI.TotalSumm * tmpMI.CurrencyValue / CASE WHEN tmpMI.ParValue <> 0 THEN tmpMI.ParValue ELSE 1 END AS NUMERIC (16, 2))) :: TFloat AS TotalSummBalance 

           , tmpMI.CurrencyValue       ::TFloat
           , tmpMI.ParValue            ::TFloat

           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods    ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = Object_PartionGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = Object_PartionGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = Object_PartionGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = Object_PartionGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = Object_PartionGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = Object_PartionGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = Object_PartionGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = Object_PartionGoods.GoodsSizeId
           
            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI.GoodsId
                                  AND tmpContainer.PartionId = tmpMI.PartionId  
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.06.17         *
 25.04.17         *
*/

-- тест
--select * from gpSelect_MovementItem_Send(inMovementId := 12 , inIsErased := 'False' ,  inSession := '2');