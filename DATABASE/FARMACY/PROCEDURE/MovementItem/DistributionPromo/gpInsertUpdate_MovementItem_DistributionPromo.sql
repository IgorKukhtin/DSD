-- Function: gpInsertUpdate_MovementItem_DistributionPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_DistributionPromo (Integer, Integer, Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_DistributionPromo(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inGoodsGroupId        Integer   , -- Группа товаров
    IN inIsChecked           Boolean   , -- отмечен
    IN inComment             TVarChar  , -- примечание
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    
    -- сохранили
    ioId := lpInsertUpdate_MovementItem_DistributionPromo (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inGoodsGroupId       := inGoodsGroupId
                                                      , inAmount             := (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat
                                                      , inComment            := inComment
                                                      , inUserId             := vbUserId
                                                      );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 02.12.20                                                       *
*/