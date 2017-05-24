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
    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbId Integer;
    DECLARE vbAmount TFloat;
    DECLARE vbIndex Integer;
    DECLARE Cursor1 refcursor;
    DECLARE Cur1 CURSOR FOR
        SELECT MovementItem.Id
             , COALESCE (MIFloat_PrintCount.ValueData, MovementItem.Amount) AS Amount
        FROM MovementItem 
               LEFT JOIN MovementItemBoolean AS MIBoolean_Print
                                              ON MIBoolean_Print.MovementItemId = MovementItem.Id
                                             AND MIBoolean_Print.DescId = zc_MIBoolean_Print()
                                             
               LEFT JOIN MovementItemFloat AS MIFloat_PrintCount
                                           ON MIFloat_PrintCount.MovementItemId = MovementItem.Id
                                          AND MIFloat_PrintCount.DescId = zc_MIFloat_PrintCount()

        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Master()
          AND MovementItem.isErased   = FALSE
          AND COALESCE (MIBoolean_Print.ValueData, TRUE) = TRUE;

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

    CREATE TEMP TABLE tmp_List (MIId Integer) ON COMMIT DROP;

    OPEN Cur1 ;
     LOOP
         FETCH Cur1 Into vbId, vbAmount;
         IF NOT FOUND THEN EXIT; END IF;
         -- парсим 
         vbIndex := 1;
         WHILE vbIndex <= vbAmount LOOP
             -- добавляем cтроку
             INSERT INTO tmp_List (MIId) SELECT vbId;
             -- теперь следуюющий
             vbIndex := vbIndex + 1;
         END LOOP;
     END LOOP;




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
                            tmp_List
                            LEFT JOIN MovementItem ON MovementItem.Id = tmp_List.MIId
                                             
                            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPrice
                                                        ON MIFloat_OperPrice.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPrice.DescId = zc_MIFloat_OperPrice()
                            LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                        ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                       AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()
                      

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
           , zfFormat_BarCode(zc_BarCodePref_Object(), tmpMI.PartionId) AS IdBarCode
           , Object_PartionGoods.PeriodYear AS PeriodYear
           , Object_Period.ValueData        AS PeriodName
           , substr(to_char(to_date(Object_PartionGoods.PeriodYear::text,'YYYY'), 'YY'),1,1) ||
             translate(
             case when length(fo[1])>1 then Upper(substr(fo[1],1,1)) else '' end ||
             case when length(fo[2])>1 then Upper(substr(fo[2],1,1)) else '' end || 
             case when length(fo[3])>1 then Upper(substr(fo[3],1,1)) else '' end ||
             case when length(fo[4])>1 then Upper(substr(fo[4],1,1)) else '' end 
             , 'ВЛЗО','VLZO')
             || substr(to_char(to_date(Object_PartionGoods.PeriodYear::text,'YYYY'), 'YY'),2,1) as slabel
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

            LEFT JOIN Object AS Object_Period          ON Object_Period.Id     = Object_PartionGoods.PeriodId   

            , regexp_split_to_array(replace(Object_Period.ValueData, '-' , ' ' ), E'\\s+') as fo

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
24.05.17                                                          *
23.05.17                                                          *
15.05.17                                                          *
05.06.15         * 
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Income_Print (inMovementId := 432692, inSession:= '5');
