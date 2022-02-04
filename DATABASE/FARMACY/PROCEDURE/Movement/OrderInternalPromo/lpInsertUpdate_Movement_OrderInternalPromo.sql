-- Function: lpInsertUpdate_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, Tfloat, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, Tfloat,Tfloat, Tfloat, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, Tfloat,Tfloat, Tfloat, Tfloat, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, Tfloat,Tfloat, Tfloat, Tfloat, Integer, TVarChar, Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderInternalPromo(
 INOUT ioId                    Integer    , -- Ключ объекта <Документ>
    IN inInvNumber             TVarChar   , -- Номер документа
    IN inOperDate              TDateTime  , -- Дата документа
    IN inStartSale             TDateTime  , -- Дата начала продаж
    IN inAmount                Tfloat     , -- 
    IN inTotalSummPrice        TFloat     , -- итого сумма по ценам прайса
    IN inTotalSummSIP          TFloat     , -- итого сумма по ценам сип
    IN inTotalAmount           TFloat     , -- Крличество для распр.
    IN inRetailId              Integer    , -- Торг. сеть
    IN inComment               TVarChar   , -- Примечание
    IN inDaysGrace             Integer    , -- Дней отсрочки
    IN inUserId                Integer     -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate  := DATE_TRUNC ('DAY', inOperDate);
    inStartSale:= DATE_TRUNC ('DAY', inStartSale);

    -- определяем признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- сохранили <Документ>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderInternalPromo(), inInvNumber, inOperDate, NULL, 0);
    
    -- сохранили связь с <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailId);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPrice(), ioId, inTotalSummPrice);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummSIP(), ioId, inTotalSummSIP);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalAmount(), ioId, inTotalAmount);
    -- сохранили <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DaysGrace(), ioId, inDaysGrace);

    -- сохранили <Примечание>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
    -- сохранили протокол
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.19         *
*/