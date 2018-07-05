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
             , AmountCurrency TFloat, Amount TFloat
             , InsertDate TDateTime
             , InsertName TVarChar
             
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
                    WHERE inIsProtocol = TRUE
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
           
           , CASE WHEN tmpProtocol.MovementId > 0 THEN TRUE ELSE FALSE END AS isProtocol
       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MF_AmountCurrency
                                    ON MF_AmountCurrency.MovementId = Movement.Id
                                   AND MF_AmountCurrency.DescId = zc_MovementFloat_AmountCurrency()
            LEFT JOIN MovementFloat AS MF_Amount
                                    ON MF_Amount.MovementId = Movement.Id
                                   AND MF_Amount.DescId = zc_MovementFloat_Amount()

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
