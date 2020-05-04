-- Function: zfCalc_ReceiptChild_GroupNumber

DROP FUNCTION IF EXISTS zfCalc_ReceiptChild_GroupNumber (Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS zfCalc_ReceiptChild_GroupNumber (Integer, Integer, Integer, Integer, Boolean, Boolean);

CREATE OR REPLACE FUNCTION zfCalc_ReceiptChild_GroupNumber(
    IN inGoodsId                Integer, -- 
    IN inGoodsKindId            Integer, -- 
    IN inInfoMoneyDestinationId Integer, -- 
    IN inInfoMoneyId            Integer, -- 
    IN inIsWeightMain           Boolean, -- 
    IN inIsTaxExit              Boolean  -- 
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- возвращаем результат
     RETURN (CASE WHEN inGoodsId = zc_Goods_WorkIce()
                     THEN 6

                  WHEN (inGoodsKindId <> 0 AND inInfoMoneyDestinationId <> zc_Enum_InfoMoneyDestination_10100()) -- Основное сырье + Мясное сырье
                    -- OR inGoodsKindId = zc_GoodsKind_WorkProgress()
                    OR inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_21300() -- Общефирменные + Незавершенное производство
                    OR inInfoMoneyId            = zc_Enum_InfoMoney_10106()            -- Основное сырье + Прочее сырье + Сыр
                       THEN 3

                  WHEN inInfoMoneyId = zc_Enum_InfoMoney_10105() -- Основное сырье + Мясное сырье + Прочее мясное сырье
                       THEN 2

                  WHEN inInfoMoneyId = zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                   AND inIsWeightMain = TRUE
                       THEN 5

                  WHEN inInfoMoneyId = zc_Enum_InfoMoney_10201() -- Основное сырье + Прочее сырье + Специи
                   AND COALESCE (inIsTaxExit, FALSE) = FALSE
                       THEN 7

                  WHEN inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10100() -- Основное сырье + Мясное сырье
                       THEN 1

                  WHEN inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_10200() -- Основное сырье + Прочее сырье (осталось Оболочка + Упаковка + Прочее сырье)
                       THEN 8

                  WHEN inInfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_30300() -- Доходы + Переработка
                       THEN 4

                  ELSE 10
           END);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_ReceiptChild_GroupNumber (Integer, Integer, Integer, Integer, Boolean, Boolean) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.03.15                                        *
*/
/*
-- тест
SELECT * FROM zfCalc_ReceiptChild_GroupNumber (inGoodsId                := 100
                                             , inGoodsKindId            := 1
                                             , inInfoMoneyDestinationId := 17
                                             , inInfoMoneyId            := 100
                                             , inIsWeightMain           := FALSE
                                             , inIsTaxExit              := FALSE
                                              )
*/