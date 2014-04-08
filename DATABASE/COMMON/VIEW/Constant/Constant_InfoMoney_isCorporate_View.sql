-- View: Constant_InfoMoney_isCorporate_View

DROP VIEW IF EXISTS Constant_InfoMoney_isCorporate_View CASCADE;

CREATE OR REPLACE VIEW Constant_InfoMoney_isCorporate_View
AS
   SELECT zc_Enum_InfoMoney_20801() AS InfoMoneyId -- Алан
  UNION ALL 
   SELECT zc_Enum_InfoMoney_20901() AS InfoMoneyId -- Ирна
  UNION ALL 
   SELECT zc_Enum_InfoMoney_21001() AS InfoMoneyId -- Чапли
  UNION ALL 
   SELECT zc_Enum_InfoMoney_21101() AS InfoMoneyId -- Дворкин
  UNION ALL 
   SELECT zc_Enum_InfoMoney_21151() AS InfoMoneyId -- ЕКСПЕРТ-АГРОТРЕЙД
  ;

ALTER TABLE Constant_InfoMoney_isCorporate_View OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 08.04.14                                        *
*/

-- тест
-- SELECT * FROM Constant_InfoMoney_isCorporate_View ORDER BY 1
