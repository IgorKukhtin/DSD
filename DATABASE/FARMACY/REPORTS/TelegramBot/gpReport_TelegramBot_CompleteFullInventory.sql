-- Function: gpReport_TelegramBot_CompleteFullInventory()

DROP FUNCTION IF EXISTS gpReport_TelegramBot_CompleteFullInventory (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TelegramBot_CompleteFullInventory(
    IN inOperDate      TDateTime ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Message Text             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMessage Text;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    vbUserId:= lpGetUserBySession (inSession);
    
    WITH tmpInventory AS (SELECT Movement.Id
                               , Object_Unit.ObjectCode AS UnitCode
                               , Object_Unit.ValueData AS UnitName
                          FROM Movement 
                                            
                               INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                            
                               INNER JOIN MovementBoolean AS MovementBoolean_FullInvent
                                                          ON MovementBoolean_FullInvent.MovementId = Movement.Id
                                                         AND MovementBoolean_FullInvent.DescId = zc_MovementBoolean_FullInvent()
                                                         AND MovementBoolean_FullInvent.ValueData = TRUE
                                                            
                               INNER JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId 
                               
                          WHERE Movement.OperDate >= inOperDate - INTERVAL '5 DAY'
                            AND Movement.DescId = zc_Movement_Inventory() 
                            AND Movement.StatusId = zc_Enum_Status_Complete())
       , tmpProtocol AS (SELECT Movement.ID
                              , MovementProtocol.OperDate
                              , MovementProtocol.UserId
                              , ROW_NUMBER() OVER (PARTITION BY Movement.ID ORDER BY MovementProtocol.OperDate DESC) AS Ord
                          FROM tmpInventory AS Movement

                               INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                                          AND MovementProtocol.ProtocolData ilike '%"Проведен"%')
                                                          
    SELECT string_agg('Аптека: '||Movement.UnitName, CHR(13))
    INTO vbMessage
    FROM tmpInventory AS Movement
    
         INNER JOIN tmpProtocol ON tmpProtocol.Id = Movement.ID
                               AND tmpProtocol.Ord = 1
                               AND tmpProtocol.OperDate >= inOperDate - INTERVAL '45 MIN'
    
    ;
      
    IF COALESCE (vbMessage, '') <> ''
    THEN
      RETURN QUERY
      SELECT 'Закончилось проведение полной инвентаризации:'||CHR(13)||CHR(13)||vbMessage;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В. 
 06.04.22                                                       * 
*/

-- тест
-- 

SELECT * FROM gpReport_TelegramBot_CompleteFullInventory('05.08.2023 20:29:37', '3');