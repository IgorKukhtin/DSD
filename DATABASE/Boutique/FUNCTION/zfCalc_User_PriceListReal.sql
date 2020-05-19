-- Function: zfCalc_User_PriceListReal

DROP FUNCTION IF EXISTS zfCalc_User_PriceListReal ();

CREATE OR REPLACE FUNCTION zfCalc_User_PriceListReal(
    IN inUserId Integer -- ключ
)
RETURNS Boolean
AS
$BODY$
BEGIN
     
     RETURN (inUserId IN (23902/*, 2*/));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.05.20                                        * - !!!для тестов!!!
*/

-- тест
-- SELECT * FROM zfCalc_User_PriceListReal (1)
