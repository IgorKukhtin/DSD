
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Plan_Plan(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Integer,   --подразделение 
    TVarChar   --сессия пользователя
);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Plan(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Integer,   --подразделение 
    TVarChar   --сессия пользователя
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo_Plan(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inIsPromo        Boolean,   --показать только Акции
    IN inIsTender       Boolean,   --показать только Тендеры
    IN inUnitId         Integer,   --подразделение 
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
      MovementId          Integer   --ИД документа акции
    , MovementItemId      Integer
    , InvNumber           Integer   --№ документа акции
    , UnitName            TVarChar  --Склад
    , PersonalTradeName   TVarChar  --Ответственный представитель коммерческого отдела
    , PersonalName        TVarChar  --Ответственный представитель маркетингового отдела	
    , DateStartSale       TDateTime --Дата отгрузки по акционным ценам
    , DeteFinalSale       TDateTime --Дата отгрузки по акционным ценам
    , DateStartPromo      TDateTime --Дата проведения акции
    , DateFinalPromo      TDateTime --Дата проведения акции
    , MonthPromo          TDateTime --Месяц акции
    , PartnerName         TBlob     --контрагенты
    , GoodsName           TVarChar  --Позиция
    , GoodsCode           Integer   --Код позиции
    , MeasureName         TVarChar  --единица измерения
    , GoodsKindName       TVarChar  --Вид упаковки
    , GoodsKindName_List  TVarChar  --Вид товара (справочно)
    , TradeMarkName       TVarChar  --Торговая марка
    , isPromo             Boolean   --Акция (да/нет)
    , Checked             Boolean   --Согласовано (да/нет)
    , GoodsWeight         TFloat    --Вес
    
    , AmountPlan1         TFloat -- Кол-во план отгрузки за пн.
    , AmountPlan2         TFloat -- Кол-во план отгрузки за вт.
    , AmountPlan3         TFloat -- Кол-во план отгрузки за ср.
    , AmountPlan4         TFloat -- Кол-во план отгрузки за чт.
    , AmountPlan5         TFloat -- Кол-во план отгрузки за пт.
    , AmountPlan6         TFloat -- Кол-во план отгрузки за сб.
    , AmountPlan7         TFloat -- Кол-во план отгрузки за вс.

    , AmountPlan1_Wh      TFloat -- 
    , AmountPlan2_Wh      TFloat -- 
    , AmountPlan3_Wh      TFloat -- 
    , AmountPlan4_Wh      TFloat -- 
    , AmountPlan5_Wh      TFloat -- 
    , AmountPlan6_Wh      TFloat -- 
    , AmountPlan7_Wh      TFloat -- 
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

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
            Movement_Promo.Id                 --ИД документа акции
          , MI_PromoGoods.Id                        AS MovementItemId
          , Movement_Promo.InvNumber          --№ документа акции
          , Movement_Promo.UnitName           --Склад
          , Movement_Promo.PersonalTradeName  --Ответственный представитель коммерческого отдела
          , Movement_Promo.PersonalName       --Ответственный представитель маркетингового отдела
          , Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , Movement_Promo.MonthPromo         --месяц акции

          , (SELECT STRING_AGG (DISTINCT Object_Partner.ValueData,'; ')
             FROM
                Movement AS Movement_PromoPartner
                INNER JOIN MovementItem AS MI_PromoPartner
                                        ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                       AND MI_PromoPartner.DescId     = zc_MI_Master()
                                       AND MI_PromoPartner.IsErased   = FALSE
                INNER JOIN Object AS Object_Partner ON Object_Partner.Id = MI_PromoPartner.ObjectId
                
             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            )::TBlob AS PartnerName
            
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.GoodsKindName

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
            
          , MI_PromoGoods.TradeMark
          , Movement_Promo.isPromo                 AS isPromo
          , Movement_Promo.Checked                 AS Checked

          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight
          
          , MIFloat_Plan1.ValueData                AS AmountPlan1
          , MIFloat_Plan2.ValueData                AS AmountPlan2
          , MIFloat_Plan3.ValueData                AS AmountPlan3
          , MIFloat_Plan4.ValueData                AS AmountPlan4
          , MIFloat_Plan5.ValueData                AS AmountPlan5
          , MIFloat_Plan6.ValueData                AS AmountPlan6
          , MIFloat_Plan7.ValueData                AS AmountPlan7 
          
          , (MIFloat_Plan1.ValueData  * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan1_Wh
          , (MIFloat_Plan2.ValueData  * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan2_Wh
          , (MIFloat_Plan3.ValueData  * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan3_Wh
          , (MIFloat_Plan4.ValueData  * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan4_Wh
          , (MIFloat_Plan5.ValueData  * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan5_Wh
          , (MIFloat_Plan6.ValueData  * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan6_Wh
          , (MIFloat_Plan7.ValueData  * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan7_Wh
           
        FROM Movement_Promo_View AS Movement_Promo
            LEFT OUTER JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                         ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                        AND MI_PromoGoods.IsErASed = FALSE
            LEFT JOIN MovementItemFloat AS MIFloat_Plan1
                                        ON MIFloat_Plan1.MovementItemId = MI_PromoGoods.Id 
                                       AND MIFloat_Plan1.DescId = zc_MIFloat_Plan1()
            LEFT JOIN MovementItemFloat AS MIFloat_Plan2
                                        ON MIFloat_Plan2.MovementItemId = MI_PromoGoods.Id 
                                       AND MIFloat_Plan2.DescId = zc_MIFloat_Plan2()
            LEFT JOIN MovementItemFloat AS MIFloat_Plan3
                                        ON MIFloat_Plan3.MovementItemId = MI_PromoGoods.Id 
                                       AND MIFloat_Plan3.DescId = zc_MIFloat_Plan3()
            LEFT JOIN MovementItemFloat AS MIFloat_Plan4
                                        ON MIFloat_Plan4.MovementItemId = MI_PromoGoods.Id 
                                       AND MIFloat_Plan4.DescId = zc_MIFloat_Plan4()
            LEFT JOIN MovementItemFloat AS MIFloat_Plan5
                                        ON MIFloat_Plan5.MovementItemId = MI_PromoGoods.Id 
                                       AND MIFloat_Plan5.DescId = zc_MIFloat_Plan5()
            LEFT JOIN MovementItemFloat AS MIFloat_Plan6
                                        ON MIFloat_Plan6.MovementItemId = MI_PromoGoods.Id 
                                       AND MIFloat_Plan6.DescId = zc_MIFloat_Plan6()
            LEFT JOIN MovementItemFloat AS MIFloat_Plan7
                                        ON MIFloat_Plan7.MovementItemId = MI_PromoGoods.Id 
                                       AND MIFloat_Plan7.DescId = zc_MIFloat_Plan7()                                             
                                                        
        WHERE ( Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
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

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Воробкало А.А.
 11.11.17         *
*/

-- тест
-- select * from gpSelect_Report_Promo_Plan(inStartDate := ('01.09.2016')::TDateTime , inEndDate := ('30.06.2017')::TDateTime , inIsPromo := 'True' , inIsTender := 'False' , inUnitId := 0 ,  inSession := '5');



