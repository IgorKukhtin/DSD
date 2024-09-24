-- Function: lpComplete_Movement_PromoTrade (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PromoTrade (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PromoTrade(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
BEGIN

     -- проверка
     IF EXISTS (SELECT 1 FROM gpSelect_Movement_PromoTradeSign (inMovementId:= inMovementId, inSession:= inUserId :: TVarChar) AS gpSelect WHERE gpSelect.ValueId IS NULL)
     THEN
          RAISE EXCEPTION 'Ошибка.Не заполнено ФИО для согласования % %.'
                        , CHR (13)
                        , (SELECT gpSelect.Name FROM gpSelect_Movement_PromoTradeSign (inMovementId:= inMovementId, inSession:= inUserId :: TVarChar) AS gpSelect WHERE gpSelect.ValueId IS NULL ORDER BY gpSelect.Ord LIMIT 1)
                         ;
     END IF;

     -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PromoTrade()
                                , inUserId     := inUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.20         *
*/

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PromoTrade (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
