
DROP FUNCTION IF EXISTS gpSelect_Report_Promo(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Integer,   --подразделение 
    TVarChar   --сессия пользователя
);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Integer,   --подразделение 
    TVarChar   --сессия пользователя
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inIsPromo        Boolean,   --показать только Акции
    IN inIsTender       Boolean,   --показать только Тендеры
    IN inUnitId         Integer,   --подразделение 
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
    ,CheckDate            TDateTime --Дата Согласования
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
    ,AmountReal           TFloat    --Объем продаж в аналогичный период, кг
    ,AmountRealWeight     TFloat    --Объем продаж в аналогичный период, кг Вес
    ,AmountOrder          TFloat    --Кол-во заявка (факт)
    ,AmountOrderWeight    TFloat    --Кол-во заявка (факт) Вес
    ,AmountOut            TFloat    --Кол-во реализация (факт)
    ,AmountOutWeight      TFloat    --Кол-во реализация (факт) Вес
    ,AmountIn             TFloat    --Кол-во возврат (факт)
    ,AmountInWeight       TFloat    --Кол-во возврат (факт) Вес
    ,GoodsKindName        TVarChar  --Вид упаковки
    ,GoodsKindCompleteName  TVarChar  --Вид упаковки ( примечание)
    ,GoodsKindName_List   TVarChar  --Вид товара (справочно)
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
    ,isPromo              Boolean   --Акция (да/нет)
    ,Checked              Boolean   --Согласовано (да/нет)
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

    -- Вставить нормальную проверку на право отображения всех колонок
    vbShowAll:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (112322, 296580, zc_Enum_Role_Admin())); -- Отдел Маркетинг + Просмотр ВСЕ (управленцы)
    
    -- таблицы для получения Вид товара (справочно) из GoodsListSale
    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList) 
            SELECT DISTINCT ObjectString_GoodsKind.ValueData AS WordList
            FROM ObjectString AS ObjectString_GoodsKind
            WHERE ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
              AND ObjectString_GoodsKind.ValueData <> '';
    
    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);
    --


    -- Результат
    RETURN QUERY
     WITH tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, Object.ValueData :: TVarChar AS GoodsKindName
                           FROM _tmpWord_Split_to 
                                LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                           GROUP BY _tmpWord_Split_to.WordList, Object.ValueData
                           )
                           
        SELECT
            Movement_Promo.Id                --ИД документа акции
          , Movement_Promo.InvNumber          --№ документа акции
          , Movement_Promo.UnitName           --Склад
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalName       --Ответственный представитель маркетингового отдела	
          , Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , Movement_Promo.MonthPromo         --месяц акции
          , Movement_Promo.CheckDate          --Дата Согласования
          -- , (SELECT STRING_AGG( DISTINCT Movement_PromoPartner.Retail_Name,'; ')
             -- FROM (SELECT DISTINCT Movement_PromoPartner_View.Retail_Name
                   -- FROM Movement_PromoPartner_View
                   -- WHERE Movement_PromoPartner_View.ParentId = Movement_Promo.Id
                     -- AND COALESCE(Movement_PromoPartner_View.Retail_Name,'')<>''
                     -- AND Movement_PromoPartner_View.isErased = FALSE
                  -- ) AS Movement_PromoPartner
            -- )::TBlob AS RetailName
            --------------------------------------
          , COALESCE ((SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
                       FROM
                          Movement AS Movement_PromoPartner
                          /*INNER JOIN MovementLinkObject AS MLO_Partner
                                                        ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                                       AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MLO_Partner.ObjectId*/
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
                ))::TBlob AS RetailName
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
            )::TBlob AS AreaName
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.AmountPlanMin       --Минимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMinWeight --Минимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountPlanMax       --Максимум планируемого объема продаж на акционный период (в кг)
          , MI_PromoGoods.AmountPlanMaxWeight --Максимум планируемого объема продаж на акционный период (в кг) Вес
          , MI_PromoGoods.AmountReal          --Объем продаж в аналогичный период, кг
          , MI_PromoGoods.AmountRealWeight    --Объем продаж в аналогичный период, кг Вес
          , MI_PromoGoods.AmountOrder         --Кол-во заявка (факт)
          , MI_PromoGoods.AmountOrderWeight   --Кол-во заявка (факт) Вес
          , MI_PromoGoods.AmountOut           --Кол-во реализация (факт)
          , MI_PromoGoods.AmountOutWeight     --Кол-во реализация (факт) Вес
          , MI_PromoGoods.AmountIn            --Кол-во возврат (факт)
          , MI_PromoGoods.AmountInWeight      --Кол-во возврат (факт) Вес
          , MI_PromoGoods.GoodsKindName       --Наименование обьекта <Вид товара>
          , MI_PromoGoods.GoodsKindCompleteName -- --Наименование обьекта <Вид товара (примечание)>
          
          , (SELECT STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName,'; ')
             FROM Movement AS Movement_PromoPartner
                INNER JOIN MovementItem AS MI_PromoPartner
                                        ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                       AND MI_PromoPartner.DescId     = zc_MI_Master()
                                       AND MI_PromoPartner.IsErased   = FALSE
                                       
                LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                     ON ObjectLink_GoodsListSale_Partner.ChildObjectId = MI_PromoPartner.ObjectId
                                    AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                     
                INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                     ON ObjectLink_GoodsListSale_Goods.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                    AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                    AND ObjectLink_GoodsListSale_Goods.ChildObjectId = MI_PromoGoods.GoodsId 
                INNER JOIN ObjectString AS ObjectString_GoodsKind
                                        ON ObjectString_GoodsKind.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                       AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
                                       
                LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = ObjectString_GoodsKind.ValueData

             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            )::TVarChar AS GoodsKindName_List
          
          
          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight
          
          , (REPLACE (TO_CHAR (MI_PromoGoods.Amount,'FM99990D99')||' ','. ','')||'  '||chr(13)||
              (SELECT STRING_AGG (MovementItem_PromoCondition.ConditionPromoName||': '||REPLACE (TO_CHAR (MovementItem_PromoCondition.Amount,'FM999990D09')||' ','.0 ',''), chr(13)) 
               FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition 
               WHERE MovementItem_PromoCondition.MovementId = Movement_Promo.Id
                 AND MovementItem_PromoCondition.IsErased   = FALSE))  :: TBlob   AS Discount
                 
          , MI_PromoGoods.PriceWithOutVAT                                         AS PriceWithOutVAT
          , MI_PromoGoods.PriceWithVAT                                            AS PriceWithVAT
          , CASE WHEN vbShowAll THEN MI_PromoGoods.Price END         :: TFloat    AS Price
          , CASE WHEN vbShowAll THEN Movement_Promo.CostPromo END    :: TFloat    AS CostPromo
          
          , CASE WHEN vbShowAll THEN 
                (SELECT STRING_AGG (Movement_PromoAdvertising.AdvertisingName,'; ')
                 FROM (SELECT DISTINCT Movement_PromoAdvertising_View.AdvertisingName
                       FROM Movement_PromoAdvertising_View
                       WHERE Movement_PromoAdvertising_View.ParentId = Movement_Promo.Id
                         AND COALESCE (Movement_PromoAdvertising_View.AdvertisingName,'') <> ''
                         AND Movement_PromoAdvertising_View.isErASed = FALSE
                      ) AS Movement_PromoAdvertising
                ) END                                                :: TBlob     AS AdvertisingName
                
          , CASE WHEN vbShowAll THEN Movement_Promo.OperDate END     :: TDateTime AS OperDate
          , CASE WHEN vbShowAll THEN MI_PromoGoods.PriceSale END     :: TFloat    AS PriceSale
          , Movement_Promo.Comment                                                AS Comment
          , vbShowAll                                                             AS ShowAll
          , Movement_Promo.isPromo                                                AS isPromo
          , Movement_Promo.Checked                                                AS Checked
        FROM
            Movement_Promo_View AS Movement_Promo
            LEFT OUTER JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                         ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                        AND MI_PromoGoods.IsErASed = FALSE
        WHERE (-- Movement_Promo.EndSale BETWEEN inStartDate AND inEndDate
                Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
                OR
                inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale
               )
           AND (Movement_Promo.UnitId = inUnitId OR inUnitId = 0)
           AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
           AND (  (Movement_Promo.isPromo = TRUE AND inIsPromo = TRUE) 
               OR (COALESCE (Movement_Promo.isPromo, FALSE) = FALSE AND inIsTender = TRUE)
               OR (inIsPromo = FALSE AND inIsTender = FALSE)
               )
               ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Report_Promo (TDateTime,TDateTime,Integer,TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 07.11.17         *
 25.07.17         *
 01.12.15                                                          *
*/

-- тест
-- SELECT * FROM gpSelect_Report_Promo (inStartDate:= '01.09.2017', inEndDate:= '01.09.2017', inIsPromo:= True, inIsTender:= False, inUnitId:= 0, inSession:= zfCalc_UserAdmin());
