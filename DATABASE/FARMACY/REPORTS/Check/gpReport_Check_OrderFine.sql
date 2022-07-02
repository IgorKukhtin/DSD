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
             , DateFine TDateTime
             , Processing TVarChar
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
                         FROM MovementBoolean AS MovementBoolean_AccruedFine

                              INNER JOIN Movement ON Movement.ID = MovementBoolean_AccruedFine.MovementId
                                                 AND Movement.OperDate >= inStartDate
                                                 AND Movement.OperDate < inEndDate + INTERVAL '1 DAY'
                               
                         WHERE MovementBoolean_AccruedFine.DescId = zc_MovementBoolean_AccruedFine()
                           AND MovementBoolean_AccruedFine.ValueData = True),
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
                             GROUP BY tmpProtocol.MovementId)

    SELECT Movement.Id
         , Movement.InvNumber
         , Movement.OperDate
         , Object_Status.ValueData                 AS StatusName
         , Object_Unit.ObjectCode                  AS UnitCode
         , Object_Unit.ValueData                   AS UnitName
         , 200::TFloat                             AS Fine
         , tmpProtocolInsert.OperDate::TDateTime   AS DateInsert
         , MovementDate_Message.ValueData          AS DateMessage
         , tmpProtocolFine.OperDate::TDateTime     AS DateFine
         , to_char(tmpProtocolFine.OperDate - MovementDate_Message.ValueData, 'HH24:MI:SS')::TVarChar AS Processing
    FROM tmpMovement AS Movement 

         INNER JOIN MovementDate  AS MovementDate_Message
                                  ON MovementDate_Message.MovementId = Movement.Id
                                 AND MovementDate_Message.DescId = zc_MovementDate_Message()  

         LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
                                     AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
         LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId  
         
         LEFT JOIN tmpProtocolInsert ON tmpProtocolInsert.MovementId = Movement.Id
         
         LEFT JOIN tmpProtocolFine ON tmpProtocolFine.MovementId = Movement.Id
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
SELECT * FROM gpReport_Check_OrderFine ('01.07.2022', '21.07.2022', 0, '3')
