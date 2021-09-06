-- Function: gpReport_ZeroingInOrders()

DROP FUNCTION IF EXISTS gpReport_ZeroingInOrders (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_ZeroingInOrders(
    IN inStartDate           TDateTime,  -- Дата начала
    IN inEndDate             TDateTime,  -- Дата окончания
    IN inUnitId              Integer  ,  -- Подразделение
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (InvNumber      TVarChar
             , OperDate       TDateTime
             , InvNumberOrder TVarChar
             , StatusName     TVarChar
             , CancelReason   TVarChar
             , UnitId         Integer
             , UnitName       TVarChar
             , Bayer          TVarChar
             , BayerPhone     TVarChar
             , ConfirmedDate  TDateTime
             , ZeroingDate    TDateTime
             , GoodsCode      Integer
             , GoodsName      TVarChar
             , AmountOrder    TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH tmpMovement AS (SELECT Movement.*
                              , MovementString_InvNumberOrder.ValueData  AS InvNumberOrder
                              , CASE WHEN Movement.StatusId = zc_Enum_Status_Erased()
                                     THEN COALESCE(Object_CancelReason.ValueData, '') END::TVarChar  AS CancelReason
                              , MovementFloat_TotalSumm.ValueData                                    AS TotalSumm
                              , COALESCE(Object_BuyerForSite.ValueData,
                                         MovementString_Bayer.ValueData, '')::TVarChar               AS Bayer
                              , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                                          MovementString_BayerPhone.ValueData, '')::TVarChar         AS BayerPhone
                              , MovementLinkObject_Unit.ObjectId                                     AS UnitId
                       FROM Movement
                                      
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                         AND (MovementLinkObject_Unit.ObjectId  = inUnitId OR COALESCE(inUnitId, 0 ) = 0)
                                 
                            INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                                       ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                      AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                                      AND MovementBoolean_Deferred.ValueData = TRUE
                                                                
                            INNER JOIN MovementString AS MovementString_InvNumberOrder
                                                      ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                         ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                        AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CancelReason
                                                         ON MovementLinkObject_CancelReason.MovementId = Movement.Id
                                                        AND MovementLinkObject_CancelReason.DescId = zc_MovementLinkObject_CancelReason()
                            LEFT JOIN Object AS Object_CancelReason 
                                             ON Object_CancelReason.Id = MovementLinkObject_CancelReason.ObjectId
                                      
                            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                                             
                            LEFT JOIN MovementString AS MovementString_Bayer
                                                     ON MovementString_Bayer.MovementId = Movement.Id
                                                    AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
                            LEFT JOIN MovementString AS MovementString_BayerPhone
                                                     ON MovementString_BayerPhone.MovementId = Movement.Id
                                                    AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                                         ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                                        AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                            LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
                            LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                                   ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                                  AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()                                                       
                                                            
                       WHERE Movement.DescId = zc_Movement_Check()
                         AND Movement.OperDate >= inStartDate
                         AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                         AND COALESCE (Object_CancelReason.ObjectCode, 0) <> 2
                         )
       , tmpMI AS (SELECT tmpMovement.*
                        , MovementItem.Id                 AS MovementItemId 
                        , MovementItem.ObjectId           AS GoodsId
                   FROM tmpMovement
                           
                        INNER JOIN MovementItem ON MovementItem.MovementId =  tmpMovement.Id
                                               AND MovementItem.DescId = zc_MI_Master()
                                               AND MovementItem.Amount = 0
                                                       
                  )
       , tmpMovementProtocol AS (SELECT MovementProtocol.MovementId
                                      , MovementProtocol.OperDate 
                                      , MovementProtocol.UserId
                                      , ROW_NUMBER() OVER (Partition BY MovementProtocol.MovementId ORDER BY MovementProtocol.Id) AS ord
                                 FROM MovementProtocol 
                                 WHERE MovementProtocol.MovementId in (SELECT DISTINCT tmpMI.Id AS ID FROM tmpMI)
                                   AND MovementProtocol.ProtocolData ILIKE '%"Статус заказа (Состояние VIP-чека)" FieldValue = "Подтвержден"%')
       , tmpMIProtocol AS (SELECT MovementItemProtocol.MovementItemId
                                , MovementItemProtocol.OperDate
                                , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                           FROM MovementItemProtocol 
                           WHERE MovementItemProtocol.MovementItemId in (SELECT tmpMI.MovementItemId FROM tmpMI)
                                                             AND MovementItemProtocol.ProtocolData ILIKE '%"Значение" FieldValue = "0.0000"%'
                          )
       , tmpMIFloat AS (SELECT MovementItemFloat.*
                        FROM MovementItemFloat 
                        WHERE MovementItemFloat.MovementItemId in (SELECT tmpMI.MovementItemId FROM tmpMI)
                       )

    SELECT Movement.InvNumber
         , Movement.OperDate
         , Movement.InvNumberOrder
         , Object_Status.ValueData
         , Movement.CancelReason
         , Object_Unit.ObjectCode
         , Object_Unit.ValueData
         , Movement.Bayer
         , Movement.BayerPhone
         , tmpMovementProtocol.OperDate
         , tmpMIProtocol.OperDate
         , Object_Goods.ObjectCode
         , Object_Goods.ValueData
         , MIFloat_AmountOrder.ValueData
             
    FROM tmpMI AS Movement
         INNER JOIN tmpMIProtocol ON tmpMIProtocol.MovementItemId = Movement.MovementItemId
                                 AND tmpMIProtocol.ord = 1
                                 
         LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement.Id
                                      AND tmpMovementProtocol.ord = 1 
                
         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId
         LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = Movement.GoodsId

         LEFT JOIN tmpMIFloat AS MIFloat_AmountOrder
                              ON MIFloat_AmountOrder.MovementItemId = Movement.MovementItemId
                             AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                                    
    WHERE tmpMIProtocol.OperDate < tmpMovementProtocol.OperDate OR tmpMovementProtocol.OperDate IS NULL
    ;  

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 03.09.21                                                      * 
*/

-- тест

SELECT * FROM gpReport_ZeroingInOrders (inStartDate := ('01.09.2021')::TDateTime , inEndDate := ('30.09.2021')::TDateTime, inUnitId := 0, inSession := '3' :: TVarChar);