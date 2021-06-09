-- Function: gpInsertUpdate_MovementItem_Send_Detail()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Send_Detail (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Send_Detail(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inParentId              Integer   , -- Ключ объекта <главный элемент>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inSubjectDocId_top      Integer   , -- 
    IN inReturnKindId_top      Integer   , -- 
    IN inSubjectDocId          Integer   , -- 
    IN inReturnKindId          Integer   , -- 
    IN inAmount                TFloat    , -- Количество
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());

     IF COALESCE (inSubjectDocId,0) = 0 AND COALESCE (inSubjectDocId_top,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не выбрано Основание для перемещения.';
     END IF;

     IF COALESCE (inReturnKindId,0) = 0 AND COALESCE (inReturnKindId_top,0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не выбран Тип перемещения.';
     END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;
 
     --Если добавляют новую строку нужно посчитать оставшееся кол-во по товару
     IF vbIsInsert = TRUE AND COALESCE (inAmount,0) = 0
     THEN
         SELECT (MovementItem.Amount - COALESCE (tmp.Amount,0)) AS Amount
        INTO inAmount
         FROM MovementItem
              INNER JOIN (SELECT SUM (MovementItem.Amount) AS Amount FROM MovementItem WHERE MovementItem.ParentId = inParentId) AS tmp ON 1 = 1
         WHERE MovementItem.Id = inParentId
         ;
     END IF;

     -- если не внесено в гриде значение берем из шапки
     IF COALESCE (inSubjectDocId,0) = 0
     THEN
         inSubjectDocId := inSubjectDocId_top;
     END IF;
     -- если не внесено в гриде значение берем из шапки
     IF COALESCE (inReturnKindId,0) = 0
     THEN
         inReturnKindId := inReturnKindId_top;
     END IF;
     

     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Detail(), inGoodsId, inMovementId, inAmount, inParentId);

     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_SubjectDoc(), ioId, inSubjectDocId);
     -- сохранили связь с <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_ReturnKind(), ioId, inReturnKindId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.04.21         *
*/

-- тест
--