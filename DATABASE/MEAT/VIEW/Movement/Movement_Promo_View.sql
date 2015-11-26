DROP VIEW IF EXISTS Movement_Promo_View;

CREATE OR REPLACE VIEW Movement_Promo_View AS 
    SELECT       
        Movement_Promo.Id                                                 --Идентификатор
      , Movement_Promo.InvNumber                                          --Номер документа
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
                                ON MovementDate_StartPromo.MovementId =  Movement_Promo.Id
                               AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                               AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

        LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId =  Movement_Promo.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId =  Movement_Promo.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                               
        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId =  Movement_Promo.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId =  Movement_Promo.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                               
        LEFT JOIN MovementFloat AS MovementFloat_CostPromo
                                ON MovementFloat_CostPromo.MovementId =  Movement_Promo.Id
                               AND MovementFloat_CostPromo.DescId = zc_MovementFloat_CostPromo()
        
        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId =  Movement_Promo.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementString AS MovementString_CommentMain
                                 ON MovementString_CommentMain.MovementId =  Movement_Promo.Id
                                AND MovementString_CommentMain.DescId = zc_MovementString_CommentMain()
                               
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
                         
    WHERE Movement_Promo.DescId = zc_Movement_Promo()
      AND Movement_Promo.ParentId is null;

ALTER TABLE Movement_Promo_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 31.10.15                                                         * 
*/

-- тест
-- SELECT * FROM Movement_Promo_View  where id = 805
