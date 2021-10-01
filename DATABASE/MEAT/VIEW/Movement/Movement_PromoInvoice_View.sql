--

DROP VIEW IF EXISTS Movement_PromoInvoice_View;

CREATE OR REPLACE VIEW Movement_PromoInvoice_View AS 
    SELECT       
        Movement.Id                                                 --Идентификатор
      , Movement.ParentId                                           --Ссылка на основной документ <Акции> (zc_Movement_Promo)
      , Movement.OperDate
      , Movement.Invnumber
      , MovementString_InvNumberPartner.ValueData AS InvNumberPartner
      
      , Object_BonusKind.Id                    AS BonusKindId
      , Object_BonusKind.ObjectCode            AS BonusKindCode
      , Object_BonusKind.ValueData             AS BonusKindName

      , Object_PaidKind.Id                     AS PaidKindId
      , Object_PaidKind.ObjectCode             AS PaidKindCode
      , Object_PaidKind.ValueData              AS PaidKindName

      , MovementFloat_TotalSumm.ValueData      AS TotalSumm
      , MovementString_Comment.ValueData       AS Comment

      , CASE WHEN Movement.StatusId = zc_Enum_Status_Erased()
                  THEN TRUE
             ELSE FALSE
        END                                    AS isErased           --Удален
      , Movement.StatusId                      AS StatusId           --ид статуса
      , Object_Status.ObjectCode               AS StatusCode         --код статуса
      , Object_Status.ValueData                AS StatusName         --Статус

      , Object_Insert.ValueData             AS InsertName
      , MovementDate_Insert.ValueData       AS InsertDate
      , Object_Update.ValueData             AS UpdateName
      , MovementDate_Update.ValueData       AS UpdateDate

      , Object_Contract.Id                     AS ContractId
      , Object_Contract.ObjectCode             AS ContractCode
      , Object_Contract.ValueData              AS ContractName

      , Object_Juridical.Id                    AS JuridicalId
      , Object_Juridical.ValueData             AS JuridicalName

    FROM Movement
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
    
        LEFT JOIN MovementLinkObject AS MovementLinkObject_BonusKind
                                     ON MovementLinkObject_BonusKind.MovementId = Movement.Id
                                    AND MovementLinkObject_BonusKind.DescId = zc_MovementLinkObject_BonusKind()
        LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MovementLinkObject_BonusKind.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                     ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                    AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MovementLinkObject_PaidKind.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId

        LEFT OUTER JOIN MovementString AS MovementString_InvNumberPartner
                                       ON MovementString_InvNumberPartner.MovementId = Movement.Id
                                      AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

        LEFT OUTER JOIN MovementString AS MovementString_Comment
                                       ON MovementString_Comment.MovementId = Movement.Id
                                      AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                      
        LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalSumm
                                      ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                     AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                     ON MovementLinkObject_Insert.MovementId = Movement.Id
                                    AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                     ON MovementLinkObject_Update.MovementId = Movement.Id
                                    AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

    WHERE Movement.DescId = zc_Movement_PromoInvoice()
   ;

ALTER TABLE Movement_PromoInvoice_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.09.21         *
 04.09.21         *
*/

-- тест