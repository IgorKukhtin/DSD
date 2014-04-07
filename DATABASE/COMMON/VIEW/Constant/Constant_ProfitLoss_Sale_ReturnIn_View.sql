-- View: Constant_ProfitLoss_Sale_ReturnIn_View

DROP VIEW IF EXISTS Constant_ProfitLoss_Sale_ReturnIn_View CASCADE;

CREATE OR REPLACE VIEW Constant_ProfitLoss_Sale_ReturnIn_View
AS
   SELECT zc_Enum_ProfitLoss_10101() AS ProfitLossId, TRUE AS isSale UNION ALL SELECT zc_Enum_ProfitLoss_10102() AS ProfitLossId, TRUE AS isSale -- Сумма реализации: Продукция + Ирна
  UNION ALL 
   SELECT zc_Enum_ProfitLoss_10201() AS ProfitLossId, TRUE AS isSale UNION ALL SELECT zc_Enum_ProfitLoss_10202() AS ProfitLossId, TRUE AS isSale -- Скидка по акциям: Продукция + Ирна
  UNION ALL 
   SELECT zc_Enum_ProfitLoss_10301() AS ProfitLossId, TRUE AS isSale UNION ALL SELECT zc_Enum_ProfitLoss_10302() AS ProfitLossId, TRUE AS isSale -- Скидка дополнительная: Продукция + Ирна
  UNION ALL 
   SELECT zc_Enum_ProfitLoss_10701() AS ProfitLossId, FALSE AS isSale UNION ALL SELECT zc_Enum_ProfitLoss_10702() AS ProfitLossId, FALSE AS isSale -- Сумма возвратов: Продукция + Ирна
    ;

ALTER TABLE Constant_ProfitLoss_Sale_ReturnIn_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 07.04.14                                        *
*/

-- тест
-- SELECT * FROM Constant_ProfitLoss_Sale_ReturnIn_View ORDER BY 1
