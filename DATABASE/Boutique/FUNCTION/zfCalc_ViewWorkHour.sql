-- Function: zfCalc_ViewWorkHour

DROP FUNCTION IF EXISTS zfCalc_ViewWorkHour (TFloat, TVarChar);

CREATE OR REPLACE FUNCTION zfCalc_ViewWorkHour(WorkHour TFloat, WorkTimeKindName TVarChar)
RETURNS TVarChar AS
$BODY$
BEGIN
  WorkTimeKindName := COALESCE(WorkTimeKindName, '');
  RETURN to_char(WorkHour, WorkTimeKindName)::TVarChar;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_ViewWorkHour (TFloat, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.10.13                        *  
*/

-- ����
/*
SELECT zfCalc_ViewWorkHour (3.5, 'TVarChar'), zfCalc_ViewWorkHour (4, 'TVarChar'), zfCalc_ViewWorkHour (0, 'TVarChar')
*/