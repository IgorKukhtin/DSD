-- Function: gpReport_Check_OrderFine()

DROP FUNCTION IF EXISTS gpReport_Check_OrderFine (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_OrderFine(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer   ,
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusName TVarChar
             , UnitCode Integer, UnitName TVarChar
             , Fine TFloat
             , DateInsert TDateTime  
             , DateMessage TDateTime
             , DateConfirmed TDateTime
             , DateFine TDateTime
             , Processing TVarChar
             , PotentiallyFine TFloat
             , ConfirmedProcessing TVarChar
             , UkraineAlarmInterval TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;

    RETURN QUERY
    WITH tmpMovement AS (SELECT Movement.*
                         FROM MovementDate AS MovementDate_AccruedFine

                              INNER JOIN Movement ON Movement.ID = MovementDate_AccruedFine.MovementId
                                                 AND Movement.OperDate >= inStartDate
                                                 AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                               
                         WHERE MovementDate_AccruedFine.DescId = zc_MovementDate_Message()
                           AND MovementDate_AccruedFine.ValueData IS NOT NULL),
         tmpProtocol AS (SELECT MovementProtocol.*
                         FROM MovementProtocol 
                         WHERE MovementProtocol.MovementId IN (SELECT tmpMovement.Id FROM tmpMovement)),
         tmpProtocolInsert AS (SELECT tmpProtocol.MovementId 
                                    , MIN(tmpProtocol.OperDate)  AS OperDate
                               FROM tmpProtocol
                               GROUP BY tmpProtocol.MovementId),
         tmpProtocolFine AS (SELECT tmpProtocol.MovementId 
                                  , MIN(tmpProtocol.OperDate)  AS OperDate
                             FROM tmpProtocol
                             WHERE tmpProtocol.ProtocolData ILIKE '%Начислить штраф%'
                             GROUP BY tmpProtocol.MovementId),
         tmpProtocolConfirmed AS (SELECT tmpProtocol.MovementId 
                                       , MIN(tmpProtocol.OperDate)  AS OperDate
                                  FROM tmpProtocol
                                  WHERE tmpProtocol.ProtocolData ILIKE '%"Подтвержден"%'
                                  GROUP BY tmpProtocol.MovementId)

    SELECT Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , Object_Status.ValueData                   AS StatusName
         , Object_Unit.ObjectCode                    AS UnitCode
         , Object_Unit.ValueData                     AS UnitName
         , CASE WHEN COALESCE(MovementBoolean_AccruedFine.ValueData, False) = TRUE THEN 200 END::TFloat  AS Fine
         , tmpProtocolInsert.OperDate::TDateTime     AS DateInsert
         , MovementDate_Message.ValueData            AS DateMessage
         , tmpProtocolConfirmed.OperDate::TDateTime  AS DateConfirmed
         , tmpProtocolFine.OperDate::TDateTime       AS DateFine
         , to_char(tmpProtocolFine.OperDate - MovementDate_Message.ValueData, 'HH24:MI:SS')::TVarChar      AS Processing
         , CASE WHEN COALESCE(MovementBoolean_AccruedFine.ValueData, False) = FALSE THEN 200 END::TFloat   AS PotentiallyFine
         , to_char(tmpProtocolConfirmed.OperDate - MovementDate_Message.ValueData, 'HH24:MI:SS')::TVarChar AS ConfirmedProcessing
         , zfGet_UkraineAlarm_RangeInterval (MovementLinkObject_Unit.ObjectId, MovementDate_Message.ValueData, COALESCE(tmpProtocolFine.OperDate, tmpProtocolConfirmed.OperDate)::TDateTime, inSession) AS UkraineAlarmInterval
    FROM tmpMovement AS Movement 

         INNER JOIN MovementDate  AS MovementDate_Message
                                  ON MovementDate_Message.MovementId = Movement.Id
                                 AND MovementDate_Message.DescId = zc_MovementDate_Message()  

         INNER JOIN tmpProtocolConfirmed ON tmpProtocolConfirmed.MovementId = Movement.Id

         LEFT JOIN MovementBoolean AS MovementBoolean_AccruedFine
                                   ON MovementBoolean_AccruedFine.MovementId = Movement.Id
                                  AND MovementBoolean_AccruedFine.DescId = zc_MovementBoolean_AccruedFine()  

         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                     AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId  
         
         LEFT JOIN tmpProtocolInsert ON tmpProtocolInsert.MovementId = Movement.Id
         
         LEFT JOIN tmpProtocolFine ON tmpProtocolFine.MovementId = Movement.Id
    WHERE MovementDate_Message.ValueData + INTERVAL '31 MINUTE' < tmpProtocolConfirmed.OperDate
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Check_OrderFine (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.07.22                                                       *
*/

-- тест
-- 

select * from gpReport_Check_OrderFine(inStartDate := ('25.08.2022')::TDateTime , inEndDate := ('25.08.2022')::TDateTime , inUnitId := 0 ,  inSession := '3');