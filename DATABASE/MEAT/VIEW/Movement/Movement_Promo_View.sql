--

DROP VIEW IF EXISTS Movement_Promo_View;

CREATE OR REPLACE VIEW Movement_Promo_View AS 
    SELECT       
        Movement_Promo.Id                                                 --Идентификатор
      , Movement_Promo.InvNumber :: Integer         AS InvNumber          --Номер документа
      , Movement_Promo.OperDate                                           --Дата документа
      , Object_Status.Id                            AS StatusId           --ид статуса
      , Object_Status.ObjectCode                    AS StatusCode         --код статуса
      , Object_Status.ValueData                     AS StatusName         --Статус
      , MovementLinkObject_PromoKind.ObjectId       AS PromoKindId        --Вид акции
      , Object_PromoKind.ValueData                  AS PromoKindName      --Вид акции
      , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --Прайс Лист
      , Object_PriceList.ValueData                  AS PriceListName      --Прайс Лист
      , MovementDate_StartPromo.ValueData           AS StartPromo         --Дата начала акции
      , MovementDate_EndPromo.ValueData             AS EndPromo           --Дата окончания акции
      , MovementDate_StartSale.ValueData            AS StartSale          --Дата начала отгрузки по акционной цене
      , MovementDate_EndSale.ValueData              AS EndSale            --Дата окончания отгрузки по акционной цене
      , MovementDate_EndReturn.ValueData            AS EndReturn          --Дата окончания возвратов по акционной цене
      , MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала расч. продаж до акции
      , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания расч. продаж до акции
      , MovementFloat_CostPromo.ValueData           AS CostPromo          --Стоимость участия в акции
      , MovementString_Comment.ValueData            AS Comment            --Примечание
      , MovementString_CommentMain.ValueData        AS CommentMain        --Примечание (общее)
      , MovementLinkObject_Unit.ObjectId            AS UnitId             --Подразделение
      , Object_Unit.ValueData                       AS UnitName           --Подразделение
      , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --Ответственный представитель коммерческого отдела
      , Object_PersonalTrade.ValueData              AS PersonalTradeName  --Ответственный представитель коммерческого отдела
      , MovementLinkObject_Personal.ObjectId        AS PersonalId         --Ответственный представитель маркетингового отдела	
      , Object_Personal.ValueData                   AS PersonalName       --Ответственный представитель маркетингового отдела	
      , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- акция (да/нет)
      , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked  -- согласовано (да/нет)
      , DATE_TRUNC ('MONTH', MovementDate_Month.ValueData) :: TDateTime AS MonthPromo         -- месяц акции
      , MovementDate_CheckDate.ValueData            AS CheckDate          --Дата согласования

      , Object_PromoStateKind.Id                    AS PromoStateKindId        --Состояние акции
      , Object_PromoStateKind.ValueData             AS PromoStateKindName      --Состояние акции
      , COALESCE (MovementFloat_PromoStateKind.ValueData,0) ::TFloat  AS PromoStateKind  -- Приоритет для состояния
      , CASE WHEN COALESCE (MovementFloat_PromoStateKind.ValueData,0) = 1 THEN  TRUE ELSE FALSE END :: Boolean AS isPromoStateKind  -- Приоритет для состояния
      
      , CASE WHEN MovementBoolean_TaxPromo.ValueData = TRUE  THEN TRUE ELSE FALSE END :: Boolean AS isTaxPromo -- 
      , CASE WHEN MovementBoolean_TaxPromo.ValueData = FALSE THEN TRUE ELSE FALSE END :: Boolean AS isTaxPromo_Condition  --

      , Object_SignInternal.Id                      AS SignInternalId
      , Object_SignInternal.ValueData               AS SignInternalName

      , MovementFloat_ChangePercent.ValueData       AS ChangePercent      --(-)% Скидки (+)% Наценки по договору 
      , MovementDate_ServiceDate.ValueData          AS ServiceDate        --Месяц расчета с/с

      , Object_PaidKind.Id                          AS PaidKindId
      , Object_PaidKind.ValueData                   AS PaidKindName      
      , COALESCE (MovementBoolean_Cost.ValueData, FALSE)    :: Boolean AS isCOst   -- затраты (да/нет)      
    FROM Movement AS Movement_Promo 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Promo.StatusId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoKind
                                     ON MovementLinkObject_PromoKind.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_PromoKind.DescId = zc_MovementLinkObject_PromoKind()
        LEFT JOIN Object AS Object_PromoKind 
                         ON Object_PromoKind.Id = MovementLinkObject_PromoKind.ObjectId
     
        LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                     ON MovementLinkObject_PriceList.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
        LEFT JOIN Object AS Object_PriceList
                         ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId
     
        LEFT JOIN MovementDate AS MovementDate_StartPromo
                                ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                               AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                               AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                               
        LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
        LEFT JOIN MovementDate AS MovementDate_EndReturn
                               ON MovementDate_EndReturn.MovementId = Movement_Promo.Id
                              AND MovementDate_EndReturn.DescId = zc_MovementDate_EndReturn()
                               
        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement_Promo.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement_Promo.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

        LEFT JOIN MovementDate AS MovementDate_Month
                               ON MovementDate_Month.MovementId = Movement_Promo.Id
                              AND MovementDate_Month.DescId = zc_MovementDate_Month()

        LEFT JOIN MovementDate AS MovementDate_CheckDate
                               ON MovementDate_CheckDate.MovementId = Movement_Promo.Id
                              AND MovementDate_CheckDate.DescId = zc_MovementDate_Check()
 
        LEFT JOIN MovementDate AS MovementDate_ServiceDate
                               ON MovementDate_ServiceDate.MovementId = Movement_Promo.Id
                              AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()
                              
        LEFT JOIN MovementFloat AS MovementFloat_CostPromo
                                ON MovementFloat_CostPromo.MovementId = Movement_Promo.Id
                               AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()

        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId = Movement_Promo.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_Promo.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementString AS MovementString_CommentMain
                                 ON MovementString_CommentMain.MovementId = Movement_Promo.Id
                                AND MovementString_CommentMain.DescId = zc_MovementString_CommentMain()

        LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                  ON MovementBoolean_Checked.MovementId = Movement_Promo.Id
                                 AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

        LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                  ON MovementBoolean_Promo.MovementId = Movement_Promo.Id
                                 AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

        LEFT JOIN MovementBoolean AS MovementBoolean_TaxPromo
                                  ON MovementBoolean_TaxPromo.MovementId = Movement_Promo.Id
                                 AND MovementBoolean_TaxPromo.DescId = zc_MovementBoolean_TaxPromo()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                     ON MovementLinkObject_Unit.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
        LEFT JOIN Object AS Object_Unit 
                         ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                     ON MovementLinkObject_PersonalTrade.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
        LEFT JOIN Object AS Object_PersonalTrade 
                         ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                     ON MovementLinkObject_Personal.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
        LEFT JOIN Object AS Object_Personal
                         ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

        LEFT JOIN MovementFloat AS MovementFloat_PromoStateKind
                                ON MovementFloat_PromoStateKind.MovementId = Movement_Promo.Id
                               AND MovementFloat_PromoStateKind.DescId = zc_MovementFloat_PromoStateKind()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoStateKind
                                     ON MovementLinkObject_PromoStateKind.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_PromoStateKind.DescId = zc_MovementLinkObject_PromoStateKind()
        LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementLinkObject_PromoStateKind.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_SignInternal
                                     ON MovementLinkObject_SignInternal.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_SignInternal.DescId = zc_MovementLinkObject_SignInternal()
        LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id = MovementLinkObject_SignInternal.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = Movement_Promo.Id
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

        LEFT JOIN MovementBoolean AS MovementBoolean_Cost
                                  ON MovementBoolean_Cost.MovementId = Movement_Promo.Id
                                 AND MovementBoolean_Cost.DescId = zc_MovementBoolean_Cost()

    WHERE Movement_Promo.DescId = zc_Movement_Promo()
   ;

ALTER TABLE Movement_Promo_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 31.10.15                                                         * 
*/

-- тест
-- SELECT * FROM Movement_Promo_View  where id = 2641111
