-- View: Object_Unit_View

DROP VIEW IF EXISTS Movement_BankAccount_View;

CREATE OR REPLACE VIEW Movement_BankAccount_View AS 
SELECT       

             Movement.Id
           , Movement.InvNumber
           , Movement.ParentId
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           , MovementItem.Amount
           , MovementItem.ObjectId             AS BankAccountId
           , Object_BankAccount_View.Name      AS BankAccountName
           , Object_BankAccount_View.JuridicalId  AS JuridicalId_Basis
           , Object_BankAccount_View.BankName  AS BankName
           , MILinkObject_MoneyPlace.ObjectId  AS MoneyPlaceId
           , MovementLinkMovement_Child.MovementChildId AS IncomeId
           , Movement_Income_View.InvNumber             AS IncomeInvNumber 

       FROM Movement 
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                         ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                        AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Child
                                           ON MovementLinkMovement_Child.MovementId = Movement.Id
                                          AND MovementLinkMovement_Child.DescId = zc_MovementLinkMovement_Child()

            LEFT JOIN Movement_Income_View ON Movement_Income_View.Id = MovementLinkMovement_Child.MovementChildId

           WHERE Movement.DescId = zc_Movement_BankAccount();

ALTER TABLE Movement_BankAccount_View
  OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ‘ÂÎÓÌ˛Í ».¬.    ÛıÚËÌ ».¬.    ÎËÏÂÌÚ¸Â‚  .».
 13.02.15                        * 
*/

-- ÚÂÒÚ
-- SELECT * FROM Movement_Income_View where id = 805
