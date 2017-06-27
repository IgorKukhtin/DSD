-- Function: gpInsertUpdate_MovementItem_Cash_Personal_Amount (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Cash_Personal_Amount (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Cash_Personal_Amount(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementId_Parent   Integer   , -- Ключ объекта <Документ>
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());


     -- Ошибка
     RAISE EXCEPTION 'Ошибка.Эта Proc отключена, работает та что по гриду.';

     -- сохранили
     PERFORM lpInsertUpdate_MovementItem_Cash_Personal (ioId                 := tmp.Id
                                                      , inMovementId         := inMovementId
                                                      , inPersonalId         := tmp.PersonalId
                                                      , inAmount             := COALESCE (tmp.Amount, 0) + COALESCE (tmp.SummRemains, 0)
                                                      , inComment            := tmp.Comment
                                                      , inInfoMoneyId        := tmp.InfoMoneyId
                                                      , inUnitId             := tmp.UnitId
                                                      , inPositionId         := tmp.PositionId
                                                      , inIsCalculated       := FALSE
                                                      , inUserId             := vbUserId
                                                       )
     FROM gpSelect_MovementItem_Cash_Personal (inMovementId    := inMovementId
                                             , inParentId      := inMovementId_Parent
                                             , inMovementItemId:= 0
                                             , inShowAll       := FALSE
                                             , inIsErased      := FALSE
                                             , inSession       := inSession
                                              ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.04.15                                        * all
 16.09.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_MovementItem_Cash_Personal_Amount(ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
