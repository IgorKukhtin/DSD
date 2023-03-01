-- Function: gpInsert_MovementItem_AsinoPharmaSP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_AsinoPharmaSP (Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_AsinoPharmaSP(
 INOUT ioId                   Integer   , -- Ключ записи
    IN inMovementId           Integer   ,
    IN inGoodsId              Integer   , -- Товары
    IN inPriceOptSP           TFloat    ,
    IN inNDS                  TFloat    ,
   OUT outPriceSale           TFloat    ,

    IN inSession              TVarChar    -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbOperDate_StartBegin TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    outPriceSale := ROUND(inPriceOptSP *  1.1 * 1.1 * (1.0 + COALESCE(inNDS, 0) / 100), 2);  

    -- сохранить запись
    ioId := lpInsertUpdate_MovementItem_AsinoPharmaSP (ioId                  := COALESCE(ioId,0)
                                                    , inMovementId          := inMovementId
                                                    , inGoodsId             := inGoodsId
                                                    , inPriceOptSP          := inPriceOptSP
                                                    , inPriceSale           := outPriceSale
                                                    , inUserId              := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.22                                                       *
*/
--