-- Function: zfCalc_Comment_pay_OrderFinance

-- DROP FUNCTION IF EXISTS zfCalc_Comment_pay_OrderFinance (TVarChar, TVarChar, TVarChar, TDateTime, TFloat, TFloat);
DROP FUNCTION IF EXISTS zfCalc_Comment_pay_OrderFinance (TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TFloat, TFloat);

CREATE OR REPLACE FUNCTION zfCalc_Comment_pay_OrderFinance(
    IN inComment     Text,
    IN inNOM_DOG     TVarChar,
    IN inNOM_IVOICE  TVarChar,
    IN inTOVAR       TVarChar,
    IN inDATA_DOG    TDateTime,
    IN inPDV         TFloat,
    IN inSUMMA_P     TFloat
)
RETURNS Text
AS
$BODY$
BEGIN

     RETURN REPLACE
           (REPLACE
           (REPLACE
           (REPLACE
           (REPLACE
           (REPLACE (COALESCE (inComment, ''), 'NOM_DOG',    COALESCE (inNOM_DOG, ''))
                                             , 'NOM_IVOICE', COALESCE (inNOM_IVOICE, ''))
                                             , 'TOVAR',      COALESCE (inTOVAR, ''))
                                             , 'DATA_DOG',   zfConvert_DateToString (COALESCE (inDATA_DOG, zc_DateStart())))
                                             , 'PDV',        '20')
                                             , 'SUMMA_P',    zfConvert_FloatToString (ROUND(COALESCE (inSUMMA_P, 0)/6, 2)));

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.09.25                                        *
*/

-- тест
-- SELECT * FROM zfCalc_Comment_pay_OrderFinance ('text: 1(NOM_DOG) 2(NOM_IVOICE) 3(TOVAR)  4(DATA_DOG) 5(PDV) 6(SUMMA_P)', '11', '22', '33', CURRENT_DATE, 44, 240);
