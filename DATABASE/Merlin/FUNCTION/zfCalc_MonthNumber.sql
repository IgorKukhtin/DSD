-- Function: zfCalc_MonthNumber (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_MonthNumber (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_MonthNumber (inOperDate TDateTime)
RETURNS TVarChar
AS
$BODY$
BEGIN

  RETURN (CASE WHEN EXTRACT (MONTH FROM inOperDate) < 10 THEN '0' ELSE '' END
       || EXTRACT (MONTH FROM inOperDate) :: TVarChar
         );

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.06.22                                        *  
*/

-- ����
-- SELECT zfCalc_MonthNumber (CURRENT_DATE)
