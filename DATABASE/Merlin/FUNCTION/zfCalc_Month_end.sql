-- Function: zfCalc_Month_end (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_Month_end (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_Month_end (inOperDate TDateTime)
RETURNS TDateTime
AS
$BODY$
BEGIN
         RETURN (DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                );
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.08.22                                        *
*/

-- ����
-- SELECT zfCalc_Month_end (CURRENT_DATE)
