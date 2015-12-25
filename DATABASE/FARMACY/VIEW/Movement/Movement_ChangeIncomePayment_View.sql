DROP VIEW IF EXISTS Movement_ChangeIncomePayment_View;

CREATE OR REPLACE VIEW Movement_ChangeIncomePayment_View AS 
    SELECT
         Movement.Id                                AS Id
       , Movement.InvNumber                         AS InvNumber
       , Movement.OperDate                          AS OperDate
       , Movement.StatusId                          AS StatusId
       , Object_Status.ObjectCode                   AS StatusCode
       , Object_Status.ValueData                    AS StatusName
       , MovementFloat_TotalSumm.ValueData          AS TotalSumm
       , MovementLinkObject_From.ObjectId           AS FromId
       , Object_From.ValueData                      AS FromName
       , MovementLinkObject_Juridical.ObjectId      AS JuridicalId
       , Object_Juridical.ValueData                 AS JuridicalName
       , MovementLinkObject_ChangeIncomePaymentKind.ObjectId AS ChangeIncomePaymentKindId
       , Object_ChangeIncomePaymentKind.ValueData            AS ChangeIncomePaymentKindName
       , MovementString_Comment.ValueData          AS Comment
    FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Juridical
                                     ON MovementLinkObject_Juridical.MovementId = Movement.Id
                                    AND MovementLinkObject_Juridical.DescId = zc_MovementLinkObject_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementLinkObject_Juridical.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_ChangeIncomePaymentKind
                                     ON MovementLinkObject_ChangeIncomePaymentKind.MovementId = Movement.Id
                                    AND MovementLinkObject_ChangeIncomePaymentKind.DescId = zc_MovementLinkObject_ChangeIncomePaymentKind()

        LEFT JOIN Object AS Object_ChangeIncomePaymentKind ON Object_ChangeIncomePaymentKind.Id = MovementLinkObject_ChangeIncomePaymentKind.ObjectId
        
        LEFT JOIN MovementString AS MovementString_Comment
                                ON MovementString_Comment.MovementId =  Movement.Id
                               AND MovementString_Comment.DescId = zc_MovementString_Comment()

    WHERE 
        Movement.DescId = zc_Movement_ChangeIncomePayment();

ALTER TABLE Movement_ChangeIncomePayment_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».  ¬ÓÓ·Í‡ÎÓ ¿.¿.
 10.12.15                                                         *
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_ChangeIncomePayment_View where id = 805
