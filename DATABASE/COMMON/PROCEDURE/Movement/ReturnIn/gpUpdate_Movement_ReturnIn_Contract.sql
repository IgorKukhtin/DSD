-- Function: gpUpdate_Movement_ReturnIn_Contract()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnIn_Contract (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnIn_Contract(
    IN inMovementId        Integer               , -- ключ Документа
    IN inContractId        Integer               , --
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_ReturnIn_Contract());

     -- сохранили связь с <Договора>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), inMovementId, inContractId);

     -- Распроводим Документ
     PERFORM gpReComplete_Movement_ReturnIn (inMovementId     := inMovementId
                                           , inStartDateSale  := NULL
                                           , inIsLastComplete := NULL
                                           , inUserId         := zc_Enum_Process_Auto_ReComplete());

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 12.09.16         *
*/

-- тест
-- SELECT gpUpdate_Movement_ReturnIn_Contract (inMovementId:= Movement.Id, inContractId:=0, inUserId:= zfCalc_UserAdmin())
