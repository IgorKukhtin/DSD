-- Function: gpInsertUpdate_MovementItem_ProductionUnion()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ProductionUnion(Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ProductionUnion(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inObjectId            Integer   , -- Лодка/ Комплектующие
    IN inReceiptProdModelId  Integer   , -- 
    IN inAmount              TFloat    , -- Количество
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
     vbUserId := lpGetUserBySession (inSession);


     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- сохранили <Элемент документа>
     SELECT tmp.ioId
            INTO ioId 
     FROM lpInsertUpdate_MovementItem_ProductionUnion (ioId
                                          , inMovementId
                                          , inObjectId
                                          , inReceiptProdModelId
                                          , inAmount
                                          , inComment
                                          , vbUserId
                                          ) AS tmp;


     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.07.21         *
*/

-- тест
--