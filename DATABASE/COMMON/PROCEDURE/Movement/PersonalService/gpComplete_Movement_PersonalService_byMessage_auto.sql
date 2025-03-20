-- Function: gpComplete_Movement_PersonalService_byMessage_auto()

DROP FUNCTION IF EXISTS gpComplete_Movement_PersonalService_byMessage_auto (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_PersonalService_byMessage_auto(
    IN inStartDate            TDateTime , -- ����
    IN inEndDate              TDateTime , -- ����
    IN inSessionCode          Integer   , -- � ������ MessagePersonalService
    IN inSession              TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId    Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService_Child());
     vbUserId:= lpGetUserBySession (inSession);

     --  �������� ���������
     PERFORM gpComplete_Movement_PersonalService (tmp.MovementId, inSession)
     FROM
         (WITH
          tmpPersonalServiceList AS (SELECT DISTINCT tmp.PersonalServiceListId
                                     FROM gpSelect_Object_MessagePersonalService(inSessionCode := inSessionCode
                                                                               , inPersonalServiceListId := 0
                                                                               , inSession := inSession) AS tmp 
                                     WHERE tmp.Name LIKE '%��� ������%' 
                                     )
          SELECT tmp.MovementId
          FROM (SELECT MovementDate_ServiceDate.MovementId
                     , ROW_NUMBER () OVER (PARTITION BY tmpPSL.PersonalServiceListId ORDER BY CASE WHEN MovementBoolean_isAuto.ValueData = TRUE THEN 0 ELSE 1 END, MovementDate_ServiceDate.MovementId) AS Ord
                FROM tmpPersonalServiceList AS tmpPSL
                     INNER JOIN MovementLinkObject AS MLO_PersonalServiceList
                                                   ON MLO_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
                                                  AND MLO_PersonalServiceList.ObjectId   = tmpPSL.PersonalServiceListId
                     INNER JOIN Movement ON Movement.Id = MLO_PersonalServiceList.MovementId
                                        AND Movement.DescId   = zc_Movement_PersonalService()
                                        AND Movement.StatusId <> zc_Enum_Status_Erased()
                     INNER JOIN MovementDate AS MovementDate_ServiceDate
                                             ON MovementDate_ServiceDate.MovementId = Movement.Id
                                            AND MovementDate_ServiceDate.ValueData = DATE_TRUNC ('MONTH', inEndDate::TDateTime)
                                            AND MovementDate_ServiceDate.DescId    = zc_MovementDate_ServiceDate()
                     LEFT JOIN MovementBoolean AS MovementBoolean_isAuto
                                               ON MovementBoolean_isAuto.MovementId = Movement.Id
                                              AND MovementBoolean_isAuto.DescId = zc_MovementBoolean_isAuto()
                ) AS tmp
          WHERE tmp.Ord = 1
         ) AS tmp;
         

    -- ��� �����
    if vbUserId IN (9457) then RAISE EXCEPTION 'Test.Ok.'; end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.03.25         *
*/

-- ����
-- SELECT * FROM gpComplete_Movement_PersonalService_byMessage_auto( inStartDate := '01.03.2025', inEndDate := '01.03.2025' , inSessionCode := 46 ::Integer, inSession := '9457' ::TVarChar)
 