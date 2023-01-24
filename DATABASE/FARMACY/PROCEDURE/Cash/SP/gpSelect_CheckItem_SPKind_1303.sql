-- Function: gpSelect_CheckItem_SPKind_1303()

DROP FUNCTION IF EXISTS gpSelect_CheckItem_SPKind_1303 (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_CheckItem_SPKind_1303(
    IN inSPKindId            Integer   , -- Сщц проект
    IN inGoodsId             Integer   , -- Товары
    IN inPriceSale           TFloat    , -- Цена без скидки
   OUT outError              TVarChar  , -- Результат
   OUT outError2             TVarChar  , -- Результат
   OUT outSentence           TVarChar  , -- Предложение по цене
   OUT outPrice              TFloat    , -- Допустимая цена
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;

   DECLARE vbPriceCalc TFloat;
   DECLARE vbPriceSale TFloat;
   DECLARE vbDeviationsPrice1303 TFloat;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());
    vbUserId:= lpGetUserBySession (inSession);
    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    outError := '';
    outError2 := '';
    outSentence := '';
    outPrice := 0;

    SELECT COALESCE(ObjectFloat_CashSettings_DeviationsPrice1303.ValueData, 1)    AS DeviationsPrice1303
    INTO vbDeviationsPrice1303
    FROM Object AS Object_CashSettings
         LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DeviationsPrice1303
                               ON ObjectFloat_CashSettings_DeviationsPrice1303.ObjectId = Object_CashSettings.Id 
                              AND ObjectFloat_CashSettings_DeviationsPrice1303.DescId = zc_ObjectFloat_CashSettings_DeviationsPrice1303()
    WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
    LIMIT 1;
         
    -- проверка ЗАПРЕТ на отпуск препаратов у которых ндс 20%, для пост. 1303
    IF inSPKindId = zc_Enum_SPKind_1303()
    THEN 
            --
            IF EXISTS (SELECT 1 
                       FROM ObjectLink
                            INNER JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                                   ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink.ChildObjectId 
                                                  AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                                                  AND ObjectFloat_NDSKind_NDS.ValueData = 20
                       WHERE ObjectLink.ObjectId = inGoodsId
                         AND ObjectLink.DescId = zc_ObjectLink_Goods_NDSKind())
               THEN
                   outError := 'Ошибка. Запрет на отпуск товара по ПКМУ 1303 со ставкой НДС=20 проц.'||Chr(13)||Chr(10)||'(ТОВАР БЕЗ РЕГИСТРАЦИИ !!!)';
                   RETURN;
            END IF;
            
            SELECT T1.PriceSale, T1.PriceSaleIncome  
            INTO vbPriceSale, vbPriceCalc                          
            FROM gpSelect_GoodsSPRegistry_1303_Unit (inUnitId := vbUnitId, inGoodsId := inGoodsId, inisCalc := True, inSession := inSession) AS T1;
                        
            IF COALESCE(vbPriceSale, 0) = 0
            THEN
                  outError :=  'БЛОК ОТПУСКА !'||Chr(13)||Chr(10)|| 
                               'Товар не найден в реестре товаров соц. проекта 1303';
                  outError2 :=  Chr(13)||Chr(10)||'Сделать PrintScreen экрана с ошибкой и отправить на Telegram   в группу ПКМУ1303  (инфо для Пелиной Любови)';
                  
                  RETURN;
            END IF;
            
            
            -- Предложение по цене
            IF (COALESCE (vbPriceCalc,0) < inPriceSale) AND (COALESCE (trunc(vbPriceCalc * 10) / 10, 0) > 0)
            THEN
               outError :=  'Ошибка. Запрет на отпуск товара по ПКМУ 1303 с наценкой более 10 процентов';
               outError2 :=  Chr(13)||Chr(10)||'Сделать PrintScreen экрана с ошибкой и отправить на Telegram своему менеджеру для  исправления Цены реализации'||Chr(13)||Chr(10)||'(после исправления - препарат можно отпустить по рецепту)';

               outPrice := trunc(vbPriceCalc * 10) / 10;
               outSentence :=  'Применить максимально допустимую цену - '||zfConvert_FloatToString(outPrice);
            END IF;

             -- raise notice 'Value 05: % % % %', vbPriceSale, vbPriceCalc, outPrice, (CASE WHEN COALESCE(outPrice, 0) = 0 THEN inPriceSale ELSE outPrice END / vbPriceSale * 100 - 100);
            
            IF vbPriceSale < inPriceSale and COALESCE(outPrice, 0) = 0 OR vbPriceSale < outPrice and COALESCE(outPrice, 0) > 0
            THEN
              outError :=  'БЛОК ОТПУСКА !'||Chr(13)||Chr(10)|| 
                           'Отпускная цена выше чем по реестру товаров соц. проекта 1303'||Chr(13)||Chr(10)||Chr(13)||Chr(10)||
                           'Максимальная цена реализации должна быть - '||zfConvert_FloatToString(vbPriceSale)||'грн.'||Chr(13)||Chr(10)|| 
                           'У нас миним. цена для отпуска по ПКМУ 1303 - '||zfConvert_FloatToString(CASE WHEN COALESCE(outPrice, 0) = 0 THEN inPriceSale ELSE outPrice END)||'грн.';
              outError2 :=  Chr(13)||Chr(10)||'% расхождения '||zfConvert_FloatToString(CASE WHEN COALESCE(outPrice, 0) = 0 THEN inPriceSale ELSE outPrice END/vbPriceSale*100 - 100)||
                           Chr(13)||Chr(10)||Chr(13)||Chr(10)||'Сделать PrintScreen экрана с ошибкой и отправить на Telegram   в группу ПКМУ1303  (инфо для Пелиной Любови)';
                           
              IF (CASE WHEN COALESCE(outPrice, 0) = 0 THEN inPriceSale ELSE outPrice END / vbPriceSale * 100 - 100) <= COALESCE(vbDeviationsPrice1303, 1.0)
              THEN
                outPrice := vbPriceSale;
                outSentence :=  'Применить максимально допустимую цену - '||zfConvert_FloatToString(outPrice);
              ELSE
                outSentence := '';
                outPrice := 0;               
              END IF;
            END IF;
    END IF;
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.    Воробкало А.А.  Шаблий О.В.
 26.01.20                                                                                      *
*/

-- SELECT * FROM gpSelect_CheckItem_SPKind_1303(inSPKindId := zc_Enum_SPKind_1303(), inGoodsId := 36643, inPriceSale := 1000, inSession := '3');


select * from gpSelect_CheckItem_SPKind_1303(inSPKindId := 4823010 , inGoodsId := 37309 , inPriceSale := 1185.5 ,  inSession := '3');