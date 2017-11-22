-- Function: gpInsertUpdate_MovementItem_MarginCategory_child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_MarginCategory_Child (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_MarginCategory_Child(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- ключ Документа
    IN inParentId            Integer   , -- элемент мастер
    IN inMarginCategoryId    Integer   , -- MarginCategory
    IN inAmount              TFloat    , -- %
    IN inComment             TVarChar  , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- сохраняем
    ioId:= lpInsertUpdate_MI_MarginCategory_Child(ioId                 := COALESCE (ioId, 0) ::integer
                                                , inMovementId         := inMovementId
                                                , inParentId           := inParentId
                                                , inMarginCategoryId   := inMarginCategoryId
                                                , inAmount             := inAmount
                                                , inComment            := inComment
                                                , inUserId             := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 21.11.17         *
*/

-- тест