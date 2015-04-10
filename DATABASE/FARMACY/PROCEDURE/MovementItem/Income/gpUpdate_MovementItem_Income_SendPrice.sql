DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_SendPrice 
          (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_SendPrice(
    IN inMovementId          Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
BEGIN
     
     -- определяем <Статус>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = inMovementId;
     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;


    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), MovementItem_Income_View.Id, MovementItem_Income_View.Price*1.5);
       FROM MovementItem_Income_View WHERE MovementId = inMovementId
     
     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 26.01.15                        *   
*/
-- select * from gpUpdate_MovementItem_Income_GoodsId(inMovementId := 12474 ,  inSession := '3');  
-- vbJuridicalId = 183312

        
