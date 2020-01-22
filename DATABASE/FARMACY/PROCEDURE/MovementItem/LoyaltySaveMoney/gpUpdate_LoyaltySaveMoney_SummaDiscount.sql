-- Function: gpUpdate_LoyaltySaveMoney_SummaDiscount()

DROP FUNCTION IF EXISTS gpUpdate_LoyaltySaveMoney_SummaDiscount (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_LoyaltySaveMoney_SummaDiscount(
    IN inId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inSummaDiscount       TFloat    , -- Сумма скидки
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbSummaUse TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := inSession;
    
    IF COALESCE(inId, 0) = 0
    THEN
       RAISE EXCEPTION 'Ошибка. Не определен ID содержимого документа Программа лояльности накопительной.';
    END IF;
    
    IF EXISTS(SELECT 1 FROM MovementItemFloat AS MIFloat_Summ
              WHERE MIFloat_Summ.MovementItemId = inId
                AND MIFloat_Summ.DescId = zc_MIFloat_Summ())
    THEN
      SELECT COALESCE(MIFloat_Summ.ValueData, 0) + COALESCE(inSummaDiscount, 0)
      INTO vbSummaUse
      FROM MovementItemFloat AS MIFloat_Summ
      WHERE MIFloat_Summ.MovementItemId = inId
        AND MIFloat_Summ.DescId = zc_MIFloat_Summ();    
    ELSE
      vbSummaUse := inSummaDiscount;
    END IF;

    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Summ(), inId, vbSummaUse);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.01.20                                                       *
*/