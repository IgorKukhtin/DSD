-- View: TaxPercent_View

DROP VIEW IF EXISTS TaxPercent_View CASCADE;

CREATE OR REPLACE VIEW TaxPercent_View
AS
      SELECT
             CAST ('01.01.2000' AS TDateTime)           AS StartDate
           , CAST ('01.01.2200' AS TDateTime)           AS EndDate
           , CAST (20 AS TFloat)                        AS Percent

       ;



ALTER TABLE TaxPercent_View OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 09.02.14                                                        *

*/

-- тест
-- SELECT * FROM TaxPercent_View