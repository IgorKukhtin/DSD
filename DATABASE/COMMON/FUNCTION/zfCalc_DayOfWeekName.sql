-- Function: zfCalc_DayOfWeekName (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_DayOfWeekName (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DayOfWeekName (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN
  RETURN (CASE EXTRACT (DOW FROM inOperDate)
               WHEN 1 THEN '�����������'
               WHEN 2 THEN '�������'
               WHEN 3 THEN '�����'
               WHEN 4 THEN '�������'
               WHEN 5 THEN '�������'
               WHEN 6 THEN '�������'
               WHEN 0 THEN '�����������'
               ELSE '???'
          END);
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_DayOfWeekName (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.16         *  
*/

-- ����
-- SELECT zfCalc_DayOfWeekName (CURRENT_DATE)
