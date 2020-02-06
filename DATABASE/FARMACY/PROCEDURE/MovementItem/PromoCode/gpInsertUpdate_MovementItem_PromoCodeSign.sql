-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCodeSign (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCodeSign (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoCodeSign(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inBayerName           TVarChar  , -- 
    IN inBayerPhone          TVarChar  , -- 
    IN inBayerEmail          TVarChar  , -- 
 INOUT ioGUID                TVarChar  , -- 
    IN inComment             TVarChar  , -- примечание
    IN inIsChecked           Boolean   , -- отмечен
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
  
     -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), 0, inMovementId, (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat, NULL);

     IF COALESCE (ioGUID, '') <> ''
     THEN
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), ioId, ioGUID);
         PERFORM lpInsertUpdate_MovementItem_PromoCode_GUID (ioId, ioGUID, vbUserId);
     ELSE
         -- генерируем новый GUID код
         ioGUID := (SELECT zfCalc_GUID());
         -- проверяем на уникальность GUID
         /*WHILE EXISTS (SELECT MovementItemString.ValueData FROM MovementItemString WHERE MovementItemString.DescId = zc_MIString_GUID() AND MovementItemString.ValueData = ioGUID) LOOP
              ioGUID := (SELECT zfCalc_GUID());
         END LOOP;
         */
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), ioId, ioGUID);
         PERFORM lpInsertUpdate_MovementItem_PromoCode_GUID (ioId, ioGUID, vbUserId);
     END IF;
     
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Bayer(), ioId, inBayerName);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BayerPhone(), ioId, inBayerPhone);
     -- сохранили свойство <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BayerEmail(), ioId, inBayerEmail);
     -- сохранили свойство <Примечание>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- сохранили связь с <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, vbUserId);
         -- сохранили свойство <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;
          
    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 05.02.20                                                                     *
 13.12.17         *
*/
--select * from gpInsertUpdate_MovementItem_PromoCodeSign(ioId := 67502267 , inMovementId := 3959814 , inBayerName := 'kbjjbjb' , inBayerPhone := '' , inBayerEmail := '' , ioGUID := '' , inComment := '' , inIsChecked:= TRUE, inSession := '3');