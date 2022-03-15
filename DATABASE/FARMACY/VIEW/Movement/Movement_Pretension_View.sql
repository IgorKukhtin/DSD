-- View: Object_Unit_View

DROP VIEW IF EXISTS Movement_Pretension_View;

CREATE OR REPLACE VIEW Movement_Pretension_View AS 
SELECT       Movement.Id                                AS Id
           , Movement.InvNumber                         AS InvNumber
           , Movement.OperDate                          AS OperDate
           , Movement.StatusId                          AS StatusId
           , Object_Status.ObjectCode                   AS StatusCode
           , Object_Status.ValueData                    AS StatusName
           , MovementFloat_TotalDeficit.ValueData       AS TotalDeficit
           , MovementFloat_TotalProficit.ValueData      AS TotalProficit
           , MovementFloat_TotalSubstandard.ValueData   AS TotalSubstandard
           , CASE WHEN Movement.StatusId <> zc_Enum_Status_Complete()
                  THEN MovementFloat_TotalSummActual.ValueData END::TFloat AS TotalSummActual
           , (COALESCE(MovementFloat_TotalSummNotActual.ValueData, 0) +
             COALESCE(CASE WHEN Movement.StatusId = zc_Enum_Status_Complete()
                           THEN MovementFloat_TotalSummActual.ValueData END, 0))::TFloat AS TotalSummNotActual
           , MovementBlob_Comment.ValueData             AS Comment
           , MovementDate_Branch.ValueData              AS BranchDate
           , MovementDate_GoodsReceipts.ValueData       AS GoodsReceiptsDate
           , MovementDate_Sent.ValueData                AS SentDate

           , MovementIncome.PriceWithVAT                AS PriceWithVAT
           , MovementLinkObject_From.ObjectId           AS FromId
           , Object_From.Name                           AS FromName
           , MovementLinkObject_To.ObjectId             AS ToId
           , Object_To.ValueData                        AS ToName
           , MovementIncome.NDSKindId                   AS NDSKindId
           , MovementIncome.NDSKindName                 AS NDSKindName
           , MovementIncome.NDS                         AS NDS
           , MLMovement_Income.MovementChildId          AS MovementIncomeId
           , MovementIncome.OperDate                    AS IncomeOperDate
           , MovementIncome.InvNumber                   AS IncomeInvNumber
           , MovementLinkObject_User.ObjectId           AS BranchUserId
           , Object_User.ValueData                      AS BranchUserName
           , MovementIncome.JuridicalId                 AS JuridicalId
           , MovementIncome.JuridicalName               AS JuridicalName
       FROM Movement 

            LEFT JOIN MovementLinkMovement AS MLMovement_Income
                                           ON MLMovement_Income.MovementId = Movement.Id
                                          AND MLMovement_Income.DescId = zc_MovementLinkMovement_Income()

            LEFT JOIN Movement_Income_View AS MovementIncome ON MovementIncome.Id = MLMovement_Income.MovementChildId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalDeficit
                                    ON MovementFloat_TotalDeficit.MovementId = Movement.Id
                                   AND MovementFloat_TotalDeficit.DescId = zc_MovementFloat_TotalDeficit()
            LEFT JOIN MovementFloat AS MovementFloat_TotalProficit
                                    ON MovementFloat_TotalProficit.MovementId = Movement.Id
                                   AND MovementFloat_TotalProficit.DescId = zc_MovementFloat_TotalProficit()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSubstandard
                                    ON MovementFloat_TotalSubstandard.MovementId = Movement.Id
                                   AND MovementFloat_TotalSubstandard.DescId = zc_MovementFloat_TotalSubstandard()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummActual
                                    ON MovementFloat_TotalSummActual.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummActual.DescId = zc_MovementFloat_TotalSummActual()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummNotActual
                                    ON MovementFloat_TotalSummNotActual.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummNotActual.DescId = zc_MovementFloat_TotalSummNotActual()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

            LEFT JOIN Object_Unit_View AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId


            LEFT JOIN MovementDate    AS MovementDate_Branch
                                      ON MovementDate_Branch.MovementId =  Movement.Id
                                     AND MovementDate_Branch.DescId = zc_MovementDate_Branch()
            LEFT JOIN MovementDate    AS MovementDate_GoodsReceipts
                                      ON MovementDate_GoodsReceipts.MovementId =  Movement.Id
                                     AND MovementDate_GoodsReceipts.DescId = zc_MovementDate_GoodsReceipts()
            LEFT JOIN MovementDate    AS MovementDate_Sent
                                      ON MovementDate_Sent.MovementId =  Movement.Id
                                     AND MovementDate_Sent.DescId = zc_MovementDate_Sent()

            LEFT JOIN MovementBlob  AS MovementBlob_Comment
                                    ON MovementBlob_Comment.MovementId =  Movement.Id
                                   AND MovementBlob_Comment.DescId = zc_MovementBlob_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                         ON MovementLinkObject_User.MovementId = Movement.Id
                                        AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()

            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
            

           WHERE Movement.DescId = zc_Movement_Pretension();

ALTER TABLE Movement_Pretension_View
  OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».   ÿ‡·ÎËÈ Œ.¬.
 02.12.21                                                       * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Pretension_View LIMIT 100