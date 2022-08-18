-- Function: zfCalc_Month_start (TDateTime)

DROP FUNCTION IF EXISTS zfCalc_Month_start (TDateTime);

CREATE OR REPLACE FUNCTION zfCalc_Month_start (inOperDate TDateTime)
RETURNS TDateTime
AS
$BODY$
BEGIN
         RETURN (DATE_TRUNC ('MONTH', inOperDate)
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
-- SELECT zfCalc_Month_start (CURRENT_DATE)
