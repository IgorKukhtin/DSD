--
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (TDateTime, TDateTime, Boolean, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (TDateTime, TDateTime, Boolean, Boolean, Boolean, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result (TDateTime, TDateTime, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo_Result (
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inIsPromo        Boolean,   --показать только Акции
    IN inIsTender       Boolean,   --показать только Тендеры
    IN inIsGoodsKind    Boolean,   -- группировать по Виду товара
    IN inUnitId         Integer,   --подразделение 
    IN inRetailId       Integer,   --подразделение 
    IN inMovementId     Integer,   --документ акции
    IN inJuridicalId    Integer,   --юр лицо
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     MovementId           Integer   --ИД документа акции
    ,InvNumber            Integer   --№ документа акции
    ,OperDate             TDateTime --
    ,UnitName             TVarChar  --Склад
    ,PersonalTradeName    TVarChar  --Ответственный представитель коммерческого отдела
    ,PersonalName         TVarChar  --Ответственный представитель маркетингового отдела	
    ,DateStartSale        TDateTime --Дата отгрузки по акционным ценам
    ,DeteFinalSale        TDateTime --Дата отгрузки по акционным ценам
    ,DateStartPromo       TDateTime --Дата проведения акции
    ,DateFinalPromo       TDateTime --Дата проведения акции
    ,MonthPromo           TDateTime --Месяц акции
    ,CheckDate            TDateTime --дата согласования
    ,RetailName           TBlob     --Сеть, в которой проходит акция
    ,AreaName             TBlob     --Регион
    ,JuridicalName_str    TBlob     --юр.лица
    ,GoodsName            TVarChar  --Позиция
    ,GoodsCode            Integer   --Код позиции
    ,GoodsId              Integer
    ,MeasureName          TVarChar  --единица измерения
    ,TradeMarkName        TVarChar  --Торговая марка
    ,GoodsGroupNameFull   TVarChar -- группа товара
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
    ,Discount_Condition   TBlob     --Компенсация, %
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
    ,AdvertisingName      TBlob     -- * рекламн.поддержка
    ,Comment              TVarChar  --примечание
    ,CommentMain          TVarChar  --
    , Days_Sale  Integer               --длительность дней отгрузки по акц. ценам
    , Days_Real  Integer               --длительность дней аналогичный период
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

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
                            OR inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale
                            OR inMovementId > 0
                          )
                      AND (Movement_Promo.UnitId = inUnitId OR inUnitId = 0)
                      AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                      AND (  (Movement_Promo.isPromo = TRUE AND inIsPromo = TRUE) 
                          OR (COALESCE (Movement_Promo.isPromo, FALSE) = FALSE AND inIsTender = TRUE)
                          OR (inIsPromo = FALSE AND inIsTender = FALSE)
                          )
                    )
                    
          -- Для Прайсластов определяем НДС
        , tmpVAT AS (SELECT tmp.PriceListId
                          , (SELECT tt.VATPercent FROM gpGet_Object_PriceList(tmp.PriceListId, inSession) AS tt) AS VATPercent
                     FROM (SELECT DISTINCT tmpMovement.PriceListId FROM tmpMovement) AS tmp
                     )

  , tmpMI AS (SELECT 
                     MI_PromoGoods.MovementId          --ИД документа <Акция>
                   , MI_PromoGoods.GoodsId             --Ид объекта  <товар>
                   , MI_PromoGoods.GoodsCode           --код объекта  <товар>
                   , MI_PromoGoods.GoodsName           --наименование объекта <товар>
                   , MI_PromoGoods.Measure             --Единица измерения
                   , MI_PromoGoods.MeasureId             --Единица измерения
                   , MI_PromoGoods.TradeMark           --Торговая марка

                   , MI_PromoGoods.Price               --Цена в прайсе
                   , MI_PromoGoods.PriceWithVAT        --Цена отгрузки с учетом НДС, с учетом скидки, грн
                   , MI_PromoGoods.PriceSale           --Цена на полке

                   , MI_PromoGoods.GoodsWeight -- Вес

                   , STRING_AGG (MI_PromoGoods.GoodsKindName, '; ')         ::TVarChar AS GoodsKindName       --Наименование обьекта <Вид товара>
                   , STRING_AGG (MI_PromoGoods.GoodsKindCompleteName, '; ') ::TVarChar AS GoodsKindCompleteName   

                   , AVG (MI_PromoGoods.Amount) AS Amount              --% скидки на товар             
                   , SUM (MI_PromoGoods.AmountReal) AS AmountReal          --Объем продаж в аналогичный период, кг
                   , SUM (MI_PromoGoods.AmountRealWeight) AS AmountRealWeight    --Объем продаж в аналогичный период, кг Вес
             
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMin,0))       AS AmountPlanMin       --Минимум планируемого объема продаж на акционный период (в кг)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMinWeight,0)) AS AmountPlanMinWeight --Минимум планируемого объема продаж на акционный период (в кг) Вес
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMax,0))       AS AmountPlanMax       --Максимум планируемого объема продаж на акционный период (в кг)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMaxWeight,0)) AS AmountPlanMaxWeight --Максимум планируемого объема продаж на акционный период (в кг) Вес
             
                   , SUM (COALESCE (MI_PromoGoods.AmountOut,0))        AS AmountOut         --Кол-во реализация (факт)
                   , SUM (COALESCE (MI_PromoGoods.AmountOutWeight,0))  AS AmountOutWeight   --Кол-во реализация (факт) Вес
                   , SUM (COALESCE (MI_PromoGoods.AmountIn,0))         AS AmountIn          --Кол-во возврат (факт)
                   , SUM (COALESCE (MI_PromoGoods.AmountInWeight,0))   AS AmountInWeight    --Кол-во возврат (факт) Вес
             
                   , SUM (COALESCE (MI_PromoGoods.AmountOut, 0) - COALESCE (MI_PromoGoods.AmountIn, 0))            :: TFloat  AS AmountSale       -- продажа - возврат 
                   , SUM(COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) :: TFloat  AS AmountSaleWeight -- продажа - возврат 
                   , SUM(COALESCE (MI_PromoGoods.Price, 0) - COALESCE (MI_PromoGoods.PriceWithVAT,0))              :: TFloat  AS Price_Diff
                   
                   , AVG (COALESCE (MI_PromoGoods.MainDiscount,0))                                                 ::TFloat   AS MainDiscount
                   , MAX (MIFloat_PriceIn1.ValueData)                                                              ::TFloat   AS PriceIn1               --себестоимость факт,  за кг
                   , MAX (MI_PromoGoods.ContractCondition)                                                         ::TFloat   AS ContractCondition      -- Бонус сети, %
                   , ObjectString_Goods_GoodsGroupFull.ValueData                                                              AS GoodsGroupNameFull
                   
              FROM tmpMovement AS Movement_Promo

                   LEFT JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                          ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                         AND MI_PromoGoods.IsErASed = FALSE
                   LEFT JOIN MovementItemFloat AS MIFloat_PriceIn1
                                               ON MIFloat_PriceIn1.MovementItemId = MI_PromoGoods.Id
                                              AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()

                   LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                          ON ObjectString_Goods_GoodsGroupFull.ObjectId = MI_PromoGoods.GoodsId
                                         AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
              GROUP BY MI_PromoGoods.MovementId
                   , MI_PromoGoods.GoodsId
                   , MI_PromoGoods.GoodsCode
                   , MI_PromoGoods.GoodsName
                   , MI_PromoGoods.Measure
                   , MI_PromoGoods.MeasureId
                   , MI_PromoGoods.TradeMark
                   , MI_PromoGoods.Price
                   , MI_PromoGoods.PriceWithVAT
                   , MI_PromoGoods.PriceSale
                   , MI_PromoGoods.GoodsWeight
                   , CASE WHEN inIsGoodsKind = FALSE THEN MI_PromoGoods.GoodsKindName ELSE '' END
                   , CASE WHEN inIsGoodsKind = FALSE THEN MI_PromoGoods.GoodsKindCompleteName ELSE '' END 
                   --, MIFloat_PriceIn1.ValueData
                   , ObjectString_Goods_GoodsGroupFull.ValueData
              )
                    
        SELECT
            Movement_Promo.Id                --ИД документа акции
          , Movement_Promo.InvNumber          -- * № документа акции
          , Movement_Promo.OperDate
          , Movement_Promo.UnitName           --Склад
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalName       --* Ответственный представитель маркетингового отдела	
          , Movement_Promo.StartSale          --*Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --*Дата окончания отгрузки по акционной цене
          , Movement_Promo.StartPromo         --*Дата начала акции
          , Movement_Promo.EndPromo           --*Дата окончания акции
          , Movement_Promo.MonthPromo         --* месяц акции
          , Movement_Promo.CheckDate          -- дата согласования

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

          , (SELECT STRING_AGG ( tmp.JuridicalName,'; ')
             FROM (SELECT DISTINCT Object_Juridical.ValueData AS JuridicalName
                        , CASE WHEN Object_Juridical.Id = inJuridicalId THEN 1 else 99 END AS ord
                   FROM
                      Movement AS Movement_PromoPartner

                      INNER JOIN MovementItem AS MI_PromoPartner
                                              ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                             AND MI_PromoPartner.DescId     = zc_MI_Master()
                                             AND MI_PromoPartner.IsErased   = FALSE
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                      LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                   WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                     AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                     AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                   ORDER BY CASE WHEN Object_Juridical.Id = inJuridicalId THEN 1 else 99 END 
                   ) AS tmp
            ) ::TBlob AS JuridicalName_str

          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.GoodsId
          , MI_PromoGoods.Measure
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.GoodsGroupNameFull
          , MI_PromoGoods.GoodsKindName
          , MI_PromoGoods.GoodsKindCompleteName
          
          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight
          
          , MI_PromoGoods.AmountPlanMin       :: TFloat --Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMinWeight  :: TFloat--Минимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanMax        :: TFloat--Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMaxWeight  :: TFloat--Максимум планируемого объема продаж на акционный период (в кг) Вес
          
          , MI_PromoGoods.AmountReal          :: TFloat --Объем продаж в аналогичный период, кг
          , MI_PromoGoods.AmountRealWeight    :: TFloat --Объем продаж в аналогичный период, кг Вес

          , MI_PromoGoods.AmountOut            :: TFloat--Кол-во реализация (факт)
          , MI_PromoGoods.AmountOutWeight      :: TFloat--Кол-во реализация (факт) Вес
          , MI_PromoGoods.AmountIn             :: TFloat--Кол-во возврат (факт)
          , MI_PromoGoods.AmountInWeight       :: TFloat--Кол-во возврат (факт) Вес
          , MI_PromoGoods.AmountSale          :: TFloat -- продажа - возврат 
          , MI_PromoGoods.AmountSaleWeight    :: TFloat -- продажа - возврат 
          
          , CAST (CASE WHEN COALESCE (MI_PromoGoods.AmountRealWeight, 0) = 0 AND MI_PromoGoods.AmountSaleWeight > 0
                            THEN 100
                       WHEN COALESCE (MI_PromoGoods.AmountRealWeight, 0) <> 0
                            THEN (MI_PromoGoods.AmountSaleWeight / MI_PromoGoods.AmountRealWeight - 1) *100
                       WHEN MI_PromoGoods.AmountSaleWeight < 0
                            THEN -100
                       ELSE 0
                  END AS NUMERIC (16, 0))     :: TFloat AS PersentResult
          
         /* , (CASE WHEN MI_PromoGoods.Amount <> 0
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
             */
           -- скидка
          , (CASE WHEN MI_PromoGoods.Amount <> 0
                       THEN zfConvert_FloatToString (MI_PromoGoods.Amount)
             END) :: TBlob   AS Discount

          -- компенсация
          , (SELECT STRING_AGG (zfConvert_FloatToString (MovementItem_PromoCondition.Amount)
                                 ||' - ' || MovementItem_PromoCondition.ConditionPromoName
                                        , '; ' ) 
             FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition
             WHERE MovementItem_PromoCondition.MovementId = Movement_Promo.Id
               AND MovementItem_PromoCondition.IsErased   = FALSE
               AND MovementItem_PromoCondition.Amount     <> 0
              ) :: TBlob   AS Discount_Condition
                 
          , MI_PromoGoods.MainDiscount        :: TFloat AS MainDiscount
                 
          , MI_PromoGoods.PriceWithVAT        :: TFloat
          , ROUND (MI_PromoGoods.Price * ((100 + tmpVAT.VATPercent)/100), 2) :: TFloat    AS Price       --- , MI_PromoGoods.Price               :: TFloat
          , Movement_Promo.CostPromo          :: TFloat
          , MI_PromoGoods.PriceSale           :: TFloat

          , MI_PromoGoods.PriceIn1            --себестоимость факт,  за кг
          , (MI_PromoGoods.Price_Diff * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))    :: TFloat AS Profit_Virt
          , (MI_PromoGoods.Price * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.AmountReal, 0) ELSE COALESCE (MI_PromoGoods.AmountRealWeight, 0) END)         :: TFloat AS SummReal
          , (MI_PromoGoods.PriceWithVAT * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.AmountSale, 0) ELSE COALESCE (MI_PromoGoods.AmountSaleWeight, 0) END ) :: TFloat AS SummPromo
          , MI_PromoGoods.ContractCondition                                              :: TFloat AS ContractCondition      -- Бонус сети, %
          
          , CASE WHEN COALESCE (MI_PromoGoods.PriceIn1, 0) <> 0 AND COALESCE (MI_PromoGoods.AmountSaleWeight, 0) <> 0
                 THEN (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))
                    - (COALESCE (MI_PromoGoods.PriceIn1, 0) 
                       + 0
                       + (( (MI_PromoGoods.PriceWithVAT * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))  * 0 /*ContractCondition*/ ) / COALESCE (MI_PromoGoods.AmountSaleWeight, 0))
                       ) * COALESCE (MI_PromoGoods.AmountSaleWeight, 0) 
                 ELSE 0
            END                               :: TFloat    AS Profit


          , (SELECT STRING_AGG (Movement_PromoAdvertising.AdvertisingName,'; ')
                 FROM (SELECT DISTINCT Movement_PromoAdvertising_View.AdvertisingName
                       FROM Movement_PromoAdvertising_View
                       WHERE Movement_PromoAdvertising_View.ParentId = Movement_Promo.Id
                         AND COALESCE (Movement_PromoAdvertising_View.AdvertisingName,'') <> ''
                         AND Movement_PromoAdvertising_View.isErASed = FALSE
                      ) AS Movement_PromoAdvertising
            )                                 :: TBlob     AS AdvertisingName

          , ''                                :: TVarChar  AS Comment                -- Примечание
          , ''                                :: TVarChar  AS CommentMain            -- Примечание

          , (EXTRACT (DAY from Movement_Promo.EndSale - Movement_Promo.StartSale) + 1)         ::Integer AS Days_Sale
          , (EXTRACT (DAY from Movement_Promo.OperDateEnd - Movement_Promo.OperDateStart) + 1) ::Integer AS Days_Real
        FROM tmpMovement AS Movement_Promo
             LEFT JOIN tmpVAT ON tmpVAT.PriceListId = Movement_Promo.PriceListId
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

-- SELECT * FROM gpSelect_Report_Promo_Result (inStartDate:= '21.09.2017', inEndDate:= '21.09.2017', inIsPromo:= TRUE, inIsTender:= FALSE, inIsGoodsKind:= true, inUnitId:= 0, inRetailId:= 0, inMovementId:= 0, inJuridicalId:= 0, inSession:= zfCalc_UserAdmin());
