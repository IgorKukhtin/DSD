--
--DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result_Month (TDateTime, TDateTime, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Result_Month (TDateTime, TDateTime, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo_Result_Month (
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inIsPromo        Boolean,   --показать только Акции
    IN inIsTender       Boolean,   --показать только Тендеры
    IN inIsGoodsKind    Boolean,   -- группировать по Виду товара
    IN inIsReal         Boolean,   -- если FALSE - продажи и аналогичный период тянем из zc_MI_Detail, для TRUE - расчет по факту
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
    ,GoodsKindId          Integer  --   
    ,GoodsKindCompleteId  Integer  --
    ,GoodsKindName          TVarChar --Наименование обьекта <Вид товара>
    ,GoodsKindCompleteName  TVarChar --Наименование обьекта <Вид товара(примечание)>

    ,GoodsWeight          TFloat    --Вес
    ,AmountPlanMin        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMinWeight  TFloat    --Планируемый объем продаж в акционный период, кг
    ,AmountPlanMax        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMaxWeight  TFloat    --Планируемый объем продаж в акционный период, кг

    ,AmountReal           TFloat    --Объем продаж в аналогичный период, кг
    ,AmountRealWeight     TFloat    --Объем продаж в аналогичный период, кг Вес
    ,AmountOut_promo            TFloat    --Кол-во реализация (факт)
    ,AmountOutWeight_promo      TFloat    --Кол-во реализация (факт) Вес
    ,AmountIn_promo             TFloat    --Кол-во возврат (факт)
    ,AmountInWeight_promo       TFloat    --Кол-во возврат (факт) Вес
    ,AmountSale_promo           TFloat -- продажа - возврат
    ,AmountSaleWeight_promo     TFloat -- продажа - возврат
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
    , Month_Partner       TDateTime --месяц продажи / возврата
     -- продажа за аналогичный период
    , AmountReal_calc        TFloat
    , AmountRealWeight_calc  TFloat
    -- возврат за аналогичный период
    , AmountRetIn_calc       TFloat
    , AmountRetInWeight_calc TFloat
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


     -- временно пока ошибка
     IF vbUserId NOT IN (5, 9457) AND inIsReal = FALSE AND 1=0
     THEN
         inIsReal = TRUE;
     END IF;


   -- inMovementId := 24701865; --23542302;  --24701865;  --29288400;

    -- Результат
    RETURN QUERY
    WITH
    --выбрать все акции действующие в тек. периоде
    tmpMovement_Promo AS (SELECT DISTINCT Movement_Promo.*
                               , ObjectFloat_VATPercent.ValueData     AS VATPercent
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
                               LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                     ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                                                    AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                                                  

                               LEFT JOIN ObjectFloat AS ObjectFloat_VATPercent
                                                     ON ObjectFloat_VATPercent.ObjectId = Movement_Promo.PriceListId
                                                    AND ObjectFloat_VATPercent.DescId = zc_ObjectFloat_PriceList_VATPercent()

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
                                OR inMovementId > 0
                                ) 
                            AND (ObjectLink_Juridical_Retail.ChildObjectId = inRetailId OR inRetailId = 0)
                        )
  --период продаж док акций
  , tmpDate_list AS (SELECT tmp.Id
                          , CASE WHEN tmp.Ord_asc = 1 THEN zc_DateStart() ELSE tmp.OperDate END    AS OperDate_start
                          , CASE WHEN tmp.Ord_desc = 1 THEN zc_DateEnd() ELSE tmp.OperDate_end END AS OperDate_end 
                          , tmp.OperDate 
                     FROM (SELECT tmp.*
                                , tmp.OperDate + INTERVAL '1 Month' - INTERVAL '1 Day' AS OperDate_end
                                , ROW_NUMBER () OVER (ORDER BY tmp.OperDate ASC) AS Ord_asc
                                , ROW_NUMBER () OVER (ORDER BY tmp.OperDate DESC) AS Ord_desc 
                           FROM (SELECT tmpMov.Id
                                      , GENERATE_SERIES (DATE_TRUNC ('MONTH',tmpMov.StartSale), DATE_TRUNC ('MONTH',tmpMov.EndSale), '1 Month' :: INTERVAL) AS OperDate
                                 FROM tmpMovement_Promo AS tmpMov
                                 ) AS tmp
                           ) AS tmp
                     )

   --строки из Акции - детально - факт продажи/ возврат и за аналогичный период для inIsReal = false
  , tmpMI_Detail AS (WITH
                     tmpMI_Detail AS (SELECT MovementItem.*
                                      FROM MovementItem
                                      WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo)
                                         AND MovementItem.DescId = zc_MI_Detail()
                                         AND MovementItem.isErased = FALSE
                                         AND inIsReal = FALSE
                                      )

                   , tmpMIFloat AS (SELECT MovementItemFloat.*
                                    FROM MovementItemFloat
                                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                                      AND MovementItemFloat.DescId IN (zc_MIFloat_AmountIn()
                                                                     , zc_MIFloat_AmountReal()
                                                                     , zc_MIFloat_AmountRetIn()
                                                                     )
                                    )

                   , tmpMIDate AS (SELECT MovementItemDate.*
                                   FROM MovementItemDate
                                   WHERE MovementItemDate.MovementItemId IN (SELECT DISTINCT tmpMI_Detail.Id FROM tmpMI_Detail)
                                     AND MovementItemDate.DescId IN (zc_MIDate_OperDate()
                                                                    )
                                   )


                  SELECT MovementItem.ParentId                  AS ParentId            --
                       , MovementItem.MovementId                AS MovementId          --ИД документа <Акция>
                       , MIDate_OperDate.ValueData ::TDateTime  AS OperDate
                       , SUM (COALESCE (MovementItem.Amount,0))          ::TFloat     AS Amount
                       , SUM (COALESCE (MIFloat_AmountIn.ValueData,0))   ::TFloat     AS AmountIn
                       , SUM (COALESCE (MIFloat_AmountReal.ValueData,0)) ::TFloat     AS AmountReal
                       , SUM (COALESCE (MIFloat_AmountRetIn.ValueData,0))::TFloat     AS AmountRetIn

                  FROM tmpMI_Detail AS MovementItem
                       LEFT JOIN tmpMIFloat AS MIFloat_AmountIn
                                            ON MIFloat_AmountIn.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
                       LEFT JOIN tmpMIFloat AS MIFloat_AmountReal
                                            ON MIFloat_AmountReal.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()
                       LEFT JOIN tmpMIFloat AS MIFloat_AmountRetIn
                                            ON MIFloat_AmountRetIn.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountRetIn.DescId = zc_MIFloat_AmountRetIn()

                       LEFT JOIN tmpMIDate AS MIDate_OperDate
                                           ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                          AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
                  GROUP BY MovementItem.ParentId
                         , MovementItem.MovementId
                         , MIDate_OperDate.ValueData
                     )

   --док продаж и возвратов по акциям
  , tmpMLM_Promo AS (SELECT MovementLinkMovement.*
                          , Movement.DescId AS MovementDescId
                          , Movement.OperDate
                     FROM MovementLinkMovement
                          INNER JOIN Movement ON Movement.Id = MovementLinkMovement.MovementId
                                             AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                             AND Movement.StatusId = zc_Enum_Status_Complete()
                     WHERE MovementLinkMovement.MovementChildId IN (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo)
                       AND MovementLinkMovement.DescId IN (zc_MovementLinkMovement_Promo())
                       AND COALESCE (MovementLinkMovement.MovementChildId,0) <> 0
                       AND inIsReal = TRUE
                      )

    --все строки  со ссылкой на выбранные акции
  , tmpMIFloat_PromoMovement AS (SELECT MovementItemFloat.MovementItemId
                                      , MovementItemFloat.ValueData ::Integer AS MovementId_promo
                                 FROM MovementItemFloat
                                 WHERE MovementItemFloat.DescId = zc_MIFloat_PromoMovementId()
                                   AND MovementItemFloat.ValueData IN  (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo) --29054915
                                   AND inIsReal = TRUE
                                 )
     --только строки продаж и возвратов
   , tmpMIAll AS (SELECT MIFloat_PromoMovement.MovementId_promo
                       , MovementItem.MovementId
                       , Movement.DescId AS MovementDescId
                       , Movement.OperDate
                       , MovementItem.Id
                       , MovementItem.ObjectId
                  FROM tmpMIFloat_PromoMovement AS MIFloat_PromoMovement
                       INNER JOIN MovementItem ON MovementItem.Id = MIFloat_PromoMovement.MovementItemId
                       INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                          AND Movement.DescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn())
                                          AND Movement.StatusId = zc_Enum_Status_Complete()
                  WHERE MovementItem.Id IN (SELECT tmpMIFloat_PromoMovement.MovementItemId FROM tmpMIFloat_PromoMovement)
                    AND MovementItem.DescId = zc_MI_Master()
                    AND MovementItem.isErased = FALSE
                  )


  , tmpMIFloat_AmountPartner AS (SELECT MovementItemFloat.*
                                 FROM MovementItemFloat
                                 WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMIAll.Id FROM tmpMIAll)
                                   AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                                 )
  , tmpMILinkObject_GoodsKind AS (SELECT MovementItemLinkObject.*
                                  FROM MovementItemLinkObject
                                  WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMIAll.Id FROM tmpMIAll)
                                    AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                                 )
    --данные из продаж и возвратов
  , tmpMI_SaleReturn AS (SELECT MovementItem.MovementId_promo
                              , DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, MovementItem.OperDate)::TDateTime)  AS Month_Partner
                              , MovementItem.ObjectId                          AS GoodsId
                              , COALESCE (MILinkObject_GoodsKind.ObjectId,0)   AS GoodsKindId
                              , SUM (CASE WHEN MovementItem.MovementDescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData,0) ELSE 0 END)     AS AmountOut    --продажа
                              , SUM (CASE WHEN MovementItem.MovementDescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData,0) ELSE 0 END) AS AmountIn     --возврат
                         FROM  tmpMIAll AS MovementItem-- ON MovementItem.MovementId = Movement.Id

                               LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId = MovementItem.MovementId
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                               LEFT JOIN tmpMIFloat_AmountPartner AS MIFloat_AmountPartner
                                                                  ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id

                               LEFT JOIN tmpMILinkObject_GoodsKind AS MILinkObject_GoodsKind
                                                                   ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                         GROUP BY MovementItem.MovementId_promo
                                , DATE_TRUNC ('MONTH', COALESCE (MovementDate_OperDatePartner.ValueData, MovementItem.OperDate)::TDateTime)
                                , MovementItem.ObjectId
                                , COALESCE (MILinkObject_GoodsKind.ObjectId,0)
                         )

    --данные по товарам док. акций
  , tmpMI_1 AS (SELECT MI_PromoGoods.*
                     , CASE WHEN MI_PromoGoods.GoodsKindId > 0 THEN MI_PromoGoods.GoodsKindId ELSE MI_PromoGoods.GoodsKindCompleteId END AS GoodsKindId_find
                      --  № п/п
                     , ROW_NUMBER() OVER (PARTITION BY MI_PromoGoods.MovementId, MI_PromoGoods.GoodsId ORDER BY MI_PromoGoods.Amount DESC) AS Ord
                FROM (SELECT DISTINCT tmpMovement_Promo.Id AS Id FROM tmpMovement_Promo) AS Movement_Promo
                   LEFT JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                          ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                         AND MI_PromoGoods.IsErASed = FALSE
               )

  , tmpMIFloat_PriceIn1 AS (SELECT MovementItemFloat.*
                            FROM MovementItemFloat
                            WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_1.Id FROM tmpMI_1)
                              AND MovementItemFloat.DescId = zc_MIFloat_PriceIn1()
                            )

  , tmpObjectString_Goods_GroupNameFull AS (SELECT ObjectString.*
                                            FROM ObjectString
                                            WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpMI_1.GoodsId FROM tmpMI_1)
                                              AND ObjectString.DescId = zc_ObjectString_Goods_GroupNameFull()
                                           )
  --
  , tmpData_notFind AS (SELECT DISTINCT tmpMI_SaleReturn.GoodsId, tmpMI_SaleReturn.GoodsKindId
                        FROM tmpMI_SaleReturn
                             LEFT JOIN tmpMI_1 AS tmpData_promo
                                               ON tmpData_promo.GoodsId     = tmpMI_SaleReturn.GoodsId
                                              AND (tmpData_promo.GoodsKindId_find = tmpMI_SaleReturn.GoodsKindId OR COALESCE (tmpData_promo.GoodsKindId_find,0) = 0)
                        WHERE tmpData_promo.GoodsId IS NULL
                       )

  , tmpMI AS (-- если в продажах есть "другие" виды упаковки
               SELECT
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
                   , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindId,0) ELSE 0 END AS GoodsKindId
                   , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindCompleteId,0) ELSE 0 END AS GoodsKindCompleteId 
                   
                   , STRING_AGG (DISTINCT MI_PromoGoods.GoodsKindName, '; ')         ::TVarChar AS GoodsKindName       --Наименование обьекта <Вид товара>
                   , STRING_AGG (DISTINCT MI_PromoGoods.GoodsKindCompleteName, '; ') ::TVarChar AS GoodsKindCompleteName

                   , AVG (MI_PromoGoods.Amount) AS Amount              --% скидки на товар
                   , SUM (MI_PromoGoods.AmountReal) AS AmountReal          --Объем продаж в аналогичный период, кг
                   , SUM (MI_PromoGoods.AmountRealWeight) AS AmountRealWeight    --Объем продаж в аналогичный период, кг Вес

                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMin,0))       AS AmountPlanMin       --Минимум планируемого объема продаж на акционный период (в кг)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMinWeight,0)) AS AmountPlanMinWeight --Минимум планируемого объема продаж на акционный период (в кг) Вес
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMax,0))       AS AmountPlanMax       --Максимум планируемого объема продаж на акционный период (в кг)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMaxWeight,0)) AS AmountPlanMaxWeight --Максимум планируемого объема продаж на акционный период (в кг) Вес
                    --информативно для проверки
                   , SUM (COALESCE (MI_PromoGoods.AmountOut,0))        AS AmountOut_promo         --Кол-во реализация (факт)
                   , SUM (COALESCE (MI_PromoGoods.AmountOutWeight,0))  AS AmountOutWeight_promo   --Кол-во реализация (факт) Вес
                   , SUM (COALESCE (MI_PromoGoods.AmountIn,0))         AS AmountIn_promo          --Кол-во возврат (факт)
                   , SUM (COALESCE (MI_PromoGoods.AmountInWeight,0))   AS AmountInWeight_promo    --Кол-во возврат (факт) Вес

                   , SUM (COALESCE (MI_PromoGoods.AmountOut, 0) - COALESCE (MI_PromoGoods.AmountIn, 0))            :: TFloat  AS AmountSale_promo       -- продажа - возврат
                   , SUM(COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) :: TFloat  AS AmountSaleWeight_promo -- продажа - возврат

                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut, tmpMI_Detail.Amount, 0))       AS AmountOut
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut, tmpMI_Detail.Amount, 0)
                                   * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END
                                   )  AS AmountOutWeight   --Кол-во реализация (факт) Вес
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountIn, tmpMI_Detail.AmountIn, 0))         AS AmountIn          --Кол-во возврат (факт)
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountIn, tmpMI_Detail.AmountIn,0)
                          * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END)   AS AmountInWeight    --Кол-во возврат (факт) Вес

                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut, tmpMI_Detail.Amount, 0) - COALESCE (tmpMI_SaleReturn.AmountIn, tmpMI_Detail.AmountIn, 0))            :: TFloat  AS AmountSale       -- продажа - возврат
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut, tmpMI_Detail.Amount, 0) * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END
                        - COALESCE (tmpMI_SaleReturn.AmountIn, tmpMI_Detail.AmountIn, 0) * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END
                         ) :: TFloat  AS AmountSaleWeight -- продажа - возврат

                   , tmpDate_list.OperDate                                                                        ::TDateTime AS Month_Partner
                   ----
                   , SUM(COALESCE (MI_PromoGoods.Price, 0) - COALESCE (MI_PromoGoods.PriceWithVAT,0))              :: TFloat  AS Price_Diff

                   , AVG (COALESCE (MI_PromoGoods.MainDiscount,0))                                                 ::TFloat   AS MainDiscount
                   , MAX (MIFloat_PriceIn1.ValueData)                                                              ::TFloat   AS PriceIn1               --себестоимость факт,  за кг
                   , MAX (MI_PromoGoods.ContractCondition)                                                         ::TFloat   AS ContractCondition      -- Бонус сети, %
                   , ObjectString_Goods_GoodsGroupFull.ValueData                                                              AS GoodsGroupNameFull

                   -- продажа за аналогичный период
                   , SUM (COALESCE (tmpMI_Detail.AmountReal,0))       ::TFloat AS AmountReal_calc
                   , SUM (COALESCE (tmpMI_Detail.AmountReal,0)
                           * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END)       ::TFloat AS AmountRealWeight_calc
                   -- возврат за аналогичный период
                   , SUM (COALESCE (tmpMI_Detail.AmountRetIn,0))      ::TFloat AS AmountRetIn_calc
                   , SUM (COALESCE (tmpMI_Detail.AmountRetIn,0)
                           * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END)       ::TFloat AS AmountRetInWeight_calc

              FROM tmpDate_list
                   --подвязываем все периоды продажи  
                   LEFT JOIN tmpMI_1 AS MI_PromoGoods ON MI_PromoGoods.MovementId = tmpDate_list.Id
                   
                   JOIN tmpData_notFind ON tmpData_notFind.GoodsId = MI_PromoGoods.GoodsId
                   
                   --показываем только товары проданные за период и факт продажи возврата и менсяц по дате покупателя.
                   LEFT JOIN tmpMI_SaleReturn ON tmpMI_SaleReturn.MovementId_promo = MI_PromoGoods.MovementId
                                             AND tmpMI_SaleReturn.GoodsId = MI_PromoGoods.GoodsId
                                             AND tmpMI_SaleReturn.Month_Partner BETWEEN tmpDate_list.OperDate_start AND tmpDate_list.OperDate_end --  
                                             AND (COALESCE (tmpMI_SaleReturn.GoodsKindId,0) = COALESCE (tmpData_notFind.GoodsKindId,0))
                                             AND inIsReal = TRUE  

                   LEFT JOIN tmpMI_Detail ON tmpMI_Detail.MovementId = MI_PromoGoods.MovementId
                                                     AND tmpMI_Detail.ParentId = MI_PromoGoods.Id
                                                     AND tmpMI_Detail.OperDate BETWEEN tmpDate_list.OperDate_start AND tmpDate_list.OperDate_end  --= tmpDate_list.OperDate --
                                                     AND inIsReal = FALSE

                   LEFT JOIN tmpMIFloat_PriceIn1 AS MIFloat_PriceIn1
                                                 ON MIFloat_PriceIn1.MovementItemId = MI_PromoGoods.Id
                                                AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()

                   LEFT JOIN tmpObjectString_Goods_GroupNameFull AS ObjectString_Goods_GoodsGroupFull
                                          ON ObjectString_Goods_GoodsGroupFull.ObjectId = MI_PromoGoods.GoodsId
                                         AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
              WHERE MI_PromoGoods.Ord = 1 AND inIsReal = TRUE
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
                     , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindId,0) ELSE 0 END
                     , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindCompleteId,0) ELSE 0 END
                     , CASE WHEN inIsGoodsKind = FALSE THEN MI_PromoGoods.GoodsKindName ELSE '' END
                     , CASE WHEN inIsGoodsKind = FALSE THEN MI_PromoGoods.GoodsKindCompleteName ELSE '' END
                     , ObjectString_Goods_GoodsGroupFull.ValueData
                     , tmpDate_list.OperDate
          UNION ALL 
              -- если в продажах "такие же" виды упаковки
              SELECT
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
                   , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindId,0) ELSE 0 END AS GoodsKindId
                   , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindCompleteId,0) ELSE 0 END AS GoodsKindCompleteId 
                   
                   , STRING_AGG (DISTINCT MI_PromoGoods.GoodsKindName, '; ')         ::TVarChar AS GoodsKindName       --Наименование обьекта <Вид товара>
                   , STRING_AGG (DISTINCT MI_PromoGoods.GoodsKindCompleteName, '; ') ::TVarChar AS GoodsKindCompleteName

                   , AVG (MI_PromoGoods.Amount) AS Amount              --% скидки на товар
                   , SUM (MI_PromoGoods.AmountReal) AS AmountReal          --Объем продаж в аналогичный период, кг
                   , SUM (MI_PromoGoods.AmountRealWeight) AS AmountRealWeight    --Объем продаж в аналогичный период, кг Вес

                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMin,0))       AS AmountPlanMin       --Минимум планируемого объема продаж на акционный период (в кг)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMinWeight,0)) AS AmountPlanMinWeight --Минимум планируемого объема продаж на акционный период (в кг) Вес
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMax,0))       AS AmountPlanMax       --Максимум планируемого объема продаж на акционный период (в кг)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMaxWeight,0)) AS AmountPlanMaxWeight --Максимум планируемого объема продаж на акционный период (в кг) Вес
                    --информативно для проверки
                   , SUM (COALESCE (MI_PromoGoods.AmountOut,0))        AS AmountOut_promo         --Кол-во реализация (факт)
                   , SUM (COALESCE (MI_PromoGoods.AmountOutWeight,0))  AS AmountOutWeight_promo   --Кол-во реализация (факт) Вес
                   , SUM (COALESCE (MI_PromoGoods.AmountIn,0))         AS AmountIn_promo          --Кол-во возврат (факт)
                   , SUM (COALESCE (MI_PromoGoods.AmountInWeight,0))   AS AmountInWeight_promo    --Кол-во возврат (факт) Вес

                   , SUM (COALESCE (MI_PromoGoods.AmountOut, 0) - COALESCE (MI_PromoGoods.AmountIn, 0))            :: TFloat  AS AmountSale_promo       -- продажа - возврат
                   , SUM(COALESCE (MI_PromoGoods.AmountOutWeight, 0) - COALESCE (MI_PromoGoods.AmountInWeight, 0)) :: TFloat  AS AmountSaleWeight_promo -- продажа - возврат

                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut,tmpMI_SaleReturn1.AmountOut,tmpMI_SaleReturn2.AmountOut, tmpMI_Detail.Amount, 0))       AS AmountOut
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut,tmpMI_SaleReturn1.AmountOut,tmpMI_SaleReturn2.AmountOut, tmpMI_Detail.Amount, 0)
                                   * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END
                                   )  AS AmountOutWeight   --Кол-во реализация (факт) Вес
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountIn, tmpMI_Detail.AmountIn, 0))         AS AmountIn          --Кол-во возврат (факт)
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountIn, tmpMI_Detail.AmountIn,0)
                          * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END)   AS AmountInWeight    --Кол-во возврат (факт) Вес

                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut,tmpMI_SaleReturn1.AmountOut,tmpMI_SaleReturn2.AmountOut, tmpMI_Detail.Amount, 0) - COALESCE (tmpMI_SaleReturn.AmountIn, tmpMI_Detail.AmountIn, 0))            :: TFloat  AS AmountSale       -- продажа - возврат
                   , SUM (COALESCE (tmpMI_SaleReturn.AmountOut,tmpMI_SaleReturn1.AmountOut,tmpMI_SaleReturn2.AmountOut, tmpMI_Detail.Amount, 0) * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END
                        - COALESCE (tmpMI_SaleReturn.AmountIn, tmpMI_Detail.AmountIn, 0) * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END
                         ) :: TFloat  AS AmountSaleWeight -- продажа - возврат

                   , tmpDate_list.OperDate                                                                        ::TDateTime AS Month_Partner
                   ----
                   , SUM(COALESCE (MI_PromoGoods.Price, 0) - COALESCE (MI_PromoGoods.PriceWithVAT,0))              :: TFloat  AS Price_Diff

                   , AVG (COALESCE (MI_PromoGoods.MainDiscount,0))                                                 ::TFloat   AS MainDiscount
                   , MAX (MIFloat_PriceIn1.ValueData)                                                              ::TFloat   AS PriceIn1               --себестоимость факт,  за кг
                   , MAX (MI_PromoGoods.ContractCondition)                                                         ::TFloat   AS ContractCondition      -- Бонус сети, %
                   , ObjectString_Goods_GoodsGroupFull.ValueData                                                              AS GoodsGroupNameFull

                   -- продажа за аналогичный период
                   , SUM (COALESCE (tmpMI_Detail.AmountReal,0))       ::TFloat AS AmountReal_calc
                   , SUM (COALESCE (tmpMI_Detail.AmountReal,0)
                           * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END)       ::TFloat AS AmountRealWeight_calc
                   -- возврат за аналогичный период
                   , SUM (COALESCE (tmpMI_Detail.AmountRetIn,0))      ::TFloat AS AmountRetIn_calc
                   , SUM (COALESCE (tmpMI_Detail.AmountRetIn,0)
                           * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE 1 END)       ::TFloat AS AmountRetInWeight_calc

              FROM tmpDate_list
                   --подвязываем все периоды продажи  
                   LEFT JOIN tmpMI_1 AS MI_PromoGoods ON MI_PromoGoods.MovementId = tmpDate_list.Id
                   
                   LEFT JOIN tmpData_notFind ON tmpData_notFind.GoodsId = MI_PromoGoods.GoodsId
                                            AND (COALESCE (tmpData_notFind.GoodsKindId,0) = COALESCE (MI_PromoGoods.GoodsKindId_find,0) OR  COALESCE (MI_PromoGoods.GoodsKindId_find,0) =0) 
                   
                   --показываем только товары проданные за период и факт продажи возврата и менсяц по дате покупателя. 
                      --привязка по GoodsKindId
                   LEFT JOIN tmpMI_SaleReturn ON tmpMI_SaleReturn.MovementId_promo = MI_PromoGoods.MovementId
                                             AND tmpMI_SaleReturn.GoodsId = MI_PromoGoods.GoodsId
                                             AND tmpMI_SaleReturn.Month_Partner BETWEEN tmpDate_list.OperDate_start AND tmpDate_list.OperDate_end 
                                             AND (COALESCE (tmpMI_SaleReturn.GoodsKindId,0) = COALESCE (MI_PromoGoods.GoodsKindId,0) AND COALESCE (MI_PromoGoods.GoodsKindId,0) <> 0)
                                             --AND (COALESCE (tmpMI_SaleReturn.GoodsKindId,0) =  COALESCE (MI_PromoGoods.GoodsKindId_find,0)
                                             --     OR COALESCE (MI_PromoGoods.GoodsKindId_find,0) = 0)
                                             AND inIsReal = TRUE 
                      -- привязка по  GoodsKindCompleteId , если  GoodsKindId - пусто
                   LEFT JOIN tmpMI_SaleReturn AS tmpMI_SaleReturn1
                                              ON tmpMI_SaleReturn1.MovementId_promo = MI_PromoGoods.MovementId
                                             AND tmpMI_SaleReturn1.GoodsId = MI_PromoGoods.GoodsId
                                             AND tmpMI_SaleReturn1.Month_Partner BETWEEN tmpDate_list.OperDate_start AND tmpDate_list.OperDate_end 
                                             AND (COALESCE (tmpMI_SaleReturn1.GoodsKindId,0) = COALESCE (MI_PromoGoods.GoodsKindCompleteId,0) AND COALESCE (MI_PromoGoods.GoodsKindCompleteId,0) <> 0 AND COALESCE (MI_PromoGoods.GoodsKindId,0) = 0)
                                             --AND (COALESCE (tmpMI_SaleReturn.GoodsKindId,0) =  COALESCE (MI_PromoGoods.GoodsKindId_find,0)
                                             --     OR COALESCE (MI_PromoGoods.GoodsKindId_find,0) = 0)
                                             AND inIsReal = TRUE

                      -- привязка если GoodsKindId - пусто и если GoodsKindCompleteId - пусто 
                   LEFT JOIN tmpMI_SaleReturn AS tmpMI_SaleReturn2
                                              ON tmpMI_SaleReturn2.MovementId_promo = MI_PromoGoods.MovementId
                                             AND tmpMI_SaleReturn2.GoodsId = MI_PromoGoods.GoodsId
                                             AND tmpMI_SaleReturn2.Month_Partner BETWEEN tmpDate_list.OperDate_start AND tmpDate_list.OperDate_end 
                                             AND COALESCE (MI_PromoGoods.GoodsKindId_find,0) = 0
                                             --AND (COALESCE (tmpMI_SaleReturn.GoodsKindId,0) =  COALESCE (MI_PromoGoods.GoodsKindId_find,0)
                                             --     OR COALESCE (MI_PromoGoods.GoodsKindId_find,0) = 0)
                                             AND inIsReal = TRUE

                   LEFT JOIN tmpMI_Detail ON tmpMI_Detail.MovementId = MI_PromoGoods.MovementId
                                                     AND tmpMI_Detail.ParentId = MI_PromoGoods.Id
                                                     AND tmpMI_Detail.OperDate BETWEEN tmpDate_list.OperDate_start AND tmpDate_list.OperDate_end --tmpDate_list.OperDate --
                                                     AND inIsReal = FALSE
                   
                   LEFT JOIN tmpMIFloat_PriceIn1 AS MIFloat_PriceIn1
                                                 ON MIFloat_PriceIn1.MovementItemId = MI_PromoGoods.Id
                                                AND MIFloat_PriceIn1.DescId = zc_MIFloat_PriceIn1()

                   LEFT JOIN tmpObjectString_Goods_GroupNameFull AS ObjectString_Goods_GoodsGroupFull
                                          ON ObjectString_Goods_GoodsGroupFull.ObjectId = MI_PromoGoods.GoodsId
                                         AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
              WHERE tmpData_notFind.GoodsId IS NULL OR inIsReal = FALSE
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
                     , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindId,0) ELSE 0 END
                     , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (MI_PromoGoods.GoodsKindCompleteId,0) ELSE 0 END
                     , CASE WHEN inIsGoodsKind = FALSE THEN MI_PromoGoods.GoodsKindName ELSE '' END
                     , CASE WHEN inIsGoodsKind = FALSE THEN MI_PromoGoods.GoodsKindCompleteName ELSE '' END
                     , ObjectString_Goods_GoodsGroupFull.ValueData
                     , tmpDate_list.OperDate
              )

  --сгруппировать после Union
  , tmpMI_group AS (
               SELECT
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
                   , MI_PromoGoods.GoodsKindId         AS GoodsKindId
                   , MI_PromoGoods.GoodsKindCompleteId AS GoodsKindCompleteId 
                   
                   , MI_PromoGoods.GoodsKindName        ::TVarChar AS GoodsKindName       --Наименование обьекта <Вид товара>
                   , MI_PromoGoods.GoodsKindCompleteName::TVarChar AS GoodsKindCompleteName

                   , AVG (MI_PromoGoods.Amount)           AS Amount              --% скидки на товар
                   , SUM (MI_PromoGoods.AmountReal)       AS AmountReal          --Объем продаж в аналогичный период, кг
                   , SUM (MI_PromoGoods.AmountRealWeight) AS AmountRealWeight    --Объем продаж в аналогичный период, кг Вес

                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMin,0))       AS AmountPlanMin       --Минимум планируемого объема продаж на акционный период (в кг)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMinWeight,0)) AS AmountPlanMinWeight --Минимум планируемого объема продаж на акционный период (в кг) Вес
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMax,0))       AS AmountPlanMax       --Максимум планируемого объема продаж на акционный период (в кг)
                   , SUM (COALESCE (MI_PromoGoods.AmountPlanMaxWeight,0)) AS AmountPlanMaxWeight --Максимум планируемого объема продаж на акционный период (в кг) Вес
                    --информативно для проверки
                   , SUM (COALESCE (MI_PromoGoods.AmountOut_promo,0))        AS AmountOut_promo         --Кол-во реализация (факт)
                   , SUM (COALESCE (MI_PromoGoods.AmountOutWeight_promo,0))  AS AmountOutWeight_promo   --Кол-во реализация (факт) Вес
                   , SUM (COALESCE (MI_PromoGoods.AmountIn_promo,0))         AS AmountIn_promo          --Кол-во возврат (факт)
                   , SUM (COALESCE (MI_PromoGoods.AmountInWeight_promo,0))   AS AmountInWeight_promo    --Кол-во возврат (факт) Вес

                   , SUM (COALESCE (MI_PromoGoods.AmountSale_promo, 0) )           ::TFloat AS AmountSale_promo       -- продажа - возврат
                   , SUM(COALESCE (MI_PromoGoods.AmountSaleWeight_promo, 0))       ::TFloat AS AmountSaleWeight_promo -- продажа - возврат

                   , SUM (COALESCE (MI_PromoGoods.AmountOut, 0))                            AS AmountOut
                   , SUM (COALESCE (MI_PromoGoods.AmountOutWeight, 0))                      AS AmountOutWeight   --Кол-во реализация (факт) Вес
                   , SUM (COALESCE (MI_PromoGoods.AmountIn, 0))                             AS AmountIn          --Кол-во возврат (факт)
                   , SUM (COALESCE (MI_PromoGoods.AmountInWeight, 0))                       AS AmountInWeight    --Кол-во возврат (факт) Вес

                   , SUM (COALESCE (MI_PromoGoods.AmountSale, 0))                  ::TFloat AS AmountSale       -- продажа - возврат
                   , SUM (COALESCE (MI_PromoGoods.AmountSaleWeight, 0))            ::TFloat AS AmountSaleWeight -- продажа - возврат

                   , MI_PromoGoods.Month_Partner                                   ::TDateTime AS Month_Partner
                   ----
                   , SUM(COALESCE (MI_PromoGoods.Price_Diff, 0))                   ::TFloat AS Price_Diff

                   , AVG (COALESCE (MI_PromoGoods.MainDiscount,0))                 ::TFloat AS MainDiscount
                   , MAX (MI_PromoGoods.PriceIn1)                                  ::TFloat AS PriceIn1               --себестоимость факт,  за кг
                   , MAX (MI_PromoGoods.ContractCondition)                         ::TFloat AS ContractCondition      -- Бонус сети, %
                   , MI_PromoGoods.GoodsGroupNameFull                                       AS GoodsGroupNameFull

                   -- продажа за аналогичный период
                   , SUM (COALESCE (MI_PromoGoods.AmountReal_calc,0))              ::TFloat AS AmountReal_calc
                   , SUM (COALESCE (MI_PromoGoods.AmountRealWeight_calc,0))        ::TFloat AS AmountRealWeight_calc
                   -- возврат за аналогичный период
                   , SUM (COALESCE (MI_PromoGoods.AmountRetIn_calc,0))             ::TFloat AS AmountRetIn_calc
                   , SUM (COALESCE (MI_PromoGoods.AmountRetInWeight_calc,0))       ::TFloat AS AmountRetInWeight_calc

              FROM tmpMI AS MI_PromoGoods
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
                     , MI_PromoGoods.GoodsKindId
                     , MI_PromoGoods.GoodsKindCompleteId
                     , MI_PromoGoods.GoodsKindName
                     , MI_PromoGoods.GoodsKindCompleteName
                     , MI_PromoGoods.GoodsGroupNameFull
                     , MI_PromoGoods.Month_Partner
              )
               
   -- данные продаж + возвратов, в доакционный период
  , tmpSaleReturn AS (SELECT tmp.Id  AS MovementId_promo
                           , spSelect.DateMonth
                           , spSelect.GoodsId
                           , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (spSelect.GoodsKindId,0) ELSE 0 END AS GoodsKindId
                           , SUM (spSelect.AmountReal)        AS AmountReal
                           , SUM (spSelect.AmountRetIn)       AS AmountRetIn
                           , SUM (spSelect.AmountRealWeight)  AS AmountRealWeight
                           , SUM (spSelect.AmountRetInWeight) AS AmountRetInWeight
                      FROM tmpMovement_Promo AS tmp
                           INNER JOIN lpSelect_Movement_Promo_Auto (inMovementId:= tmp.Id, inUserId:= zfCalc_UserAdmin() :: Integer) AS spSelect ON 1 = 1
                      WHERE inIsReal = TRUE
                      GROUP BY tmp.Id
                             , spSelect.DateMonth
                             , spSelect.GoodsId
                             , CASE WHEN inIsGoodsKind = FALSE THEN COALESCE (spSelect.GoodsKindId,0) ELSE 0 END
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
          , COALESCE (MI_PromoGoods.GoodsKindId,0)         ::Integer AS GoodsKindId
          , COALESCE (MI_PromoGoods.GoodsKindCompleteId,0) ::Integer AS GoodsKindCompleteId
          , MI_PromoGoods.GoodsKindName
          , MI_PromoGoods.GoodsKindCompleteName

          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight

          , MI_PromoGoods.AmountPlanMin       :: TFloat --Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMinWeight  :: TFloat--Минимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanMax        :: TFloat--Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMaxWeight  :: TFloat--Максимум планируемого объема продаж на акционный период (в кг) Вес

          , MI_PromoGoods.AmountReal          :: TFloat --Объем продаж в аналогичный период, кг
          , MI_PromoGoods.AmountRealWeight    :: TFloat --Объем продаж в аналогичный период, кг Вес
          -- 4 свойства из док. акция для проверки
          , MI_PromoGoods.AmountOut_promo            :: TFloat--Кол-во реализация (факт)
          , MI_PromoGoods.AmountOutWeight_promo      :: TFloat--Кол-во реализация (факт) Вес
          , MI_PromoGoods.AmountIn_promo             :: TFloat--Кол-во возврат (факт)
          , MI_PromoGoods.AmountInWeight_promo       :: TFloat--Кол-во возврат (факт) Вес
          , MI_PromoGoods.AmountSale_promo          :: TFloat -- продажа - возврат
          , MI_PromoGoods.AmountSaleWeight_promo    :: TFloat -- продажа - возврат

          , MI_PromoGoods.AmountOut            :: TFloat--Кол-во реализация (факт)
          , MI_PromoGoods.AmountOutWeight      :: TFloat--Кол-во реализация (факт) Вес
          , MI_PromoGoods.AmountIn             :: TFloat--Кол-во возврат (факт)
          , MI_PromoGoods.AmountInWeight       :: TFloat--Кол-во возврат (факт) Вес
          , MI_PromoGoods.AmountSale          :: TFloat -- продажа - возврат
          , MI_PromoGoods.AmountSaleWeight    :: TFloat -- продажа - возврат

          , CAST (CASE WHEN COALESCE (tmpSaleReturn.AmountRealWeight, MI_PromoGoods.AmountRealWeight_calc, 0) = 0 AND MI_PromoGoods.AmountSaleWeight > 0
                            THEN 100
                       WHEN COALESCE (tmpSaleReturn.AmountRealWeight, MI_PromoGoods.AmountRealWeight_calc, 0) <> 0
                            THEN (MI_PromoGoods.AmountSaleWeight / COALESCE (tmpSaleReturn.AmountRealWeight, MI_PromoGoods.AmountRealWeight_calc, 0)) *100
                       WHEN MI_PromoGoods.AmountSaleWeight < 0
                            THEN -100
                       ELSE 0
                  END AS NUMERIC (16, 0))     :: TFloat AS PersentResult

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
          , ROUND (MI_PromoGoods.Price * ((100 + Movement_Promo.VATPercent)/100), 2) :: TFloat    AS Price       --- , MI_PromoGoods.Price               :: TFloat
          , Movement_Promo.CostPromo          :: TFloat
          , MI_PromoGoods.PriceSale           :: TFloat

          , MI_PromoGoods.PriceIn1            --себестоимость факт,  за кг
          , (MI_PromoGoods.Price_Diff * COALESCE (MI_PromoGoods.AmountSaleWeight, 0))    :: TFloat AS Profit_Virt
          , (MI_PromoGoods.Price * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (tmpSaleReturn.AmountReal, 0) ELSE COALESCE (tmpSaleReturn.AmountRealWeight, 0) END)         :: TFloat AS SummReal
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

          , MI_PromoGoods.Month_Partner ::TDateTime AS Month_Partner --Месяц продажи / возврата - по дате покупателя / аналогичный период
          -- продажа за аналогичный период
          , COALESCE (tmpSaleReturn.AmountReal, MI_PromoGoods.AmountReal_calc, 0)              ::TFloat AS AmountReal_calc
          , COALESCE (tmpSaleReturn.AmountRealWeight, MI_PromoGoods.AmountRealWeight_calc, 0)  ::TFloat AS AmountRealWeight_calc
          -- возврат за аналогичный период
          , COALESCE (tmpSaleReturn.AmountRetIn, MI_PromoGoods.AmountRetIn_calc, 0)            ::TFloat AS AmountRetIn_calc
          , COALESCE (tmpSaleReturn.AmountRetInWeight, MI_PromoGoods.AmountRetInWeight_calc, 0)::TFloat AS AmountRetInWeight_calc
        FROM tmpMovement_Promo AS Movement_Promo
            -- LEFT JOIN tmpVAT ON tmpVAT.PriceListId = Movement_Promo.PriceListId
             LEFT JOIN tmpMI_group AS MI_PromoGoods ON MI_PromoGoods.MovementId = Movement_Promo.Id

             LEFT JOIN tmpSaleReturn ON tmpSaleReturn.MovementId_promo = Movement_Promo.Id
                                    AND tmpSaleReturn.GoodsId = MI_PromoGoods.GoodsId
                                    AND COALESCE (tmpSaleReturn.GoodsKindId,0) = CASE WHEN COALESCE (MI_PromoGoods.GoodsKindId,0) > 0 THEN COALESCE (MI_PromoGoods.GoodsKindId,0) ELSE COALESCE (MI_PromoGoods.GoodsKindCompleteId,0) END
                                    AND tmpSaleReturn.DateMonth = MI_PromoGoods.Month_Partner
                                    AND inIsReal = TRUE
        WHERE COALESCE (MI_PromoGoods.AmountOut,0) <> 0 
           OR (MI_PromoGoods.Month_Partner >= DATE_TRUNC ('MONTH', Movement_Promo.StartSale) 
           AND MI_PromoGoods.Month_Partner <= Movement_Promo.EndSale)
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 17.01.25         *
 21.11.24         *
*/

-- тест
-- SELECT * FROM gpSelect_Report_Promo_Result_Month (inStartDate:= '21.09.2017', inEndDate:= '21.09.2017', inIsPromo:= TRUE, inIsTender:= FALSE, inIsGoodsKind:= true, inUnitId:= 0, inRetailId:= 0, inMovementId:= 0, inJuridicalId:= 0, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpSelect_Report_Promo_Result_Month (inStartDate:= '21.09.2024', inEndDate:= '21.09.2024', inIsPromo:= TRUE, inIsTender:= FALSE, inIsGoodsKind:= true, inUnitId:= 0, inRetailId:= 0, inMovementId:= 0, inJuridicalId:= 0, inSession:= zfCalc_UserAdmin());
-- select * from gpSelect_Report_Promo_Result_Month(inStartDate := ('01.11.2024')::TDateTime , inEndDate := ('01.11.2024')::TDateTime , inIsPromo := 'True' , inIsTender := 'False' , inisGoodsKind := 'False', inIsReal :=TRUE , inUnitId := 0 , inRetailId := 0 , inMovementId := 29054915 , inJuridicalId := 0 ,  inSession := '9457');

--select * from gpSelect_Report_Promo_Result_Month (inStartDate := ('20.01.2025')::TDateTime , inEndDate := ('20.01.2025')::TDateTime , inIsPromo := 'True' , inIsTender := 'False' , inisGoodsKind := 'False' , inisReal := 'False' , inUnitId := 0 , inRetailId := 0 , inMovementId := 30033215 , inJuridicalId := 0 ,  inSession := '9457') as tt
