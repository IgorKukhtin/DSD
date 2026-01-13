-- Function: gpUpdate_Scale_Movement_PersonalComlete()

-- DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_PersonalComlete (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
-- DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_PersonalComlete (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_PersonalComlete (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Scale_Movement_PersonalComlete (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Scale_Movement_PersonalComlete(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPersonalId1         Integer   , -- Ключ объекта
    IN inPersonalId2         Integer   , -- Ключ объекта
    IN inPersonalId3         Integer   , -- Ключ объекта
    IN inPersonalId4         Integer   , -- Ключ объекта
    IN inPersonalId5         Integer   , -- Ключ объекта
    IN inPersonalId6         Integer   , -- Ключ объекта
    IN inPersonalId7         Integer   , -- Ключ объекта
    IN inPersonalId8         Integer   , -- Ключ объекта
    IN inPositionId1         Integer   , -- Ключ объекта
    IN inPositionId2         Integer   , -- Ключ объекта
    IN inPositionId3         Integer   , -- Ключ объекта
    IN inPositionId4         Integer   , -- Ключ объекта
    IN inPositionId5         Integer   , -- Ключ объекта
    IN inPositionId6         Integer   , -- Ключ объекта
    IN inPositionId7         Integer   , -- Ключ объекта
    IN inPositionId8         Integer   , -- Ключ объекта
    IN inPersonalId1_Stick   Integer   , -- Ключ объекта
    IN inPositionId1_Stick   Integer   , -- Ключ объекта
    IN inSession             TVarChar    -- сессия пользователя
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Scale_Movement_check());
     vbUserId:= lpGetUserBySession (inSession);


     -- сохранили связь с <Сотрудник комплектовщик 1>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalComplete1(), inMovementId, inPersonalId1);
     -- сохранили связь с <Сотрудник комплектовщик 2>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalComplete2(), inMovementId, inPersonalId2);
     -- сохранили связь с <Сотрудник комплектовщик 3>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalComplete3(), inMovementId, inPersonalId3);
     -- сохранили связь с <Сотрудник комплектовщик 4>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalComplete4(), inMovementId, inPersonalId4);
     -- сохранили связь с <Сотрудник комплектовщик 5>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalComplete5(), inMovementId, inPersonalId5);

     -- сохранили связь с <Сотрудник комплектовщик 6>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalComplete6(), inMovementId, inPersonalId6);
     -- сохранили связь с <Сотрудник комплектовщик 7>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalComplete7(), inMovementId, inPersonalId7);
     -- сохранили связь с <Сотрудник комплектовщик 8>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalComplete8(), inMovementId, inPersonalId8);


     -- сохранили связь с <Должность комплектовщик 1>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionComplete1(), inMovementId, inPositionId1);
     -- сохранили связь с <Должность комплектовщик 2>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionComplete2(), inMovementId, inPositionId2);
     -- сохранили связь с <Должность комплектовщик 3>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionComplete3(), inMovementId, inPositionId3);
     -- сохранили связь с <Должность комплектовщик 4>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionComplete4(), inMovementId, inPositionId4);
     -- сохранили связь с <Должность комплектовщик 5>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionComplete5(), inMovementId, inPositionId5);

     -- сохранили связь с <Должность комплектовщик 6>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionComplete6(), inMovementId, inPositionId6);
     -- сохранили связь с <Должность комплектовщик 7>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionComplete7(), inMovementId, inPositionId7);
     -- сохранили связь с <Должность комплектовщик 8>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionComplete8(), inMovementId, inPositionId8);


     -- сохранили связь с <Сотрудник Стикеровщик 1>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PersonalStick1(), inMovementId, inPersonalId1_Stick);
     -- сохранили связь с <Должность Стикеровщик 1>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionStick1(), inMovementId, inPositionId1_Stick);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.01.26         *
 30.04.19                                        *
 18.05.15                                        *
*/

-- тест
-- SELECT * FROM gpUpdate_Scale_Movement_PersonalComlete (inMovementId:= 0, inSession:= '2')
