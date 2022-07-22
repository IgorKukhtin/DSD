-- Function: gpReport_Inventory_ProficitReturnOut()

DROP FUNCTION IF EXISTS gpReport_Inventory_ProficitReturnOut (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Inventory_ProficitReturnOut(
    IN inStartDate   TDateTime , --С даты
    IN inEndDate     TDateTime , --По дату
    IN inSession     TVarChar    --сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, OperDateStatus TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat, Remains TFloat
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);
          
     -- определяется <Торговая сеть>
     vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', vbUserId);

     RETURN QUERY
     WITH tmpUnit  AS  (SELECT ObjectLink_Unit_Juridical.ObjectId AS UnitId
                        FROM ObjectLink AS ObjectLink_Unit_Juridical
                           INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                                                AND ObjectLink_Juridical_Retail.ChildObjectId = vbObjectId
                        WHERE  ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
                        )

        , tmpMovement AS (SELECT Movement.*
                               , MovementLinkObject_Unit.ObjectId AS UnitId
                          FROM Movement 
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                               INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                               INNER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                                          ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                                         AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
                                                         AND MovementBoolean_FullInvent.ValueData = True
                          WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate 
                            AND Movement.DescId = zc_Movement_Inventory() 
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          )
        , tmpProtocolAll AS (SELECT ROW_NUMBER() OVER (PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate) AS Ord,
                                    MovementProtocol.MovementId,
                                    MovementProtocol.OperDate,
                                    MovementProtocol.UserID,
                                    MovementProtocol.isInsert,
                                    case when MovementProtocol.ProtocolData like '%"Статус" FieldValue = "Проведен"%' THEN 1 ELSE 0 END AS Status
                                 FROM tmpMovement
                                      INNER JOIN MovementProtocol ON MovementProtocol.MovementId = tmpMovement.Id)
        , tmpProtocol AS (SELECT tmpProtocol.MovementId,
                                 MAX(date_trunc('DAY', tmpProtocol.OperDate))::TDateTime AS OperDateStatus
                              FROM tmpProtocolAll AS tmpProtocol
                                  
                                   INNER JOIN tmpProtocolAll AS tmpProtocolPrev
                                                             ON tmpProtocolPrev.MovementId = tmpProtocol.MovementId
                                                            AND tmpProtocolPrev.Ord = tmpProtocol.Ord - 1 
                                                            AND tmpProtocolPrev.Status = tmpProtocol.Status - 1 
                                  
                              WHERE tmpProtocol.Status = 1
                              GROUP BY tmpProtocol.MovementId)
          -- строчная часть
        , tmpMI AS (SELECT MovementItem.Id            AS Id
                         , MovementItem.MovementId    AS MovementId
                         , tmpMovement.UnitId         AS UnitId
                         , MovementItem.ObjectId      AS GoodsId
                         , MovementItem.Amount        AS Amount
                         , MIFloat_Remains.ValueData  AS Remains

                    FROM tmpMovement 
                    
                         INNER JOIN MovementItem ON MovementItem.MovementId =  tmpMovement.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased  = FALSE                                                
                         
                         LEFT JOIN MovementItemFloat AS MIFloat_Remains
                                                     ON MIFloat_Remains.MovementItemId = MovementItem.Id
                                                    AND MIFloat_Remains.DescId = zc_MIFloat_Remains()

                    WHERE MovementItem.Amount > COALESCE (MIFloat_Remains.ValueData, 0)
                   )
          -- Возврвты поставщику
        , tmpMovementReturnOut AS (SELECT Movement.*
                                        , MovementLinkObject_Unit.ObjectId AS UnitId
                                   FROM Movement 
                                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_From()
                                        INNER JOIN tmpUnit ON tmpUnit.UnitId = MovementLinkObject_Unit.ObjectId
                                   WHERE Movement.OperDate BETWEEN inStartDate - INTERVAL '1 MONTH' AND inEndDate + INTERVAL '1 MONTH'
                                     AND Movement.DescId = zc_Movement_ReturnOut()
                                   )
          -- строчная часть возвратов поставщику
        , tmpMIReturnOut AS (SELECT MovementItem.Id            AS Id
                                  , MovementItem.MovementId    AS MovementId
                                  , tmpMovement.UnitId         AS UnitId
                                  , MovementItem.ObjectId      AS GoodsId
                                  , MovementItem.Amount        AS Amount
  
                             FROM tmpMovementReturnOut AS tmpMovement 
                            
                                  INNER JOIN MovementItem ON MovementItem.MovementId =  tmpMovement.Id
                                                         AND MovementItem.DescId     = zc_MI_Master()
                                                         AND MovementItem.isErased  = FALSE                                                
                                 
                            )
        , tmpMIPresumably AS (SELECT tmpMovement.*                                AS OperDate

                                   , tmpMI.ID                                     AS MovementItemId
                                   , tmpMI.GoodsId
                                   
                                   , tmpMIReturnOut.Id                            AS MovementItemROId
                                   , tmpMIReturnOut.MovementId                    AS MovementROId

                               FROM tmpMovement AS tmpMovement
                                    
                                    INNER JOIN tmpMI ON tmpMI.MovementId =  tmpMovement.Id
                                    
                                    INNER JOIN tmpMIReturnOut ON tmpMIReturnOut.GoodsId = tmpMI.GoodsId
                                                             AND tmpMIReturnOut.UnitId = tmpMI.UnitId)
        , tmpMIProtocol AS (SELECT tmpMIPresumably.MovementItemId,
                                   MIN(MovementItemProtocol.OperDate)::TDateTime AS OperDate
                            FROM tmpMIPresumably
                                 INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = tmpMIPresumably.MovementItemId
                            GROUP BY tmpMIPresumably.MovementItemId)
        , tmpProtocolROAll AS (SELECT ROW_NUMBER() OVER (PARTITION BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate) AS Ord,
                                      MovementProtocol.MovementId,
                                      MovementProtocol.OperDate,
                                      case when MovementProtocol.ProtocolData like '%"Статус" FieldValue = "Проведен"%' THEN 1 
                                           when MovementProtocol.ProtocolData like '%"Статус" FieldValue = "Удален"%' THEN -1 
                                           ELSE 0 END AS Status,
                                      case when MovementProtocol.ProtocolData like '%Отложен" FieldValue = "true%' THEN 1 
                                           ELSE 0 END AS Postponed
                                FROM (SELECT tmpMIPresumably.MovementROId AS ID FROM tmpMIPresumably) AS tmpMovement
                                     INNER JOIN MovementProtocol ON MovementProtocol.MovementId = tmpMovement.Id)
        , tmpProtocolRO AS (SELECT tmpProtocol.*,
                                   COALESCE (tmpProtocolNext.OperDate, zc_DateEnd()) AS OperDateEnd
                                FROM tmpProtocolROAll AS tmpProtocol
                                    
                                     LEFT JOIN tmpProtocolROAll AS tmpProtocolNext
                                                                ON tmpProtocolNext.MovementId = tmpProtocol.MovementId
                                                               AND tmpProtocolNext.Ord = tmpProtocol.Ord + 1 
                                )
        , tmpMIBust AS (SELECT tmpMIPresumably.*
                              
                        FROM tmpMIPresumably

                             INNER JOIN tmpMIProtocol ON tmpMIProtocol.MovementItemId = tmpMIPresumably.MovementItemId
                             
                             INNER JOIN tmpProtocolRO ON tmpProtocolRO.MovementId = tmpMIPresumably.MovementROId
                                                     AND tmpProtocolRO.OperDate <= tmpMIProtocol.OperDate
                                                     AND tmpProtocolRO.OperDateEnd > tmpMIProtocol.OperDate
                                                     AND tmpProtocolRO.Status = 0
                                                    -- AND tmpProtocolRO.Postponed = 1
                             
                        )
        , tmpMIReturnOutGroup AS (SELECT DISTINCT tmpMIBust.UnitId
                                       , tmpMIBust.GoodsId
                                  FROM tmpMIBust)
                              
       -- Результат
       SELECT
             tmpMovement.Id                                       AS Id
           , tmpMovement.InvNumber                                AS InvNumber
           , tmpMovement.OperDate                                 AS OperDate
           , tmpProtocol.OperDateStatus                           AS OperDateStatus
           , Object_Status.ObjectCode                             AS StatusCode
           , Object_Status.ValueData                              AS StatusName
           , tmpMovement.UnitId                                   AS UnitId
           , Object_Unit.ObjectCode                             AS StatusCode
           , Object_Unit.ValueData                              AS StatusName

           , tmpMI.GoodsId
           , Object_Goods.ObjectCode                             AS StatusCode
           , Object_Goods.ValueData                              AS StatusName
           , tmpMI.Amount
           , tmpMI.Remains

       FROM tmpMovement AS tmpMovement
            
            INNER JOIN tmpMI ON tmpMI.MovementId =  tmpMovement.Id
            
            INNER JOIN tmpMIReturnOutGroup ON tmpMIReturnOutGroup.GoodsId = tmpMI.GoodsId
                                          AND tmpMIReturnOutGroup.UnitId = tmpMI.UnitId  
                                                              
            LEFT JOIN tmpProtocol ON tmpProtocol.MovementId = tmpMovement.Id

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId
            
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMI.GoodsId
            

            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_Inventory_ProficitReturnOut (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.07.22                                                       *
*/

-- тест
-- 
SELECT * FROM gpReport_Inventory_ProficitReturnOut (inStartDate:= '01.06.2022', inEndDate:= '30.07.2022', inSession:= '2')
