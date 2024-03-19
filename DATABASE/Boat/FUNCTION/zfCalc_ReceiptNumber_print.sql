-- Function: zfCalc_ReceiptNumber_print (TVarChar, TVarChar, TDateTime, Integer)

DROP FUNCTION IF EXISTS zfCalc_ReceiptNumber_print (TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_ReceiptNumber_print (inReceiptNumber TVarChar)
RETURNS TVarChar
AS
$BODY$
BEGIN
      RETURN REPEAT ('0', 8 - LENGTH (COALESCE (inReceiptNumber, ''))) || COALESCE (inReceiptNumber, '')
     ;

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.05.21                                        *
*/

-- тест
-- SELECT zfCalc_ReceiptNumber_print ('123')
