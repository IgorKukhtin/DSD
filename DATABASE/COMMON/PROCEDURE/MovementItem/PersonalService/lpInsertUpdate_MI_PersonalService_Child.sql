-- Function: lpInsertUpdate_MI_PersonalService_Child()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PersonalService_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PersonalService_Child (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_PersonalService_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inParentId            Integer   , -- Главный элемент документа
    IN inMemberId            Integer   , -- 
    IN inPositionLevelId     Integer   , -- 
    IN inStaffListId         Integer   , -- 
    IN inModelServiceId      Integer   , -- 
    IN inStaffListSummKindId Integer   , -- 

    IN inAmount              TFloat    , -- 
    IN inMemberCount         TFloat    , -- 
    IN inDayCount            TFloat    , -- 
    IN inWorkTimeHoursOne   TFloat    , -- 
    IN inWorkTimeHours       TFloat    , -- 
    IN inPrice               TFloat    , -- 
    IN inHoursPlan           TFloat    , -- 
    IN inHoursDay            TFloat  , -- 
    IN inPersonalCount       TFloat    , -- 
    IN inGrossOne            TFloat  , -- 
    IN inKoeff               TFloat  , -- 

    IN inUserId              Integer     -- пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка - связанные документы Изменять нельзя
     -- PERFORM lfCheck_Movement_Parent (inMovementId:= inMovementId, inComment:= 'изменение');


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Child(), inMemberId, inMovementId, inAmount, inParentId, inUserId);
   
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MemberCount(), ioId, inMemberCount);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_DayCount(), ioId, inDayCount);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WorkTimeHoursOne(), ioId, inWorkTimeHoursOne);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_WorkTimeHours(), ioId, inWorkTimeHours);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HoursPlan(), ioId, inHoursPlan);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_HoursDay(), ioId, inHoursDay);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PersonalCount(), ioId, inPersonalCount);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_GrossOne(), ioId, inGrossOne);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Koeff(), ioId, inKoeff);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffList(), ioId, inStaffListId );
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ModelService(), ioId, inModelServiceId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffListSummKind(), ioId, inStaffListSummKindId);


     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.11.21         *
 22.06.16         *
*/

-- тест
-- SELECT * FROM lpInsertUpdate_MI_PersonalService_Child (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
