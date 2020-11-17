-- Function: lpInsertUpdate_MovementItem_WagesAdditionalExpenses ()

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_WagesAdditionalExpenses (Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_WagesAdditionalExpenses(
 INOUT ioId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId               Integer   , -- Ключ объекта <Документ>
    IN inUnitID                   Integer   , -- Плдразделение
    IN inSummaCleaning            TFloat    , -- Уборка
    IN inSummaSP                  TFloat    , -- СП
    IN inSummaOther               TFloat    , -- Прочее
    IN inSummaValidationResults   TFloat    , -- Результаты проверки
    IN inSummaIntentionalPeresort TFloat    , -- Штраф за намеренный пересорт
    IN inSummaFullChargeFact      TFloat    , -- Полное списание факт
    IN inisIssuedBy               Boolean   , -- Выдано
    IN inComment                  TVarChar  , -- Примечание
    IN inUserId                   Integer   -- пользователь
 )
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- определяется признак Создание/Корректировка
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    IF vbIsInsert = TRUE
    THEN
       -- Создали <Элемент документа>
      ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, 0, 0);
    END IF;
    
     -- сохранили свойство <Уборка>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaCleaning(), ioId, inSummaCleaning);

     -- сохранили свойство <СП>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaSP(), ioId, inSummaSP);

     -- сохранили свойство <Прочее>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaOther(), ioId, inSummaOther);

     -- сохранили свойство <Результаты проверки>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ValidationResults(), ioId, inSummaValidationResults);

     -- сохранили свойство <Штраф за намеренный пересорт>
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_IntentionalPeresort(), ioId, inSummaIntentionalPeresort);
            
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_SummaFullChargeFact(), ioId, inSummaFullChargeFact);
    
    -- сохранили <Элемент документа>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), inUnitId, inMovementId, lpGet_MovementItem_WagesAE_TotalSum (ioId, inUserId), 0);

    -- сохранили свойство <Примечание>
    PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- сохранили свойство <Дата выдачи>
    IF vbIsInsert AND inisIssuedBy OR 
      NOT vbIsInsert AND inisIssuedBy <> COALESCE (
      (SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId) , FALSE)
    THEN
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
    END IF;
    
     -- сохранили свойство <Выдано>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
    

    -- сохранили протокол
    PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
                Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.02.20                                                        *
 02.10.19                                                        *
 01.09.19                                                        *
*/

-- тест
-- 
