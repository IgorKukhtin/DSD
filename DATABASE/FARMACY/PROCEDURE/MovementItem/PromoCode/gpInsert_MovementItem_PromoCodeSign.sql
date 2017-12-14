-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_PromoCodeSign (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_PromoCodeSign(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inCount_GUID          Integer   ,
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbIndex Integer;
   DECLARE vbGUID TVarChar;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
  
    vbIndex := 0;
  
    vbGUID := ((SELECT MAX (MovementItemString.ValueData ::integer ) FROM MovementItemString WHERE MovementItemString.DescId = zc_MIString_GUID()) + 1);
      
     -- строим строчку для кросса
     WHILE (vbIndex < inCount_GUID) LOOP
       vbIndex := vbIndex + 1;
       
       -- сохранили <Элемент документа>
       vbId := lpInsertUpdate_MovementItem (0, zc_MI_Sign(), 0, inMovementId, 0, NULL);
   
       vbGUID := (vbGUID ::Integer + 1);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, vbGUID);
   
       -- сохранили связь с <>
       PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbId, vbUserId);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId, CURRENT_TIMESTAMP);

     END LOOP;
     
              
   -- сохранили протокол
   --PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 13.12.17         *
*/
--