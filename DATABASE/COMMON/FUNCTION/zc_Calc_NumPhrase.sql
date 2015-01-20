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
         RETURN COALESCE ('����', '');
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
                    WHEN 1 THEN ' ���'
                    WHEN 2 THEN ' ������'
                    WHEN 3 THEN ' ������'
                    WHEN 4 THEN ' ���������'
                    WHEN 5 THEN ' �������'
                    WHEN 6 THEN ' ��������'
                    WHEN 7 THEN ' �������'
                    WHEN 8 THEN ' ���������'
                    WHEN 9 THEN ' ���������'
                  ELSE '' END
              || CASE d2
                    WHEN 2 THEN ' ��������'
                    WHEN 3 THEN ' ��������'
                    WHEN 4 THEN ' �����'
                    WHEN 5 THEN ' ���������'
                    WHEN 6 THEN ' ����������'
                    WHEN 7 THEN ' ���������'
                    WHEN 8 THEN ' �����������'
                    WHEN 9 THEN ' ���������'
                 ELSE '' END
              || CASE d1
                    WHEN 1 THEN (CASE WHEN th=2 or (th=1 and inGender=0) THEN ' ����' WHEN (th=1 and inGender=2) THEN ' ����' ELSE ' ����' END)
                    WHEN 2 THEN (case WHEN th=2 or (th=1 and inGender=0) then ' ���' else ' ���' end)
                    WHEN 3 THEN ' ���'
                    WHEN 4 THEN ' ������'
                    WHEN 5 THEN ' ����'
                    WHEN 6 THEN ' �����'
                    WHEN 7 THEN ' ����'
                    WHEN 8 THEN ' ������'
                    WHEN 9 THEN ' ������'
                    WHEN 10 THEN ' ������'
                    WHEN 11 THEN ' �����������'
                    WHEN 12 THEN ' ����������'
                    WHEN 13 THEN ' ����������'
                    WHEN 14 THEN ' ������������'
                    WHEN 15 THEN ' ����������'
                    WHEN 16 THEN ' �����������'
                    WHEN 17 THEN ' ����������'
                    WHEN 18 THEN ' ������������'
                    WHEN 19 THEN ' ������������'
                 ELSE '' END
              || CASE th
                    WHEN 2 THEN ' �����'     || (CASE WHEN d1=1 THEN '�' WHEN d1 in (2,3,4) THEN '�' ELSE ''   END)
                    WHEN 3 THEN ' �������' WHEN 4 THEN ' ��������' WHEN 5 THEN ' ��������' WHEN 6 THEN ' �����������' WHEN 7 then ' �����������'
                 ELSE '' END
              || CASE
                    WHEN th IN (3,4,5,6,7) THEN (CASE WHEN d1=1 then '' WHEN d1 in (2,3,4) THEN '�' ELSE '��' END)
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
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.01.15                                                       *
*/

-- ����
--SELECT * FROM zc_Calc_NumPhrase (inNum := 4121361, inGender:=1);