-- Function: gpSelect_Movement_Currency()

DROP FUNCTION IF EXISTS gpSelect_Movement_Currency (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Currency(
    IN inStartDate        TDateTime , --
    IN inEndDate          TDateTime , --
    IN inIsErased         Boolean ,
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar
             , StartDate TDateTime
             , EndDate   TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat, ParValue TFloat
             , Comment TVarChar
             , CurrencyFromName TVarChar
             , CurrencyToName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Currency());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
        , tmpMovement AS (SELECT
                                Movement.Id
                              , Movement.InvNumber
                              , Movement.OperDate
                              , Object_Status.ObjectCode   AS StatusCode
                              , Object_Status.ValueData    AS StatusName
                      
                      
                              , MovementItem.Amount             AS Amount
                              , MIFloat_ParValue.ValueData      AS ParValue
                      
                              , MIString_Comment.ValueData      AS Comment
                      
                              , MovementItem.ObjectId           AS CurrencyFromId
                              , Object_CurrencyFrom.ValueData   AS CurrencyFromName
                              
                              , MILinkObject_CurrencyTo.ObjectId  AS CurrencyToId
                              , Object_CurrencyTo.ValueData     AS CurrencyToName
                      
                              , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_CurrencyTo.ObjectId ORDER BY Movement.OperDate, Movement.Id) AS Ord
 
                          FROM tmpStatus
                               JOIN Movement ON Movement.DescId = zc_Movement_Currency()
                                            AND Movement.StatusId = tmpStatus.StatusId
                      
                               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
                      
                               LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                               LEFT JOIN Object AS Object_CurrencyFrom ON Object_CurrencyFrom.Id = MovementItem.ObjectId
                      
                               LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                           ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                          AND MIFloat_ParValue.DescId = zc_MIFloat_ParValue()
                               LEFT JOIN MovementItemString AS MIString_Comment 
                                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                                           AND MIString_Comment.DescId = zc_MIString_Comment()
                      
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_CurrencyTo
                                                                ON MILinkObject_CurrencyTo.MovementItemId = MovementItem.Id
                                                               AND MILinkObject_CurrencyTo.DescId = zc_MILinkObject_Currency()
                               LEFT JOIN Object AS Object_CurrencyTo ON Object_CurrencyTo.Id = MILinkObject_CurrencyTo.ObjectId
                          )
       -- Результат
       SELECT tmpMovement.Id, tmpMovement.InvNumber
            , tmpMovement.OperDate AS StartDate
            , CASE WHEN tmpMovement.OperDate < COALESCE (tmpMovement_next.OperDate, zc_DateEnd()) 
                       THEN COALESCE (tmpMovement_next.OperDate - INTERVAL '1 DAY', zc_DateEnd()) 
                       ELSE NULL
              END :: TDateTime AS EndDate
            , tmpMovement.StatusCode, tmpMovement.StatusName
            , tmpMovement.Amount, tmpMovement.ParValue
            , tmpMovement.Comment
            , tmpMovement.CurrencyFromName
            , tmpMovement.CurrencyToName
       FROM tmpMovement
            LEFT JOIN tmpMovement AS tmpMovement_next
                                  ON tmpMovement_next.CurrencyFromId = tmpMovement.CurrencyFromId
                                 AND tmpMovement_next.CurrencyToId   = tmpMovement.CurrencyToId
                                 AND tmpMovement_next.Ord            = tmpMovement.Ord + 1
       WHERE (inStartDate BETWEEN tmpMovement.OperDate AND COALESCE (tmpMovement_next.OperDate - INTERVAL '1 DAY', zc_DateEnd()))
          OR (inEndDate   BETWEEN tmpMovement.OperDate AND COALESCE (tmpMovement_next.OperDate - INTERVAL '1 DAY', zc_DateEnd()))
          OR (tmpMovement.OperDate BETWEEN inStartDate AND inEndDate)
          OR (COALESCE (tmpMovement_next.OperDate - INTERVAL '1 DAY', zc_DateEnd()) BETWEEN inStartDate AND inEndDate)
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.04.22         * Merlin
 27.04.17         * бутики
*/

-- тест
--  SELECT * FROM gpSelect_Movement_Currency (inStartDate:= '01.01.2016', inEndDate:= '31.12.2016', inIsErased:= false, inSession:= zfCalc_UserAdmin())
