DROP VIEW IF EXISTS MovementItem_Payment_View;

CREATE OR REPLACE VIEW MovementItem_Payment_View AS
    SELECT
        MI_Income.Id                                AS Id
      , MI_Income.MovementId                        AS MovementId
      , MIFloat_IncomeId.ValueData::Integer         AS IncomeId
      , Movement_Income.InvNumber                   AS Income_InvNumber
      , Movement_Income.Operdate                    AS Income_Operdate
      , MovementDate_Payment.ValueData              AS Income_DatePayment
      , Object_Status.ValueData                     AS Income_StatusName
      , MLO_From.ObjectId                           AS Income_JuridicalId
      , Object_From.ValueData                       AS Income_JuridicalName
      , MLO_To.ObjectId                             AS Income_UnitId
      , Object_To.Name                              AS Income_UnitName
      , Object_To.JuridicalId                       AS Unit_JuridicalId
      , Object_To.JuridicalName                     AS Unit_JuridicalName
      , Object_NDSKind.ValueData                    AS Income_NDSKindName
      , Object_Contract.ValueData                   AS Income_ContractName
      , MovementFloat_TotalSumm.ValueData           AS Income_TotalSumm
      , Container.Amount                            AS Income_PaySumm
      , MI_Income.Amount                            AS SummaPay
      , MIFloat_BankAccountId.ValueData::Integer    AS BankAccountId
      , MI_BankAccountItem.ObjectId                 AS AccountId
      , Object_BankAccount.Name                     AS AccountName
      , Object_BankAccount.BankName                 AS BankName
      , MI_Income.isErased                          AS isErased
      , COALESCE(MIBoolean_NeedPay.ValueData,FALSE) AS NeedPay
    FROM  MovementItem AS MI_Income
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_IncomeId
                                          ON MIFloat_IncomeId.MovementItemId = MI_Income.ID
                                         AND MIFloat_IncomeId.DescId = zc_MIFloat_MovementId()
        LEFT OUTER JOIN Movement AS Movement_Income
                                 ON Movement_Income.Id = MIFloat_IncomeId.ValueData::INTEGER
        LEFT OUTER JOIN Object AS Object_Status
                               ON Object_Status.Id = Movement_Income.StatusId
        
        LEFT OUTER JOIN MovementLinkObject AS MLO_From
                                           ON MLO_From.MovementId = Movement_Income.Id
                                          AND MLO_From.DescId = zc_MovementLinkObject_From()
        LEFT OUTER JOIN Object AS Object_From
                               ON Object_From.Id = MLO_From.ObjectId
                               
        LEFT OUTER JOIN MovementLinkObject AS MLO_To
                                           ON MLO_To.MovementId = Movement_Income.Id
                                          AND MLO_To.DescId = zc_MovementLinkObject_To()
        LEFT OUTER JOIN Object_Unit_View AS Object_To
                                         ON Object_To.Id = MLO_To.ObjectId

        LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                     ON MovementLinkObject_NDSKind.MovementId = Movement_Income.Id
                                    AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
        LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = MovementLinkObject_NDSKind.ObjectId
        
        LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                     ON MovementLinkObject_Contract.MovementId = Movement_Income.Id
                                    AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
        LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
        
        LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                ON MovementFloat_TotalSumm.MovementId = Movement_Income.Id
                               AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

        LEFT JOIN MovementDate    AS MovementDate_Payment
                                  ON MovementDate_Payment.MovementId = Movement_Income.Id
                                 AND MovementDate_Payment.DescId = zc_MovementDate_Payment()

        LEFT JOIN Object AS Object_Movement
                         ON Object_Movement.ObjectCode = Movement_Income.Id
                        AND Object_Movement.DescId = zc_Object_PartionMovement()
        LEFT JOIN Container ON Container.DescId = zc_Container_SummIncomeMovementPayment()
                           AND Container.ObjectId = Object_Movement.Id
                           AND Container.KeyValue like '%,'||Object_To.JuridicalId::TVarChar||';%'
        
        
        LEFT OUTER JOIN MovementItem AS MI_BankAccount
                                     ON MI_BankAccount.DescId = zc_MI_Child()
                                    AND MI_BankAccount.ParentId = MI_Income.ID
        LEFT OUTER JOIN MovementItemFloat AS MIFloat_BankAccountId
                                          ON MIFloat_BankAccountId.MovementItemId = MI_BankAccount.ID
                                         AND MIFloat_BankAccountId.DescId = zc_MIFloat_MovementId()
        LEFT JOIN Movement AS Movement_BankAccount
                           ON Movement_BankAccount.Id = MIFloat_BankAccountId.ValueData::INTEGER
        LEFT JOIN MovementItem AS MI_BankAccountItem
                               ON MI_BankAccountItem.MovementId = Movement_BankAccount.Id
                              AND MI_BankAccountItem.DescId = zc_MI_Master()

        LEFT JOIN Object_BankAccount_View AS Object_BankAccount
                                          ON Object_BankAccount.Id = MI_BankAccountItem.ObjectId
        
        LEFT JOIN MovementItemBoolean AS MIBoolean_NeedPay
                                      ON MIBoolean_NeedPay.MovementItemId = MI_Income.Id
                                     AND MIBoolean_NeedPay.DescId = zc_MIBoolean_NeedPay()
    WHERE
        MI_Income.DescId = zc_MI_Master();

ALTER TABLE MovementItem_Payment_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».  ¬ÓÓ·Í‡ÎÓ ¿.¿.
 13.10.15                                                         *
*/