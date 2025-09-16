-- Function: lpInsertUpdate_Movement_StaffListMember ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_StaffListMember (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_StaffListMember(
 INOUT ioId                  Integer   , -- Ключ объекта <Документ>
    IN inInvNumber           TVarChar  , -- Номер документа
    IN inOperDate            TDateTime , -- Дата документа
    IN inMemberId            Integer   , -- 
    IN inPositionId          Integer   , --
    IN inPositionLevelId     Integer   , --
    IN inUnitId              Integer   , --
    IN inPositionId_old      Integer   , --
    IN inPositionLevelId_old Integer   , --
    IN inUnitId_old          Integer   , --
    IN inReasonOutId         Integer   , --
    IN inStaffListKindId     Integer   , --
    IN inisOfficial          Boolean   , --
    IN inisMain              Boolean   , --
    IN inComment             TVarChar  , --
    IN inUserId              Integer     -- Пользователь
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- 1. Распроводим Документ
     IF ioId > 0
     THEN
         -- сначала распроведение
         PERFORM gpUnComplete_Movement_StaffListMember (inMovementId := ioId
                                                      , inSession    := inUserId :: TVarChar
                                                       );
     END IF;
     
     -- определяем признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Документ>
     ioId := lpInsertUpdate_Movement (ioId, zc_Movement_StaffListMember(), inInvNumber, inOperDate, NULL);
    
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Member(), ioId, inMemberId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Position(), ioId, inPositionId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Position_old(), ioId, inPositionId_old);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PositionLevel_old(), ioId, inPositionLevelId_old);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit_old(), ioId, inUnitId_old);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ReasonOut(), ioId, inReasonOutId);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Official(), ioId, inisOfficial);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Main(), ioId, inisMain);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

     
     IF vbIsInsert = TRUE
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
     ELSE
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
     END IF;


     -- 5.2. потом проводим Документ + сохранили протокол
     PERFORM gpComplete_Movement_StaffListMember (inMovementId := ioId
                                                , inSession    := inUserId :: TVarChar
                                                 );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.25         *
*/

-- тест
--