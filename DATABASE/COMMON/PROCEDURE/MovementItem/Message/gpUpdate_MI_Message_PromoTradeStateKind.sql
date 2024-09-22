-- Function: gpUpdate_MI_Message_PromoTradeStateKind()

DROP FUNCTION IF EXISTS gpUpdate_MI_Message_PromoTradeStateKind (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_Message_PromoTradeStateKind(
 INOUT ioId                      Integer   , --
    IN inMovementId              Integer   , -- Ключ объекта <Документ>
    IN inPromoTradeStateKindId   Integer   , -- Состояние
    IN inComment                 TVarChar  ,
    IN inSession                 TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoTrade());
     
     
     IF inPromoTradeStateKindId = -1
     THEN
         -- !!!убрать подпись!!!
         PERFORM lpSetErased_MovementItem (inMovementItemId:= (SELECT MovementItem.Id FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescId = zc_MI_Sign() AND MovementItem.Amount = (SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.Id = ioId) AND MovementItem.isErased = FALSE)
                                         , inUserId        := vbUserId
                                          );
         -- удалили
         PERFORM lpSetErased_MovementItem (inMovementItemId:= ioId
                                         , inUserId        := vbUserId
                                          );

     ELSE
          -- добавили состояние
          ioId:= gpInsertUpdate_MI_Message_PromoTradeStateKind (ioId                    := ioId
                                                              , inMovementId            := inMovementId
                                                              , inPromoTradeStateKindId := inPromoTradeStateKindId
                                                              , inIsQuickly             := TRUE
                                                              , inComment               := inComment
                                                              , inSession               := inSession
                                                               );
     END IF;

     --
     -- RAISE EXCEPTION 'Ошибка.OK';

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.  Климентьев К.И.
 27.06.20                                       *
*/

-- тест
--