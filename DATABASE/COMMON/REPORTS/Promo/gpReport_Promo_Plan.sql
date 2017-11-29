
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
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Plan(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Integer,   --подразделение 
    Integer,   --подразделение для продаж
    TVarChar   --сессия пользователя
);
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Plan(
    TDateTime, --дата начала периода
    TDateTime, --дата окончания периода
    Boolean,   --показать только Акции
    Boolean,   --показать только Тендеры
    Boolean,   --показать склады продажи
    Integer,   --подразделение 
    Integer,   --подразделение для продаж
    TVarChar   --сессия пользователя
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo_Plan(
    IN inStartDate      TDateTime, --дата начала периода
    IN inEndDate        TDateTime, --дата окончания периода
    IN inIsPromo        Boolean,   --показать только Акции
    IN inIsTender       Boolean,   --показать только Тендеры
    IN inIsUnitSale     Boolean,   --показать склады продажи
    IN inUnitId         Integer,   --подразделение 
    IN inUnitId_Sale    Integer,   --подразделение для продаж
    IN inSession        TVarChar   --сессия пользователя
)
RETURNS TABLE(
      MovementId                Integer   --ИД документа акции
    , MovementItemId            Integer
    , InvNumber                 Integer   --№ документа акции
    , UnitName                  TVarChar  --Склад
    , UnitCode_Sale             Integer   -- код склад продажи
    , UnitName_Sale             TVarChar  -- склад продажи    
    , PersonalTradeName         TVarChar  --Ответственный представитель коммерческого отдела
    , UnitCode_PersonalTrade    Integer
    , UnitName_PersonalTrade    TVarChar
    , BranchCode_PersonalTrade  Integer
    , BranchName_PersonalTrade  TVarChar
    , PersonalName              TVarChar  --Ответственный представитель маркетингового отдела	
    , DateStartSale             TDateTime --Дата отгрузки по акционным ценам
    , DeteFinalSale             TDateTime --Дата отгрузки по акционным ценам
    , DateStartPromo            TDateTime --Дата проведения акции
    , DateFinalPromo            TDateTime --Дата проведения акции
    , MonthPromo                TDateTime --Месяц акции
    , RetailName                TBlob     --контрагенты
    , PartnerName               TBlob     --контрагенты
    , GoodsName                 TVarChar  --Позиция
    , GoodsCode                 Integer   --Код позиции
    , MeasureName               TVarChar  --единица измерения
    , GoodsKindName             TVarChar  --Вид упаковки
    , GoodsKindCompleteName     TVarChar  --Вид упаковки ( примечание)
    , GoodsKindName_Sale        TVarChar  -- список вид.уп. док.продаж
    , GoodsKindName_List        TVarChar  --Вид товара (справочно)
    , TradeMarkName             TVarChar  --Торговая марка
    , isPromo                   Boolean   --Акция (да/нет)
    , Checked                   Boolean   --Согласовано (да/нет)
    , GoodsWeight               TFloat    --Вес
    
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
     
    , AmountSale1         TFloat
    , AmountSale2         TFloat
    , AmountSale3         TFloat
    , AmountSale4         TFloat
    , AmountSale5         TFloat
    , AmountSale6         TFloat
    , AmountSale7         TFloat
          
    , isPlan1             Boolean
    , isPlan2             Boolean
    , isPlan3             Boolean
    , isPlan4             Boolean
    , isPlan5             Boolean
    , isPlan6             Boolean
    , isPlan7             Boolean

    , Color_EndDate       Integer
    , isEndDate           Boolean
    , isSale              Boolean
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
    DECLARE vbDayStart integer;
    DECLARE vbDayEnd integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);


     vbDayStart := CASE EXTRACT (DOW FROM inStartDate) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM inStartDate) END  ::integer;
     vbDayEnd   := CASE EXTRACT (DOW FROM inEndDate)   WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM inEndDate) END  ::integer;
     
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
        --продажи акционных товаров
        , tmpMov_Sale_All AS (SELECT MIFloat_PromoMovement.ValueData ::Integer                                       AS MovementId_Promo
                                   , Movement_Sale.OperDate                                                          AS OperDate
                                   , MI_Sale.ObjectId                                                                AS GoodsId
                                   , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)                                   AS GoodsKindId
                                   , SUM (COALESCE (MI_Sale.Amount, 0))                                              AS Amount
                                   , CASE WHEN inIsUnitSale = TRUE THEN MovementLinkObject_From.ObjectId ELSE 0 END  AS UnitId_Sale
                                   , MAX (Movement_Sale.OperDate) OVER (PARTITION BY MI_Sale.ObjectId, MIFloat_PromoMovement.ValueData) AS OperDateMax_Sale
                              FROM Movement AS Movement_Sale
                                   INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                 ON MovementLinkObject_From.MovementId = Movement_Sale.Id
                                                                AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                AND (MovementLinkObject_From.ObjectId = inUnitId_Sale OR inUnitId_Sale = 0)
                                   
                                   INNER JOIN MovementItem AS MI_Sale ON MI_Sale.MovementId = Movement_Sale.Id
                                                                     AND MI_Sale.IsErased = FALSE
                                  
                                   INNER JOIN MovementItemFloat AS MIFloat_PromoMovement
                                                                ON MIFloat_PromoMovement.MovementItemId = MI_Sale.Id
                                                               AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
  
                                   LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                                             ON MovementBoolean_Promo.MovementId = MIFloat_PromoMovement.ValueData ::Integer
                                                            AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()
                                                              
                                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                                    ON MILinkObject_GoodsKind.MovementItemId = MI_Sale.Id
                                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                              WHERE Movement_Sale.DescId = zc_Movement_Sale()
                                AND Movement_Sale.OperDate BETWEEN inStartDate AND inEndDate
                                AND Movement_Sale.StatusId = zc_Enum_Status_Complete()
                                AND (  (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = TRUE AND inIsPromo = TRUE) 
                                    OR (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = FALSE AND inIsTender = TRUE)
                                    OR (inIsPromo = FALSE AND inIsTender = FALSE)
                                       )

                              GROUP BY MIFloat_PromoMovement.ValueData
                                     , Movement_Sale.OperDate
                                     , MI_Sale.ObjectId
                                     , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                                     , CASE WHEN inIsUnitSale = TRUE THEN MovementLinkObject_From.ObjectId ELSE 0 END
                              )
         -- сворачиваем продажи по дням
        , tmpMovement_Sale AS (SELECT tmpSale.MovementId_Promo
                                    , tmpSale.OperDateMax_Sale
                                    , tmpSale.UnitId_Sale
                                    , tmpSale.GoodsId    
                                    , STRING_AGG (Object_GoodsKind.ValueData, '; ')  AS GoodsKindName
                                   -- , tmpSale.GoodsKindId                         AS GoodsKindId
                                   -- , COALESCE (Object_GoodsKind.ValueData, '')   AS GoodsKindName
                                    , SUM (CASE WHEN EXTRACT (DOW FROM tmpSale.OperDate) = 1 THEN tmpSale.Amount ELSE 0 END) AS AmountSale1
                                    , SUM (CASE WHEN EXTRACT (DOW FROM tmpSale.OperDate) = 2 THEN tmpSale.Amount ELSE 0 END) AS AmountSale2
                                    , SUM (CASE WHEN EXTRACT (DOW FROM tmpSale.OperDate) = 3 THEN tmpSale.Amount ELSE 0 END) AS AmountSale3
                                    , SUM (CASE WHEN EXTRACT (DOW FROM tmpSale.OperDate) = 4 THEN tmpSale.Amount ELSE 0 END) AS AmountSale4
                                    , SUM (CASE WHEN EXTRACT (DOW FROM tmpSale.OperDate) = 5 THEN tmpSale.Amount ELSE 0 END) AS AmountSale5
                                    , SUM (CASE WHEN EXTRACT (DOW FROM tmpSale.OperDate) = 6 THEN tmpSale.Amount ELSE 0 END) AS AmountSale6
                                    , SUM (CASE WHEN EXTRACT (DOW FROM tmpSale.OperDate) = 0 THEN tmpSale.Amount ELSE 0 END) AS AmountSale7
                               FROM tmpMov_Sale_All AS tmpSale
                                    LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpSale.GoodsKindId
                               GROUP BY tmpSale.MovementId_Promo
                                      , tmpSale.GoodsId
                                      , tmpSale.OperDateMax_Sale
                                      , tmpSale.UnitId_Sale
                               )

        -- документы акций
        , tmpMovement_Promo AS (SELECT Movement_Promo.*
                                     , MovementDate_StartSale.ValueData            AS StartSale
                                     , MovementDate_EndSale.ValueData              AS EndSale
                                     , MovementLinkObject_Unit.ObjectId            AS UnitId
                                     , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- акция (да/нет)
                                     , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked  -- согласовано (да/нет)
                                     
                                     , CASE WHEN MovementDate_StartSale.ValueData >= inStartDate THEN EXTRACT (DOW FROM MovementDate_StartSale.ValueData) ELSE 0 END :: Integer AS DayStartSale
                                     , CASE WHEN MovementDate_EndSale.ValueData   <= inEndDate   THEN EXTRACT (DOW FROM MovementDate_EndSale.ValueData)   ELSE 0 END :: Integer AS DayEndSale
                                FROM Movement AS Movement_Promo 
                                     LEFT JOIN MovementDate AS MovementDate_StartSale
                                                             ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                     LEFT JOIN MovementDate AS MovementDate_EndSale
                                                             ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                            AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
            
                                     LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                                               ON MovementBoolean_Checked.MovementId = Movement_Promo.Id
                                                              AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
                             
                                     LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                                               ON MovementBoolean_Promo.MovementId = Movement_Promo.Id
                                                              AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()
            
                                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                  ON MovementLinkObject_Unit.MovementId = Movement_Promo.Id
                                                                 AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                 
                                WHERE Movement_Promo.DescId = zc_Movement_Promo()
                                 AND ( ( MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                                        OR
                                        inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                                       )
                                   AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                                   AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                                   AND (  (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = TRUE AND inIsPromo = TRUE) 
                                       OR (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = FALSE AND inIsTender = TRUE)
                                       OR (inIsPromo = FALSE AND inIsTender = FALSE)
                                       )
                                      )
                               )
                               
        -- все док. акции плюс по продажам
        , tmpMov AS (SELECT tmpMovement_Promo.Id           AS MovementId_Promo
                          , tmpMovement_Promo.DayStartSale
                          , tmpMovement_Promo.DayEndSale
                          , 0                              AS UnitId_Sale
                          , TRUE                           AS isPromo 
                     FROM tmpMovement_Promo
                   UNION 
                     SELECT tmp.MovementId_Promo                        AS MovementId_Promo
                          , tmp.DayStartSale
                          , tmp.DayEndSale
                          , tmp.UnitId_Sale
                          , CASE WHEN inIsUnitSale = TRUE THEN FALSE ELSE TRUE END  AS isPromo

                     FROM (SELECT tmpMov_Sale_All.*
                                , tmp.DayStartSale
                                , tmp.DayEndSale         
                           FROM tmpMov_Sale_All
                                LEFT JOIN ( SELECT tmp.MovementId_Promo
                                                 , CASE WHEN MovementDate_StartSale.ValueData >= inStartDate THEN EXTRACT (DOW FROM MovementDate_StartSale.ValueData) ELSE 0 END :: Integer AS DayStartSale
                                                 , CASE WHEN MovementDate_EndSale.ValueData   <= inEndDate   THEN EXTRACT (DOW FROM MovementDate_EndSale.ValueData)   ELSE 0 END :: Integer AS DayEndSale     
                                            FROM (SELECT DISTINCT tmpMov_Sale_All.MovementId_Promo FROM tmpMov_Sale_All) AS tmp
                                                 LEFT JOIN MovementDate AS MovementDate_StartSale
                                                        ON MovementDate_StartSale.MovementId = tmp.MovementId_Promo
                                                       AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                                                 LEFT JOIN MovementDate AS MovementDate_EndSale
                                                        ON MovementDate_EndSale.MovementId = tmp.MovementId_Promo
                                                       AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                                            ) AS tmp ON tmp.MovementId_Promo = tmpMov_Sale_All.MovementId_Promo
                           ) AS tmp
                     )
                       
        , tmpMI_Promo AS (SELECT MI_PromoGoods.*
                               , CASE WHEN vbDayStart  = 1                   AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale = 1)                                                                        THEN MIFloat_Plan1.ValueData ELSE 0 END AS AmountPlan1
                               , CASE WHEN vbDayStart <= 2 AND vbDayEnd >= 2 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 2) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 2) THEN MIFloat_Plan2.ValueData ELSE 0 END AS AmountPlan2
                               , CASE WHEN vbDayStart <= 3 AND vbDayEnd >= 3 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 3) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 3) THEN MIFloat_Plan3.ValueData ELSE 0 END AS AmountPlan3
                               , CASE WHEN vbDayStart <= 4 AND vbDayEnd >= 4 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 4) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 4) THEN MIFloat_Plan4.ValueData ELSE 0 END AS AmountPlan4
                               , CASE WHEN vbDayStart <= 5 AND vbDayEnd >= 5 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 5) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 5) THEN MIFloat_Plan5.ValueData ELSE 0 END AS AmountPlan5
                               , CASE WHEN vbDayStart <= 6 AND vbDayEnd >= 6 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 6) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 6) THEN MIFloat_Plan6.ValueData ELSE 0 END AS AmountPlan6
                               , CASE WHEN vbDayStart <= 7 AND vbDayEnd  = 7 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 7) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale  = 7) THEN MIFloat_Plan7.ValueData ELSE 0 END AS AmountPlan7
                               
                               , CASE WHEN vbDayStart  = 1                   AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale = 1)                                                                        THEN TRUE ELSE FALSE END AS isPlan1
                               , CASE WHEN vbDayStart <= 2 AND vbDayEnd >= 2 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 2) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 2) THEN TRUE ELSE FALSE END AS isPlan2
                               , CASE WHEN vbDayStart <= 3 AND vbDayEnd >= 3 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 3) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 3) THEN TRUE ELSE FALSE END AS isPlan3
                               , CASE WHEN vbDayStart <= 4 AND vbDayEnd >= 4 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 4) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 4) THEN TRUE ELSE FALSE END AS isPlan4
                               , CASE WHEN vbDayStart <= 5 AND vbDayEnd >= 5 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 5) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 5) THEN TRUE ELSE FALSE END AS isPlan5
                               , CASE WHEN vbDayStart <= 6 AND vbDayEnd >= 6 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 6) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale >= 6) THEN TRUE ELSE FALSE END AS isPlan6
                               , CASE WHEN vbDayStart <= 7 AND vbDayEnd  = 7 AND (Movement_Promo.DayStartSale = 0 OR Movement_Promo.DayStartSale <= 7) AND (Movement_Promo.DayEndSale = 0 OR Movement_Promo.DayEndSale  = 7) THEN TRUE ELSE FALSE END AS isPlan7

                          FROM (SELECT DISTINCT tmpMov.MovementId_Promo, tmpMov.DayStartSale, tmpMov.DayEndSale FROM tmpMov) AS Movement_Promo
                               LEFT OUTER JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                                            ON MI_PromoGoods.MovementId = Movement_Promo.MovementId_Promo
                                                                           AND MI_PromoGoods.IsErased = FALSE
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
                         )

   , tmpPromoDetail AS (SELECT Movement_Promo.*
                        FROM (SELECT DISTINCT tmpMov.MovementId_Promo FROM tmpMov) AS tmpMov
                             LEFT JOIN Movement_Promo_View AS Movement_Promo ON Movement_Promo.Id = tmpMov.MovementId_Promo
                           
                        )

        --
        SELECT 
            Movement_Promo.Id                 --ИД документа акции
          , MI_PromoGoods.Id                    AS MovementItemId
          , Movement_Promo.InvNumber          --№ документа акции
          , Movement_Promo.UnitName           --Склад
          
          , Object_UnitSale.ObjectCode          AS UnitCode_Sale   -- код склад продажи
          , Object_UnitSale.ValueData           AS UnitName_Sale   -- склад продажи
          
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
                ))::TBlob AS RetailName
            , RetailName AS PartnerName
 
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.GoodsKindName
          , MI_PromoGoods.GoodsKindCompleteName
          , tmpMovement_Sale.GoodsKindName ::TVarChar AS GoodsKindName_Sale

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

          , CASE WHEN tmpMov.isPromo = TRUE THEN MI_PromoGoods.AmountPlan1 ELSE 0 END     ::TFloat  AS AmountPlan1
          , CASE WHEN tmpMov.isPromo = TRUE THEN MI_PromoGoods.AmountPlan2 ELSE 0 END     ::TFloat  AS AmountPlan2
          , CASE WHEN tmpMov.isPromo = TRUE THEN MI_PromoGoods.AmountPlan3 ELSE 0 END     ::TFloat  AS AmountPlan3
          , CASE WHEN tmpMov.isPromo = TRUE THEN MI_PromoGoods.AmountPlan4 ELSE 0 END     ::TFloat  AS AmountPlan4
          , CASE WHEN tmpMov.isPromo = TRUE THEN MI_PromoGoods.AmountPlan5 ELSE 0 END     ::TFloat  AS AmountPlan5
          , CASE WHEN tmpMov.isPromo = TRUE THEN MI_PromoGoods.AmountPlan6 ELSE 0 END     ::TFloat  AS AmountPlan6
          , CASE WHEN tmpMov.isPromo = TRUE THEN MI_PromoGoods.AmountPlan7 ELSE 0 END     ::TFloat  AS AmountPlan7
          
          , ((CASE WHEN tmpMov.isPromo = TRUE THEN 1 ELSE 0 END) * (MI_PromoGoods.AmountPlan1 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END))    ::TFloat  AS AmountPlan1_Wh
          , ((CASE WHEN tmpMov.isPromo = TRUE THEN 1 ELSE 0 END) * (MI_PromoGoods.AmountPlan2 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END))    ::TFloat  AS AmountPlan2_Wh
          , ((CASE WHEN tmpMov.isPromo = TRUE THEN 1 ELSE 0 END) * (MI_PromoGoods.AmountPlan3 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END))    ::TFloat  AS AmountPlan3_Wh
          , ((CASE WHEN tmpMov.isPromo = TRUE THEN 1 ELSE 0 END) * (MI_PromoGoods.AmountPlan4 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END))    ::TFloat  AS AmountPlan4_Wh
          , ((CASE WHEN tmpMov.isPromo = TRUE THEN 1 ELSE 0 END) * (MI_PromoGoods.AmountPlan5 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END))    ::TFloat  AS AmountPlan5_Wh
          , ((CASE WHEN tmpMov.isPromo = TRUE THEN 1 ELSE 0 END) * (MI_PromoGoods.AmountPlan6 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END))    ::TFloat  AS AmountPlan6_Wh
          , ((CASE WHEN tmpMov.isPromo = TRUE THEN 1 ELSE 0 END) * (MI_PromoGoods.AmountPlan7 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END))    ::TFloat  AS AmountPlan7_Wh
          

          , (tmpMovement_Sale.AmountSale1 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END) ::TFloat  AS AmountSale1
          , (tmpMovement_Sale.AmountSale2 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END) ::TFloat  AS AmountSale2
          , (tmpMovement_Sale.AmountSale3 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END) ::TFloat  AS AmountSale3
          , (tmpMovement_Sale.AmountSale4 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END) ::TFloat  AS AmountSale4
          , (tmpMovement_Sale.AmountSale5 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END) ::TFloat  AS AmountSale5
          , (tmpMovement_Sale.AmountSale6 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END) ::TFloat  AS AmountSale6
          , (tmpMovement_Sale.AmountSale7 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END) ::TFloat  AS AmountSale7

          , MI_PromoGoods.isPlan1         ::Boolean
          , MI_PromoGoods.isPlan2         ::Boolean
          , MI_PromoGoods.isPlan3         ::Boolean
          , MI_PromoGoods.isPlan4         ::Boolean
          , MI_PromoGoods.isPlan5         ::Boolean
          , MI_PromoGoods.isPlan6         ::Boolean
          , MI_PromoGoods.isPlan7         ::Boolean

          --если акция заканчивается в этом периоде, т.е. EndSale <= inEndDate + подсветитить красным - если факт продажи позже чем EndSale
          , CASE WHEN tmpMovement_Sale.OperDateMax_Sale > Movement_Promo.EndSale THEN zc_Color_Red()                         -- факт продажи позже чем EndSale
                 WHEN Movement_Promo.EndSale <= inEndDate THEN 16777158                                                      --голубой 16777158   16316574
                 ELSE zc_Color_White() 
            END AS Color_EndDate           
          , CASE WHEN Movement_Promo.EndSale <= inEndDate THEN TRUE ELSE FALSE END                AS isEndDate               -- если акция заканчивается в этом периоде
          , CASE WHEN tmpMovement_Sale.OperDateMax_Sale > Movement_Promo.EndSale THEN TRUE ELSE FALSE END               AS isSale                                                                                                 --если факт продажи позже чем EndSale
        FROM tmpMov
            LEFT JOIN tmpPromoDetail AS Movement_Promo ON Movement_Promo.Id = tmpMov.MovementId_Promo

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = Movement_Promo.PersonalTradeId
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId

            LEFT JOIN tmpMI_Promo AS MI_PromoGoods ON MI_PromoGoods.MovementId = Movement_Promo.Id

            LEFT JOIN tmpMovement_Sale ON tmpMovement_Sale.MovementId_Promo = tmpMov.MovementId_Promo
                                      AND tmpMovement_Sale.GoodsId = MI_PromoGoods.GoodsId 
                                      AND tmpMov.isPromo = CASE WHEN inIsUnitSale = TRUE THEN FALSE ELSE TRUE END
                                      AND tmpMovement_Sale.UnitId_Sale = tmpMov.UnitId_Sale

            LEFT JOIN Object AS Object_UnitSale ON Object_UnitSale.Id = tmpMovement_Sale.UnitId_Sale
where tmpMov.isPromo = TRUE 
   OR (tmpMov.isPromo = FALSE AND
       (tmpMovement_Sale.AmountSale1 <> 0
     OR tmpMovement_Sale.AmountSale2 <> 0
     OR tmpMovement_Sale.AmountSale3 <> 0
     OR tmpMovement_Sale.AmountSale4 <> 0
     OR tmpMovement_Sale.AmountSale5 <> 0
     OR tmpMovement_Sale.AmountSale6 <> 0
     OR tmpMovement_Sale.AmountSale7 <> 0) 
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
-- SELECT * FROM gpSelect_Report_Promo_Plan (inStartDate:= '01.09.2017', inEndDate:= '01.09.2017', inIsPromo:= True, inIsTender:= False, inUnitId:= 0, inUnitId_Sale:= 0, inSession:= zfCalc_UserAdmin());
