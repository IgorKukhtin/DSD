-- Function: zfCalc_MonthNameUkr_export (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthNameUkr_export (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthNameUkr_export (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN '����'
               WHEN 2 THEN '������'
               WHEN 3 THEN '�������'
               WHEN 4 THEN '�����'
               WHEN 5 THEN '������'
               WHEN 6 THEN '�������'
               WHEN 7 THEN '�����'
               WHEN 8 THEN '������'
               WHEN 9 THEN '�������'
               WHEN 10 THEN '������'
               WHEN 11 THEN '���������'
               WHEN 12 THEN '������'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

-------------------------------------------------------------------------------
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.03.21                                                       *
*/

-- ����
-- SELECT zfCalc_MonthNameUkr_export (CURRENT_DATE)
