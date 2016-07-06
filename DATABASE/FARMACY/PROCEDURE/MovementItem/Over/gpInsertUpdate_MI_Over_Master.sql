-- Function: gpInsertUpdate_MI_Over_Master()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Over_Master  (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Over_Master(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inRemains	     TFloat    , -- 
    IN inPrice	             TFloat    , -- 
    IN inMCS                 TFloat    , -- 
    IN inMinExpirationDate   TDateTime , -- 
    IN inComment             TVarChar  , --
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Over());

   -- сохранили <Элемент документа>
   ioId :=lpInsertUpdate_MI_Over_Master (ioId               := ioId
                                       , inMovementId       := inMovementId
                                       , inGoodsId          := inGoodsId
                                       , inAmount           := inAmount
                                       , inRemains          := inRemains
                                       , inPrice            := inPrice
                                       , inMCS              := inMCS
                                       , inMinExpirationDate := inMinExpirationDate
                                       , inComment          := inComment
                                       , inUserId           := vbUserId
                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.07.16         * 
 
*/

-- тест
-- 