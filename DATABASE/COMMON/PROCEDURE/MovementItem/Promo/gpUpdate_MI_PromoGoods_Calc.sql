-- Function: gpUpdate_MI_PromoGoods_Calc()

DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PromoGoods_Calc(
    IN inId                       Integer   , -- Ключ объекта <Элемент документа>
    IN inPriceIn                  TFloat    , -- Себ-ть прод, грн/кг
    IN inNum                      TFloat    , -- номер строки
    IN inAmountPlanMax            TFloat    , --
    IN inSummaPlanMax             TFloat    , -- 
    IN inAmountRetIn              TFloat    , -- 
    IN inAmountContractCondition  TFloat    , -- 
   OUT outSummaProfit             TFloat    , --сумма прибыли
    IN inSession                  TVarChar    -- сессия пользователя
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := CASE WHEN inSession = '-12345' THEN inSession :: Integer ELSE lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo()) END;


    -- Проверили уникальность товар/вид товара
    IF inNum NOT IN (2, 4)
    THEN
        RAISE EXCEPTION 'Ошибка. Строка № <%> не редактируется' , zfConvert_FloatToString (inNum);
    END IF;
    
    IF inNum = 2
    THEN
        -- сохраняем Себ-ть - 1 прод, грн/кг
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), inId, inPriceIn);
    ELSE
        -- сохраняем Себ-ть - 2 прод, грн/кг
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn2(), inId, inPriceIn);
    END IF;
    
    outSummaProfit := COALESCE (inSummaPlanMax, 0) - (COALESCE (inPriceIn, 0) + COALESCE (inAmountRetIn, 0) + COALESCE (inAmountContractCondition, 0)) * COALESCE (inAmountPlanMax, 0);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 06.08.17         *
*/