-- Function: сравниваем числа , если разные ошибка

DROP FUNCTION IF EXISTS zfCalc_Summ_Equal (TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Summ_Equal(
    IN inSumm1          TFloat, -- 
    IN inSumm2          TFloat  -- 
)
RETURNS TFloat
AS
$BODY$
BEGIN
     IF COALESCE (inSumm1,0) <> COALESCE (inSumm2,0)
     THEN
         -- 
         RAISE EXCEPTION 'Ошибка. Cумма к оплате не соответствует сумме счета.'; 
     END IF;

     RETURN COALESCE (inSumm1, 0);

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 14.12.23         *
*/

-- тест
-- SELECT * FROM zfCalc_Summ_Equal (inSumm1:= 100, inSumm2:= 100)
