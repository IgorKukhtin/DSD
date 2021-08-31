-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar, INTEGER, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar, INTEGER, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar, INTEGER, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTime(
    IN inMemberId            Integer   , -- ���� ���. ����
    IN inPositionId          Integer   , -- ���������
    IN inPositionLevelId     Integer   , -- ������
    IN inUnitId              Integer   , -- �������������
    IN inPersonalGroupId     Integer   , -- ����������� ����������
    IN inStorageLineId       Integer   , -- ����� �����-��
    IN inOperDate            TDateTime , -- ����
 INOUT ioValue               TVarChar  , -- ����
 INOUT ioTypeId              Integer   , 
   OUT OutAmountHours        Tfloat    , 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbEndDate   TDateTime;

   DECLARE vbValue TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    
    -- ��������� ����� ������
    vbEndDate := DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';

    -- ��������
    IF NOT EXISTS (SELECT 1
                   FROM Object_Personal_View
                   WHERE Object_Personal_View.UnitId     = inUnitId
                     AND Object_Personal_View.MemberId   = inMemberId
                     AND Object_Personal_View.PositionId = inPositionId
                     AND Object_Personal_View.isErased   = FALSE
                  )
    THEN
        RAISE EXCEPTION '������.� ����������� ����������� <%> <%>  <%> �� ������.'
                      , lfGet_Object_ValueData_sh (inMemberId)
                      , lfGet_Object_ValueData_sh (inPositionId)
                      , lfGet_Object_ValueData_sh (inUnitId)
                        ;
    END IF;

    -- ��������
    IF NOT EXISTS (SELECT 1
                   FROM Object_Personal_View
                   WHERE Object_Personal_View.DateIn     <= vbEndDate
                     AND Object_Personal_View.DateOut    >= vbEndDate
                     AND Object_Personal_View.UnitId     = inUnitId
                     AND Object_Personal_View.MemberId   = inMemberId
                     AND Object_Personal_View.PositionId = inPositionId
                  )
    THEN
        IF EXISTS (SELECT 1
                         FROM Object_Personal_View
                         WHERE Object_Personal_View.DateIn     > vbEndDate
                           AND Object_Personal_View.UnitId     = inUnitId
                           AND Object_Personal_View.MemberId   = inMemberId
                           AND Object_Personal_View.PositionId = inPositionId
                        )
        THEN
            RAISE EXCEPTION '������. ��������� <%> <%>  <%> ������ � <%>.���� � ������ �������� ����� ���� ����.'
                          , lfGet_Object_ValueData_sh (inMemberId)
                          , lfGet_Object_ValueData_sh (inPositionId)
                          , lfGet_Object_ValueData_sh (inUnitId)
                          , (SELECT zfConvert_DateToString (MIN (Object_Personal_View.DateIn))
                             FROM Object_Personal_View
                             WHERE Object_Personal_View.DateIn     > vbEndDate
                               AND Object_Personal_View.UnitId     = inUnitId
                               AND Object_Personal_View.MemberId   = inMemberId
                               AND Object_Personal_View.PositionId = inPositionId
                            )
                           ;
        ELSE
            RAISE EXCEPTION '������. ��������� <%> <%>  <%> ������ � <%>.���� � ������ ������.'
                          , lfGet_Object_ValueData_sh (inMemberId)
                          , lfGet_Object_ValueData_sh (inPositionId)
                          , lfGet_Object_ValueData_sh (inUnitId)
                          , (SELECT zfConvert_DateToString (MAX (Object_Personal_View.DateOut))
                             FROM Object_Personal_View
                             WHERE Object_Personal_View.DateOut    <= vbEndDate
                               AND Object_Personal_View.UnitId     = inUnitId
                               AND Object_Personal_View.MemberId   = inMemberId
                               AND Object_Personal_View.PositionId = inPositionId
                            )
                           ;
        END IF;
    END IF;

    --�������� ���� �� ���� ���� ������ ������, �������� ��������� ��� ������� ���������
   IF EXISTS (SELECT 1
               FROM MovementLinkObject AS MovementLinkObject_Member
                    INNER JOIN Movement AS Movement_MemberHoliday 
                                        ON Movement_MemberHoliday.Id = MovementLinkObject_Member.MovementId
                                       AND Movement_MemberHoliday.DescId = zc_Movement_MemberHoliday()
                                       AND Movement_MemberHoliday.StatusId = zc_Enum_Status_Complete()

                    INNER JOIN MovementDate AS MovementDate_BeginDateStart
                                            ON MovementDate_BeginDateStart.MovementId = MovementLinkObject_Member.MovementId
                                           AND MovementDate_BeginDateStart.DescId = zc_MovementDate_BeginDateStart()
                                           AND MovementDate_BeginDateStart.ValueData <= inOperDate
                    INNER JOIN MovementDate AS MovementDate_BeginDateEnd
                                            ON MovementDate_BeginDateEnd.MovementId = MovementDate_BeginDateStart.MovementId
                                           AND MovementDate_BeginDateEnd.DescId = zc_MovementDate_BeginDateEnd()
                                           AND MovementDate_BeginDateEnd.ValueData >= inOperDate
               WHERE MovementLinkObject_Member.DescId = zc_MovementLinkObject_Member()
                 AND MovementLinkObject_Member.ObjectId = inMemberId
               )
       AND ioTypeId NOT IN (zc_Enum_WorkTimeKind_Holiday(), zc_Enum_WorkTimeKind_HolidayNoZp())
    THEN
        RAISE EXCEPTION '������. � ���������� <%> <%>  <%> �� <%> ���� ������.'
                               , lfGet_Object_ValueData_sh (inMemberId)
                               , lfGet_Object_ValueData_sh (inPositionId)
                               , lfGet_Object_ValueData_sh (inUnitId)
                               , zfConvert_DateToString(inOperDate)
                                ;
    END IF;


    
    IF (ioValue = '0' OR TRIM (ioValue) = '')
    THEN
         ioTypeId := 0;
         vbValue  := 0;
    ELSE

        -- RAISE EXCEPTION '"%"  %  ', vbValue, POSITION ('0' IN zfGet_ViewWorkHour ('0', ioTypeId));

        IF EXISTS (SELECT 1
                   FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                   WHERE ObjectString_WorkTimeKind_ShortName.ValueData = UPPER (TRIM (ioValue))
                     AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                  )
        THEN
            ioTypeId:= (SELECT ObjectString_WorkTimeKind_ShortName.ObjectId
                        FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                        WHERE ObjectString_WorkTimeKind_ShortName.ValueData = UPPER (TRIM (ioValue))
                          AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                       );
            --
            vbValue:= 0;
        ELSE
/*        IF (vbValue >= 0 AND vbValue <= 24 AND POSITION ('0' IN zfGet_ViewWorkHour ('0', ioTypeId)) = 1) --  AND zfConvert_StringToNumber (ioValue) > 0)
        OR (ioTypeId = 0 AND vbValue >= 0 AND vbValue <= 24)
        THEN*/
            IF zfConvert_StringToFloat(SPLIT_PART (UPPER (TRIM (ioValue)), '/', 1)) > 0 AND SPLIT_PART (UPPER (TRIM (ioValue)), '/', 2) <> ''
               AND EXISTS (SELECT 1
                           FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                           WHERE ObjectString_WorkTimeKind_ShortName.ValueData = 'FM99/' || SPLIT_PART (UPPER (TRIM (ioValue)), '/', 2)
                             AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                          )
               -- AND vbUserId = 5
            THEN
               ioTypeId:= (SELECT ObjectString_WorkTimeKind_ShortName.ObjectId
                           FROM ObjectString AS ObjectString_WorkTimeKind_ShortName
                           WHERE ObjectString_WorkTimeKind_ShortName.ValueData = 'FM99/' || SPLIT_PART (UPPER (TRIM (ioValue)), '/', 2)
                             AND ObjectString_WorkTimeKind_ShortName.DescId = zc_ObjectString_WorkTimeKind_ShortName()
                          );
            ELSE
               ioTypeId := CASE WHEN COALESCE (ioTypeId, 0) = 0 OR POSITION ('0' IN zfGet_ViewWorkHour ('0', ioTypeId)) = 0
                                     THEN zc_Enum_WorkTimeKind_Work()
                                ELSE ioTypeId
                           END;
            END IF;
        --
        vbValue := zfConvert_ViewWorkHourToHour (ioValue);

        END IF;

    END IF;



    ---

    -- ��� ������ ��������� ID Movement, ���� ������� �������. ������ ����� OperDate � UnitId
    vbMovementId := (SELECT Movement_SheetWorkTime.Id
                     FROM Movement AS Movement_SheetWorkTime
                          JOIN MovementLinkObject AS MovementLinkObject_Unit 
                                                  ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                 AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                                 AND MovementLinkObject_Unit.ObjectId = inUnitId
                     WHERE Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() AND Movement_SheetWorkTime.OperDate = inOperDate
                       AND Movement_SheetWorkTime.StatusId <> zc_Enum_Status_Erased()
                    );
 
    -- ��������� <��������>
    IF COALESCE (vbMovementId, 0) = 0
    THEN
        vbMovementId := lpInsertUpdate_Movement_SheetWorkTime(vbMovementId, '', inOperDate::DATE, inUnitId, vbUserId);
    END IF;

    -- ����� MovementItemId
    vbMovementItemId := (SELECT MI_SheetWorkTime.Id 
                         FROM MovementItem AS MI_SheetWorkTime
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                                     ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine() 
                          WHERE MI_SheetWorkTime.MovementId = vbMovementId
                            AND MI_SheetWorkTime.ObjectId   = inMemberId
                            AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                            AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                            AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                            AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                         );


     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;

    -- ���������
    vbMovementItemId:= lpInsertUpdate_MovementItem_SheetWorkTime (inMovementItemId      := vbMovementItemId  -- ���� ������� <������� ���������>
                                                                , inMovementId          := vbMovementId      -- ���� ���������
                                                                , inMemberId            := inMemberId        -- ���. ����
                                                                , inPositionId          := inPositionId      -- ���������
                                                                , inPositionLevelId     := inPositionLevelId -- ������
                                                                , inPersonalGroupId     := inPersonalGroupId -- ����������� ����������
                                                                , inStorageLineId       := inStorageLineId   -- ����� ������������
                                                                , inAmount              := vbValue           -- ���������� ����� ����
                                                                , inWorkTimeKindId      := ioTypeId          -- ���� �������� �������
                                                                 );

    -- 
    ioValue := zfGet_ViewWorkHour (vbValue, ioTypeId);
                         

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = 'tmpoperdate')
     THEN
         DELETE FROM tmpOperDate;
         INSERT INTO tmpOperDate (OperDate)
             SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;
     ELSE
         -- ������������� ����� ������� �����
         CREATE TEMP TABLE tmpOperDate ON COMMIT DROP AS
             SELECT GENERATE_SERIES (DATE_TRUNC ('MONTH', inOperDate), DATE_TRUNC ('MONTH', inOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY', '1 DAY' :: INTERVAL) AS OperDate;
     END IF;

    OutAmountHours := (SELECT  SUM(MI_SheetWorkTime.Amount) as  AmountHours
                       FROM tmpOperDate
                        JOIN Movement ON Movement.operDate = tmpOperDate.OperDate
                                     AND Movement.DescId = zc_Movement_SheetWorkTime()
                        JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                        JOIN MovementItem AS MI_SheetWorkTime ON MI_SheetWorkTime.MovementId = Movement.Id
                        LEFT JOIN MovementItemLinkObject AS MIObject_Position
                                                         ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                        AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                        LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                         ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                        AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                        LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                         ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                        AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                        LEFT OUTER JOIN MovementItemLinkObject AS MIObject_StorageLine
                                                               ON MIObject_StorageLine.MovementItemId = MI_SheetWorkTime.Id 
                                                              AND MIObject_StorageLine.DescId = zc_MILinkObject_StorageLine()
                       WHERE MovementLinkObject_Unit.ObjectId = inUnitId
                         AND MI_SheetWorkTime.ObjectId   = inMemberId
                         AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
                         AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                         AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                         AND COALESCE (MIObject_StorageLine.ObjectId, 0)   = COALESCE (inStorageLineId, 0)
                       ); 


    -- ��������� ��������
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), vbMovementId, CURRENT_TIMESTAMP);
    -- ��������� ��������
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), vbMovementId, vbUserId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);
/*
if vbUserId = 5 AND 1=1
then
    RAISE EXCEPTION 'Admin.<%> <%> <%> <%> <%>  -  <%>  <%>'
                      , zfConvert_DateToString (inOperDate)
                      , inUnitId
                      , inMemberId
                      , inPositionId
                      , zfConvert_DateToString (vbEndDate)
                      , (SELECT COUNT(*) FROM MovementItemProtocol WHERE MovementItemProtocol.MovementItemId = vbMovementItemId)
                      , vbMovementItemId
                       ;
                       */
end if;

if 0 = COALESCE ((SELECT COUNT(*) FROM MovementItemProtocol WHERE MovementItemProtocol.MovementItemId = vbMovementItemId), 0)
then
    RAISE EXCEPTION '������.������ ��������� �� ��������� (%)', vbMovementItemId;
end if;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 25.05.17         * add StorageLine
 25.03.16         * add OutAmountHours
 07.01.14                         * Replace inPersonalId <> inMemberId
 25.11.13                         * Add inPositionLevelId
 17.10.13                         *
 03.10.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SheetWorkTime (, inSession:= '2')
