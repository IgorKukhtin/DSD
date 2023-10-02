-- Function: gpUpdate_MI_PromoGoods_Calc()
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_MI_PromoGoods_Calc (Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, Boolean, TVarChar);
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
   DECLARE vbTaxPromo TFloat;
   DECLARE vbGoodsId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := CASE WHEN inSession = '-12345' THEN inSession :: Integer ELSE lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Promo()) END;

    -- vbTaxPromo := (REPLACE(REPLACE (inTaxPromo, '%', ''), ',', '.')) :: TFloat;
    vbGoodsId  := (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.Id = inId);
    
    -- проверка - если есть подписи, корректировать нельзя
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- Проверили уникальность товар/вид товара
    IF inNum IN (3)
    THEN
        RAISE EXCEPTION 'Ошибка. Строка № <%> не редактируется' , zfConvert_FloatToString (inNum);
    END IF;
    
    -- ввод %
    IF inNum = 1
    THEN
        -- сохраняем % Возврат
        PERFORM -- сохраняем % Возврат
                lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxRetIn(), MovementItem.Id, inTaxRetIn)  -- zfConvert_StringToFloat(TRIM (REPLACE (REPLACE (inTaxRetIn, '%', ''), ',', '.')))
               -- сохраняем % бонус
              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_TaxPromo(), MovementItem.Id, inTaxPromo)  -- zfConvert_StringToFloat(TRIM (REPLACE (REPLACE (inTaxPromo, '%', ''), ',', '.')))
              -- сохраняем % скидка
              , lpInsertUpdate_MovementItemFloat (zc_MIFloat_ContractCondition(), MovementItem.Id, inContractCondition)  -- zfConvert_StringToFloat(TRIM (REPLACE (REPLACE (inContractCondition, '%', ''), ',', '.')))
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.ObjectId   = vbGoodsId;
          
        -- сохранили протокол
        PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
        FROM MovementItem
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.ObjectId   = vbGoodsId
         ;
        
              
        --свойство документа - какая схема
        /*IF COALESCE (inisTaxPromo, FALSE) = TRUE
        THEN
            --свойство документа - какая схема
            PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TaxPromo(), inMovementId, inisTaxPromo);  
        ELSE
            -- 
            PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TaxPromo(), inMovementId, NULL :: Boolean);  
        END IF;
        */
    END IF;

    IF inNum = 2
    THEN
        -- сохраняем Себ-ть - 2 прод, грн/кг
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn2(), inId, inPriceIn);
        -- сохраняем Кол-во отгрузка
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountSale(), inId, inAmountSale);        

        -- сохранили протокол
        PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

    END IF;
    IF inNum = 4
    THEN
        -- сохраняем Себ-ть - 1 прод, грн/кг
        PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn1(), inId, inPriceIn);

        -- сохранили протокол
        PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

    END IF;
    
    
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_TaxPromo(), inMovementId, inisTaxPromo); 

    --outSummaProfit := COALESCE (inSummaSale, 0) - (COALESCE (inPriceIn, 0) + COALESCE (inAmountRetIn, 0) + COALESCE (inContractCondition, 0)) * COALESCE (inAmountSale, 0);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.
 02.07.20         *
 06.04.20         *
 06.08.17         *
*/