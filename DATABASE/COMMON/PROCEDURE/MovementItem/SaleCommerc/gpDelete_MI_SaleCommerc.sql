-- Function: gpDelete_MI_SaleCommerc ()

DROP FUNCTION IF EXISTS gpDelete_MI_SaleCommerc (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_MI_SaleCommerc(
    IN inMovementId            Integer   , -- ключ Документа
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SaleCommerc());

     -- удаление все строки чайлд и мастер
     UPDATE MovementItem  SET isErased = TRUE 
     WHERE MovementItem.MovementId    = inMovementId
       AND MovementItem.isErased      = FALSE
    ;
     
     -- Протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, TRUE)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId;

                                                 
    -- тест
    --if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. '; end if;
                                                  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.07.26         *
*/

-- тест
-- 