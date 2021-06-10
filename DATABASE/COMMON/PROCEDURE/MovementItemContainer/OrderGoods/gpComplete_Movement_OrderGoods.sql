-- Function: gpComplete_Movement_OrderGoods()

DROP FUNCTION IF EXISTS gpComplete_Movement_OrderGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_OrderGoods(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_OrderGoods());
      vbUserId:= lpGetUserBySession (inSession);

      -- проводим Документ + сохранили протокол
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_OrderGoods()
                                 , inUserId     := vbUserId
                                  );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.06.21         *
 */

-- тест
--