-- Function: gpSelect_Movement_Income_PrintSticker (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Movement_Income_PrintSticker (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Income_PrintSticker(
    IN inMovementId        Integer   ,   -- ключ Документа
    IN inSession           TVarChar      -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE Cursor1 refcursor;
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income_Print());
     vbUserId:= inSession;


    

     -- очень важная проверка
    IF COALESCE (vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> удален.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION 'Ошибка.Документ <%> № <%> от <%> не проведен.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- это уже странная ошибка
       -- RAISE EXCEPTION 'Ошибка.Документ <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



      --

    OPEN Cursor1 FOR
       WITH tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.ObjectId AS GoodsId
                           , MovementItem.PartionId
                           , MovementItem.Amount
                           , COALESCE (MIFloat_OperPrice.ValueData, 0)       AS OperPrice
                           , COALESCE (MIFloat_CountForPrice.ValueData, 1)   AS CountForPrice
                           , COALESCE (MIFloat_OperPriceList.ValueData, 0)   AS OperPriceList
                           , MovementItem.isErased
                       FROM 
                             MovementItem 
                                             
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                       where  MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = false

                     )
       -- Результат
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
           , Object_GoodsSize.ValueData     AS GoodsSizeName
           , Object_Brand.ValueData         AS BrandName
           , Object_CountryBrand.ValueData  AS CountryBrandName
           ,zfFormat_BarCode(zc_BarCodePref_Object(), tmpMI.PartionId) AS IdBarCode
           , tmpMI.Amount

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

            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id       = Object_PartionGoods.BrandId

            LEFT JOIN ObjectLink AS Object_Brand_CountryBrand
                                 ON Object_Brand_CountryBrand.ObjectId = Object_Brand.Id
                                AND Object_Brand_CountryBrand.DescId = zc_ObjectLink_Brand_CountryBrand()
            LEFT JOIN Object AS Object_CountryBrand ON Object_CountryBrand.Id = Object_Brand_CountryBrand.ChildObjectId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId   =  zc_ObjectString_Goods_GroupNameFull()

           

       WHERE tmpMI.Amount <> 0
       ORDER BY tmpMI.PartionId

       ;

    RETURN NEXT Cursor1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Полятыкин А.А.
23.05.17                                                          *
15.05.17                                                          *
05.06.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income_Print (inMovementId := 432692, inSession:= '5');
