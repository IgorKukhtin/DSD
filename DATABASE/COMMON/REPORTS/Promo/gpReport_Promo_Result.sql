--
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo_Result (
    IN inMovementId     Integer,   --документ акции
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     MovementId           Integer   --ИД документа акции
    ,InvNumber            Integer   --№ документа акции
    ,UnitName             TVarChar  --Склад
    ,PersonalTradeName    TVarChar  --Ответственный представитель коммерческого отдела
    ,PersonalName         TVarChar  --Ответственный представитель маркетингового отдела	
    ,DateStartSale        TDateTime --Дата отгрузки по акционным ценам
    ,DeteFinalSale        TDateTime --Дата отгрузки по акционным ценам
    ,DateStartPromo       TDateTime --Дата проведения акции
    ,DateFinalPromo       TDateTime --Дата проведения акции
    ,MonthPromo           TDateTime --Месяц акции
    ,RetailName           TBlob     --Сеть, в которой проходит акция
    ,AreaName             TBlob     --Регион
    ,GoodsName            TVarChar  --Позиция
    ,GoodsCode            Integer   --Код позиции
    ,MeasureName          TVarChar  --единица измерения
    ,TradeMarkName        TVarChar  --Торговая марка
    ,GoodsWeight          TFloat    --Вес
    ,AmountPlanMin        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMinWeight  TFloat    --Планируемый объем продаж в акционный период, кг
    ,AmountPlanMax        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMaxWeight  TFloat    --Планируемый объем продаж в акционный период, кг
    
    ,AmountReal           TFloat    --Объем продаж в аналогичный период, кг
    ,AmountRealWeight     TFloat    --Объем продаж в аналогичный период, кг Вес
    ,AmountOut            TFloat    --Кол-во реализация (факт)
    ,AmountOutWeight      TFloat    --Кол-во реализация (факт) Вес
    ,AmountIn             TFloat    --Кол-во возврат (факт)
    ,AmountInWeight       TFloat    --Кол-во возврат (факт) Вес
    ,AmountSaleWeight     TFloat    --продажи за весь период отгрузки по акционной цене за минусом возврата, в кг
    
    ,PersentResult        TFloat    --Результат, % ((продажи в акц.период/продажи в доакц пер.-1)*100)

    ,Discount             TBlob     --Скидка, %
    ,MainDiscount         TFloat    --Общая скидка для покупателя, %  (вносится вручную)
    ,PriceWithVAT         TFloat    --Отгрузочная акционная цена с учетом НДС, грн
    ,Price                TFloat    -- * Цена спецификации с НДС, грн
    ,CostPromo            TFloat    -- * Стоимость участия
    ,PriceSale            TFloat    -- * Цена на полке/скидка для покупателя
    ,PriceIn1             TFloat    --себестоимость факт,  за кг
    ,Profit_Virt          TFloat    --Виртуальная недополученная выручка по акционному объему
    ,SummReal             TFloat    --ТО (грн) до акционный период по цене спецификации
    ,SummPromo            TFloat    --ТО (грн) акционный период по акционным ценам
    ,ContractCondition    TFloat    -- Бонус сети, %
    ,Profit               TFloat    --
    ,Comment              TVarChar  --примечание
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
        SELECT
            Movement_Promo.Id                --ИД документа акции
          , Movement_Promo.InvNumber          -- * № документа акции
          , Movement_Promo.UnitName           --Склад
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalName       --* Ответственный представитель маркетингового отдела	
          , Movement_Promo.StartSale          --*Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --*Дата окончания отгрузки по акционной цене
          , Movement_Promo.StartPromo         --*Дата начала акции
          , Movement_Promo.EndPromo           --*Дата окончания акции
          , Movement_Promo.MonthPromo         --* месяц акции

          , COALESCE ((SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
                       FROM Movement AS Movement_PromoPartner
                          INNER JOIN MovementItem AS MI_PromoPartner
                                                  ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                 AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                 AND MI_PromoPartner.IsErased   = FALSE
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                                              AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId
                          
                          LEFT OUTER JOIN MovementString AS MovementString_Retail
                                                         ON MovementString_Retail.MovementId = Movement_PromoPartner.Id
                                                        AND MovementString_Retail.DescId = zc_MovementString_Retail()
                                                        AND MovementString_Retail.ValueData <> ''
                                      
                       WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                         AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                         AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                      )
            , (SELECT STRING_AGG (DISTINCT Object.ValueData,'; ')
               FROM
                  Movement AS Movement_PromoPartner
                  INNER JOIN MovementLinkObject AS MLO_Partner
                                                ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                               AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                  INNER JOIN Object ON Object.Id = MLO_Partner.ObjectId
               WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                 AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                 AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                ))                                                               ::TBlob AS RetailName             -- * торговая сеть
            --------------------------------------
          , (SELECT STRING_AGG (DISTINCT Object_Area.ValueData,'; ')
             FROM
                Movement AS Movement_PromoPartner
                INNER JOIN MovementItem AS MI_PromoPartner
                                        ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                       AND MI_PromoPartner.DescId     = zc_MI_Master()
                                       AND MI_PromoPartner.IsErased   = FALSE
                INNER JOIN ObjectLink AS ObjectLink_Partner_Area
                                      ON ObjectLink_Partner_Area.ObjectId = MI_PromoPartner.ObjectId
                                     AND ObjectLink_Partner_Area.DescId   = zc_ObjectLink_Partner_Area()
                INNER JOIN Object AS Object_Area ON Object_Area.Id = ObjectLink_Partner_Area.ChildObjectId
                
             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            )                                                                    ::TBlob AS AreaName               -- * регион
            
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.TradeMark
          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight
          
          , MI_PromoGoods.AmountPlanMin       --Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMinWeight --Минимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanMax       --Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMaxWeight --Максимум планируемого объема продаж на акционный период (в кг) Вес
          
          , MI_PromoGoods.AmountReal          --Объем продаж в аналогичный период, кг
          , MI_PromoGoods.AmountRealWeight    --Объем продаж в аналогичный период, кг Вес

          , MI_PromoGoods.AmountOut           --Кол-во реализация (факт)
          , MI_PromoGoods.AmountOutWeight     --Кол-во реализация (факт) Вес
          , MI_PromoGoods.AmountIn            --Кол-во возврат (факт)
          , MI_PromoGoods.AmountInWeight      --Кол-во возврат (факт) Вес
          , (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) :: TFloat  AS AmountSaleWeight -- продажа - возврат 
          
          , CASE WHEN (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) <> 0
                 THEN (MI_PromoGoods.AmountRealWeight/ (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) - 1) *100
                 ELSE 0
            END                    :: TFloat AS PersentResult
          
          , (REPLACE (TO_CHAR (MI_PromoGoods.Amount,'FM99990D99')||' ','. ','')||'  '||chr(13)||
              (SELECT STRING_AGG (MovementItem_PromoCondition.ConditionPromoName||': '||REPLACE (TO_CHAR (MovementItem_PromoCondition.Amount,'FM999990D09')||' ','.0 ',''), chr(13)) 
               FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition 
               WHERE MovementItem_PromoCondition.MovementId = Movement_Promo.Id
                 AND MovementItem_PromoCondition.IsErased   = FALSE))  :: TBlob   AS Discount
                 
          , 0 :: Tfloat AS MainDiscount
                 
          , MI_PromoGoods.PriceWithVAT                                            AS PriceWithVAT
          , MI_PromoGoods.Price               :: TFloat    AS Price
          , Movement_Promo.CostPromo          :: TFloat    AS CostPromo
          
          , MI_PromoGoods.PriceSale           :: TFloat    AS PriceSale

          , MIFloat_PriceIn1.ValueData        :: TFloat    AS PriceIn1               --себестоимость факт,  за кг
          , ((MI_PromoGoods.Price - MI_PromoGoods.PriceWithVAT) * (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0))) :: TFloat AS Profit_Virt
          , (MI_PromoGoods.Price * MI_PromoGoods.AmountRealWeight)                                                                    :: TFloat AS SummReal
          , (MI_PromoGoods.PriceWithVAT * (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0))) :: TFloat AS SummPromo
          , 0                                 :: TFloat    AS ContractCondition      -- Бонус сети, %
          , CASE WHEN COALESCE (MIFloat_PriceIn1.ValueData, 0) <>0
                 THEN (MI_PromoGoods.PriceWithVAT * (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)))
                    - (COALESCE (MIFloat_PriceIn1.ValueData, 0) 
                       + 0
                       + (( (MI_PromoGoods.PriceWithVAT * (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0))) * 0 /*ContractCondition*/ ) / (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) )
                       ) * (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) 
                 ELSE 0
            END                               :: TFloat    AS Profit
          , ''                                :: TVarChar  AS Comment                -- Примечание
        FROM Movement_Promo_View AS Movement_Promo
            LEFT OUTER JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                         ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                        AND MI_PromoGoods.IsErASed = FALSE
            LEFT JOIN MovementItemFloat AS MIFloat_PriceIn1
                                        ON MIFloat_PriceIn1.MovementItemId = MI_PromoGoods.Id
                                       AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()
        WHERE Movement_Promo.Id = inMovementId
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 08.08.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Report_Promo ('20150101','20160101',0,'5');

