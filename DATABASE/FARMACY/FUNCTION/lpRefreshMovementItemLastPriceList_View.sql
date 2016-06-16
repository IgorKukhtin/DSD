-- Function: lpRefreshMovementItemLastPriceList_View()

DROP FUNCTION IF EXISTS lpRefreshMovementItemLastPriceList_View();
DROP FUNCTION IF EXISTS lpRefreshMovementItemLastPriceList_View(
  TVarChar);

CREATE OR REPLACE FUNCTION lpRefreshMovementItemLastPriceList_View(
  IN inSession TVarChar = ''
  )
RETURNS VOID
AS
$BODY$
BEGIN
    REFRESH MATERIALIZED VIEW MovementItemLastPriceList_View;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION lpRefreshMovementItemLastPriceList_View() OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 24.05.16                                                                       *  
*/

-- тест
-- SELECT lpRefreshMovementItemLastPriceList_View();
