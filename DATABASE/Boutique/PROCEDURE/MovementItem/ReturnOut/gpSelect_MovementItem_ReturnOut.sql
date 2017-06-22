-- Function: gpSelect_MovementItem_ReturnOut()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnOut (Integer, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnOut(
    IN inMovementId       Integer      , -- ключ Документа
    IN inShowAll          Boolean      , --
    IN inIsErased         Boolean      , -- 
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PartionId Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , CompositionGroupName TVarChar
             , CompositionName TVarChar
             , GoodsInfoName TVarChar
             , LineFabricaName TVarChar
             , LabelName TVarChar
             , GoodsSizeName TVarChar
             , Amount TFloat, Remains TFloat
             , OperPrice TFloat, CountForPrice TFloat, OperPriceList TFloat
             , AmountSumm TFloat, AmountPriceListSumm TFloat
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
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_ReturnOut());
     vbUserId:= lpGetUserBySession (inSession);

     -- данные из шапки
     SELECT Movement.OperDate
          , MovementLinkObject_From.ObjectId
          , MovementLinkObject_To.ObjectId
    INTO vbOperDate, vbUnitId, vbPartnerId
     FROM Movement 
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
     WHERE Movement.Id = inMovementId;


    IF inShowAll THEN
     RETURN QUERY 
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice 
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
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
       , tmpGoods AS (SELECT Object_PartionGoods.MovementItemId AS PartionId
                           , Object_PartionGoods.GoodsId
                           , Object_PartionGoods.GoodsGroupId
                           , Object_PartionGoods.MeasureId
                           , Object_PartionGoods.CompositionId
                           , Object_PartionGoods.CompositionGroupId
                           , Object_PartionGoods.GoodsInfoId
                           , Object_PartionGoods.LineFabricaId
                           , Object_PartionGoods.LabelId
                           , Object_PartionGoods.GoodsSizeId
                           , Object_PartionGoods.OperPrice      ::TFloat
                           , Object_PartionGoods.PriceSale      ::TFloat
                      FROM Object_PartionGoods
                      WHERE Object_PartionGoods.PartnerId = vbPartnerId
                      )
   , tmpContainer AS (SELECT Container.PartionId
                           , Container.ObjectId                                        AS GoodsId
                           , Container.Amount - SUM (COALESCE (MIContainer.Amount, 0)) AS Remains
                      FROM tmpGoods 
                           INNER JOIN Container ON Container.ObjectId = tmpGoods.GoodsId
                                               AND Container.PartionId = tmpGoods.PartionId
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
             0
           , tmpGoods.PartionId
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData AS MeasureName

           , Object_CompositionGroup.ValueData   AS CompositionGroupName  
           , Object_Composition.ValueData   AS CompositionName
           , Object_GoodsInfo.ValueData     AS GoodsInfoName
           , Object_LineFabrica.ValueData   AS LineFabricaName
           , Object_Label.ValueData         AS LabelName
           , Object_GoodsSize.ValueData     AS GoodsSizeName  

           , CAST (0 AS TFloat) AS Amount
           , tmpContainer.Remains ::TFloat

           , tmpGoods.OperPrice
           , CAST (1 AS TFloat) AS CountForPrice
           , tmpGoods.PriceSale AS OperPriceList

           , CAST (0 AS TFloat) AS AmountSumm

           , CAST (0 AS TFloat) AS AmountPriceListSumm

           , False AS isErased

       FROM tmpGoods
            LEFT JOIN tmpMI ON tmpMI.GoodsId   = tmpGoods.GoodsId
                           AND tmpMI.PartionId = tmpGoods.PartionId

            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = tmpGoods.GoodsId

            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpGoods.GoodsGroupId
            LEFT JOIN Object AS Object_Measure          ON Object_Measure.Id          = tmpGoods.MeasureId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpGoods.CompositionId
            LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpGoods.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpGoods.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpGoods.LineFabricaId 
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpGoods.LabelId
            LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpGoods.GoodsSizeId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpGoods.GoodsId
                                  AND tmpContainer.PartionId = tmpGoods.PartionId  

       WHERE tmpMI.Id IS NULL

    UNION ALL
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
           , tmpContainer.Remains ::TFloat

           , tmpMI.OperPrice      ::TFloat
           , tmpMI.CountForPrice  ::TFloat
           , tmpMI.OperPriceList  ::TFloat

           , CAST (CASE WHEN tmpMI.CountForPrice <> 0
                           THEN CAST (COALESCE (tmpMI.Amount, 0) * tmpMI.OperPrice / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.OperPrice AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , CAST (CASE WHEN tmpMI.CountForPrice <> 0
                           THEN CAST (COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountPriceListSumm

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
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI.GoodsId
                                  AND tmpContainer.PartionId = tmpMI.PartionId  
       ;

     ELSE
     -- Результат такой
     RETURN QUERY 
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount 
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice 
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
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
           , tmpContainer.Remains ::TFloat

           , tmpMI.OperPrice      ::TFloat
           , tmpMI.CountForPrice  ::TFloat
           , tmpMI.OperPriceList  ::TFloat

           , CAST (CASE WHEN tmpMI.CountForPrice <> 0
                           THEN CAST (COALESCE (tmpMI.Amount, 0) * tmpMI.OperPrice / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.OperPrice AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm

           , CAST (CASE WHEN tmpMI.CountForPrice <> 0
                           THEN CAST (COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList / tmpMI.CountForPrice AS NUMERIC (16, 2))
                        ELSE CAST ( COALESCE (tmpMI.Amount, 0) * tmpMI.OperPriceList AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountPriceListSumm

           , tmpMI.isErased

       FROM tmpMI
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMI.PartionId                                 

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
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN tmpContainer ON tmpContainer.GoodsId = tmpMI.GoodsId
                                  AND tmpContainer.PartionId = tmpMI.PartionId  
       ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 21.06.17         *
 24.04.17         *
*/

-- тест
--select * from gpSelect_MovementItem_ReturnOut(inMovementId := 7 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '2');
--select * from gpSelect_MovementItem_ReturnOut(inMovementId := 7 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '2');