
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
    , UnitCode_PersonalTrade    Integer
    , UnitName_PersonalTrade    TVarChar
    , BranchCode_PersonalTrade  Integer
    , BranchName_PersonalTrade  TVarChar
    , PersonalName        TVarChar  --Ответственный представитель маркетингового отдела	
    , DateStartSale       TDateTime --Дата отгрузки по акционным ценам
    , DeteFinalSale       TDateTime --Дата отгрузки по акционным ценам
    , DateStartPromo      TDateTime --Дата проведения акции
    , DateFinalPromo      TDateTime --Дата проведения акции
    , MonthPromo          TDateTime --Месяц акции
    , RetailName          TBlob     --контрагенты
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
          
          , Object_Unit.ObjectCode              AS UnitCode_PersonalTrade
          , Object_Unit.ValueData               AS UnitName_PersonalTrade
          , Object_Branch.ObjectCode            AS BranchCode_PersonalTrade
          , Object_Branch.ValueData             AS BranchName_PersonalTrade
          
          , Movement_Promo.PersonalName       --Ответственный представитель маркетингового отдела
          , Movement_Promo.StartSale          --Дата начала отгрузки по акционной цене
          , Movement_Promo.EndSale            --Дата окончания отгрузки по акционной цене
          , Movement_Promo.StartPromo         --Дата начала акции
          , Movement_Promo.EndPromo           --Дата окончания акции
          , Movement_Promo.MonthPromo         --месяц акции

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
            , RetailName AS PartnerName
 
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
                                            

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = Movement_Promo.PersonalTradeId
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
       
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
                        
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
-- SELECT * FROM gpSelect_Report_Promo_Plan (inStartDate:= '01.09.2017', inEndDate:= '01.09.2017', inIsPromo:= True, inIsTender:= False, inUnitId:= 0, inSession:= zfCalc_UserAdmin());
