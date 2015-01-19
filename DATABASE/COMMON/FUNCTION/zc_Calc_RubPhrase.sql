--DROP FUNCTION IF EXISTS zc_Calc_RubPhrase ();
DROP FUNCTION IF EXISTS zc_Calc_RubPhrase (numeric);

CREATE OR REPLACE FUNCTION zc_Calc_RubPhrase(
    IN inSumm                     numeric
)
RETURNS TVarChar AS
$BODY$
    DECLARE rpart bigint;
    DECLARE rattr bigint;
    DECLARE cpart bigint;
    DECLARE cattr bigint;
BEGIN

  rpart := floor(inSumm);
  rattr := rpart%100;

  IF rattr > 19 THEN rattr :=  rattr%10; END IF;

  cpart := floor((inSumm - rpart) * 100);

  IF cpart > 19 THEN cattr := cpart%10; ELSE cattr := cpart; END IF;

  RETURN(zc_Calc_NumPhrase(rpart,1) || ' ����'
           || CASE
                WHEN rattr=1 then '�'
                WHEN rattr in (2,3,4) then '�'
              ELSE '��' END || ' '
           || right('0' || cast(cpart as varchar(2)), 2)||' ����'
           || CASE
                WHEN cattr = 1 then '���'
                WHEN cattr in (2,3,4) then '���'
              ELSE '��' END);


--  RETURN (CAST(Summ||'-'||rpart AS TEXT));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zc_Calc_RubPhrase (numeric) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.01.15                                                       *
*/

-- ����
--SELECT * FROM zc_Calc_RubPhrase (inSumm:=245351.92);