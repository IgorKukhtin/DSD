-- Function: gpUpdateMI_OrderFinance_SignSB()

DROP FUNCTION IF EXISTS gpUpdateMI_OrderFinance_SignSB (Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdateMI_OrderFinance_SignSB (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMI_OrderFinance_SignSB(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId              Integer   , -- Ключ объекта <главный элемент>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inIsSign                Boolean   ,
    IN inComment_SB            TVarChar  ,
   OUT outTextSign             TVarChar  ,
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_OrderFinance_SB());

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;


     -- Проверка - <Виза СБ>
     IF EXISTS (SELECT FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_SignSB() AND MB.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка.Корректировка заблокирована.В документе установлена <Виза СБ>.';
     END IF;


     -- если нет чайлда - создаем
     IF COALESCE (ioId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не найден элемент для подтверждения.';
         -- сохранили <Элемент документа>
         /*ioId := lpInsertUpdate_MovementItem (ioId
                                            , zc_MI_Child()
                                            , NULL
                                            , inMovementId
                                            , (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = inParentId) ::TFloat  -- нет чайлда сохраняем сумму из мастера
                                            , inParentId
                                             );*/
     END IF;

     -- сохранили свойство <Согласован>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Sign(), ioId, inIsSign);

     -- сохранили свойство <Согласован>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment_SB(), ioId, inComment_SB);

     -- Результат
     outTextSign := (CASE WHEN inIsSign = TRUE THEN 'Погоджено'
                          WHEN inIsSign = FALSE THEN 'Не погоджено'
                          ELSE ''
                     END)::TVarChar;

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.26         *
*/

-- тест
--