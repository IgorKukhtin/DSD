-- Function: gpSelect_Movement_Cash()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash(
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
             , CashId Integer, CashName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
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
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());


     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                                            AND Movement.DescId   = zc_Movement_Cash()
                                            AND Movement.StatusId = tmpStatus.StatusId
                          )
        , tmpMI AS (SELECT MovementItem.MovementId
                         , MovementItem.Id
                    FROM tmpMovement
                        INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                               AND MovementItem.DescId     = zc_MI_Master()
                                               AND MovementItem.isErased   = FALSE
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
                              WHERE MovementProtocol.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
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

           , MF_AmountCurrency.ValueData                 AS AmountCurrency
           , MF_Amount.ValueData                         AS Amount
           
           , MovementDate_Insert.ValueData               AS InsertDate
           , Object_Insert.ValueData                     AS InsertName
           
           , CASE WHEN COALESCE (tmpMI.Amount,0) < 0 THEN tmpMI.Amount ELSE 0 END AS AmountOut
           , CASE WHEN COALESCE (tmpMI.Amount,0) > 0 THEN tmpMI.Amount ELSE 0 END AS AmountIn

           , Object_Cash.Id                              AS CashId
           , Object_Cash.ValueData                       AS CashName
           , Object_MoneyPlace.Id                        AS MoneyPlaceId
           , Object_MoneyPlace.ValueData                 AS MoneyPlaceName

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
            
            LEFT JOIN tmpMI ON tmpMI.MovementId = Movement.Id

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId
           ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 05.07.18         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cash (inStartDate:= '01.03.2017', inEndDate:= '01.03.2017', inStartProtocol:= '01.03.2017', inEndProtocol:= '01.03.2017', inIsProtocol:= FALSE, inIsErased:= FALSE,inSession:= zfCalc_UserAdmin())
