DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TaxFromMedoc (integer, TVarChar, TVarChar, tfloat, tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TaxFromMedoc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsName           TVarChar  , -- Товары
    IN inMeasureName         TVarChar  , -- Единица измерения
    IN inAmount              TFloat    , -- Количество
    IN inSumm                TFloat    , -- Сумма по позиции
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsExternalId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Tax());

     -- Ищем товар. Если не нашли - вставляем
     
     SELECT Id INTO vbGoodsExternalId FROM Object WHERE DescId = zc_ObjectExternal() AND ValueData = inGoodsName;

     IF COALESCE(vbGoodsExternalId, 0) = 0 THEN
        vbGoodsExternalId := lpInsertUpdate_Object (vbGoodsExternalId, zc_ObjectExternal(), 0, inGoodsName);
     END IF;

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_Tax (ioId              := ioId
                                         , inMovementId         := inMovementId
                                         , inGoodsId            := vbGoodsExternalId
                                         , inAmount             := inAmount
                                         , inPrice              := (inSumm / inAmount)
                                         , ioCountForPrice      := 1
                                         , inGoodsKindId        := NULL
                                         , inUserId             := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 16.04.15                         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Tax (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')