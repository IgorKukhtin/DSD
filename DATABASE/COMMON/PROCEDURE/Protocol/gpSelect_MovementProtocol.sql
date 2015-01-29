
-- Function: gpSelect_Protocol() 

DROP FUNCTION IF EXISTS gpSelect_MovementProtocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementProtocol(
    IN inStartDate       TDateTime , -- 
    IN inEndDate         TDateTime , --
    IN inUserId          Integer,    -- пользователь  
    IN inMovementDescId  Integer,    -- тип объекта
    IN inMovementId      Integer,    -- объект
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, ProtocolData Text, UserName TVarChar, 
               InvNumber TVarChar, MovementOperDate TDateTime, MovementDescName TVarChar)
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName
  FROM MovementProtocol 
  JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
  JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND (Movement.Id = inMovementId OR 0 = inMovementId)
   AND (Movement.DescId = inMovementDescId OR inMovementDescId = 0)
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
 WHERE MovementProtocol.OperDate BETWEEN inStartDate AND inEndDate;

--inUserId        Integer,    -- пользователь  
  --  IN inObjectDescId  Integer,    -- тип объекта

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementProtocol (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.01.15         *
 14.02.14                         *  

*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inSession:= '2'); 
                                                                
--select * from gpSelect_MovementProtocol(inStartDate := ('01.05.2013')::TDateTime , inEndDate := ('01.05.2015')::TDateTime , inUserId := 0 , inMovementDescId := 0 , inMovementId :=  354233 ,  inSession := '5');