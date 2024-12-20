-- Function: gpSelect_UserTimePenalty()

DROP FUNCTION IF EXISTS gpSelect_UserTimePenalty(TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_UserTimePenalty(
    IN inDate        TDateTime ,
    IN inUserID      Integer   ,
    IN inUserName    TVarChar  ,
    IN inSession     TVarChar    -- ������ ������������
)
  RETURNS SETOF refcursor
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate TDateTime;
  DECLARE cur1 refcursor;
  DECLARE cur2 refcursor;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());

     vbOperDate:= DATE_TRUNC ('MONTH', inDate);

     OPEN cur1 FOR SELECT '�������� �� ���������� '||inUserName||' ������� ��������� �� '||
       to_char(DATE_TRUNC ('DAY', vbOperDate), 'MM.YYYY')::TVarChar as Title,
       1::Integer as ID;
     RETURN NEXT cur1;

     CREATE TEMP TABLE tmpCurrOperDate ON COMMIT DROP AS
        SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inDate), DATE_TRUNC ('MONTH', inDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;

     OPEN cur2 FOR
     WITH tmpEmployeeSchedule AS (SELECT tmpCurrOperDate.OperDate::TDateTime
            , DateIn.Value
            , Min(EmployeeWorkLog.DateLogIn)::TDateTime AS DateStart
            , DateIn.HourIn
            , ((date_part('hour', Min(EmployeeWorkLog.DateLogIn)) - COALESCE(DateIn.HourIn, 8)) * 60 +
              date_part('minute', Min(EmployeeWorkLog.DateLogIn)))::Integer                                  AS MinutePenalty

       FROM tmpCurrOperDate
            LEFT JOIN gpSelect_MovementItem_EmployeeSchedule_KPU(vbOperDate, inSession) AS DateIn
                                                                                        ON DateIn.UserID = inUserID
                                                                                       AND DateIn.Date = tmpCurrOperDate.OperDate
            LEFT JOIN EmployeeWorkLog ON EmployeeWorkLog.UserId = inUserID
                                     AND EmployeeWorkLog.DateLogIn >= tmpCurrOperDate.OperDate
                                     AND EmployeeWorkLog.DateLogIn < tmpCurrOperDate.OperDate + INTERVAL '1 DAY'
       GROUP BY tmpCurrOperDate.OperDate
              , DateIn.Value
              , DateIn.HourIn)

     SELECT tmpEmployeeSchedule.OperDate                         AS OperDate
          , tmpEmployeeSchedule.Value                            AS TypeDay
          , to_char(tmpEmployeeSchedule.DateStart, 'HH24:MI:SS') AS DateStart
          , CASE WHEN COALESCE(tmpEmployeeSchedule.HourIn, 8) > 0 AND tmpEmployeeSchedule.MinutePenalty > 1 THEN tmpEmployeeSchedule.MinutePenalty END AS MinutePenalty
          , CASE WHEN COALESCE(tmpEmployeeSchedule.Value, '�') <> '�' AND tmpEmployeeSchedule.DateStart IS NULL THEN - 3
                 ELSE CASE WHEN COALESCE(tmpEmployeeSchedule.HourIn, 8) > 0 AND tmpEmployeeSchedule.MinutePenalty > 1 AND tmpEmployeeSchedule.MinutePenalty <= 5 THEN - 1
                 ELSE CASE WHEN COALESCE(tmpEmployeeSchedule.HourIn, 8) > 0 AND tmpEmployeeSchedule.MinutePenalty > 1 AND tmpEmployeeSchedule.MinutePenalty <= 15 THEN - 2
                 ELSE CASE WHEN COALESCE(tmpEmployeeSchedule.HourIn, 8) > 0 AND tmpEmployeeSchedule.MinutePenalty > 1 AND tmpEmployeeSchedule.MinutePenalty > 15 THEN - 3
                 END END END END                                                    AS Penalty

     FROM tmpEmployeeSchedule
     ORDER BY tmpEmployeeSchedule.OperDate;
     RETURN NEXT cur2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_UserTimePenalty (TDateTime, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.01.19                                                       *
 11.01.19                                                       *
 09.01.19                                                       *
*/

-- ����
-- select * from gpSelect_UserTimePenalty(inDate:= '31.12.2018', inUserID := 6002014, inUserName := 'sadfssad', inSession := '4183126');