-- Function: gpSelect_Movement_Send()

DROP FUNCTION IF EXISTS gpSelect_Movement_Send (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Send (TDateTime, TDateTime, TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Send(
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
             , TotalCount TFloat, TotalSummBalance TFloat, TotalSummPriceList TFloat
             , FromName TVarChar, ToName TVarChar
             , Comment TVarChar
             , isProtocol Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Send());


     -- Результат
     RETURN QUERY 
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
     , tmpMovement AS (SELECT Movement.id
                       FROM tmpStatus
                            JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                                         AND Movement.DescId = zc_Movement_Send()
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

           , MovementFloat_TotalCount.ValueData          AS TotalCount
           , MovementFloat_TotalSummBalance.ValueData    AS TotalSummBalance
           , MovementFloat_TotalSummPriceList.ValueData  AS TotalSummPriceList
        
           , Object_From.ValueData                       AS FromName
           , Object_To.ValueData                         AS ToName

           , MovementString_Comment.ValueData            AS Comment
           
           , CASE WHEN tmpProtocol.MovementId > 0 THEN TRUE ELSE FALSE END AS isProtocol
         
       FROM tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.id
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummPriceList
                                    ON MovementFloat_TotalSummPriceList.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummPriceList.DescId = zc_MovementFloat_TotalSummPriceList()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummBalance 	
                                    ON MovementFloat_TotalSummBalance.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummBalance.DescId = zc_MovementFloat_TotalSummBalance()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
            --
            LEFT JOIN tmpProtocol ON tmpProtocol.MovementId = tmpMovement.Id
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И. 
 03.05.18         * add protocol
 14.06.17         * add TotalSummBalance
 25.04.17         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Send (inStartDate:= '01.01.2015', inEndDate:= '01.02.2015', inStartProtocol:= '01.03.2017', inEndProtocol:= '01.03.2017', inIsProtocol:= FALSE, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
