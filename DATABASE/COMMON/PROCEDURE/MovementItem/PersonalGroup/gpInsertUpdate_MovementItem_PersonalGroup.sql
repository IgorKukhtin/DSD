-- Function: gpInsertUpdate_MovementItem_PersonalGroup()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalGroup(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPersonalId            Integer   , -- ����������
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , --
    IN inWorkTimeKindCode      Integer   , --    
   OUT outWorkTimeKindId       Integer   ,
   OUT outWorkTimeKindName     TVarChar   ,
 INOUT ioAmount                TFloat    , --
    IN inComment               TVarChar  , --
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbHoursDay TFloat; 
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalGroup());

    --��������
    IF COALESCE (inPersonalId,0) = 0
    THEN
        RAISE EXCEPTION '������.�� ������ ���������';
    END IF;

    -- ������������� �� ����� ���������
    SELECT MovementLinkObject_Unit.ObjectId AS UnitId
           INTO vbUnitId
    FROM MovementLinkObject AS MovementLinkObject_Unit
    WHERE MovementLinkObject_Unit.MovementId = inMovementId
      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit();

    -- ������� ���� �� �������� �� �������� ���������� �2 ������� ���� �� ��������
    vbHoursDay := (SELECT tmp.HoursDay
                   FROM (WITH tmpStaffList AS (SELECT ObjectLink_StaffList_Unit.ChildObjectId           AS UnitId
                                                    , ObjectLink_StaffList_Position.ChildObjectId       AS PositionId
                                                    , ObjectLink_StaffList_PositionLevel.ChildObjectId  AS PositionLevelId
                                                    , MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) AS HoursDay
                                               FROM Object AS Object_StaffList
                                                     INNER JOIN ObjectLink AS ObjectLink_StaffList_Position
                                                                           ON ObjectLink_StaffList_Position.ObjectId = Object_StaffList.Id
                                                                          AND ObjectLink_StaffList_Position.DescId = zc_ObjectLink_StaffList_Position()
                                                                          AND ObjectLink_StaffList_Position.ChildObjectId = inPositionId  --12452 ---
                                                     LEFT JOIN ObjectLink AS ObjectLink_StaffList_PositionLevel
                                                                          ON ObjectLink_StaffList_PositionLevel.ObjectId = Object_StaffList.Id
                                                                         AND ObjectLink_StaffList_PositionLevel.DescId = zc_ObjectLink_StaffList_PositionLevel()

                                                     LEFT JOIN ObjectLink AS ObjectLink_StaffList_Unit
                                                                          ON ObjectLink_StaffList_Unit.ObjectId = Object_StaffList.Id
                                                                         AND ObjectLink_StaffList_Unit.DescId = zc_ObjectLink_StaffList_Unit()
                                                     LEFT JOIN ObjectFloat AS ObjectFloat_HoursDay
                                                                           ON ObjectFloat_HoursDay.ObjectId = Object_StaffList.Id
                                                                          AND ObjectFloat_HoursDay.DescId = zc_ObjectFloat_StaffList_HoursDay()
                                               WHERE Object_StaffList.DescId = zc_Object_StaffList()
                                                 AND Object_StaffList.isErased = False
                                                 AND (ObjectLink_StaffList_PositionLevel.ChildObjectId = 0 OR 0 = 0)
                                               GROUP BY ObjectLink_StaffList_Unit.ChildObjectId
                                                      , ObjectLink_StaffList_Position.ChildObjectId
                                                      , ObjectLink_StaffList_PositionLevel.ChildObjectId
                                               HAVING MAX (COALESCE (ObjectFloat_HoursDay.ValueData,0)) <> 0
                                                )
                       -- ����������� �������� ����� �� ��������
                       SELECT  COALESCE ((SELECT MAX (tmpStaffList.HoursDay) FROM tmpStaffList WHERE tmpStaffList.UnitId = vbUnitId)
                                      , (SELECT MAX (tmpStaffList.HoursDay) FROM tmpStaffList)) AS HoursDay
                       ) AS tmp
                       );

     -- ���������� outWorkTimeKindId
     SELECT Object.Id, Object.ValueData
     INTO outWorkTimeKindId, outWorkTimeKindName
     FROM Object 
     WHERE Object.ObjectCode = inWorkTimeKindCode
       AND Object.DescId = zc_Object_WorkTimeKind();

     --�������������� ���-�� ����� ���� ���������� ���
     IF outWorkTimeKindId IN (zc_Enum_WorkTimeKind_HospitalDoc(), zc_Enum_WorkTimeKind_HolidayNoZp(), zc_Enum_WorkTimeKind_WorkDayOff()
                            ,zc_Enum_WorkTimeKind_DayOff(), zc_Enum_WorkTimeKind_Skip())
     THEN
         ioAmount := 0;
     END IF;

     --��������   ����� ������ ioAmount �� �� ������ ��� ������� ���� �� �������� �� �������� ����������
     IF COALESCE (ioId,0) <> 0
     THEN
         vbAmount := (SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId);
         IF COALESCE (ioAmount,0) > COALESCE (vbHoursDay,0) AND COALESCE (vbHoursDay,0) <> 0
         THEN
             RAISE EXCEPTION '������.������� ���� �� ����� ��������� <%>', vbHoursDay;
         END IF;
     END IF;

     -- ���������
     ioId := lpInsertUpdate_MovementItem_PersonalGroup (ioId              := ioId
                                                      , inMovementId      := inMovementId
                                                      , inPersonalId      := inPersonalId
                                                      , inPositionId      := inPositionId
                                                      , inPositionLevelId := inPositionLevelId
                                                      , inWorkTimeKindId  := outWorkTimeKindId
                                                      , inAmount          := ioAmount
                                                      , inComment         := inComment
                                                      , inUserId          := vbUserId
                                                       ) AS tmp;   

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.04.22         * inWorkTimeKindCode
 16.12.21         *
 09.12.21         *
 22.11.21         *
*/

-- ����
--