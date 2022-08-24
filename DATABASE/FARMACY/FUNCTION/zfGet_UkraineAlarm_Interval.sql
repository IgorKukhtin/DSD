-- Function: zfGet_UkraineAlarm_Interval()

  DROP FUNCTION IF EXISTS zfGet_UkraineAlarm_Interval (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION zfGet_UkraineAlarm_Interval(
    IN inUnitId            Integer ,  --
    IN inStartDate         TDateTime, 
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbResult Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    WITH tmpUkraineAlarm AS (SELECT MAX(COALESCE(UkraineAlarm.endDate, CURRENT_TIMESTAMP)) - 
                                    MIN(CASE WHEN inStartDate > UkraineAlarm.startDate THEN inStartDate ELSE UkraineAlarm.startDate END) AS Interv
                             FROM UkraineAlarm
                             WHERE UkraineAlarm.startDate > CURRENT_DATE - INTERVAL '2 DAY'
                               AND (UkraineAlarm.endDate IS NULL OR UkraineAlarm.endDate >= inStartDate)
                               AND (inUnitId in (3457773, 6741875) AND UkraineAlarm.regionId in (9, 47, 351) OR
                                    inUnitId in (1529734, 8156016) AND UkraineAlarm.regionId in (9, 42, 300) OR
                                    inUnitId NOT in (3457773, 6741875, 1529734, 8156016) AND UkraineAlarm.regionId in (9, 44, 332)
                                   ))
                                   
    SELECT date_part('MINUTE', tmpUkraineAlarm.Interv)::Integer + 1
    INTO vbResult
    FROM tmpUkraineAlarm;
    
    RETURN COALESCE (vbResult, 0);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.08.22                                                       *
*/

-- ����
-- 

SELECT * FROM zfGet_UkraineAlarm_Interval (3457773, CURRENT_TIMESTAMP - INTERVAL '50 MINUTE', inSession:= '3')