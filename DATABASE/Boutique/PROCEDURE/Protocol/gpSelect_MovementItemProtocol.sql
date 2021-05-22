-- Function: gpSelect_Protocol()

DROP FUNCTION IF EXISTS gpSelect_MovementItemProtocol (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItemProtocol(
    IN inStartDate           TDateTime , --
    IN inEndDate             TDateTime , --
    IN inUserId              Integer,    -- пользователь
    IN inMovementItemId      Integer,    -- Документ
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime, ProtocolData Text, UserName TVarChar, MovementItemId Integer)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItemProtocol());
     vbUserId:= lpGetUserBySession (inSession);

     -- проверка
     IF COALESCE (inMovementItemId, 0) = 0 THEN
        RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
     END IF;

     IF lpGetUnit_byUser (vbUserId) > 0 THEN
        RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
     END IF;


     IF inMovementItemId <> 0
     THEN
          -- Результат
          RETURN QUERY
            -- real-1
            SELECT
               MovementItemProtocol.OperDate,
               MovementItemProtocol.ProtocolData::Text,
               Object_User.ValueData AS UserName,
               MovementItemProtocol.MovementItemId
            FROM MovementItemProtocol
                 JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
            WHERE MovementItemProtocol.MovementItemId = inMovementItemId
           UNION ALL
            SELECT
               MovementItemProtocol.OperDate,
               MovementItemProtocol.ProtocolData::Text,
               Object_User.ValueData AS UserName,
               MovementItemProtocol.MovementItemId
            FROM MovementItem
                 JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                 JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
            WHERE MovementItem.ParentId = inMovementItemId

           UNION ALL
            SELECT
               MovementItemProtocol.OperDate,
               MovementItemProtocol.ProtocolData::Text,
               Object_User.ValueData AS UserName,
               MovementItemProtocol.MovementItemId
            FROM MovementItem
                 JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                 JOIN Object AS Object_User ON Object_User.Id = MovementItemProtocol.UserId
            WHERE MovementItem.MovementId IN (SELECT DISTINCT MovementItem.MovementId FROM MovementItem WHERE MovementItem.Id = inMovementItemId)
              AND MovementItem.DescId = zc_MI_Child()
              AND MovementItem.ParentId IS NULL
           ;

     ELSE
          RAISE EXCEPTION 'Ошибка.Просмотр протокола недоступен.';
     END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.01.15         *
 14.02.14                         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItemProtocol (inStartDate:= NULL, inEndDate:= NULL, inUserId:= NULL, inMovementItemId:= 1, inSession:= '5');
