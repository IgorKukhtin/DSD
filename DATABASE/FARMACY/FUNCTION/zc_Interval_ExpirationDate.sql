-- Function: zfCalc_UserSite

DROP FUNCTION IF EXISTS zc_Interval_ExpirationDate() ;


CREATE OR REPLACE FUNCTION zc_Interval_ExpirationDate() 
RETURNS Interval 
AS 
$BODY$
BEGIN 
    RETURN
          ('12 MONTH' );
END; 
$BODY$ 
LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.09.16         *                             *
*/

-- тест
-- 