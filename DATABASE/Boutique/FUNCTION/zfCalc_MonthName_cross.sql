-- Function: zfCalc_MonthName_cross (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthName_cross (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthName_cross (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (MONTH FROM inOperDate)
               WHEN 1 THEN '01-������'
               WHEN 2 THEN '02-�������'
               WHEN 3 THEN '03-����'
               WHEN 4 THEN '04-������'
               WHEN 5 THEN '05-���'
               WHEN 6 THEN '06-����'
               WHEN 7 THEN '07-����'
               WHEN 8 THEN '08-������'
               WHEN 9 THEN '09-��������'
               WHEN 10 THEN '10-�������'
               WHEN 11 THEN '11-������'
               WHEN 12 THEN '12-�������'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthName_cross (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.02.18                                        *  
*/

-- ����
-- SELECT zfCalc_MonthName_cross (CURRENT_DATE)
