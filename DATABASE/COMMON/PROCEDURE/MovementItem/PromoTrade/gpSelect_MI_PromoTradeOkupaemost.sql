-- Function: gpSelect_MI_PromoTradeOkupaemost()

DROP FUNCTION IF EXISTS gpSelect_MI_PromoTradeOkupaemost (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PromoTradeOkupaemost(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        NUM      Integer 
      , GroupNum Integer
      , Id                  Integer  --идентификатор
      , GoodsId             Integer  --ИД объекта <товар>
      , GoodsCode           Integer  --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , GoodsKindId         Integer  --ИД обьекта <Вид товара>
      , GoodsKindName       TVarChar --Наименование обьекта <Вид товара> 
      , MeasureName         TVarChar --Единица измерения      
      
      , PromoTax          TFloat
      , PricePromo        TFloat
      , PricePromo_new    TFloat
      , ChangePercent     TFloat
      , PriceWithVAT      TFloat     --Цена план (мес.), с учетом НДС
      , AmountPlan        TFloat     --Ожидаемый среднемесячный объем продаж в Ед. Изм.
      , AmountPlan_weight TFloat     --Ожидаемый среднемесячный объем продаж, кг
      , SummWithVATPlan   TFloat     --Ожидаемый среднемесячный объем продаж, грн
      , Summ_pos          TFloat     --Стоимость ввода позиции, грн
)
AS
$BODY$
    DECLARE vbUserId Integer;
            vbPriceListId Integer;
            vbPriceWithVAT Boolean;
            vbVATPercent   TFloat;
    DECLARE vbMovementId_PromoTradeCondition Integer;
            vbChangePercent TFloat;
            vbChangePercent_new  TFloat;
            
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PromoTradeGoods());
    vbUserId:= lpGetUserBySession (inSession);

    vbPriceListId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_PriceList());

    SELECT ObjectBoolean_PriceWithVAT.ValueData AS PriceWithVAT
         , ObjectFloat_VATPercent.ValueData     AS VATPercent
  INTO vbPriceWithVAT, vbVATPercent
    FROM Object AS Object_PriceList
         LEFT JOIN ObjectBoolean AS ObjectBoolean_PriceWithVAT
                                 ON ObjectBoolean_PriceWithVAT.ObjectId = Object_PriceList.Id
                                AND ObjectBoolean_PriceWithVAT.DescId = zc_ObjectBoolean_PriceList_PriceWithVAT()
         LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                               ON ObjectFloat_VATPercent.ObjectId = Object_PriceList.Id
                              AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()
    WHERE Object_PriceList.DescId = zc_Object_PriceList()
      AND Object_PriceList.Id = vbPriceListId;

    vbMovementId_PromoTradeCondition := (SELECT Movement.Id
                                         FROM Movement
                                         WHERE Movement.DescId = zc_Movement_PromoTradeCondition()
                                           AND Movement.ParentId =  inMovementId
                                         );

    SELECT MovementFloat_ChangePercent.ValueData     ::TVarChar AS ChangePercent
         , MovementFloat_ChangePercent_new.ValueData ::TVarChar AS ChangePercent_new
  INTO vbChangePercent, vbChangePercent_new
    FROM MovementFloat AS MovementFloat_ChangePercent 
         LEFT JOIN MovementFloat AS MovementFloat_ChangePercent_new 
                                 ON MovementFloat_ChangePercent_new.MovementId = vbMovementId_PromoTradeCondition
                                AND MovementFloat_ChangePercent_new.DescId = zc_MovementFloat_ChangePercent_new()
    WHERE MovementFloat_ChangePercent.MovementId = inMovementId
      AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent();

    RETURN QUERY
    WITH
    tmpPrice AS (SELECT tmp.GoodsId
                      , tmp.GoodsKindId
                      , tmp.ValuePrice
                 FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId
                                                          , inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                            ) AS tmp
                 )


  , tmpMI AS (SELECT MovementItem.*
                   , MILinkObject_GoodsKind.ObjectId AS GoodsKindId

                   -- расчет цены без НДС, до 4 знаков
                   , CASE WHEN vbPriceWithVAT = TRUE
                          THEN CAST (COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) - COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                          ELSE COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice)
                     END    ::TFloat    AS PriceWithOutVAT
                   -- расчет цены с НДС, до 4 знаков
                   , CASE WHEN vbPriceWithVAT = TRUE
                          THEN COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice)
                          ELSE CAST (COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) * ( (vbVATPercent + 100)/100) AS NUMERIC (16, 2))
                     END    ::TFloat    AS PriceWithVAT
              FROM MovementItem 
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                    ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                   -- привязываем 2 раза по виду товара и без
                   LEFT JOIN tmpPrice ON tmpPrice.GoodsId = MovementItem.ObjectId
                                     AND tmpPrice.GoodsKindId IS NULL
                   LEFT JOIN tmpPrice AS tmpPrice_Kind
                                      ON tmpPrice_Kind.GoodsId = MovementItem.ObjectId
                                     AND COALESCE (tmpPrice_Kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId,0)

              WHERE MovementItem.DescId = zc_MI_Master()
                AND MovementItem.MovementId = inMovementId
                AND MovementItem.isErased = FALSE
              )

  , tmpMIFloat AS (SELECT MovementItemFloat.* 
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_PromoTax()
                                                    , zc_MIFloat_AmountPlan()
                                                    , zc_MIFloat_Summ()
                                                    , zc_MIFloat_ChangePercent()
                                                    , zc_MIFloat_PricePromo()
                                                    , zc_MIFloat_PricePromo_new()
                                                     )
                   )       
  , tmpData AS (
                SELECT MovementItem.Id
                     , MovementItem.ObjectId            AS GoodsId
                     , Object_Goods.ObjectCode::Integer AS GoodsCode
                     , Object_Goods.ValueData           AS GoodsName
                     , Object_Measure.Id                AS MeasureId
                     , Object_Measure.ValueData         AS MeasureName 
                     , Object_GoodsKind.Id              AS GoodsKindId     
                     , Object_GoodsKind.ValueData       AS GoodsKindName
                     
                     , MIFloat_AmountPlan.ValueData      ::TFloat AS AmountPlan
                     , (MIFloat_AmountPlan.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) ::TFloat AS AmountPlan_weight
                     , (MIFloat_AmountPlan.ValueData * COALESCE (MIFloat_PromoTax.ValueData,0))                                                                                       ::TFloat AS AmountPlan_calc
                     , (MIFloat_AmountPlan.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END * COALESCE (MIFloat_PromoTax.ValueData,0)) ::TFloat AS AmountPlan_weight_calc
                     , MIFloat_Summ.ValueData            ::TFloat AS Summ
                     , MIFloat_PromoTax.ValueData        ::TFloat AS PromoTax
                                         
                     -- расчет цены с НДС со скидкой
                     , (MovementItem.PriceWithVAT - (1- COALESCE (MIFloat_ChangePercent.ValueData,100) / 100)) ::TFloat AS PriceWithVAT
                     , MIFloat_ChangePercent.ValueData AS ChangePercent
                     , MIFloat_PricePromo.ValueData     ::TFloat AS PricePromo
                     , MIFloat_PricePromo_new.ValueData ::TFloat AS PricePromo_new
             
                FROM tmpMI AS MovementItem
                     LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                          ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                         AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                     LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                     LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                           ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                          AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
 
                     LEFT JOIN tmpMIFloat AS MIFloat_Summ
                                          ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                         AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                     LEFT JOIN tmpMIFloat AS MIFloat_AmountPlan
                                          ON MIFloat_AmountPlan.MovementItemId = MovementItem.Id
                                         AND MIFloat_AmountPlan.DescId = zc_MIFloat_AmountPlan()
                     LEFT JOIN tmpMIFloat AS MIFloat_PromoTax
                                          ON MIFloat_PromoTax.MovementItemId = MovementItem.Id
                                         AND MIFloat_PromoTax.DescId = zc_MIFloat_PromoTax()

                     LEFT JOIN tmpMIFloat AS MIFloat_PricePromo
                                          ON MIFloat_PricePromo.MovementItemId = MovementItem.Id
                                         AND MIFloat_PricePromo.DescId = zc_MIFloat_PricePromo()
                     LEFT JOIN tmpMIFloat AS MIFloat_PricePromo_new
                                          ON MIFloat_PricePromo_new.MovementItemId = MovementItem.Id
                                         AND MIFloat_PricePromo_new.DescId = zc_MIFloat_PricePromo_new()
                                        
                     LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                          ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                         AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                     LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                     LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MovementItem.GoodsKindId
                     
                     
               )

  , tmpRes AS (
               --Текущие условия
               SELECT 1 AS Num
                    , tmpData.Id
                    , tmpData.GoodsId
                    , tmpData.GoodsCode
                    , tmpData.GoodsName
                    , tmpData.GoodsKindId
                    , tmpData.GoodsKindName
                    , tmpData.MeasureId
                    , tmpData.MeasureName
                    , tmpData.PromoTax
                    , tmpData.PricePromo
                    , tmpData.PricePromo_new
                    , tmpData.ChangePercent                                                                             
                    , tmpData.PriceWithVAT
                    , (COALESCE (tmpData.AmountPlan,0) - COALESCE (tmpData.AmountPlan_calc,0)) ::TFloat AS AmountPlan  --Ожидаемый среднемесячный объем продаж в Ед. Изм.
                    , tmpData.AmountPlan_weight                                                                        --Ожидаемый среднемесячный объем продаж, кг
                    , ((COALESCE (tmpData.AmountPlan,0) - COALESCE (tmpData.AmountPlan_calc,0))                        
                       * tmpData.PriceWithVAT)  ::TFloat AS SummWithVATPlan                                            --Ожидаемый среднемесячный объем продаж, грн
                    , CASE WHEN COALESCE (tmpData.AmountPlan,0) <> 0 
                           THEN (tmpData.Summ /tmpData.AmountPlan * (COALESCE (tmpData.AmountPlan,0) - COALESCE (tmpData.AmountPlan_calc,0)))
                           ELSE 0
                      END ::TFloat AS Summ_pos                                                                         --Стоимость ввода позиции, грн
               FROM tmpData
             UNION ALL     
               --Текущие условия (Акция)
               SELECT 2 AS Num
                    , tmpData.Id
                    , tmpData.GoodsId
                    , tmpData.GoodsCode
                    , tmpData.GoodsName
                    , tmpData.GoodsKindId
                    , tmpData.GoodsKindName
                    , tmpData.MeasureId
                    , tmpData.MeasureName
                    , tmpData.PromoTax 
                    , tmpData.PricePromo
                    , tmpData.PricePromo_new
                    , tmpData.ChangePercent
                    , tmpData.PriceWithVAT                                                                             --Цена план (мес.), с учетом НДС
                    , COALESCE (tmpData.AmountPlan_calc,0) ::TFloat AS AmountPlan                                      --Ожидаемый среднемесячный объем продаж в Ед. Изм.
                    , tmpData.AmountPlan_weight_calc       ::TFloat AS AmountPlan_weight                               --Ожидаемый среднемесячный объем продаж, кг
                    , (COALESCE (tmpData.AmountPlan_calc,0)                        
                       * tmpData.PriceWithVAT)  ::TFloat AS SummWithVATPlan                                            --Ожидаемый среднемесячный объем продаж, грн
                    , CASE WHEN COALESCE (tmpData.AmountPlan,0) <> 0 
                           THEN tmpData.Summ /tmpData.AmountPlan * COALESCE (tmpData.AmountPlan_calc,0)
                           ELSE 0
                      END ::TFloat AS Summ_pos                                                                         --Стоимость ввода позиции, грн
               FROM tmpData
               WHERE COALESCE (tmpData.PromoTax,0) <> 0
               --Новые условия
               --Новые условия (Акция) 

               )

        SELECT tmpData.NUM AS NUM
             , CASE WHEN tmpData.NUM IN (1, 2) THEN 1
                    WHEN tmpData.NUM IN (3, 4) THEN 2 
                    ELSE 3 
               END AS GroupNum
             
             , tmpData.Id
             , tmpData.GoodsId
             , tmpData.GoodsCode
             , tmpData.GoodsName
             , tmpData.GoodsKindId
             , tmpData.GoodsKindName
             , tmpData.MeasureName
             , tmpData.PromoTax          ::TFloat
             , tmpData.PricePromo        ::TFloat
             , tmpData.PricePromo_new    ::TFloat
             , tmpData.ChangePercent     ::TFloat
             , tmpData.PriceWithVAT      ::TFloat                              --Цена план (мес.), с учетом НДС
             , tmpData.AmountPlan        ::TFloat                              --Ожидаемый среднемесячный объем продаж в Ед. Изм.
             , tmpData.AmountPlan_weight ::TFloat                              --Ожидаемый среднемесячный объем продаж, кг
             , tmpData.SummWithVATPlan   ::TFloat                              --Ожидаемый среднемесячный объем продаж, грн
             , tmpData.Summ_pos          ::TFloat                              --Стоимость ввода позиции, грн
        FROM tmpRes AS tmpData
        ORDER BY tmpData.Id
               , tmpData.NUM
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.07.25         *
*/
-- тест
--SELECT * FROM gpSelect_MI_PromoTradeOkupaemost (5083159 , zfCalc_UserAdmin());
-- select * from gpSelect_MI_PromoTradeOkupaemost(inMovementId := 31603021  , inSession := '9457');