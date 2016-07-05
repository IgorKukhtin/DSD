-- Function: gpInsertUpdate_MovementItem_Income()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_ver2(Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_ver2(
 INOUT ioId                  Integer   , -- Ключ объекта <строка документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPrice               TFloat    , -- Цена
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbReserve TFloat;
   DECLARE vbRemains TFloat;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);


    -- Находим элемент по документу и товару
    IF (COALESCE(ioId,0) = 0)
       or
       (NOT EXISTS(SELECT 1 FROM MovementItem Where Id = ioId))       
    THEN
        SELECT 
            Id
        INTO 
            ioId
        FROM MovementItem
        WHERE MovementId = inMovementId 
          AND ObjectId = inGoodsId 
          AND DescId = zc_MI_Master();
    END IF;

     -- определяется признак Создание/Корректировка
     vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

    -- сохранили свойство <Цена>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), ioId, inPrice);
     
    -- пересчитали Итоговые суммы
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (inMovementId);

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_ver2(Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 03.11.2015                                                                      *
 07.08.2015                                                                      *
 26.05.15                        *
*/
