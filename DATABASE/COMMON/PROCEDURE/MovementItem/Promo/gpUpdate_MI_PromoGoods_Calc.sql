-- Function: gpUpdate_MI_PromoGoods_Calc()
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoGoods_Calc(
    IN inId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId               Integer   , -- документ
    IN inPriceIn                  TFloat    , -- Себ-ть прод, грн/кг
    IN inNum                      TFloat    , -- номер строки
    IN inAmountSale               TFloat    , --
    IN inSummaSale                TFloat    , -- 
    IN inContractCondition        TFloat    , -- бонус
    IN inTaxRetIn                 TFloat    , -- % возврат
    IN inTaxPromo                 TFloat    , -- % Скидки, Компенсации
    IN inisTaxPromo               Boolean   , -- 
   --OUT outSummaProfit             TFloat    , --сумма прибыли
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS  void
AS 
$BODY$ 
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := CASE WHEN inSession = '-12345' THEN inSession :: Integer ELSE lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo()) END;


    -- Проверили уникальность товар/вид товара
    IF inNum IN (3)
    THEN
        RAISE EXCEPTION 'Ошибка. Строка № <%> не редактируется' , zfConvert_FloatToString (inNum);
    END IF;
    
    -- ввод %
    IF inNum = 1
    THEN
        -- сохраняем % Возврат
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxRetIn(), inId, inTaxRetIn);
        -- сохраняем % бонус
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxPromo(), inId, inTaxPromo);
        -- сохраняем % скидка
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractCondition(), inId, inContractCondition);
        
        --свойство документа - какая схема
        IF COALESCE (inTaxPromo,0) <> 0
        THEN
            --свойство документа - какая схема
            PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TaxPromo(), inMovementId, inisTaxPromo);  
        ELSE
            -- если 0
            PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TaxPromo(), inMovementId, NULL :: Boolean);  
        END IF;
    END IF;

    IF inNum = 2
    THEN
        -- сохраняем Себ-ть - 1 прод, грн/кг
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), inId, inPriceIn);
        -- сохраняем Кол-во отгрузка
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSale(), inId, inAmountSale);        
    END IF;
    IF inNum = 4
    THEN
        -- сохраняем Себ-ть - 2 прод, грн/кг
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn2(), inId, inPriceIn);
    END IF;
    
    


    --outSummaProfit := COALESCE (inSummaSale, 0) - (COALESCE (inPriceIn, 0) + COALESCE (inAmountRetIn, 0) + COALESCE (inContractCondition, 0)) * COALESCE (inAmountSale, 0);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 06.04.20         *
 06.08.17         *
*/