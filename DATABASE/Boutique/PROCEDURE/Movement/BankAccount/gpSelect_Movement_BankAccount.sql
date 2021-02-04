-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_BankAccount (Integer, TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_BankAccount(
    IN inBankAccountId            Integer   , -- касса
    IN inStartDate         TDateTime , -- Дата нач. периода
    IN inEndDate           TDateTime , -- Дата оконч. периода
    IN inStartProtocol     TDateTime , -- Дата нач. для протокола
    IN inEndProtocol       TDateTime , -- Дата оконч. для протокола
    IN inIsProtocol        Boolean   , -- показывать протокол Да/Нет
    IN inIsErased          Boolean   , -- показывать удаленные Да/Нет
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , CurrencyValue TFloat, ParValue TFloat
             , CurrencyPartnerValue TFloat, ParPartnerValue TFloat
             , InsertDate TDateTime
             , InsertName TVarChar
           
             , AmountOut TFloat
             , AmountIn  TFloat
             , BankAccountId Integer, BankAccountName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar, ItemName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar
           
             , isProtocol Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_BankAccount());


     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement_All AS (SELECT Movement.*
                              FROM tmpStatus
                                   JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                                                AND Movement.DescId   = zc_Movement_BankAccount()
                                                AND Movement.StatusId = tmpStatus.StatusId
                              )
        , tmpMI AS (SELECT MovementItem.*
                    FROM tmpMovement_All AS tmpMovement
                        INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = FALSE
                                               AND (MovementItem.ObjectId = inBankAccountId OR inBankAccountId = 0)  
                   )
        , tmpMovement AS (SELECT tmpMovement_All.*
                          FROM tmpMovement_All
                              INNER JOIN tmpMI ON tmpMI.MovementId = tmpMovement_All.Id
                          )
        
        , tmpProtocol_MI AS (SELECT DISTINCT tmpMI.MovementId
                             FROM tmpMI
                                  INNER JOIN (SELECT DISTINCT MovementItemProtocol.MovementItemId
                                              FROM MovementItemProtocol
                                              WHERE MovementItemProtocol.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                                AND MovementItemProtocol.OperDate >= inStartProtocol AND MovementItemProtocol.OperDate < inEndProtocol + INTERVAL '1 DAY'
                                                AND inIsProtocol = TRUE
                                             ) AS tmp ON tmp.MovementItemId = tmpMI.Id
                            )
        , tmpProtocol_Mov AS (SELECT DISTINCT MovementProtocol.MovementId
                              FROM MovementProtocol
                              WHERE MovementProtocol.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                                AND MovementProtocol.OperDate >= inStartProtocol AND MovementProtocol.OperDate < inEndProtocol + INTERVAL '1 DAY'
                                AND inIsProtocol = TRUE
                             )
        , tmpProtocol AS (SELECT tmp.MovementId
                          FROM tmpProtocol_MI AS tmp
                         UNION 
                          SELECT tmp.MovementId
                          FROM tmpProtocol_Mov AS tmp
                         )


       SELECT
             Movement.Id
           , zfConvert_StringToNumber (Movement.InvNumber) AS InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode                    AS StatusCode
           , Object_Status.ValueData                     AS StatusName

           , MF_CurrencyValue.ValueData                  AS CurrencyValue
           , MF_ParValue.ValueData                       AS ParValue

           , MF_CurrencyPartnerValue.ValueData           AS CurrencyPartnerValue
           , MF_ParPartnerValue.ValueData                AS ParPartnerValue

           , MovementDate_Insert.ValueData               AS InsertDate
           , Object_Insert.ValueData                     AS InsertName
           
           , CASE WHEN COALESCE (tmpMI.Amount,0) < 0 THEN -1 * tmpMI.Amount  ELSE 0 END :: TFloat AS AmountOut
           , CASE WHEN COALESCE (tmpMI.Amount,0) > 0 THEN tmpMI.Amount ELSE 0 END       :: TFloat AS AmountIn

           , Object_BankAccount.Id                       AS BankAccountId
           , Object_BankAccount.ValueData                AS BankAccountName
           , Object_Currency.Id                          AS CurrencyId
           , Object_Currency.ValueData                   AS CurrencyName
           , Object_MoneyPlace.Id                        AS MoneyPlaceId
           , Object_MoneyPlace.ValueData                 AS MoneyPlaceName
           , ObjectDesc.ItemName

           , Object_InfoMoney.Id                         AS InfoMoneyId
           , Object_InfoMoney.ValueData                  AS InfoMoneyName
           , Object_Unit.Id                              AS UnitId
           , Object_Unit.ValueData                       AS UnitName

           , MIString_Comment.ValueData                  AS Comment 

           , CASE WHEN tmpProtocol.MovementId > 0 THEN TRUE ELSE FALSE END AS isProtocol
       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MF_ParValue
                                    ON MF_ParValue.MovementId = Movement.Id
                                   AND MF_ParValue.DescId = zc_MovementFloat_ParValue()
            LEFT JOIN MovementFloat AS MF_CurrencyValue
                                    ON MF_CurrencyValue.MovementId = Movement.Id
                                   AND MF_CurrencyValue.DescId = zc_MovementFloat_CurrencyValue()

            LEFT JOIN MovementFloat AS MF_ParPartnerValue
                                    ON MF_ParPartnerValue.MovementId = Movement.Id
                                   AND MF_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()
            LEFT JOIN MovementFloat AS MF_CurrencyPartnerValue
                                    ON MF_CurrencyPartnerValue.MovementId = Movement.Id
                                   AND MF_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            --
            LEFT JOIN tmpProtocol ON tmpProtocol.MovementId = Movement.Id
            
            INNER JOIN tmpMI ON tmpMI.MovementId = Movement.Id
            LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = tmpMI.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Currency
                                 ON ObjectLink_BankAccount_Currency.ObjectId = Object_BankAccount.Id
                                AND ObjectLink_BankAccount_Currency.DescId = zc_ObjectLink_BankAccount_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_BankAccount_Currency.ChildObjectId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpMI.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = tmpMI.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = tmpMI.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = tmpMI.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
           ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.18         *
*/

-- тест
-- select * from gpSelect_Movement_BankAccount(inBankAccountId := 0 , inStartDate := ('01.07.2018')::TDateTime , inEndDate := ('31.08.2018')::TDateTime , inStartProtocol := ('12.07.2018')::TDateTime , inEndProtocol := ('12.07.2018')::TDateTime , inIsProtocol := 'False' , inIsErased := 'False' ,  inSession := '8');