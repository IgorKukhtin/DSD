-- Function: zfCalc_MonthName (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthName (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthName (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN '������'
               WHEN 2 THEN '�������'
               WHEN 3 THEN '����'
               WHEN 4 THEN '������'
               WHEN 5 THEN '���'
               WHEN 6 THEN '����'
               WHEN 7 THEN '����'
               WHEN 8 THEN '������'
               WHEN 9 THEN '��������'
               WHEN 10 THEN '�������'
               WHEN 11 THEN '������'
               WHEN 12 THEN '�������'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthName (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.04.15                                        *  
*/

-- ����
-- SELECT zfCalc_MonthName (CURRENT_DATE)
