-- Function: zfCalc_MonthYearName (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthYearName (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthYearName (inOperDate TDateTime)
RETURNS TVarChar AS
$BODY$
BEGIN

  RETURN (zfCalc_MonthName (inOperDate) || '-' || EXTRACT (YEAR FROM inOperDate));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_MonthYearName (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.04.15                                        *  
*/

-- ����
-- SELECT zfCalc_MonthYearName (CURRENT_DATE)
