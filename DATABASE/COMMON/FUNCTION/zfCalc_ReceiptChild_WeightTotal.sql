-- Function: zfCalc_ReceiptChild_isWeightTotal

DROP FUNCTION IF EXISTS zfCalc_ReceiptChild_isWeightTotal (Integer, Integer, Integer, Integer, Boolean, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_ReceiptChild_isWeightTotal(
    IN inGoodsId                Integer, -- 
    IN inGoodsKindId            Integer, -- 
    IN inInfoMoneyDestinationId Integer, -- 
    IN inInfoMoneyId            Integer, -- 
    IN inIsWeightMain           Boolean, -- 
    IN inIsTaxExit              Boolean  -- 
)
RETURNS Boolean
AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (CASE WHEN inInfoMoneyId <> zc_Enum_InfoMoney_10202() -- Основное сырье + Прочее сырье + Оболочка
                   AND inInfoMoneyId <> zc_Enum_InfoMoney_10203() -- Основное сырье + Прочее сырье + Упаковка
                   AND inInfoMoneyId <> zc_Enum_InfoMoney_10204() -- Основное сырье + Прочее сырье + Прочее сырье
                   AND (COALESCE (inIsTaxExit, FALSE) = FALSE
                     OR inInfoMoneyId = zc_Enum_InfoMoney_20901() -- Общефирменные + Ирна
                     OR inInfoMoneyId = zc_Enum_InfoMoney_30101() -- Доходы + Продукция + Готовая продукция
                     OR inInfoMoneyId = zc_Enum_InfoMoney_30201() -- Доходы + Продукция + Мясное сырье
                       )
                     THEN TRUE
                 ELSE FALSE
           END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_ReceiptChild_isWeightTotal (Integer, Integer, Integer, Integer, Boolean, Boolean) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.15                                        *
*/
/*
-- тест
SELECT * FROM zfCalc_ReceiptChild_isWeightTotal (inGoodsId                := 100
                                             , inGoodsKindId            := 1
                                             , inInfoMoneyDestinationId := 17
                                             , inInfoMoneyId            := 100
                                             , inIsWeightMain           := FALSE
                                             , inIsTaxExit              := FALSE
                                              )
*/