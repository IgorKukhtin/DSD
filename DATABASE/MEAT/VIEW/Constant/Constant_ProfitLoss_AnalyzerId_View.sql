-- View: Constant_ProfitLoss_AnalyzerId_View

-- DROP VIEW IF EXISTS Constant_ProfitLoss_AnalyzerId_View;

CREATE OR REPLACE VIEW Constant_ProfitLoss_AnalyzerId_View
AS
   --
   SELECT Object.DescId
        , Object.Id AS AnalyzerId
        , Object.ObjectCode
        , Object.ValueData
        , CASE WHEN Object.ObjectCode BETWEEN 101 AND 199 THEN TRUE ELSE FALSE END AS isSale
        , CASE WHEN Object.ObjectCode BETWEEN 111 AND 119 OR Object.ObjectCode BETWEEN 211 AND 219 THEN TRUE ELSE FALSE END AS isCost
        , CASE WHEN Object.ObjectCode BETWEEN 111 AND 199 OR Object.ObjectCode BETWEEN 211 AND 299 THEN TRUE ELSE FALSE END AS isSumm
   FROM Object
   WHERE Object.DescId = zc_Object_AnalyzerId()
     AND Object.Id NOT IN (zc_Enum_AnalyzerId_LossCount_20200(), zc_Enum_AnalyzerId_LossSumm_20200()) -- !!!списание!!!
     AND Object.ObjectCode < 1000
  UNION ALL
   -- Сумма реализации + Разница с оптовыми ценами + Скидка дополнительная
   SELECT Object.DescId
        , Object.Id AS AnalyzerId
        , Object.ObjectCode
        , Object.ValueData
        , TRUE AS isSale
        , FALSE AS isCost
        , TRUE AS isSumm
   FROM Object
   WHERE Object.DescId = zc_Object_ProfitLossDirection()
     AND Object.ObjectCode IN (10100, 10200, 10300)
  UNION ALL
   -- Сумма возвратов + Скидка дополнительная
   SELECT Object.DescId
        , Object.Id AS AnalyzerId
        , Object.ObjectCode
        , Object.ValueData
        , FALSE AS isSale
        , FALSE AS isCost
        , TRUE AS isSumm
   FROM Object
   WHERE Object.DescId = zc_Object_ProfitLossDirection()
     AND Object.ObjectCode IN (10200, 10700)
  UNION ALL
   -- с/с реализации + Скидка за вес + Разница в весе
   SELECT Object.DescId
        , Object.Id AS AnalyzerId
        , Object.ObjectCode
        , Object.ValueData
        , TRUE AS isSale
        , TRUE AS isCost
        , TRUE AS isSumm
   FROM Object
   WHERE Object.DescId = zc_Object_ProfitLossDirection()
     AND Object.ObjectCode IN (10400, 10500, 40200)
  UNION ALL
   -- с/с возвратов + Разница в весе
   SELECT Object.DescId
        , Object.Id AS AnalyzerId
        , Object.ObjectCode
        , Object.ValueData
        , FALSE AS isSale
        , TRUE AS isCost
        , TRUE AS isSumm
   FROM Object
   WHERE Object.DescId = zc_Object_ProfitLossDirection()
     AND Object.ObjectCode IN (10800, 40200)

  UNION ALL
   -- Кол-во реализации + Скидка за вес + Разница в весе
   SELECT Object.DescId
        , Object.Id AS AnalyzerId
        , Object.ObjectCode
        , Object.ValueData
        , TRUE AS isSale
        , FALSE AS isCost
        , FALSE AS isSumm
   FROM Object
   WHERE Object.DescId = zc_Object_ProfitLossDirection()
     AND Object.ObjectCode IN (10400, 10500, 40200)
  UNION ALL
   -- Кол-во возвратов + Разница в весе
   SELECT Object.DescId
        , Object.Id AS AnalyzerId
        , Object.ObjectCode
        , Object.ValueData
        , FALSE AS isSale
        , FALSE AS isCost
        , FALSE AS isSumm
   FROM Object
   WHERE Object.DescId = zc_Object_ProfitLossDirection()
     AND Object.ObjectCode IN (10800, 40200)

  ;

ALTER TABLE Constant_ProfitLoss_AnalyzerId_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 18.12.14                                        *
*/

-- тест
-- SELECT * FROM Constant_ProfitLoss_AnalyzerId_View ORDER BY 2
