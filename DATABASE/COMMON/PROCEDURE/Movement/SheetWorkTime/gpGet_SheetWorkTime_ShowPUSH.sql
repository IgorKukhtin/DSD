-- Function: gpGet_SheetWorkTime_ShowPUSH (TVarChar)

DROP FUNCTION IF EXISTS gpGet_SheetWorkTime_ShowPUSH (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_SheetWorkTime_ShowPUSH(
   OUT outShowMessage Boolean,          -- ��������� ���������
   OUT outPUSHType    Integer,          -- ��� ���������
   OUT outText        Text,             -- ����� ���������
    IN inSession      TVarChar          -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    outShowMessage := FALSE;

    IF vbUserId = 5
    THEN

    -- �������� - ������ ������
    IF  EXISTS (SELECT 1
                FROM Movement
                     INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                             ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                            AND MovementDate_OperDateEnd.DescId   = zc_MovementDate_OperDateEnd()
                                            AND MovementDate_OperDateEnd.ValueData - INTERVAL '2 DAY' <= CURRENT_DATE
                     LEFT JOIN MovementDate AS MovementDate_TimeClose
                                            ON MovementDate_TimeClose.MovementId = Movement.Id
                                           AND MovementDate_TimeClose.DescId = zc_MovementDate_TimeClose()
                     LEFT JOIN MovementBoolean AS MovementBoolean_ClosedAuto
                                               ON MovementBoolean_ClosedAuto.MovementId = Movement.Id
                                              AND MovementBoolean_ClosedAuto.DescId = zc_MovementBoolean_ClosedAuto()
                WHERE Movement.DescId = zc_Movement_SheetWorkTimeClose()
                  AND Movement.OperDate >= DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH'
                  AND Movement.StatusId = zc_Enum_Status_Complete()
                  AND MovementBoolean_ClosedAuto.ValueData = TRUE AND MovementDate_TimeClose.ValueData + INTERVAL '3 DAY' >= CURRENT_TIMESTAMP
               )
    THEN
        outText:= '��������!!!!'
       ||CHR(13)||'_______����� �������� ������'
       ||CHR(13)||'�       _________����� ����� ������������ �������� ������.'
       ||CHR(13)||'�������������� ������ � �������� ������� ����� ����������!!!'
       ||CHR(13)||'������� ��ʻ, ��� �� �����������;'
    END IF;

    --
    IF COALESCE (outText, '') <> ''
    THEN
      outShowMessage := True;
      outPUSHType := 3;
     END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.11.21                                        *
*/

-- SELECT * FROM gpGet_SheetWorkTime_ShowPUSH (inSession:= zfCalc_UserAdmin())
