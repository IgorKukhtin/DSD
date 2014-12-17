-- View: Constant_ProfitLoss_Goods_View

-- DROP VIEW IF EXISTS Constant_ProfitLoss_Goods_View CASCADE;

CREATE OR REPLACE VIEW Constant_ProfitLoss_Goods_View
AS
   SELECT ProfitLossGroupId, ProfitLossDirectionId, ProfitLossId, isSale, isCost
             FROM Constant_ProfitLoss_Sale_ReturnIn_View
  UNION ALL 
   -- Скидка за вес: Продукция + Ирна
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10500() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10501() AS ProfitLossId, TRUE AS isSale, TRUE AS isCost
  UNION ALL
   SELECT zc_Enum_ProfitLossGroup_10000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_10500() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_10502() AS ProfitLossId, TRUE AS isSale, TRUE AS isCost

  UNION ALL
   -- Расходы на сбыт + Содержание филиалов + Разница в весе
   SELECT zc_Enum_ProfitLossGroup_40000() AS ProfitLossGroupId, zc_Enum_ProfitLossDirection_40200() AS ProfitLossDirectionId, zc_Enum_ProfitLoss_40208() AS ProfitLossId, TRUE AS isSale, TRUE AS isCost
  ;

ALTER TABLE Constant_ProfitLoss_Goods_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.12.14                                        *
*/

-- тест
-- SELECT * FROM Constant_ProfitLoss_Goods_View LEFT JOIN Object_ProfitLoss_View ON Object_ProfitLoss_View.ProfitLossId = Constant_ProfitLoss_Goods_View.ProfitLossId ORDER BY 3
