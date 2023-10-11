-- Function: gpUpdate_Movement_Sale_PriceList()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_PriceList (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_PriceList(
    IN inMovementId      Integer   , -- Ключ объекта <Документ>   
    IN inPriceListId     Integer   , -- прайс
    IN inSession         TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId    Integer; 
   DECLARE vbStatusId  Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale_PriceList());

     IF COALESCE (inPriceListId,0) = 0 
     THEN 
          RAISE EXCEPTION 'Ошибка.Значение <Прайс лист> должно быть установлено.';
     END IF;
     
     IF COALESCE (inMovementId,0) = 0 
     THEN 
          RAISE EXCEPTION 'Ошибка.Документ не определен.';
     END IF;
     
     --если документ проведен распроводим
     vbStatusId := (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);  
     
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN 
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;
       
     -- сохранили связь с <Прайс лист>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, inPriceListId);  
     
     --вызов процедуры обновления цен в документе
     PERFORM gpUpdate_MovementItem_Sale_Price(inMovementId, inSession);

     --если документ был проведен  проводим обратно
     IF vbStatusId = zc_Enum_Status_Complete()
     THEN 
         PERFORM gpComplete_Movement_Sale (inMovementId := inMovementId);
     END IF;
     
     
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.10.23         *
*/
