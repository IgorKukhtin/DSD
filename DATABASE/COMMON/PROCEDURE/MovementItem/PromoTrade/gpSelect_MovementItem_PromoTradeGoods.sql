-- Function: gpSelect_MovementItem_PromoTradeGoods()

-- DROP FUNCTION IF EXISTS gpSelect_MI_PromoTradeGoods_Plan (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoTradeGoods (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoTradeGoods(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
        Ord                 Integer
      , Id                  Integer --идентификатор
      , MovementId          Integer --ИД документа <Акция>
      , PartnerId           Integer
      , PartnerName         TVarChar
      , GoodsId             Integer --ИД объекта <товар>
      , GoodsCode           Integer --код объекта  <товар>
      , GoodsName           TVarChar --наименование объекта <товар>
      , MeasureName         TVarChar --Единица измерения  
      , GoodsKindId         Integer --ИД обьекта <Вид товара>
      , GoodsKindName       TVarChar --Наименование обьекта <Вид товара>      
      , TradeMarkId Integer, TradeMarkName       TVarChar --Торговая марка 
      , GoodsGroupPropertyId Integer, GoodsGroupPropertyName TVarChar, GoodsGroupPropertyId_Parent Integer, GoodsGroupPropertyName_Parent TVarChar 
      , GoodsGroupDirectionId Integer, GoodsGroupDirectionName TVarChar  

      , Amount             TFloat --Кол-во 
      , Amount_weight      TFloat -- вес
      , Summ               TFloat --Сумма, грн
      , PartnerCount       TFloat --Количество ТТ  
      , AmountPlan         TFloat -- 
      , AmountPlan_weight  TFloat
      , AmountPlan_calc         TFloat -- 
      , AmountPlan_weight_calc  TFloat

      -- сохраненная цена Прайс
      , PriceWithOutVAT_pr TFloat
      , PriceWithVAT_pr    TFloat
      , PriceWithOutVAT    TFloat       --прайс цена со скидкой документа
      , PriceWithVAT       TFloat       --прайс цена со скидкой документа
      , PriceWithOutVAT_new    TFloat   --прайс цена с новой скидкой документа (ком.условия)
      , PriceWithVAT_new       TFloat   --прайс цена с новой скидкой документа (ком.условия)
      , PriceIn                TFloat   --Себ-ть прод, грн/кг
      , PriceIn_calc           TFloat   --Себ-ть прод, грн/кг (расчет) 
      , ChangePrice            TFloat   --Себ-ть расходы, грн/кг
      , SummWithOutVATPlan     TFloat   --Сумма со скидкой документа
      , SummWithVATPlan        TFloat   --Сумма со скидкой документа
      , SummWithOutVATPlan_new TFloat   --Сумма с новой скидкой документа (ком.условия)
      , SummWithVATPlan_new    TFloat   --Сумма с новой скидкой документа (ком.условия)

      , PromoTax           TFloat
      , ChangePercent      TFloat
      , PricePromo         TFloat
      , PricePromo_new     TFloat
      
      , Comment            TVarChar --Комментарий       
      , isErased           Boolean  --удален
)
AS
$BODY$
    DECLARE vbUserId Integer;
            vbPriceListId Integer;
            vbPriceWithVAT Boolean;
            vbVATPercent   TFloat;
            vbMovementId_PromoTradeCondition Integer;
            vbChangePercent      TFloat;
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

    vbChangePercent := (SELECT MovementFloat.ValueData
                        FROM MovementFloat 
                        WHERE MovementFloat.MovementId = inMovementId
                          AND MovementFloat.DescId = zc_MovementFloat_ChangePercent()
                        );

    vbChangePercent_new := (SELECT MovementFloat.ValueData
                            FROM MovementFloat
                            WHERE MovementFloat.MovementId = vbMovementId_PromoTradeCondition
                              AND MovementFloat.DescId = zc_MovementFloat_ChangePercent_new()
                            );

    RETURN QUERY
    WITH
    tmpPrice AS (SELECT tmp.GoodsId
                      , tmp.GoodsKindId
                      , tmp.ValuePrice
                 FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId
                                                          , inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)
                                                            ) AS tmp
                 )

  , tmpMI AS (
              SELECT tmp.Id
                   , tmp.MovementId
                   , tmp.ObjectId
                   , tmp.GoodsKindId
                   , tmp.Amount
                   , tmp.isErased
                   -- сохраненная цена Прайс
                   , tmp.PriceWithOutVAT      ::TFloat    AS PriceWithOutVAT_pr
                   , tmp.PriceWithVAT         ::TFloat    AS PriceWithVAT_pr
                   --текущая  цена Прайс со скидкой из документа
                   , CASE WHEN COALESCE (vbChangePercent,0)<> 0 THEN (tmp.PriceWithOutVAT - tmp.PriceWithOutVAT * vbChangePercent / 100) ELSE tmp.PriceWithOutVAT END      ::TFloat    AS PriceWithOutVAT
                   , CASE WHEN COALESCE (vbChangePercent,0)<> 0 THEN (tmp.PriceWithVAT - tmp.PriceWithVAT * vbChangePercent / 100) ELSE tmp.PriceWithVAT END               ::TFloat    AS PriceWithVAT
                   --Новая    Цена Прайс с новой скидкой из  PromoTradeCondition
                   , CASE WHEN COALESCE (vbChangePercent_new,0)<> 0 THEN (tmp.PriceWithOutVAT - tmp.PriceWithOutVAT * vbChangePercent_new / 100) ELSE tmp.PriceWithOutVAT END  ::TFloat    AS PriceWithOutVAT_new
                   , CASE WHEN COALESCE (vbChangePercent_new,0)<> 0 THEN (tmp.PriceWithVAT - tmp.PriceWithVAT * vbChangePercent_new / 100) ELSE tmp.PriceWithVAT END           ::TFloat    AS PriceWithVAT_new
              FROM (SELECT MovementItem.*
                         , MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                         -- расчет цены без НДС
                         , CASE WHEN COALESCE (MIFloat_PriceWithOutVAT.ValueData,0) <> 0 
                                THEN MIFloat_PriceWithOutVAT.ValueData
                                ELSE CASE WHEN vbPriceWithVAT = TRUE
                                          THEN CAST (COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) - COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) * (vbVATPercent / (vbVATPercent + 100)) AS NUMERIC (16, 2))
                                          ELSE COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice)
                                     END
                           END    ::TFloat    AS PriceWithOutVAT
                         -- расчет цены с НДС
                         , CASE WHEN COALESCE (MIFloat_PriceWithVAT.ValueData,0) <> 0 
                                THEN MIFloat_PriceWithVAT.ValueData
                                ELSE CASE WHEN vbPriceWithVAT = TRUE
                                          THEN COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice)
                                          ELSE CAST (COALESCE (tmpPrice_Kind.ValuePrice, tmpPrice.ValuePrice) * ( (vbVATPercent + 100)/100) AS NUMERIC (16, 2))
                                     END
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

                         LEFT JOIN MovementItemFloat AS MIFloat_PriceWithOutVAT
                                                     ON MIFloat_PriceWithOutVAT.MovementItemId = MovementItem.Id
                                                    AND MIFloat_PriceWithOutVAT.DescId = zc_MIFloat_PriceWithOutVAT()
                         LEFT JOIN MovementItemFloat AS MIFloat_PriceWithVAT
                                                     ON MIFloat_PriceWithVAT.MovementItemId = MovementItem.Id
                                                    AND MIFloat_PriceWithVAT.DescId = zc_MIFloat_PriceWithVAT()      
                    WHERE MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.MovementId = inMovementId
                      AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                   ) AS tmp 
              )

  , tmpMIFloat AS (SELECT MovementItemFloat.*
                   FROM MovementItemFloat
                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                     AND MovementItemFloat.DescId IN (zc_MIFloat_PartnerCount()
                                                    , zc_MIFloat_Summ()
                                                    , zc_MIFloat_AmountPlan()
                                                    , zc_MIFloat_PromoTax()
                                                    , zc_MIFloat_ChangePercent()
                                                    , zc_MIFloat_PricePromo()
                                                    , zc_MIFloat_PricePromo_new()
                                                    , zc_MIFloat_PriceIn1()
                                                    , zc_MIFloat_PriceIn1_Calc()
                                                    , zc_MIFloat_ChangePrice()
                                                    ) 
                   )        
          
  , tmpMIString AS (SELECT MovementItemString.*
                    FROM MovementItemString
                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                      AND MovementItemString.DescId IN (zc_MIString_Comment()
                                                      ) 
                    ) 

  , tmpMILO AS (SELECT MovementItemLinkObject.*
                FROM MovementItemLinkObject
                WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                  AND MovementItemLinkObject.DescId IN (zc_MILinkObject_Partner()
                                                      , zc_MILinkObject_TradeMark()
                                                      , zc_MILinkObject_GoodsGroupProperty()
                                                      , zc_MILinkObject_GoodsGroupDirection()
                                                      ) 
                )

        SELECT ROW_NUMBER() OVER (ORDER BY MovementItem.Id) ::Integer AS Ord
             , MovementItem.Id                        AS Id                  --идентификатор
             , MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
             , Object_Partner.Id                      AS PartnerId
             , Object_Partner.ValueData               AS PartnerName
             , MovementItem.ObjectId                  AS GoodsId             --ИД объекта <товар>
             , Object_Goods.ObjectCode::Integer       AS GoodsCode           --код объекта  <товар>
             , Object_Goods.ValueData                 AS GoodsName           --наименование объекта <товар>
             , Object_Measure.ValueData               AS Measure             --Единица измерения   
             , Object_GoodsKind.Id                    AS GoodsKindId                 --ИД обьекта <Вид товара>
             , Object_GoodsKind.ValueData             AS GoodsKindName               --Наименование обьекта <Вид товара>
             , Object_TradeMark.Id                       AS TradeMarkId
             , Object_TradeMark.ValueData                AS TradeMark           --Торговая марка   
             , Object_GoodsGroupProperty.Id              AS GoodsGroupPropertyId
             , Object_GoodsGroupProperty.ValueData       AS GoodsGroupPropertyName
             , Object_GoodsGroupPropertyParent.Id        AS GoodsGroupPropertyId_Parent
             , Object_GoodsGroupPropertyParent.ValueData AS GoodsGroupPropertyName_Parent
             , Object_GoodsGroupDirection.Id             AS GoodsGroupDirectionId
             , Object_GoodsGroupDirection.ValueData      AS GoodsGroupDirectionName
            
             , MovementItem.Amount            ::TFloat AS Amount           
             , (MovementItem.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) ::TFloat AS Amount_weight
             , MIFloat_Summ.ValueData         ::TFloat AS Summ             
             , MIFloat_PartnerCount.ValueData ::TFloat AS PartnerCount         
             
             , MIFloat_AmountPlan.ValueData      ::TFloat AS AmountPlan
             , (MIFloat_AmountPlan.ValueData * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END) ::TFloat AS AmountPlan_weight
             , (MIFloat_AmountPlan.ValueData * COALESCE (MIFloat_PromoTax.ValueData,1))    ::TFloat AS AmountPlan_calc
             , (MIFloat_AmountPlan.ValueData * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN COALESCE (ObjectFloat_Weight.ValueData, 0) ELSE 1 END * COALESCE (MIFloat_PromoTax.ValueData,1)) ::TFloat AS AmountPlan_weight_calc

             -- сохраненная цена Прайс
             , MovementItem.PriceWithOutVAT_pr      ::TFloat    AS PriceWithOutVAT_pr
             , MovementItem.PriceWithVAT_pr         ::TFloat    AS PriceWithVAT_pr

             --текущая 
             , MovementItem.PriceWithOutVAT        ::TFloat    AS PriceWithOutVAT
             , MovementItem.PriceWithVAT           ::TFloat    AS PriceWithVAT  

             --Новая 
             , MovementItem.PriceWithOutVAT_new    ::TFloat    AS PriceWithOutVAT_new
             , MovementItem.PriceWithVAT_new       ::TFloat    AS PriceWithVAT_new  
             --c/c
             , MIFloat_PriceIn1.ValueData        ::TFloat AS PriceIn
             , MIFloat_PriceIn1_Calc.ValueData   ::TFloat AS PriceIn_calc
             , MIFloat_ChangePrice.ValueData     ::TFloat AS ChangePrice
             
             , (MIFloat_AmountPlan.ValueData * (MovementItem.PriceWithOutVAT))  ::TFloat AS SummWithOutVATPlan
             , (MIFloat_AmountPlan.ValueData * (MovementItem.PriceWithVAT))     ::TFloat AS SummWithVATPlan
             --
             , (MIFloat_AmountPlan.ValueData * (MovementItem.PriceWithOutVAT_new))  ::TFloat AS SummWithOutVATPlan_new
             , (MIFloat_AmountPlan.ValueData * (MovementItem.PriceWithVAT_new))     ::TFloat AS SummWithVATPlan_new
             
             /*, MIFloat_PriceWithOutVAT.ValueData ::TFloat AS PriceWithOutVAT
             , MIFloat_PriceWithVAT.ValueData    ::TFloat AS PriceWithVAT 
             , (MIFloat_AmountPlan.ValueData * MIFloat_PriceWithOutVAT.ValueData)  ::TFloat AS SummWithOutVATPlan
             , (MIFloat_AmountPlan.ValueData * MIFloat_PriceWithVAT.ValueData)     ::TFloat AS SummWithVATPlan
             */
             , MIFloat_PromoTax.ValueData       ::TFloat AS PromoTax
             , MIFloat_ChangePercent.ValueData  ::TFloat AS ChangePercent
             , CASE WHEN COALESCE (MIFloat_ChangePercent.ValueData,0) <> 0 THEN (MovementItem.PriceWithVAT - MovementItem.PriceWithVAT * MIFloat_ChangePercent.ValueData/ 100) ELSE CASE WHEN COALESCE (MIFloat_PricePromo.ValueData,0) <> 0 THEN MIFloat_PricePromo.ValueData ELSE MovementItem.PriceWithVAT END  END                    ::TFloat AS PricePromo
             , CASE WHEN COALESCE (MIFloat_ChangePercent.ValueData,0) <> 0 THEN (MovementItem.PriceWithVAT_new - MovementItem.PriceWithVAT_new * MIFloat_ChangePercent.ValueData/ 100) ELSE CASE WHEN COALESCE (MIFloat_PricePromo_new.ValueData,0) <> 0 THEN MIFloat_PricePromo_new.ValueData ELSE MovementItem.PriceWithVAT_new END END ::TFloat AS PricePromo_new

             , MIString_Comment.ValueData              AS Comment                     -- Примечание
             , MovementItem.isErased                   AS isErased                    -- Удален
        FROM tmpMI AS MovementItem
             LEFT JOIN tmpMIFloat AS MIFloat_PartnerCount
                                  ON MIFloat_PartnerCount.MovementItemId = MovementItem.Id
                                 AND MIFloat_PartnerCount.DescId = zc_MIFloat_PartnerCount()
             LEFT JOIN tmpMIFloat AS MIFloat_Summ
                                  ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                 AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

             LEFT JOIN tmpMIFloat AS MIFloat_AmountPlan
                                  ON MIFloat_AmountPlan.MovementItemId = MovementItem.Id
                                 AND MIFloat_AmountPlan.DescId = zc_MIFloat_AmountPlan()

             LEFT JOIN tmpMIFloat AS MIFloat_PromoTax
                                  ON MIFloat_PromoTax.MovementItemId = MovementItem.Id
                                 AND MIFloat_PromoTax.DescId = zc_MIFloat_PromoTax()
             LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                  ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                 AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
             LEFT JOIN tmpMIFloat AS MIFloat_PricePromo
                                  ON MIFloat_PricePromo.MovementItemId = MovementItem.Id
                                 AND MIFloat_PricePromo.DescId = zc_MIFloat_PricePromo()
             LEFT JOIN tmpMIFloat AS MIFloat_PricePromo_new
                                  ON MIFloat_PricePromo_new.MovementItemId = MovementItem.Id
                                 AND MIFloat_PricePromo_new.DescId = zc_MIFloat_PricePromo_new()

             LEFT JOIN tmpMIFloat AS MIFloat_PriceIn1
                                  ON MIFloat_PriceIn1.MovementItemId = MovementItem.Id
                                 AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()
             LEFT JOIN tmpMIFloat AS MIFloat_PriceIn1_Calc
                                  ON MIFloat_PriceIn1_Calc.MovementItemId = MovementItem.Id
                                 AND MIFloat_PriceIn1_Calc.DescId = zc_MIFloat_PriceIn1_Calc()
             LEFT JOIN tmpMIFloat AS MIFloat_ChangePrice
                                  ON MIFloat_ChangePrice.MovementItemId = MovementItem.Id
                                 AND MIFloat_ChangePrice.DescId = zc_MIFloat_ChangePrice()

             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

             /*LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
             */
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MovementItem.GoodsKindId

             LEFT JOIN tmpMILO AS MILinkObject_Partner
                               ON MILinkObject_Partner.MovementItemId = MovementItem.Id
                              AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
             LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MILinkObject_Partner.ObjectId

             LEFT OUTER JOIN tmpMIString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.ID
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
             LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                  ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                   AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
             LEFT JOIN Object AS Object_Measure
                              ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

             LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                   ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                  AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
             --
             LEFT JOIN tmpMILO AS MILinkObject_TradeMark
                               ON MILinkObject_TradeMark.MovementItemId = MovementItem.Id
                              AND MILinkObject_TradeMark.DescId = zc_MILinkObject_TradeMark()  
                              AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                  ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = COALESCE (MILinkObject_TradeMark.ObjectId, ObjectLink_Goods_TradeMark.ChildObjectId)
             --
             LEFT JOIN tmpMILO AS MILinkObject_GoodsGroupProperty
                               ON MILinkObject_GoodsGroupProperty.MovementItemId = MovementItem.Id
                              AND MILinkObject_GoodsGroupProperty.DescId = zc_MILinkObject_GoodsGroupProperty()  
                              AND COALESCE (MovementItem.ObjectId,0) = 0

             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupProperty
                                  ON ObjectLink_Goods_GoodsGroupProperty.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupProperty.DescId = zc_ObjectLink_Goods_GoodsGroupProperty()
             LEFT JOIN Object AS Object_GoodsGroupProperty ON Object_GoodsGroupProperty.Id = ObjectLink_Goods_GoodsGroupProperty.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_GoodsGroupProperty_Parent
                                  ON ObjectLink_GoodsGroupProperty_Parent.ObjectId = Object_GoodsGroupProperty.Id
                                 AND ObjectLink_GoodsGroupProperty_Parent.DescId = zc_ObjectLink_GoodsGroupProperty_Parent()
             LEFT JOIN Object AS Object_GoodsGroupPropertyParent ON Object_GoodsGroupPropertyParent.Id = COALESCE (ObjectLink_GoodsGroupProperty_Parent.ChildObjectId, MILinkObject_GoodsGroupProperty.ObjectId)
             --                                
             LEFT JOIN tmpMILO AS MILinkObject_GoodsGroupDirection
                               ON MILinkObject_GoodsGroupDirection.MovementItemId = MovementItem.Id
                              AND MILinkObject_GoodsGroupDirection.DescId = zc_MILinkObject_GoodsGroupDirection() 
                              AND COALESCE (MovementItem.ObjectId,0) = 0
             LEFT JOIN ObjectLink AS ObjectLink_Goods_GoodsGroupDirection
                                  ON ObjectLink_Goods_GoodsGroupDirection.ObjectId = MovementItem.ObjectId
                                 AND ObjectLink_Goods_GoodsGroupDirection.DescId = zc_ObjectLink_Goods_GoodsGroupDirection()
             LEFT JOIN Object AS Object_GoodsGroupDirection ON Object_GoodsGroupDirection.Id = COALESCE (MILinkObject_GoodsGroupDirection.ObjectId, ObjectLink_Goods_GoodsGroupDirection.ChildObjectId)


        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.08.24         *
*/
-- тест
-- SELECT * FROM gpSelect_MovementItem_PromoTradeGoods (5083159 , FALSE, zfCalc_UserAdmin());
-- select * from gpSelect_MovementItem_PromoTradeGoods(inMovementId := 30320049 , inIsErased := 'True' ,  inSession := '9457');