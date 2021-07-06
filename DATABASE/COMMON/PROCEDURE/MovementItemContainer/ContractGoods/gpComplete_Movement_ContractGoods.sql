-- Function: gpComplete_Movement_ContractGoods()

DROP FUNCTION IF EXISTS gpComplete_Movement_ContractGoods (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ContractGoods(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ContractGoods());
      vbUserId:= lpGetUserBySession (inSession);

      -- проводим Документ + сохранили протокол
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_ContractGoods()
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