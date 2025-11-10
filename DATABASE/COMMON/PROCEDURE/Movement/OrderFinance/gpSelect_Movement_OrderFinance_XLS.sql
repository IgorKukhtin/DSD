-- Function:  gpSelect_Movement_OrderFinance_XLS()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderFinance_XLS (Integer, TVarChar);

CREATE OR REPLACE FUNCTION  gpSelect_Movement_OrderFinance_XLS(
    IN inMovementId       Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate         TDateTime
             , Invnumber        TVarChar
             , ContractName     TVarChar
             , BankMFO          TVarChar
             , BankAccountName  TVarChar
             , JuridicalName    TVarChar
             , PaidKindName     TVarChar
             , OKPO             TVarChar
             , Comment          TVarChar
             , WeekNumber       Integer
             , Amount           TFloat
             , AmountRemains    TFloat
             , AmountPartner    TFloat
             , AmountSumm       TFloat
             , AmountPartner_1  TFloat
             , AmountPartner_2  TFloat
             , AmountPartner_3  TFloat
             , AmountPlan_1     TFloat
             , AmountPlan_2     TFloat
             , AmountPlan_3     TFloat
             , AmountPlan_4     TFloat
             , AmountPlan_5     TFloat
               )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMemberId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH          tmpMovement AS (SELECT Movement.Id
                               , Movement.Invnumber
                               , Movement.OperDate
                               , Object_BankAccount_View.MFO
                               , Object_BankAccount_View.Name        AS BankAccountName
                               , OrderFinance_PaidKind.ChildObjectId AS PaidKindId
                               , MovementFloat_WeekNumber.ValueData   ::TFloat    AS WeekNumber
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_BankAccount
                                                            ON MovementLinkObject_BankAccount.MovementId = Movement.Id
                                                           AND MovementLinkObject_BankAccount.DescId = zc_MovementLinkObject_BankAccount()
                               LEFT JOIN Object_BankAccount_View ON Object_BankAccount_View.Id = MovementLinkObject_BankAccount.ObjectId

                               LEFT JOIN MovementLinkObject AS MovementLinkObject_OrderFinance
                                                            ON MovementLinkObject_OrderFinance.MovementId = inMovementId
                                                           AND MovementLinkObject_OrderFinance.DescId = zc_MovementLinkObject_OrderFinance()
                               LEFT JOIN ObjectLink AS OrderFinance_PaidKind
                                                    ON OrderFinance_PaidKind.ObjectId = MovementLinkObject_OrderFinance.ObjectId
                                                   AND OrderFinance_PaidKind.DescId = zc_ObjectLink_OrderFinance_PaidKind()

                               LEFT JOIN MovementFloat AS MovementFloat_WeekNumber
                                                       ON MovementFloat_WeekNumber.MovementId = Movement.Id
                                                      AND MovementFloat_WeekNumber.DescId = zc_MovementFloat_WeekNumber()
                          WHERE Movement.DescId = zc_Movement_OrderFinance()
                            AND Movement.Id = inMovementId
                         )

        , tmpMI AS (SELECT MovementItem.MovementId
                         , MovementItem.Id       AS Id
                         , MovementItem.ObjectId AS JuridicalId
                         , MovementItem.Amount   AS Amount
                    FROM MovementItem
                    WHERE MovementItem.MovementId = inMovementId
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = False
                      AND COALESCE (MovementItem.Amount, 0) <> 0
                    )                         

        , tmpMovementItemFloat AS (SELECT *
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                   )

        SELECT --(lpad (EXTRACT (YEAR FROM tmpMovement.OperDate)::tvarchar ,4, '0')||lpad (EXTRACT (MONTH FROM tmpMovement.OperDate)::tvarchar ,2, '0') ||lpad (EXTRACT (DAY FROM tmpMovement.OperDate)::tvarchar ,2, '0')) ::TVarchar AS OperDate     --Дата документа
               tmpMovement.OperDate ::TDateTime AS OperDate
             , tmpMovement.Invnumber            AS Invnumber
             , Object_Contract.ValueData ::TVarChar AS ContractName
             , tmpMovement.MFO                  AS BankMFO
             , tmpMovement.BankAccountName      AS BankAccountName

             , Object_Juridical.ValueData       AS JuridicalName
             , Object_PaidKind.ValueData        AS PaidKindName
             , COALESCE (ObjectHistory_JuridicalDetails_View.OKPO,'') :: TVarChar AS OKPO
             , COALESCE (MIString_Comment.ValueData, '') ::TVarChar   :: TVarChar AS Comment
             , tmpMovement.WeekNumber     ::Integer
             , COALESCE (MovementItem.Amount,0)  ::TFloat AS Amount
             , MIFloat_AmountRemains.ValueData   ::TFloat AS AmountRemains
             , MIFloat_AmountPartner.ValueData   ::TFloat AS AmountPartner
             , MIFloat_AmountSumm.ValueData      ::TFloat AS AmountSumm
             , MIFloat_AmountPartner_1.ValueData ::TFloat AS AmountPartner_1
             , MIFloat_AmountPartner_2.ValueData ::TFloat AS AmountPartner_2
             , MIFloat_AmountPartner_3.ValueData ::TFloat AS AmountPartner_3
             , MIFloat_AmountPlan_1.ValueData    ::TFloat AS AmountPlan_1
             , MIFloat_AmountPlan_2.ValueData    ::TFloat AS AmountPlan_2
             , MIFloat_AmountPlan_3.ValueData    ::TFloat AS AmountPlan_3
             , MIFloat_AmountPlan_4.ValueData    ::TFloat AS AmountPlan_4
             , MIFloat_AmountPlan_5.ValueData    ::TFloat AS AmountPlan_5             
        FROM tmpMovement
             LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = tmpMovement.Id

             LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = tmpMovement.PaidKindId
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.JuridicalId     
             -- если юр. лицо
             LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = MovementItem.JuridicalId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId

            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountRemains
                                           ON MIFloat_AmountRemains.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountRemains.DescId = zc_MIFloat_AmountRemains()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner
                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountSumm
                                           ON MIFloat_AmountSumm.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountSumm.DescId = zc_MIFloat_AmountSumm()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_1
                                           ON MIFloat_AmountPartner_1.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner_1.DescId = zc_MIFloat_AmountPartner_1()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_2
                                           ON MIFloat_AmountPartner_2.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner_2.DescId = zc_MIFloat_AmountPartner_2()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner_3
                                           ON MIFloat_AmountPartner_3.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner_3.DescId = zc_MIFloat_AmountPartner_3()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_1
                                           ON MIFloat_AmountPlan_1.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_1.DescId = zc_MIFloat_AmountPlan_1()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_2
                                           ON MIFloat_AmountPlan_2.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_2.DescId = zc_MIFloat_AmountPlan_2()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_3
                                           ON MIFloat_AmountPlan_3.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_3.DescId = zc_MIFloat_AmountPlan_3()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_4
                                           ON MIFloat_AmountPlan_4.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_4.DescId = zc_MIFloat_AmountPlan_4()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlan_5
                                           ON MIFloat_AmountPlan_5.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPlan_5.DescId = zc_MIFloat_AmountPlan_5()
            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 09.11.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_OrderFinance_XLS(inMovementId :=19727298 ::Integer , inSession := '9457'::TVarChar);
