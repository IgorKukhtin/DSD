-- Function: gpComplete_Movement_PromoTrade()

DROP FUNCTION IF EXISTS gpComplete_Movement_PromoTrade (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PromoTrade(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_PromoTrade());


    -- Проверили - Сумма, грн 
    IF EXISTS (SELECT 1
                   FROM (SELECT 1 AS x) AS xx
                        LEFT JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                              AND MovementItem.DescId     = zc_MI_Master()
                                              AND MovementItem.isErased   = FALSE
                        LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                                    ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Summ.DescId         = zc_MIFloat_Summ()
                   WHERE COALESCE (MIFloat_Summ.ValueData, 0) = 0
                  )
    THEN
        RAISE EXCEPTION 'Ошибка.В строчной части необходимо заполнить ячейку <Сумма,грн>.';
    END IF;


     -- проводим Документ + сохранили протокол
     PERFORM lpComplete_Movement_PromoTrade (inMovementId := inMovementId
                                           , inUserId     := vbUserId
                                            );
                                             
     -- пересчитали данные - История клиента
     PERFORM gpUpdate_Movement_PromoTradeHistory (inMovementId := inMovementId
                                                , inSession    := inSession
                                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.20         *
 */

-- тест
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalService (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
