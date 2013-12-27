-- View: test_view_personalservice

 DROP VIEW IF EXISTS test_View_PersonalService;

CREATE OR REPLACE VIEW test_View_PersonalService AS 
 -- Здесь данные для расчета з\п
       SELECT '2013-11-04'::TDateTime, 2702 AS GoodsId, 10 AS Amount
 UNION SELECT '2013-11-14'::TDateTime, 2702 AS GoodsId, 40 AS Amount

 UNION SELECT '2013-11-11'::TDateTime, 2781 AS GoodsId, 40 AS Amount
 UNION SELECT '2013-11-15'::TDateTime, 2781 AS GoodsId, 60 AS Amount

 UNION SELECT '2013-11-12'::TDateTime, 3761 AS GoodsId, 30 AS Amount
 UNION SELECT '2013-11-17'::TDateTime, 3761 AS GoodsId, 70 AS Amount;


ALTER TABLE test_View_PersonalService OWNER TO postgres;
/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.12.13                        *                 
*/

-- тест
