DROP FUNCTION IF EXISTS zc_Calc_NumPhraseUA (NUMERIC, Integer);

CREATE OR REPLACE FUNCTION zc_Calc_NumPhraseUA(
    IN inNum                NUMERIC   ,
    IN inGender             Integer
)
RETURNS TVarChar AS
$BODY$
    DECLARE nword  text;
    DECLARE th SMALLINT;
    DECLARE gr SMALLINT;
    DECLARE d3 SMALLINT;
    DECLARE d2 SMALLINT;
    DECLARE d1 SMALLINT;
BEGIN

     IF inNum < 0
     THEN
         RETURN ('*** Error: Negative value');
     ELSE
      IF inNum = 0
      THEN
         RETURN COALESCE ('Ќуль', '');
      END IF;
     END IF;

  WHILE inNum > 0 LOOP

    th := COALESCE(th, 0) + 1;
    gr := inNum%1000;
    inNum := (inNum - gr)/1000;

    IF gr > 0 THEN
    BEGIN
      d3 := (gr - gr%100)/100;
      d1 := gr%10;
      d2 := (gr - d3*100 - d1)/10;
      IF d2 = 1 THEN d1 := 10 + d1; END IF;

      SELECT
                  CASE d3
                    WHEN 1 THEN ' сто'
                    WHEN 2 THEN ' двiст≥'
                    WHEN 3 THEN ' триста'
                    WHEN 4 THEN ' чотириста'
                    WHEN 5 THEN ' п`€тсот'
                    WHEN 6 THEN ' ш≥стсот'
                    WHEN 7 THEN ' с≥мсот'
                    WHEN 8 THEN ' в≥с≥мсот'
                    WHEN 9 THEN ' дев`€тсот'
                  ELSE '' END
              || CASE d2
                    WHEN 2 THEN ' двадц€ть'
                    WHEN 3 THEN ' тридц€ть'
                    WHEN 4 THEN ' сорок'
                    WHEN 5 THEN ' п`€тдес€т'
                    WHEN 6 THEN ' ш≥стдес€т'
                    WHEN 7 THEN ' с≥мдес€т'
                    WHEN 8 THEN ' в≥с≥мдес€т'
                    WHEN 9 THEN ' дев`€носто'
                 ELSE '' END
              || CASE d1
                    WHEN 1 THEN (CASE WHEN th=2 or (th=1 and inGender=0) THEN ' одна' WHEN (th=1 and inGender=2) THEN ' одне' ELSE ' один' END)
                    WHEN 2 THEN (case WHEN th=2 or (th=1 and inGender=0) then ' дв≥' else ' два' end)
                    WHEN 3 THEN ' три'
                    WHEN 4 THEN ' чотири'
                    WHEN 5 THEN ' п`€ть'
                    WHEN 6 THEN ' ш≥сть'
                    WHEN 7 THEN ' с≥м'
                    WHEN 8 THEN ' в≥с≥м'
                    WHEN 9 THEN ' дев`€ть'
                    WHEN 10 THEN ' дес€ть'
                    WHEN 11 THEN ' одинадц€ть'
                    WHEN 12 THEN ' дванадц€ть'
                    WHEN 13 THEN ' тринадц€ть'
                    WHEN 14 THEN ' чотирнадц€ть'
                    WHEN 15 THEN ' п`€тнадц€ть'
                    WHEN 16 THEN ' ш≥стнадц€ть'
                    WHEN 17 THEN ' с≥мнадц€ть'
                    WHEN 18 THEN ' в≥с≥мнадц€ть'
                    WHEN 19 THEN ' дев`€тнадц€ть'
                 ELSE '' END
              || CASE th
                    WHEN 2 THEN ' тис€ч'     || (CASE WHEN d1=1 THEN 'а' WHEN d1 in (2,3,4) THEN '≥' ELSE ''   END)
                    WHEN 3 THEN ' м≥льйон' WHEN 4 THEN ' м≥ль€рд' WHEN 5 THEN ' трильйон' WHEN 6 THEN ' квадр≥лл≥он' WHEN 7 then ' кв≥нтильйон'
                 ELSE '' END
              || CASE
                    WHEN th IN (3,4,5,6,7) THEN (CASE WHEN d1=1 then '' WHEN d1 in (2,3,4) THEN 'а' ELSE '≥в' END)
                 ELSE '' END
              || COALESCE(nword,'')
        INTO nword;

    END;
    END IF;

  END LOOP;
  RETURN (upper(substring(nword,2,1)) || substring(nword, 3, length(nword) - 2));




END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zc_Calc_NumPhraseUA (NUMERIC, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 »—“ќ–»я –ј«–јЅќ“ »: ƒј“ј, ј¬“ќ–
               ‘елонюк ».¬.    ухтин ».¬.    лиментьев  .».   ћанько ƒ.ј.
 19.01.15                                                       *
*/

-- тест
--SELECT * FROM zc_Calc_NumPhraseUA (inNum := 4121361, inGender:=1);