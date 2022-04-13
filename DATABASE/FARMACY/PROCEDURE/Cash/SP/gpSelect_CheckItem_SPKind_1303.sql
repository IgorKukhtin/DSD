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
   DECLARE vbPersent   TFloat;
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
            
            SELECT CASE WHEN tt.Price < 100 THEN tt.Price * 1.099  --1.249
                         WHEN tt.Price >= 100 AND tt.Price < 500 THEN tt.Price * 1.099 -- 1.199
                         WHEN tt.Price >= 500 AND tt.Price < 1000 THEN tt.Price * 1.099 -- 1.149
                         WHEN tt.Price >= 1000 THEN tt.Price * 1.099
                    END :: TFloat AS PriceCalc
                  , CASE WHEN tt.Price < 100 THEN 10 -- 25
                         WHEN tt.Price >= 100 AND tt.Price < 500 THEN 10 -- 20
                         WHEN tt.Price >= 500 AND tt.Price < 1000 THEN 10 -- 15
                         WHEN tt.Price >= 1000 THEN 10
                    END :: TFloat AS Persent
            INTO vbPriceCalc, vbPersent
             FROM (SELECT CASE WHEN MovementBoolean_PriceWithVAT.ValueData = TRUE THEN MIFloat_Price.ValueData
                               ELSE (MIFloat_Price.ValueData * (1 + COALESCE (ObjectFloat_NDSKind_NDS.ValueData,1)/100))::TFloat    -- в партии инвентаризации  цена с НДС, а параметра НДС нет
                          END AS Price   -- цена c НДС
                        , ROW_NUMBER() OVER (ORDER BY MovementLinkObject_To.ObjectId <> vbUnitId, MI_Income.MovementId DESC) AS ord   -- Люба сказала смотреть по последней партии
                   FROM Container 
                      LEFT OUTER JOIN ContainerLinkObject AS CLI_MI 
                                                          ON CLI_MI.ContainerId = Container.Id
                                                         AND CLI_MI.DescId = zc_ContainerLinkObject_PartionMovementItem()
                      LEFT OUTER JOIN OBJECT AS Object_PartionMovementItem ON Object_PartionMovementItem.Id = CLI_MI.ObjectId

                      LEFT OUTER JOIN MovementItem AS MI_Income ON MI_Income.Id = Object_PartionMovementItem.ObjectCode :: Integer
                      LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                  ON MIFloat_Price.MovementItemId = MI_Income.Id
                                                 AND MIFloat_Price.DescId = zc_MIFloat_Price()

                      LEFT JOIN MovementBoolean AS MovementBoolean_PriceWithVAT
                                                ON MovementBoolean_PriceWithVAT.MovementId =  MI_Income.MovementId
                                               AND MovementBoolean_PriceWithVAT.DescId = zc_MovementBoolean_PriceWithVAT()
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_NDSKind
                                                   ON MovementLinkObject_NDSKind.MovementId = MI_Income.MovementId
                                                  AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind()
                      LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                                   ON MovementLinkObject_To.MovementId = MI_Income.MovementId
                                                  AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()   
                      LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                            ON ObjectFloat_NDSKind_NDS.ObjectId = MovementLinkObject_NDSKind.ObjectId
                                           AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

                   WHERE Container.ObjectId = inGoodsId
                     AND Container.DescId = zc_Container_Count()
                     AND Container.WhereObjectId = vbUnitId
                     --AND COALESCE (Container.Amount,0 ) > 0
                     AND COALESCE (MIFloat_Price.ValueData ,0) > 0
                   ) AS tt
             WHERE tt.Ord = 1;

            -- проверка  Цена < 100грн – максимальна торгівельна надбавка може складати 25%. від 100 до 500 грн – надбавка на рівні 20%. Від 500 до 1000 – 15%. Понад 1000 грн надбавка на рівні 10%.
            IF (COALESCE (vbPriceCalc,0) < inPriceSale) AND (COALESCE (vbPriceCalc,0) <> 0)
               THEN
                   IF vbPersent = 25 THEN  outError :=  'Ошибка. Запрет на отпуск товара по ПКМУ 1303 с наценкой более 25 процентов'||Chr(13)||Chr(10)||'(для товара с приходной ценой до 100грн)'; END IF;
                   IF vbPersent = 20 THEN  outError :=  'Ошибка. Запрет на отпуск товара по ПКМУ 1303 с наценкой более 20 процентов'||Chr(13)||Chr(10)||'(для товара с приходной ценой от 100грн до 500грн)'; END IF;
                   IF vbPersent = 15 THEN  outError :=  'Ошибка. Запрет на отпуск товара по ПКМУ 1303 с наценкой более 15 процентов'||Chr(13)||Chr(10)||'(для товара с приходной ценой от 500грн до 1000грн)'; END IF;
                   IF vbPersent = 10 THEN  outError :=  'Ошибка. Запрет на отпуск товара по ПКМУ 1303 с наценкой более 10 процентов'||Chr(13)||Chr(10)||'(для товара с приходной ценой свыше 1000грн)'; END IF;
                   outError2 :=  Chr(13)||Chr(10)||'Сделать PrintScreen экрана с ошибкой и отправить на Skype своему менеджеру для  исправления Цены реализации'||Chr(13)||Chr(10)||'(после исправления - препарат можно отпустить по рецепту)';
            END IF;
            
            -- Предложение по цене
            IF (COALESCE (vbPriceCalc,0) < inPriceSale) AND (COALESCE (trunc(vbPriceCalc * 10) / 10, 0) > 0)
            THEN
                   outPrice := trunc(vbPriceCalc * 10) / 10;
                   outSentence :=  'Применить максимально допустимую цену - '||to_char(outPrice, 'G999G999G999G999D99');
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

-- 
SELECT * FROM gpSelect_CheckItem_SPKind_1303(inSPKindId := zc_Enum_SPKind_1303(), inGoodsId := 36643, inPriceSale := 1000, inSession := '3');