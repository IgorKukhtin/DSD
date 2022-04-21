-- Function: gpSelect_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpSelect_Movement_OrderInternalPromo (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_OrderInternalPromo(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- ñåññèÿ ïîëüçîâàòåëÿ
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusId  Integer
             , StatusCode Integer
             , StatusName TVarChar
             , StartSale TDateTime
             , Amount TFloat
             , TotalSummPrice TFloat, TotalSummSIP TFloat, TotalAmount TFloat
             , RetailId Integer
             , RetailName TVarChar
             , Comment TVarChar
             , Distributed TFloat
             , DistributedSumma TFloat
             , DateInsert TDateTime
             , DaysGrace Integer
             , DatePayment TDateTime
             , DateSent TDateTime
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                     UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                     UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       ),
             tmpMovement AS (SELECT Movement.Id
                                  , Movement.InvNumber
                                  , Movement.OperDate
                                  , Movement.StatusId
                             FROM Movement 
                             WHERE Movement.DescId = zc_Movement_OrderInternalPromo()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate),
             tmpMIMaster AS (SELECT MovementItem.Id
                                  , MovementItem.MovementID
                                  , MIFloat_Price.ValueData         ::TFloat AS Price
                             FROM tmpMovement AS Movement 
                                  INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                         AND MovementItem.DescId = zc_MI_Master()
                                                         AND MovementItem.isErased = FALSE 
                                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
                            ),
             tmpMIChild AS (SELECT MovementItem.ParentId
                                 , MovementItem.Amount              AS Amount
                            FROM tmpMovement AS Movement 
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Child()
                                                        AND MovementItem.isErased = FALSE 
                           ),
             tmpMISum AS (SELECT MIMaster.MovementID
                               , Sum(MIChild.Amount)::TFloat                             AS Distributed
                               , Sum(MIMaster.Price * MIChild.Amount)::TFloat            AS DistributedSumma
                          FROM tmpMIMaster AS MIMaster
                           
                               INNER JOIN tmpMIChild AS MIChild
                                                     ON MIChild.ParentId = MIMaster.Id
                          GROUP BY MIMaster.MovementID
                           ),
             tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                          , MIN(DATE_TRUNC ('DAY', MovementProtocol.OperDate))::TDateTime  AS OperDate 
                                     FROM MovementProtocol 
                                     WHERE MovementProtocol.MovementId in (SELECT DISTINCT tmpMovement.Id AS ID FROM tmpMovement)
                                     GROUP BY MovementProtocol.MovementId)


     SELECT Movement.Id
          , Movement.InvNumber
          , Movement.OperDate
          , Movement.StatusId
          , Object_Status.ObjectCode                                       AS StatusCode
          , Object_Status.ValueData                                        AS StatusName
          , MovementDate_StartSale.ValueData                               AS StartSale
          , COALESCE (MovementFloat_Amount.ValueData,0)       :: TFloat    AS Amount
          , COALESCE (MovementFloat_TotalSummPrice.ValueData,0):: TFloat   AS TotalSummPrice
          , COALESCE (MovementFloat_TotalSummSIP.ValueData,0) :: TFloat    AS TotalSummSIP
          , COALESCE (MovementFloat_TotalAmount.ValueData,0) :: TFloat     AS TotalAmount
          , MovementLinkObject_Retail.ObjectId                             AS RetailId
          , Object_Retail.ValueData                                        AS RetailName
          , MovementString_Comment.ValueData                               AS Comment
          , MISum.Distributed                                              AS Distributed
          , MISum.DistributedSumma                                         AS DistributedSumma
          , tmpMovementProtocol.OperDate                                   AS DateInsert
          , COALESCE (MovementFloat_DaysGrace.ValueData,0)      :: Integer AS DaysGrace
          , (tmpMovementProtocol.OperDate + (COALESCE (NULLIF(MovementFloat_DaysGrace.ValueData, 0),30)::TVarChar||' DAY')::Interval)::TDateTime  AS DatePayment
          , MovementDate_Sent.ValueData                                    AS DateSent
     FROM tmpMovement AS Movement 
        INNER JOIN tmpStatus ON Movement.StatusId = tmpStatus.StatusId
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementFloat AS MovementFloat_Amount
                                ON MovementFloat_Amount.MovementId =  Movement.Id
                               AND MovementFloat_Amount.DescId = zc_MovementFloat_Amount()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummPrice
                                ON MovementFloat_TotalSummPrice.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummPrice.DescId = zc_MovementFloat_TotalSummPrice()

        LEFT JOIN MovementFloat AS MovementFloat_TotalSummSIP
                                ON MovementFloat_TotalSummSIP.MovementId =  Movement.Id
                               AND MovementFloat_TotalSummSIP.DescId = zc_MovementFloat_TotalSummSIP()

        LEFT JOIN MovementFloat AS MovementFloat_TotalAmount
                                ON MovementFloat_TotalAmount.MovementId =  Movement.Id
                               AND MovementFloat_TotalAmount.DescId = zc_MovementFloat_TotalAmount()

        LEFT JOIN MovementFloat AS MovementFloat_DaysGrace
                                ON MovementFloat_DaysGrace.MovementId =  Movement.Id
                               AND MovementFloat_DaysGrace.DescId = zc_MovementFloat_DaysGrace()

        LEFT JOIN MovementDate AS MovementDate_StartSale
                               ON MovementDate_StartSale.MovementId = Movement.Id
                              AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
        LEFT JOIN MovementDate AS MovementDate_Sent
                               ON MovementDate_Sent.MovementId = Movement.Id
                              AND MovementDate_Sent.DescId = zc_MovementDate_Sent()

        LEFT JOIN MovementLinkObject AS MovementLinkObject_Retail
                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MovementLinkObject_Retail.ObjectId
        
        LEFT JOIN MovementString AS MovementString_Comment
                                 ON MovementString_Comment.MovementId = Movement.Id
                                AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                
        LEFT JOIN tmpMISum AS MISum ON MISum.MovementID = Movement.Id

        LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id

     ORDER BY InvNumber;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ÈÑÒÎÐÈß ÐÀÇÐÀÁÎÒÊÈ: ÄÀÒÀ, ÀÂÒÎÐ
               Ôåëîíþê È.Â.   Êóõòèí È.Â.   Êëèìåíòüåâ Ê.È.
 15.04.19         *
*/
-- select * from gpSelect_Movement_OrderInternalPromo(inStartDate := ('13.03.2019')::TDateTime ,inEndDate := ('13.03.2021')::TDateTime , inIsErased:= False, inSession := '3');


select * from gpSelect_Movement_OrderInternalPromo(inStartDate := ('28.06.2021')::TDateTime , inEndDate := ('30.11.2023')::TDateTime , inIsErased := 'False' ,  inSession := '3')