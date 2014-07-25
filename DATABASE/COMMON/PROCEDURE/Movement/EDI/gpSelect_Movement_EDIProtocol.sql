-- Function: gpSelect_Movement_EDIProtocol()

DROP FUNCTION IF EXISTS gpSelect_Movement_EDIProtocol (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_EDIProtocol(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
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
              FROM (SELECT Movement.Id
                         , XPATH ('/XML/EDIEvent/@Value', MovementProtocol.ProtocolData :: XML) AS X
                         , MovementProtocol.OperDate
                         , MovementProtocol.UserId
                    FROM MovementProtocol
                         JOIN Movement ON Movement.DescId = zc_Movement_EDI()
                                      AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                      AND Movement.Id = MovementProtocol.MovementId
                    WHERE MovementProtocol.isInsert IS NULL
                   ) AS MovementProtocolData
             ) AS MovementProtocolData
             LEFT JOIN Object AS Object_User ON Object_User.Id = MovementProtocolData.UserId; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_EDIProtocol (TDateTime, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.06.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_MI_EDI (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MI_EDI (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
