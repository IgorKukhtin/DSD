-- Function: gpUpdate_MI_ProductionUnion_Child()

DROP FUNCTION IF EXISTS gpUpdate_MI_ProductionUnion_Child (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_ProductionUnion_Child(
    IN inParentId               Integer   , -- 
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_ProductionUnion());
     vbUserId := lpGetUserBySession (inSession);

     -- автоматом формируем zc_MI_Child - по значениям план
     PERFORM lpInsertUpdate_MI_ProductionUnion_Child (ioId         := COALESCE (tmp.Id) :: Integer
                                                    , inParentId   := inParentId
                                                    , inMovementId := inMovementId
                                                    , inObjectId   := tmp.ObjectId
                                                    , inAmount     := COALESCE (tmp.Value,0) :: TFloat
                                                    , inUserId     := vbUserId
                                                    )
     FROM gpSelect_MI_ProductionUnion_Child (inMovementId, TRUE, FALSE, inSession) AS tmp
     WHERE tmp.ParentId = inParentId;
         
     -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- сохранили протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Child()
       AND MovementItem.isErased   = FALSE
     ;


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.07.21         *
*/

-- тест
--