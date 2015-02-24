
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
               InvNumber TVarChar, MovementOperDate TDateTime, MovementDescName TVarChar,
               isInsert Boolean)
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  IF inMovementId <> 0 AND EXISTS (SELECT Id FROM Movement WHERE Id = inMovementId AND DescId IN (zc_Movement_Cash(), zc_Movement_BankAccount(), zc_Movement_ProfitLossService(), zc_Movement_Service()))
  THEN
  RETURN QUERY 
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol 
  JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
  JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
 UNION ALL
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementItemDesc.ItemName AS MovementDescName,
     MovementItemProtocol.isInsert
  FROM MovementItemProtocol
  JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
  JOIN MovementItem ON MovementItem.Id = MovementItemProtocol.MovementItemId AND MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Master()
  JOIN MovementItemDesc ON MovementItemDesc.Id = MovementItem.DescId
  JOIN Movement ON Movement.Id = MovementItem.MovementId;

  ELSE

  IF inMovementId <> 0 
  THEN
  RETURN QUERY 
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol 
  JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
  JOIN Movement ON Movement.Id = MovementProtocol.MovementId AND Movement.Id = inMovementId
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId;

  ELSE

  RETURN QUERY 
  SELECT 
     MovementProtocol.OperDate,
     MovementProtocol.ProtocolData::Text,
     Object_User.ValueData,
     Movement.InvNumber, 
     Movement.OperDate, 
     MovementDesc.ItemName AS MovementDescName,
     MovementProtocol.isInsert
  FROM MovementProtocol 
  JOIN Object AS Object_User ON Object_User.Id = MovementProtocol.UserId
  JOIN Movement ON Movement.Id = MovementProtocol.MovementId
              AND (Movement.DescId = inMovementDescId OR inMovementDescId = 0)
  JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
 WHERE MovementProtocol.OperDate BETWEEN inStartDate AND inEndDate;

  END IF;
  END IF;

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