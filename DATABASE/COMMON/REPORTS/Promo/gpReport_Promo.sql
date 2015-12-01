DROP FUNCTION IF EXISTS gpSelect_Report_Promo(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Integer,   --подразделение 
    TVarChar   --сессия пользователя
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inUnitId         Integer,   --подразделение 
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
     DateStartSale        TDateTime --Дата отгрузки по акционным ценам
    ,DeteFinalSale        TDateTime --Дата отгрузки по акционным ценам
    ,DateStartPromo       TDateTime --Дата проведения акции
    ,DateFinalPromo       TDateTime --Дата проведения акции
    ,RetailName           TBlob     --Сеть, в которой проходит акция
    ,AreaName             TBlob     --Регион
    ,GoodsName            TVarChar  --Позиция
    ,GoodsCode            Integer   --Код позиции
    ,MeasureName          TVarChar  --единица измерения
    ,TradeMarkName        TVarChar  --Торговая марка
    ,AmountPlanMin        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMinWeight  TFloat    --Планируемый объем продаж в акционный период, кг
    ,AmountPlanMax        TFloat    --Планируемый объем продаж в акционный период, шт
    ,AmountPlanMaxWeight  TFloat    --Планируемый объем продаж в акционный период, кг
    ,GoodsKindName        TVarChar  --Вид упаковки
    ,GoodsWeight          TFloat    --Вес
    ,Discount             TBlob     --Скидка, %
    ,PriceWithOutVAT      TFloat    --Отгрузочная акционная цена без учета НДС, грн
    ,PriceWithVAT         TFloat    --Отгрузочная акционная цена с учетом НДС, грн
    ,Price                TFloat    -- * Цена спецификации с НДС, грн
    ,CostPromo            TFloat    -- * Стоимость участия
    ,AdvertisingName      TBlob     -- * рекламн.поддержка
    ,OperDate             TDateTime -- * Статус внесения в базу
    ,PriceSale            TFloat    -- * Цена на полке/скидка для покупателя
    ,Comment              TVarChar  --Комментарии
    ,ShowAll              Boolean   --Показывать все данные
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
    vbUserId := inSession::Integer;
    --Вставить нормальную проверку на право отображения всех колонок
    IF vbUserId = 5
    THEN
        vbShowAll := TRUE;
    ELSE
        vbShowAll := FALSE;
    END IF;
    
    RETURN QUERY
        SELECT
            Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , (SELECT STRING_AGG(Movement_PromoPartner.Retail_Name,'; ')
             FROM (SELECT DISTINCT Movement_PromoPartner_View.Retail_Name
                   FROM Movement_PromoPartner_View
                   WHERE Movement_PromoPartner_View.ParentId = Movement_Promo.Id
                     AND COALESCE(Movement_PromoPartner_View.Retail_Name,'')<>''
                     AND Movement_PromoPartner_View.isErased = FALSE
                  ) AS Movement_PromoPartner
            )::TBlob AS RetailName
          , (SELECT STRING_AGG(Movement_PromoPartner.AreaName,'; ')
             FROM (SELECT DISTINCT Movement_PromoPartner_View.AreaName
                   FROM Movement_PromoPartner_View
                   WHERE Movement_PromoPartner_View.ParentId = Movement_Promo.Id
                     AND COALESCE(Movement_PromoPartner_View.AreaName,'')<>''
                     AND Movement_PromoPartner_View.isErased = FALSE
                  ) AS Movement_PromoPartner
            )::TBlob AS AreaName
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.AmountPlanMin    --Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMinWeight --Минимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanMax       --Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMaxWeight --Максимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.GoodsKindName    --Наименование обьекта <Вид товара>
          , MI_PromoGoods.GoodsWeight
          , (REPLACE(TO_CHAR(MI_PromoGoods.Amount,'FM99990D99')||' ','. ','')||'  '||chr(13)||
              (SELECT STRING_AGG(MovementItem_PromoCondition.ConditionPromoName||': '||REPLACE(TO_CHAR(MovementItem_PromoCondition.Amount,'FM999990D09')||' ','.0 ',''), chr(13)) 
               FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition 
               WHERE MovementItem_PromoCondition.MovementId = Movement_Promo.Id
                 AND MovementItem_PromoCondition.IsErased = FALSE))::TBlob AS Discount
          , MI_PromoGoods.PriceWithOutVAT
          , MI_PromoGoods.PriceWithVAT
          , CASE WHEN vbShowAll THEN MI_PromoGoods.Price END::TFloat AS Price
          , CASE WHEN vbShowAll THEN Movement_Promo.CostPromo END::TFloat as CostPromo
          , CASE WHEN vbShowAll THEN 
                (SELECT STRING_AGG(Movement_PromoAdvertising.AdvertisingName,'; ')
                 FROM (SELECT DISTINCT Movement_PromoAdvertising_View.AdvertisingName
                       FROM Movement_PromoAdvertising_View
                       WHERE Movement_PromoAdvertising_View.ParentId = Movement_Promo.Id
                         AND COALESCE(Movement_PromoAdvertising_View.AdvertisingName,'')<>''
                         AND Movement_PromoAdvertising_View.isErased = FALSE
                      ) AS Movement_PromoAdvertising
                ) END::TBlob AS AdvertisingName
          , CASE WHEN vbShowAll THEN Movement_Promo.OperDate END::TDateTime AS OperDate
          , CASE WHEN vbShowAll THEN MI_PromoGoods.PriceSale END::TFloat AS PriceSale
          , MI_PromoGoods.Comment
          , vbShowAll as ShowAll
        FROM
            Movement_Promo_View AS Movement_Promo
            LEFT OUTER JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                         ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                        AND MI_PromoGoods.IsErased = FALSE
        WHERE
            (
                Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
                OR
                inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale
            )
            AND
            (
                Movement_Promo.UnitId = inUnitId
                OR
                inUnitId = 0
            );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_Promo (TDateTime,TDateTime,Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 01.12.15                                                          *
*/
--Select * from gpSelect_Report_Promo('20150101','20160101',0,'5');