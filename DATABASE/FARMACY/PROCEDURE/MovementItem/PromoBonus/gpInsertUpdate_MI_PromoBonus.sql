-- Function: gpInsertUpdate_MI_PromoBonus()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PromoBonus (Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PromoBonus(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsId             Integer   , -- Товары
    IN inMIPromoId           Integer   , -- MI маркетингового контракта
    IN inAmount              TFloat    , -- Маркетинговый бонус
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    IF COALESCE (inAmount, 0) < 0 OR COALESCE (inAmount, 0) > 100
    THEN
        RAISE EXCEPTION 'Ошибка. Маркетинговый бонус должен быть в диапазоне от 0 до 100.';         
    END IF;


     -- сохранили
    ioId := lpInsertUpdate_MI_PromoBonus (ioId                 := ioId
                                        , inMovementId         := inMovementId
                                        , inGoodsId            := inGoodsId
                                        , inMIPromoId          := inMIPromoId
                                        , inAmount             := inAmount
                                        , inUserId             := vbUserId
                                         );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_PromoBonus (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 17.02.21                                                                      *
*/

-- тест
-- select * from gpInsertUpdate_MI_PromoBonus(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');