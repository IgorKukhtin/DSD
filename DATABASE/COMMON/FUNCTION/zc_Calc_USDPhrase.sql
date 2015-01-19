DROP FUNCTION IF EXISTS zc_Calc_USDPhrase (numeric);

CREATE OR REPLACE FUNCTION zc_Calc_USDPhrase(
    IN inSumm                     numeric
)
RETURNS TVarChar AS
$BODY$
    DECLARE dpart bigint;
    DECLARE dattr bigint;
    DECLARE cpart bigint;
    DECLARE cattr bigint;
BEGIN

  dpart := floor(inSumm);
  dattr := dpart % 100;

  IF dattr > 19 THEN dattr :=  dattr % 10; END IF;

  cpart := floor((inSumm - dpart) * 100);

  IF cpart > 19 THEN cattr := cpart  %10; ELSE cattr := cpart; END IF;
--  RETURN  zc_Calc_NumPhrase( CAST(floor(inSumm) AS BIGINT), 1);
    RETURN(zc_Calc_NumPhrase( CAST(floor(inSumm) AS BIGINT), 1) || ' доллар'

           || CASE
                WHEN dattr = 1 THEN ''
                WHEN dattr in (2,3,4) THEN 'а'
              ELSE 'ов' END
           || ' США ' || right('0' || cast(cpart as varchar(2)), 2) || ' цент'
           || CASE
                WHEN cattr=1 THEN ''
                WHEN cattr in (2,3,4) THEN 'а'
              ELSE 'ов' END);




--  RETURN (CAST(Summ||'-'||rpart AS TEXT));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zc_Calc_USDPhrase (numeric) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.01.15                                                       *
*/

-- тест
--SELECT * FROM zc_Calc_USDPhrase (inSumm:=245351.92);