-- Function: gpGet_SheetWorkTime_ShowPUSH (TVarChar)

-- DROP FUNCTION IF EXISTS gpGet_SheetWorkTime_ShowPUSH (TVarChar);
DROP FUNCTION IF EXISTS gpGet_SheetWorkTime_ShowPUSH (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_SheetWorkTime_ShowPUSH(
    IN inNumber       Integer,          -- ��� ���������
   OUT outShowMessage Boolean,          -- ��������� ���������
   OUT outPUSHType    Integer,          -- ��� ���������
   OUT outText        Text,             -- ����� ���������
    IN inSession      TVarChar          -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId_close Integer;
   DECLARE vbOperDate_close TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    outShowMessage := FALSE;


    IF vbUserId = 5 OR 1=1
    THEN

    -- 1
    IF inNumber = 1
    THEN
        -- ����� ��������� ��������
        vbMovementId_close:= (SELECT MovementDate_TimeClose.MovementId
                              FROM MovementDate AS MovementDate_TimeClose -- ����/����� ��������
                                   --
                                   INNER JOIN Movement ON Movement.Id       = MovementDate_TimeClose.MovementId
                                                      AND Movement.DescId   = zc_Movement_SheetWorkTimeClose()
                                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                   -- ���� ���������
                                   INNER JOIN MovementBoolean AS MovementBoolean_ClosedAuto
                                                              ON MovementBoolean_ClosedAuto.MovementId = Movement.Id
                                                             AND MovementBoolean_ClosedAuto.DescId     = zc_MovementBoolean_ClosedAuto()
                                                             AND MovementBoolean_ClosedAuto.ValueData  = TRUE
                              WHERE -- �� 3 ��� �� �������� �������
                                    MovementDate_TimeClose.ValueData BETWEEN CURRENT_TIMESTAMP AND CURRENT_TIMESTAMP + INTERVAL '3 DAY'
                                AND MovementDate_TimeClose.DescId = zc_MovementDate_TimeClose()
                              ORDER BY Movement.OperDate DESC
                              LIMIT 1
                             );
        -- ����/����� ��������
        vbOperDate_close:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = vbMovementId_close AND MD.DescId = zc_MovementDate_TimeClose());

        -- �������� - ����� ������ ����� ������
        IF  vbMovementId_close > 0
        THEN
            outText:= '��������!!!!'
           ||CHR(13)|| EXTRACT (DAY FROM vbOperDate_close) || ' �����'
                    || CASE WHEN EXTRACT (MONTH FROM vbOperDate_close) = EXTRACT (MONTH FROM CURRENT_DATE) THEN ' �������� ������' ELSE ' ���������� ������' END
           ||CHR(13)||'� ' || zfConvert_TimeShortToString (vbOperDate_close)
                    ||' ����� ������������ �������� ������.'
           ||CHR(13)||'�������������� ������ � �������� ������� ����� ����������!!!'
           ||CHR(13)||'������� ��ʻ, ��� �� �����������.'
          ;
        END IF;

    END IF;


    -- 2
    IF inNumber = 2
    THEN
        -- �������� - ����-2
        IF EXTRACT (DAY FROM CURRENT_DATE) IN (1,15)
        THEN
            outText:= '��������!!!!'
           ||CHR(13)||'������� �������� � ����� ������'
           ||CHR(13)||'�������� �� �������������'
           ||CHR(13)||'� ��������� �� ���� ��� ������.'
          ;
        END IF;
    END IF;


    -- 3
    IF inNumber = 3
    THEN
        -- �������� - ����-3
        IF EXISTS (SELECT 1
                   FROM ObjectLink AS ObjectLink_User_Member
                        LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                             ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                            AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                        LEFT JOIN ObjectLink AS ObjectLink_Unit_PersonalHead
                                             ON ObjectLink_Unit_PersonalHead.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                            AND ObjectLink_Unit_PersonalHead.DescId        = zc_ObjectLink_Unit_PersonalHead()
                        JOIN Movement AS Movement_SheetWorkTime
                                      ON Movement_SheetWorkTime.OperDate BETWEEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH' AND DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
                                     AND Movement_SheetWorkTime.StatusId <> zc_Enum_Status_Erased()

                        JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id
                                               AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                               AND MovementLinkObject_Unit.ObjectId   = ObjectLink_Unit_PersonalHead.ObjectId
                        LEFT JOIN MovementBoolean AS MovementBoolean_CheckedHead
                                                  ON MovementBoolean_CheckedHead.MovementId = Movement_SheetWorkTime.Id
                                                 AND MovementBoolean_CheckedHead.DescId     = zc_MovementBoolean_CheckedHead()
                                                 AND MovementBoolean_CheckedHead.ValueData  = TRUE
                   WHERE ObjectLink_User_Member.ObjectId = vbUserId
                     AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                     AND MovementBoolean_CheckedHead.MovementId IS NULL
                  )
         --OR vbUserId = 5
        THEN
            outText:= '��������!!!!'
           ||CHR(13)||'�� �� ����������� ��������'
           ||CHR(13)||'������ ��� <' || lfGet_Object_ValueData_sh ((SELECT MovementLinkObject_Unit.ObjectId
                                                                    FROM ObjectLink AS ObjectLink_User_Member
                                                                         LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                                                                              ON ObjectLink_Personal_Member.ChildObjectId = ObjectLink_User_Member.ChildObjectId
                                                                                             AND ObjectLink_Personal_Member.DescId        = zc_ObjectLink_Personal_Member()
                                                                         LEFT JOIN ObjectLink AS ObjectLink_Unit_PersonalHead
                                                                                              ON ObjectLink_Unit_PersonalHead.ChildObjectId = ObjectLink_Personal_Member.ObjectId
                                                                                             AND ObjectLink_Unit_PersonalHead.DescId        = zc_ObjectLink_Unit_PersonalHead()
                                                                         JOIN Movement AS Movement_SheetWorkTime
                                                                                       ON Movement_SheetWorkTime.OperDate BETWEEN DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 MONTH' AND DATE_TRUNC ('MONTH', CURRENT_DATE) - INTERVAL '1 DAY'
                                                                                      AND Movement_SheetWorkTime.StatusId <> zc_Enum_Status_Erased()
                                                 
                                                                         JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                                                 ON MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id
                                                                                                AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                                                                                                AND (MovementLinkObject_Unit.ObjectId   = ObjectLink_Unit_PersonalHead.ObjectId
                                                                                                --OR vbUserId = 5
                                                                                                    )
                                                                         LEFT JOIN MovementBoolean AS MovementBoolean_CheckedHead
                                                                                                   ON MovementBoolean_CheckedHead.MovementId = Movement_SheetWorkTime.Id
                                                                                                  AND MovementBoolean_CheckedHead.DescId     = zc_MovementBoolean_CheckedHead()
                                                                                                  AND MovementBoolean_CheckedHead.ValueData  = TRUE
                                                                    WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                                                      AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
                                                                      AND MovementBoolean_CheckedHead.MovementId IS NULL
                                                                    LIMIT 1
                                                                  ))
                    || '>'
           ||CHR(13)||'�� ��������� �����.'
           ||CHR(13)||'������� ��ʻ, ��� �� �����������.'
          ;
        END IF;
    END IF;


    --
    IF COALESCE (outText, '') <> ''
    THEN
      outShowMessage := True;
      outPUSHType := 3;

    END IF;

    END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.11.21                                        *
*/

-- SELECT * FROM gpGet_SheetWorkTime_ShowPUSH (inNumber:= 1, inSession:= zfCalc_UserAdmin())
