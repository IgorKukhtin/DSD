--
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo_Result (
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inIsPromo        Boolean,   --показать только Акции
    IN inIsTender       Boolean,   --показать только Тендеры
    IN inUnitId         Integer,   --подразделение 
    IN inRetailId       Integer,   --подразделение 
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
    ,GoodsKindName          TVarChar --Наименование обьекта <Вид товара>
    ,GoodsKindCompleteName  TVarChar --Наименование обьекта <Вид товара(примечание)>
    
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
    ,AmountSale           TFloat    --продажи за весь период отгрузки по акционной цене за минусом возврата
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
    WITH 
    tmpMovement AS (SELECT DISTINCT Movement_Promo.*
                    FROM Movement_Promo_View AS Movement_Promo
                    
                         LEFT JOIN Movement AS Movement_PromoPartner 
                                             ON Movement_PromoPartner.ParentId = Movement_Promo.Id
                                            AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                                            AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                          LEFT JOIN MovementItem AS MI_PromoPartner
                                                 ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                AND MI_PromoPartner.IsErased   = FALSE
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                          INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                                               AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                                              AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                    
                    WHERE (Movement_Promo.Id = inMovementId OR inMovementId = 0)
                      AND (Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
                            OR inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale)
                      AND (Movement_Promo.UnitId = inUnitId OR inUnitId = 0)
                      AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                      AND (  (Movement_Promo.isPromo = TRUE AND inIsPromo = TRUE) 
                          OR (COALESCE (Movement_Promo.isPromo, FALSE) = FALSE AND inIsTender = TRUE)
                          OR (inIsPromo = FALSE AND inIsTender = FALSE)
                          )
                    )
  , tmpMI AS (SELECT MI_PromoGoods.*
                   , (COALESCE (MI_PromoGoods.AmountOut, 0) - COALESCE (MI_PromoGoods.AmountIn, 0))             :: TFloat  AS AmountSale       -- продажа - возврат 
                   , (COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) :: TFloat  AS AmountSaleWeight -- продажа - возврат 
                   , (COALESCE (MI_PromoGoods.Price, 0) - COALESCE (MI_PromoGoods.PriceWithVAT,0))              :: TFloat  AS Price_Diff
                   , MIFloat_PriceIn1.ValueData                                                                 :: TFloat  AS PriceIn1               --себестоимость факт,  за кг
              FROM tmpMovement AS Movement_Promo
                   LEFT JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                          ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                         AND MI_PromoGoods.IsErASed = FALSE
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceIn1
                                               ON MIFloat_PriceIn1.MovementItemId = MI_PromoGoods.Id
                                              AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()
              )
                    
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
                        ))                                                       :: TBlob AS RetailName    -- * торговая сеть
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
            )                                                                    :: TBlob AS AreaName      -- * регион
            
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.GoodsKindName
          , MI_PromoGoods.GoodsKindCompleteName
          
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
          , MI_PromoGoods.AmountSale          -- продажа - возврат 
          , MI_PromoGoods.AmountSaleWeight    -- продажа - возврат 
          
          , CAST (CASE WHEN COALESCE (MI_PromoGoods.AmountRealWeight, 0) = 0 AND MI_PromoGoods.AmountSaleWeight > 0
                            THEN 100
                       WHEN COALESCE (MI_PromoGoods.AmountRealWeight, 0) <> 0
                            THEN (MI_PromoGoods.AmountSaleWeight / MI_PromoGoods.AmountRealWeight - 1) *100
                       WHEN MI_PromoGoods.AmountSaleWeight < 0
                            THEN -100
                       ELSE 0
                  END AS NUMERIC (16, 0))     :: TFloat AS PersentResult
          
          , (CASE WHEN MI_PromoGoods.Amount <> 0
                       THEN zfConvert_FloatToString (MI_PromoGoods.Amount)
                  ELSE (SELECT STRING_AGG (zfConvert_FloatToString (MovementItem_PromoCondition.Amount)
                                 ||' - ' || MovementItem_PromoCondition.ConditionPromoName
                                        , '; ' ) 
                       FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition
                       WHERE MovementItem_PromoCondition.MovementId = Movement_Promo.Id
                         AND MovementItem_PromoCondition.IsErased   = FALSE
                         AND MovementItem_PromoCondition.Amount     <> 0
                       )
             END) :: TBlob   AS Discount
                 
          , 0                                 :: TFloat AS MainDiscount
                 
          , MI_PromoGoods.PriceWithVAT        :: TFloat
          , MI_PromoGoods.Price               :: TFloat
          , Movement_Promo.CostPromo          :: TFloat
          , MI_PromoGoods.PriceSale           :: TFloat    

          , MI_PromoGoods.PriceIn1            --себестоимость факт,  за кг
          , (MI_PromoGoods.Price_Diff * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))    :: TFloat AS Profit_Virt
          , (MI_PromoGoods.Price * COALESCE (MI_PromoGoods.AmountRealWeight, 0))         :: TFloat AS SummReal
          , (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0) ) :: TFloat AS SummPromo
          , 0                                                                            :: TFloat    AS ContractCondition      -- Бонус сети, %
          
          , CASE WHEN COALESCE (MI_PromoGoods.PriceIn1, 0) <> 0 AND COALESCE (MI_PromoGoods.AmountSaleWeight, 0) <> 0
                 THEN (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))
                    - (COALESCE (MI_PromoGoods.PriceIn1, 0) 
                       + 0
                       + (( (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))  * 0 /*ContractCondition*/ ) / COALESCE (MI_PromoGoods.AmountSaleWeight, 0))
                       ) * COALESCE (MI_PromoGoods.AmountSaleWeight, 0) 
                 ELSE 0
            END                               :: TFloat    AS Profit
          , ''                                :: TVarChar  AS Comment                -- Примечание
        FROM tmpMovement AS Movement_Promo
             LEFT JOIN tmpMI AS MI_PromoGoods ON MI_PromoGoods.MovementId = Movement_Promo.Id
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 30.11.17         *
 08.08.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Report_Promo_Result (inStartDate:= '21.09.2017', inEndDate:= '21.09.2017', inIsPromo:= TRUE, inIsTender:= FALSE, inUnitId:= 0, inRetailId:= 0, inMovementId:= 0, inSession:= zfCalc_UserAdmin());
