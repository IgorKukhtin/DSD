-- Function: zfCalc_UserMobile_limit0 ()

DROP FUNCTION IF EXISTS zfCalc_UserMobile_limit0 (Integer);
DROP FUNCTION IF EXISTS zfCalc_UserMobile_limit0 ();

CREATE OR REPLACE FUNCTION zfCalc_UserMobile_limit0()
RETURNS Integer
AS
$BODY$
BEGIN
      -- Результат
    -- RETURN 1160641;
    RETURN 1058571 ; 
    -- RETURN 0;
END;
$BODY$
  LANGUAGE plpgsql IMMUTABLE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 02.04.17                                        *
*/

-- тест
-- SELECT * FROM Object WHERE Id = zfCalc_UserMobile_limit0()
