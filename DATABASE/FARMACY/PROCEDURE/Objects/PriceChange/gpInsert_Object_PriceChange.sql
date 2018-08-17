-- Function: gpInsert_Object_PriceChange_BySend()

DROP FUNCTION IF EXISTS gpInsert_Object_PriceChange_BySend (Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Object_PriceChange_BySend(
    IN inRetailId            Integer   , -- Подразделение 
    IN inGoodsId             Integer   , -- Товары
    IN inAmount              TFloat    , -- Количество
    IN inPriceChangeNew      TFloat    , -- Цена новая
 INOUT ioPriceChange         TFloat    , -- Цена получателя
   OUT outSumma              TFloat    , -- Сумма в ценах получателя
    IN inSession             TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    --если цена получателя <> 0  - ругаемся нельзя менять
    IF COALESCE (ioPriceChangeUnitTo, 0) <> 0 
    THEN
        RAISE EXCEPTION 'Ошибка.Изменение невозможно Цена получателя больше 0.';
    END IF;
    
    --если новая цена должна быть > 0
    IF COALESCE (inPriceChangeNew, 0) = 0 
    THEN
        RAISE EXCEPTION 'Ошибка.Новая цена должна быть больше 0.';
    END IF;
    
    ioPriceChangeUnitTo := inPriceChangeNew;
        
    --переоценить товар
    PERFORM lpInsertUpdate_Object_PriceChange(inGoodsId := inGoodsId,
                                        inUnitId  := inUnitId,
                                        inPriceChange   := ioPriceChangeUnitTo,
                                        inDate    := CURRENT_DATE::TDateTime,
                                        inUserId  := vbUserId);
                                        
                                            
    --Посчитали сумму
    outSummaUnitTo := ROUND(inAmount * ioPriceChangeUnitTo, 2); 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.09.17         *
*/

-- тест
-- 