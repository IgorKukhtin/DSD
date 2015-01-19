DROP FUNCTION IF EXISTS zc_Calc_NumPhrase (NUMERIC, Integer);

CREATE OR REPLACE FUNCTION zc_Calc_NumPhrase(
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
         RETURN COALESCE ('Ноль', '');
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
                    WHEN 2 THEN ' двести'
                    WHEN 3 THEN ' триста'
                    WHEN 4 THEN ' четыреста'
                    WHEN 5 THEN ' пятьсот'
                    WHEN 6 THEN ' шестьсот'
                    WHEN 7 THEN ' семьсот'
                    WHEN 8 THEN ' восемьсот'
                    WHEN 9 THEN ' девятьсот'
                  ELSE '' END
              || CASE d2
                    WHEN 2 THEN ' двадцать'
                    WHEN 3 THEN ' тридцать'
                    WHEN 4 THEN ' сорок'
                    WHEN 5 THEN ' пятьдесят'
                    WHEN 6 THEN ' шестьдесят'
                    WHEN 7 THEN ' семьдесят'
                    WHEN 8 THEN ' восемьдесят'
                    WHEN 9 THEN ' девяносто'
                 ELSE '' END
              || CASE d1
                    WHEN 1 THEN (CASE WHEN th=2 or (th=1 and inGender=0) THEN ' одна' WHEN (th=1 and inGender=2) THEN ' одно' ELSE ' один' END)
                    WHEN 2 THEN (case WHEN th=2 or (th=1 and inGender=0) then ' две' else ' два' end)
                    WHEN 3 THEN ' три'
                    WHEN 4 THEN ' четыре'
                    WHEN 5 THEN ' пять'
                    WHEN 6 THEN ' шесть'
                    WHEN 7 THEN ' семь'
                    WHEN 8 THEN ' восемь'
                    WHEN 9 THEN ' девять'
                    WHEN 10 THEN ' десять'
                    WHEN 11 THEN ' одиннадцать'
                    WHEN 12 THEN ' двенадцать'
                    WHEN 13 THEN ' тринадцать'
                    WHEN 14 THEN ' четырнадцать'
                    WHEN 15 THEN ' пятнадцать'
                    WHEN 16 THEN ' шестнадцать'
                    WHEN 17 THEN ' семнадцать'
                    WHEN 18 THEN ' восемнадцать'
                    WHEN 19 THEN ' девятнадцать'
                 ELSE '' END
              || CASE th
                    WHEN 2 THEN ' тысяч'     || (CASE WHEN d1=1 THEN 'а' WHEN d1 in (2,3,4) THEN 'и' ELSE ''   END)
                    WHEN 3 THEN ' миллион' WHEN 4 THEN ' миллиард' WHEN 5 THEN ' триллион' WHEN 6 THEN ' квадриллион' WHEN 7 then ' квинтиллион'
                 ELSE '' END
              || CASE
                    WHEN th IN (3,4,5,6,7) THEN (CASE WHEN d1=1 then '' WHEN d1 in (2,3,4) THEN 'а' ELSE 'ов' END)
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
ALTER FUNCTION zcCalc_NumPhrase (NUMERIC, Integer) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 19.01.15                                                       *
*/

-- тест
--SELECT * FROM zc_Calc_NumPhrase (inNum := 4121361, inGender:=1);