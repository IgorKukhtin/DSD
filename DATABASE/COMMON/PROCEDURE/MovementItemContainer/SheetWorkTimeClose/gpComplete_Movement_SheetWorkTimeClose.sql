-- Function: gpComplete_Movement_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS gpComplete_Movement_SheetWorkTimeClose (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_SheetWorkTimeClose(
    IN inMovementId        Integer                , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''      -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_SheetWorkTimeClose());
      vbUserId:= lpGetUserBySession (inSession);


      -- 
      IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete()) AND vbUserId <> 5
      THEN
          RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> уже в статусе <%>.'
                         , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                         , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                         , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                          ;
      END IF;

      -- проводим Документ + сохранили протокол
      PERFORM lpComplete_Movement (inMovementId := inMovementId
                                 , inDescId     := zc_Movement_SheetWorkTimeClose()
                                 , inUserId     := vbUserId
                                  );
      -- 
      IF vbUserId = 5
      THEN
          RAISE EXCEPTION 'Test - ok.Документ № <%> от <%> в статусе <%>.'
                         , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                         , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                         , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                          ;
      END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.21         *
 */

-- тест
--