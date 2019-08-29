-- Function: zfCalc_DateToVarCharUkr (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_DateToVarCharUkr (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DateToVarCharUkr (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
  DECLARE cResult TVarChar;
BEGIN
  cResult :=  '"'||to_char(inOperDate, 'dd')||'" ';
  cResult := cResult||
          (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN 'ѳ����'
               WHEN 2 THEN '������'
               WHEN 3 THEN '��������'
               WHEN 4 THEN '������'
               WHEN 5 THEN '�������'
               WHEN 6 THEN '�������'
               WHEN 7 THEN '������'
               WHEN 8 THEN '������'
               WHEN 9 THEN '��������'
               WHEN 10 THEN '�������'
               WHEN 11 THEN '���������'
               WHEN 12 THEN '�������'
               ELSE '???'
          END);
  cResult := cResult||' '||EXTRACT (YEAR FROM inOperDate)||' �.' ;
          
  RETURN cResult;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_DateToVarCharUkr (TDateTime) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.04.15                                        *  
*/

-- ����
-- SELECT zfCalc_DateToVarCharUkr (CURRENT_DATE)
