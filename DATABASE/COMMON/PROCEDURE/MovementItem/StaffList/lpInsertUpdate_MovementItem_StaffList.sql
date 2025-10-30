-- Function: lpInsertUpdate_MovementItem_StaffList()
  
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_StaffList (Integer, Integer, Integer,Integer, Integer, Integer,Integer, Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_StaffList (Integer, Integer, Integer,Integer, Integer, Integer,Integer, Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_StaffList (Integer, Integer, Integer,Integer, Integer, Integer,Integer, Integer, Integer, TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat,TFloat, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_StaffList(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , --
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , --
    IN inPersonalId            Integer   , -- 
    IN inStaffPaidKindId       Integer   , -- 
    IN inStaffHoursDayId       Integer   , -- 
    IN inStaffHoursId          Integer   , -- 
    IN inStaffHoursLengthId    Integer   , -- 
    IN inAmount                TFloat    , --
    IN inAmountReport          TFloat    , --
    IN inStaffCount_1          TFloat    , --
    IN inStaffCount_2          TFloat    , --
    IN inStaffCount_3          TFloat    , --
    IN inStaffCount_4          TFloat    , --
    IN inStaffCount_5          TFloat    , --
    IN inStaffCount_6          TFloat    , --
    IN inStaffCount_7          TFloat    , --
    IN inStaffCount_Invent     TFloat    , --
    IN inStaff_Price           TFloat    , --
    IN inStaff_Summ_MK         TFloat    , --
    IN inStaff_Summ_MK3        TFloat    , --
    IN inStaff_Summ_MK6        TFloat    , --
    IN inStaff_Summ_real       TFloat    , --
    IN inStaff_Summ_add        TFloat    , --
    IN inStaff_Summ_total_real  TFloat    , --
    IN inStaff_Summ_total_add   TFloat    , --
    IN inComment               TVarChar  , -- 
    IN inUserId                Integer     -- пользователь
)                               
RETURNS Integer AS               
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ не сохрнен.';
     END IF;
     -- проверка
     IF COALESCE (inPositionId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не заполнено значение <ДОлжность>.';
     END IF;
    
     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPositionId, inMovementId, inAmount, NULL);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountReport(), ioId, inAmountReport);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_1(), ioId, inStaffCount_1);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_2(), ioId, inStaffCount_2);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_3(), ioId, inStaffCount_3);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_4(), ioId, inStaffCount_4);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_5(), ioId, inStaffCount_5);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_6(), ioId, inStaffCount_6);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_7(), ioId, inStaffCount_7);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_StaffCount_Invent(), ioId, inStaffCount_Invent);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Price(), ioId, inStaff_Price);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_MK(), ioId, inStaff_Summ_MK);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_MK_3(), ioId, inStaff_Summ_MK3);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_MK_6(), ioId, inStaff_Summ_MK6);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_real(), ioId, inStaff_Summ_real);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_add(), ioId, inStaff_Summ_add);

     -- Преміальний фонд(для 1-єї шт.од)
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_total_real(), ioId, inStaff_Summ_total_real);
     -- Преміальний фонд(загальна сума)
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Staff_Summ_total_add(), ioId, inStaff_Summ_total_add);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffPaidKind(), ioId, inStaffPaidKindId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffHoursDay(), ioId, inStaffHoursDayId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffHours(), ioId, inStaffHoursId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_StaffHoursLength(), ioId, inStaffHoursLengthId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Personal(), ioId, inPersonalId);
     
     
     -- пересчитали Итоговые суммы по накладной
     --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.10.25         * Staff_Summ_MK3, Staff_Summ_MK6
 20.08.25         *
*/

-- тест
-- 