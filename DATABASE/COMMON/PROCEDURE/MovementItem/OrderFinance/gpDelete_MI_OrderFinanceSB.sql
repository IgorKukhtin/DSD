-- Function: gpDelete_MI_OrderFinanceSB ()

DROP FUNCTION IF EXISTS gpDelete_MI_OrderFinanceSB (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpDelete_MI_OrderFinanceSB(
    IN inMovementId            Integer   , -- ключ Документа
    IN inSession               TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer; 
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

     -- удаление все строки чайлд и мастер
     UPDATE MovementItem  SET isErased = TRUE 
     FROM MovementItemLinkObject AS MILO_Insert
     WHERE MovementItem.MovementId    = inMovementId
       AND MovementItem.isErased      = FALSE
       AND MILO_Insert.MovementItemId = MovementItem.Id
       AND MILO_Insert.DescId         = zc_MILinkObject_Insert()
       AND MILO_Insert.ObjectId       = vbUserId
    ;
     
     -- Протокол
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, TRUE)
     FROM MovementItem
          INNER JOIN MovementItemLinkObject AS MILO_Insert
                                            ON MILO_Insert.MovementItemId = MovementItem.Id
                                           AND MILO_Insert.DescId         = zc_MILinkObject_Insert()
                                           AND MILO_Insert.ObjectId       = vbUserId
     WHERE MovementItem.MovementId = inMovementId;

                                                 
     -- пересчитали Итоговые суммы по накладной
     PERFORM lpInsertUpdate_MovementFloat_TotalSummOrderFinance (inMovementId);

    -- тест
    --if vbUserId IN (9457) then RAISE EXCEPTION 'Админ.Test Ok. '; end if;
                                                  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.02.26         *
*/

-- тест
-- 