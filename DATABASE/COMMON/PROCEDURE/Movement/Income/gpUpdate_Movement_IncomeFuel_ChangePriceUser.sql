-- Function: gpUpdate_Movement_IncomeFuel_ChangePriceUser()

DROP FUNCTION IF EXISTS gpUpdate_Movement_IncomeFuel_ChangePriceUser (Integer, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_IncomeFuel_ChangePriceUser(
    IN inId                  Integer   , -- Ключ объекта <Документ>
    IN inChangePrice         TFloat    , -- Скидка в цене
    IN inIsChangePriceUser   Boolean   , -- Ручная скидка в цене (да/нет)
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     IF EXISTS (SELECT 1  FROM  MovementLinkObject AS MLO WHERE MLO.MovementId = inId AND MLO.DescId = zc_MovementLinkObject_PaidKind() AND MLO.ObjectId = zc_Enum_PaidKind_SecondForm())
     THEN vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_IncomeFuel_ChangePriceUserSF());
     ELSE vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_IncomeFuel_ChangePriceUser());
     END IF;

     -- текущий статус документа
     vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inId);
     
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
         --распроводим документ
         PERFORM lpUnComplete_Movement (inMovementId := inId
                                      , inUserId     := vbUserId);
     END IF;

     -- сохранили свойство <Ручная скидка в цене (да/нет)>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ChangePriceUser(), inId, inIsChangePriceUser);
     
     -- сохранили свойство <Скидка в цене>
     PERFORM lpInsertUpdate_MovemenTFloat (zc_MovemenTFloat_ChangePrice(), inId, inChangePrice);


     -- 5.3. проводим Документ
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN
          -- создаются временные таблицы - для формирование данных для проводок
          PERFORM lpComplete_Movement_Income_CreateTemp();
          -- Проводим Документ
          PERFORM lpComplete_Movement_Income (inMovementId     := inId
                                            , inUserId         := vbUserId
                                            , inIsLastComplete := TRUE
                                             );
     ELSE
          PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);
     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.22         *
*/

-- тест
--