-- Function: gpInsert_MovementItem_PromoCodePercentSign()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_PromoCodePercentSign (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_PromoCodePercentSign(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inCount_GUID          Integer   ,
    IN inChangePercent_GUID  TFloat    ,
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
  
    -- строим строчку для кросса
    WHILE (vbIndex < inCount_GUID) LOOP
      vbIndex := vbIndex + 1;
      
      -- сохранили <Элемент документа>
      vbId := lpInsertUpdate_MovementItem (0, zc_MI_Sign(), 0, inMovementId, 1, NULL);

      -- генерируем новый GUID код
      vbGUID := (SELECT zfCalc_GUID());
      -- проверяем на уникальность GUID
      /*WHILE EXISTS (SELECT MovementItemString.ValueData FROM MovementItemString WHERE MovementItemString.DescId = zc_MIString_GUID() AND MovementItemString.ValueData = vbGUID) LOOP
           vbGUID := (SELECT zfCalc_GUID());
      END LOOP;
      */
      -- сохранили свойство <>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, vbGUID);
      PERFORM lpInsertUpdate_MovementItem_PromoCode_GUID (vbId, vbGUID, vbUserId);
        -- сохранили свойство <Процент скидки по проиокоду>
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ChangePercent(), vbId, inChangePercent_GUID);
  
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
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 27.03.20                                                                     *
*/
