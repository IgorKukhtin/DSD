-- Function: gpUpdate_Scale_Movement_Status()

DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_Status (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement_Status(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Scale_MI_Erased());
     vbUserId:= lpGetUserBySession (inSession);



     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ Инвентаризация еще не сформирован.%Необходимо сначала закрыть взвешивание.', CHR (13);
     END IF;

     -- проверка
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> уже в статусе <%>.'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;

     -- проверка
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId <> zc_Enum_Status_UnComplete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ № <%> от <%> в статусе <%>.'
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT lfGet_Object_ValueData_sh (Movement.StatusId) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;

     -- проверка
     IF NOT EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Inventory())
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав проводить документ <%>%№ <%> от <%> .'
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , CHR (13)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;
     

     IF vbUserId NOT IN (2414368 -- ;2405;"Тихоненко Е.Н."
                       , 2118489 -- ;2382;"Кандела Л.А."
                       , 2687823 -- ;2434;"Хитрук О.М."
                       , 6527404 -- ;2785;"Бєлай Л.Ю."
                       , 300539 -- ;1040;"Прибега А.В."
                       , 8098596 -- ;2897;"Городсков О.В."
                       , 4103954 -- ;2558;"Скуратовская Т.В."
                        )
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав проводить документ <%>%№ <%> от <%> .'
                       , (SELECT MovementDesc.ItemName FROM Movement JOIN MovementDesc ON MovementDesc.Id = Movement.DescId WHERE Movement.Id = inMovementId)
                       , CHR (13)
                       , (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId)
                       , (SELECT zfConvert_DateToString (Movement.OperDate) FROM Movement WHERE Movement.Id = inMovementId)
                        ;
     END IF;

     -- Проводим Документ
     PERFORM gpComplete_Movement_Inventory (inMovementId     := inMovementId
                                          , inIsLastComplete := NULL
                                          , inSession        := inSession);


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.10.23                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_Movement_Status (inMovementId:= 0, inSession:= '5')
