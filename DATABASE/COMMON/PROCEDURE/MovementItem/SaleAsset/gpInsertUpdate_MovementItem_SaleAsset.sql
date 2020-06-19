-- Function: gpInsertUpdate_MovementItem_SaleAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SaleAsset (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SaleAsset(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inGoodsId               Integer   , -- Товары
    IN inContainerId           Integer   , -- Партия ОС
    IN inAmount                TFloat    , -- Количество
    IN inPrice                 TFloat    , -- Цена
 INOUT ioCountForPrice         TFloat    , -- Цена за количество
   OUT outAmountSumm           TFloat    , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SaleAsset());

     -- Заменили свойство <Цена за количество>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- сохранили
     ioId := lpInsertUpdate_MovementItem_SaleAsset (ioId          := ioId
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := inGoodsId
                                                  , inAmount      := inAmount
                                                  , inPrice         := inPrice
                                                  , inCountForPrice := ioCountForPrice
                                                  , inContainerId := inContainerId
                                                  , inUserId      := vbUserId
                                                   ) AS tmp;
     outAmountSumm := ( CASE WHEN COALESCE (ioCountForPrice, 1) > 0 THEN CAST ( COALESCE (inAmount, 0) * COALESCE (inPrice, 0) / COALESCE (ioCountForPrice, 1) AS NUMERIC (16, 2)) 
                             ELSE CAST ( COALESCE (inAmount, 0) * COALESCE (inPrice, 0) AS NUMERIC (16, 2))
                        END) ::TFloat;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.06.20         *
*/

-- тест
--