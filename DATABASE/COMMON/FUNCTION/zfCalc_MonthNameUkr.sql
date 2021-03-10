-- Function: zfCalc_DateToVarCharUkr (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthNameUkr (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthNameUkr (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN 'ѳ����'
               WHEN 2 THEN '�����'
               WHEN 3 THEN '��������'
               WHEN 4 THEN '������'
               WHEN 5 THEN '�������'
               WHEN 6 THEN '�������'
               WHEN 7 THEN '������'
               WHEN 8 THEN '�������'
               WHEN 9 THEN '��������'
               WHEN 10 THEN '�������'
               WHEN 11 THEN '��������'
               WHEN 12 THEN '�������'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthNameUkr (TDateTime) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.03.21                                                       *
*/

-- ����
-- SELECT zfCalc_MonthNameUkr (CURRENT_DATE)
