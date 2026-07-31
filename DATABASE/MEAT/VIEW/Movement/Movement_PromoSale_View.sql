--

DROP VIEW IF EXISTS Movement_PromoSale_View;

CREATE OR REPLACE VIEW Movement_PromoSale_View AS 
    SELECT       
        Movement_PromoSale.Id                                                 --Идентификатор
      , Movement_PromoSale.InvNumber :: Integer         AS InvNumber          --Номер документа
      , Movement_PromoSale.OperDate                                           --Дата документа
      , Object_Status.Id                            AS StatusId           --ид статуса
      , Object_Status.ObjectCode                    AS StatusCode         --код статуса
      , Object_Status.ValueData                     AS StatusName         --Статус
      , MovementLinkObject_PriceList.ObjectId       AS PriceListId        --Прайс Лист
      , Object_PriceList.ValueData                  AS PriceListName      --Прайс Лист
      , MovementDate_StartPromo.ValueData           AS StartPromo         --Дата начала акции
      , MovementDate_EndPromo.ValueData             AS EndPromo           --Дата окончания акции
      , MovementDate_StartSale.ValueData            AS StartSale          --Дата начала отгрузки по акционной цене
      , MovementDate_EndSale.ValueData              AS EndSale            --Дата окончания отгрузки по акционной цене
      , MovementDate_OperDateStart.ValueData        AS OperDateStart      --Дата начала расч. продаж до акции
      , MovementDate_OperDateEnd.ValueData          AS OperDateEnd        --Дата окончания расч. продаж до акции
      , MovementString_Comment.ValueData            AS Comment            --Примечание
      , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId    --Ответственный представитель коммерческого отдела
      , Object_PersonalTrade.ValueData              AS PersonalTradeName  --Ответственный представитель коммерческого отдела
      , MovementLinkObject_Personal.ObjectId        AS PersonalId         --Ответственный представитель маркетингового отдела	
      , Object_Personal.ValueData                   AS PersonalName       --Ответственный представитель маркетингового отдела	

      , MovementFloat_ChangePercent.ValueData       AS ChangePercent      --(-)% Скидки (+)% Наценки по договору 

      , Object_NotBudgPromo.Id                      AS NotBudgPromoId
      , Object_NotBudgPromo.ValueData               AS NotBudgPromoName
      , COALESCE (MovementBoolean_NotBudgPromo.ValueData, FALSE) ::Boolean AS isNotBudgPromo
    FROM Movement AS Movement_PromoSale 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PromoSale.StatusId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                     ON MovementLinkObject_PriceList.MovementId = Movement_PromoSale.Id
                                    AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
        LEFT JOIN Object AS Object_PriceList
                         ON Object_PriceList.Id = MovementLinkObject_PriceList.ObjectId
     
        LEFT JOIN MovementDate AS MovementDate_StartPromo
                                ON MovementDate_StartPromo.MovementId = Movement_PromoSale.Id
                               AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
        LEFT JOIN MovementDate AS MovementDate_EndPromo
                                ON MovementDate_EndPromo.MovementId =  Movement_PromoSale.Id
                               AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                               
        LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement_PromoSale.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement_PromoSale.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                               
        LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                ON MovementDate_OperDateStart.MovementId = Movement_PromoSale.Id
                               AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
        LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                ON MovementDate_OperDateEnd.MovementId = Movement_PromoSale.Id
                               AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()
                              
        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                ON MovementFloat_ChangePercent.MovementId = Movement_PromoSale.Id
                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement_PromoSale.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()

        LEFT JOIN MovementBoolean AS MovementBoolean_NotBudgPromo
                                  ON MovementBoolean_NotBudgPromo.MovementId = Movement_PromoSale.Id
                                 AND MovementBoolean_NotBudgPromo.DescId = zc_MovementBoolean_NotBudgPromo()
 
        LEFT JOIN MovementLinkObject AS MovementLinkObject_NotBudgPromo
                                     ON MovementLinkObject_NotBudgPromo.MovementId = Movement_PromoSale.Id
                                    AND MovementLinkObject_NotBudgPromo.DescId = zc_MovementLinkObject_NotBudgPromo()
        LEFT JOIN Object AS Object_NotBudgPromo ON Object_NotBudgPromo.Id = MovementLinkObject_NotBudgPromo.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                     ON MovementLinkObject_PersonalTrade.MovementId = Movement_PromoSale.Id
                                    AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
        LEFT JOIN Object AS Object_PersonalTrade 
                         ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                     ON MovementLinkObject_Personal.MovementId = Movement_PromoSale.Id
                                    AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
        LEFT JOIN Object AS Object_Personal
                         ON Object_Personal.Id = MovementLinkObject_Personal.ObjectId

    WHERE Movement_PromoSale.DescId = zc_Movement_PromoSale()
   ;

ALTER TABLE Movement_PromoSale_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 31.07.26         *
*/

-- тест
-- SELECT * FROM Movement_PromoSale_View  where id = 2641111
