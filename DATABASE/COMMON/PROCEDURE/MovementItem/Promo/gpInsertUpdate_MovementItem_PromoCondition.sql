-- Function: gpInsertUpdate_MovementItem_PromoCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoCondition(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inConditionPromoId    Integer   , -- Ключ объекта <Условия участия>
    IN inAmount              TFloat    , -- значение
    IN inComment             TVarChar  , -- Комментарий
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoGoods());
    vbUserId := lpGetUserBySession (inSession);


    -- проверка - если есть подписи, корректировать нельзя
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- Проверили уникальность условия в документе
    IF EXISTS(SELECT 1
              FROM
                  MovementItem_PromoCondition_View AS MI_PromoCondition
              WHERE
                  MI_PromoCondition.MovementId = inMovementId
                  AND
                  MI_PromoCondition.ConditionPromoId = inConditionPromoId
                  AND
                  MI_PromoCondition.Id <> COALESCE(ioId,0))
    THEN
        RAISE EXCEPTION 'Ошибка. В документе уже указано выбранное условие <%>', (SELECT ValueData FROM Object WHERE id = inConditionPromoId);
    END IF;


    -- сохранили
    ioId := lpInsertUpdate_MovementItem_PromoCondition (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inConditionPromoId   := inConditionPromoId
                                                      , inAmount             := inAmount
                                                      , inComment            := inComment
                                                      , inUserId             := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 25.11.15                                                                         * Comment
 05.11.15                                                                         *
*/