-- Function: zfCalc_MonthYearNameUkr (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthYearNameUkr (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthYearNameUkr (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN

  RETURN (zfCalc_MonthNameUkr (inOperDate) || ' ' || EXTRACT (YEAR FROM inOperDate));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthYearNameUkr (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.03.21                                                       *
*/

-- ����
-- SELECT zfCalc_MonthYearNameUkr (CURRENT_DATE)
