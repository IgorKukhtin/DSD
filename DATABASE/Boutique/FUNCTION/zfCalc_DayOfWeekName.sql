-- Function: zfCalc_DayOfWeekName (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_DayOfWeekName (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_DayOfWeekName (inOperDate TDateTime)
RETURNS TABLE (Ord_dow            Integer
             , Ord                Integer
             , DayOfWeekName      TVarChar
             , DayOfWeekName_Full TVarChar
              )
AS
$BODY$
BEGIN
  RETURN QUERY
  SELECT EXTRACT (DOW FROM inOperDate) :: Integer AS Ord_dow
       , CASE EXTRACT (DOW FROM inOperDate) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM inOperDate) END  :: Integer AS Ord
       , CASE EXTRACT (DOW FROM inOperDate)
               WHEN 1 THEN '��'
               WHEN 2 THEN '��'
               WHEN 3 THEN '��'
               WHEN 4 THEN '��'
               WHEN 5 THEN '��'
               WHEN 6 THEN '��'
               WHEN 0 THEN '��'
               ELSE '???'
          END :: TVarChar AS DayOfWeekName
       , CASE EXTRACT (DOW FROM inOperDate)
               WHEN 1 THEN '�����������'
               WHEN 2 THEN '�������'
               WHEN 3 THEN '�����'
               WHEN 4 THEN '�������'
               WHEN 5 THEN '�������'
               WHEN 6 THEN '�������'
               WHEN 0 THEN '�����������'
               ELSE '???'
          END :: TVarChar AS DayOfWeekName_Full
         ;
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
-- SELECT zfCalc.* FROM (SELECT GENERATE_SERIES (CURRENT_DATE, CURRENT_DATE + INTERVAL '6 DAY', '1 DAY' :: INTERVAL) AS OperDate) AS tmp CROSS JOIN zfCalc_DayOfWeekName (tmp.OperDate) AS zfCalc ORDER BY 2
