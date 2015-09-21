-- View: Object_Unit_View

DROP VIEW IF EXISTS Movement_Income_View;

CREATE OR REPLACE VIEW Movement_Income_View AS 
    SELECT
         Movement.Id                                AS Id
       , Movement.InvNumber                         AS InvNumber
       , Movement.OperDate                          AS OperDate
       , Movement.StatusId                          AS StatusId
       , Object_Status.ObjectCode                   AS StatusCode
       , Object_Status.ValueData                    AS StatusName
       , MovementFloat_TotalCount.ValueData         AS TotalCount
       , MovementFloat_TotalSummMVAT.ValueData      AS TotalSummMVAT
       , MovementFloat_TotalSumm.ValueData          AS TotalSumm
       , MovementBoolean_PriceWithVAT.ValueData     AS PriceWithVAT
       , MovementLinkObject_From.ObjectId           AS FromId
       , Object_From.ValueData                      AS FromName
       , MovementLinkObject_To.ObjectId             AS ToId
       , Object_To.Name                             AS ToName
       , Object_To.JuridicalName                    AS JuridicalName
       , Object_To.JuridicalId                      AS JuridicalId
       , MovementLinkObject_NDSKind.ObjectId        AS NDSKindId
       , Object_NDSKind.ValueData                   AS NDSKindName
       , ObjectFloat_NDSKind_NDS.ValueData          AS NDS
       , MovementLinkObject_Contract.ObjectId       AS ContractId
       , Object_Contract.ValueData                  AS ContractName
       , MovementDate_Payment.ValueData             AS PaymentDate
       , Container.Amount                           AS PaySumm
       , MovementFloat_TotalSummSale.ValueData      AS SaleSumm
       , MovementString_InvNumberBranch.ValueData   AS InvNumberBranch
       , MovementDate_Branch.ValueData              AS BranchDate
       , COALESCE(MovementBoolean_Checked.ValueData, false)   AS Checked

    FROM Movement 
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                ON MovementFloat_TotalCount.MovementId =  Movement.Id
                               AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSale
                                ON MovementFloat_TotalSummSale.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummSale.DescId = zc_MovementFloat_TotalSummSale()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummMVAT
                                ON MovementFloat_TotalSummMVAT.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummMVAT.DescId = zc_MovementFloat_TotalSummMVAT()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                     ON MovementLinkObject_From.MovementId = Movement.Id
                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

        LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                     ON MovementLinkObject_To.MovementId = Movement.Id
                                    AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()

        LEFT JOIN Object_Unit_View AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                     ON MovementLinkObject_NDSKind.MovementId = Movement.Id
                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()

        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                              ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                             AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()   

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()

        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

        LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                  ON MovementBoolean_PriceWithVAT.MovementId =  Movement.Id
                                 AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()

        LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                  ON MovementBoolean_Checked.MovementId =  Movement.Id
                                 AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()

        LEFT JOIN MovementDate    AS MovementDate_Payment
                                  ON MovementDate_Payment.MovementId =  Movement.Id
                                 AND MovementDate_Payment.DescId = zc_MovementDate_Payment()

        LEFT JOIN MovementDate    AS MovementDate_Branch
                                  ON MovementDate_Branch.MovementId = Movement.Id
                                 AND MovementDate_Branch.DescId = zc_MovementDate_Branch()

        LEFT JOIN MovementString  AS MovementString_InvNumberBranch
                                  ON MovementString_InvNumberBranch.MovementId = Movement.Id
                                 AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()

        -- œ‡ÚËˇ Ì‡ÍÎ‡‰ÌÓÈ
        LEFT JOIN Object AS Object_Movement
                         ON Object_Movement.ObjectCode = Movement.Id 
                        AND Object_Movement.DescId = zc_Object_PartionMovement()
        LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                           AND Container.ObjectId = Object_Movement.Id
                           AND Container.KeyValue like '%,'||Object_To.JuridicalId::TVarChar||';%'
    WHERE 
        Movement.DescId = zc_Movement_Income();

ALTER TABLE Movement_Income_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 14.05.15                        * 
 11.02.15                        * 
 04.02.15                        * 
 12.01.15                        * 
 12.09.14                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Income_View where id = 805
