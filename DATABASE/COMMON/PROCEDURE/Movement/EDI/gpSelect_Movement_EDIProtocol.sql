-- Function: gpSelect_Movement_EDIProtocol()

DROP FUNCTION IF EXISTS gpSelect_Movement_EDIProtocol (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_EDIProtocol (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_EDIProtocol(
    IN inMovementId  Integer , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId Integer, OperDate TDateTime, ProtocolText TVarChar, UserName TVarChar)
AS
$BODY$
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ZakazInternal());

     RETURN QUERY 
       SELECT 
           MovementProtocolData.Id
         , MovementProtocolData.OperDate
         , MovementProtocolData.ProtocolText::TVarChar
         , Object_User.ValueData              AS UserName
        FROM (SELECT MovementProtocolData.Id
                   , x[1] AS ProtocolText
                   , MovementProtocolData.OperDate
                   , MovementProtocolData.UserId
              FROM (SELECT inMovementId AS Id
                         , XPATH ('/XML/EDIEvent/@Value', MovementProtocol.ProtocolData :: XML) AS X
                         , MovementProtocol.OperDate
                         , MovementProtocol.UserId
                    FROM MovementProtocol
                         
                    WHERE MovementProtocol.MovementId = inMovementId AND MovementProtocol.isInsert IS NULL
                   UNION ALL
                    SELECT inMovementId AS Id
                         , XPATH ('/XML/EDIEvent/@Value', MovementProtocol.ProtocolData :: XML) AS X
                         , MovementProtocol.OperDate
                         , MovementProtocol.UserId
                    FROM MovementProtocol_arc AS MovementProtocol
                         
                    WHERE MovementProtocol.MovementId = inMovementId AND MovementProtocol.isInsert IS NULL

                   UNION ALL
                    SELECT inMovementId AS Id
                         , XPATH ('/XML/EDIEvent/@Value', MovementProtocol.ProtocolData :: XML) AS X
                         , MovementProtocol.OperDate
                         , MovementProtocol.UserId
                    FROM MovementProtocol_arc_arc AS MovementProtocol
                         
                    WHERE MovementProtocol.MovementId = inMovementId AND MovementProtocol.isInsert IS NULL

                   ) AS MovementProtocolData
             ) AS MovementProtocolData
             LEFT JOIN Object AS Object_User ON Object_User.Id = MovementProtocolData.UserId; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_EDIProtocol (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.15                         *
 02.06.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_EDIProtocol (inMovementId:= 16092370, inSession:= zfCalc_UserAdmin())
