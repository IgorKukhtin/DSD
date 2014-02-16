-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocol (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemProtocol(
    IN inMovementId    Integer,    -- Документ  
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, ProtocolData TVarChar, UserName TVarChar, MovementItemId Integer)
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Fuel());

  RETURN QUERY 
  SELECT 
     MovementItemProtocol.OperDate,
     MovementItemProtocol.ProtocolData::TVarChar,
     Object_User.ValueData AS UserName,
     MovementItemProtocol.MovementItemId
  FROM MovementItem
       JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
       JOIN Object AS Object_User ON Object_User.Id = ObjectProtocol.UserId
 WHERE MovementItem.MovementId = inMovementId;

--inUserId        Integer,    -- пользователь  
  --  IN inObjectDescId  Integer,    -- тип объекта

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItemProtocol (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.02.14                         *  
*/

-- тест
-- SELECT * FROM gpReport_Fuel (inStartDate:= '01.01.2013', inEndDate:= '01.02.2013', inFuelId:= null, inCarId:= null, inSession:= '2'); 
                                                                
