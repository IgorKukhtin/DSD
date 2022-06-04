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

  -- проверка
  IF COALESCE (inMovementId, 0) = 0 THEN
     --RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
     RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Просмотр протокола недоступен.' :: TVarChar
                                           , inProcedureName := 'gpSelect_Protocol' :: TVarChar
                                           , inUserId        := inUserId
                                           );
  END IF;


  IF inMovementId <> 0 
  THEN
      -- Результат
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
             JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
         WHERE MovementProtocol.MovementId = inMovementId

        UNION ALL
            SELECT
               MovementItemProtocol.OperDate,
               MovementItemProtocol.ProtocolData::Text,
               Object_User.ValueData AS UserName,
               Movement.InvNumber, 
               Movement.OperDate, 
               MovementDesc.ItemName AS MovementDescName,
               TRUE  :: Boolean AS isInsert
            FROM MovementItem
                 JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                 JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
                 JOIN Movement ON Movement.Id = MovementItem.MovementId
                 JOIN MovementDesc ON MovementDesc.Id = Movement.DescId
            WHERE MovementItem.MovementId = inMovementId
        ;

  ELSE
      RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Просмотр протокола недоступен.' :: TVarChar
                                            , inProcedureName := 'gpSelect_Protocol' :: TVarChar
                                            , inUserId        := inUserId
                                             );

  END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.06.17         *
 27.01.15         *
 14.02.14                         *  

*/

-- тест
-- SELECT * FROM gpSelect_MovementProtocol (inStartDate:= NULL, inEndDate:= NULL, inUserId:= 0, inMovementDescId:= 0, inMovementId:=  354233, inSession := '5');
