-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar, INTEGER, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTime(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTime(
    IN inMemberId            Integer   , -- ���� ���. ����
    IN inPositionId          Integer   , -- ���������
    IN inPositionLevelId     Integer   , -- ������
    IN inUnitId              Integer   , -- �������������
    IN inPersonalGroupId     Integer   , -- ����������� ����������
    IN inOperDate            TDateTime , -- ���� ��������� �����
 INOUT ioValue               TVarChar  , -- ����
    IN inTypeId              Integer   , 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TVarChar
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    
    vbUserId := inSession;

    IF  COALESCE(inTypeId, 0) = 0 THEN
        inTypeId := zc_Enum_WorkTimeKind_Work();
    END IF;

    -- ��� ������ ��������� ID Movement, ���� ������� �������. ������ ����� OperDate � UnitId
    vbMovementId := (SELECT Movement_SheetWorkTime.Id FROM Movement AS Movement_SheetWorkTime
                               JOIN MovementLinkObject AS MovementLinkObject_Unit 
                                 ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                AND MovementLinkObject_Unit.ObjectId = inUnitId 
                           WHERE Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() AND Movement_SheetWorkTime.OperDate::Date = inOperDate::Date);
 
     IF COALESCE(vbMovementId, 0) = 0 THEN
        -- ��������� <��������>
        vbMovementId := lpInsertUpdate_Movement_SheetWorkTime(vbMovementId, '', inOperDate::DATE, inUnitId);
     END IF;

     -- ������ ���� MovementItemId
     vbMovementItemId := (SELECT MI_SheetWorkTime.Id 
                            FROM MovementItem AS MI_SheetWorkTime
                            JOIN MovementItemLinkObject AS MIObject_Position
                              ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                             AND ((MIObject_Position.ObjectId IS NULL) OR (MIObject_Position.ObjectId = inPositionId))
                             AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                            JOIN MovementItemLinkObject AS MIObject_PositionLevel
                              ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                             AND ((MIObject_PositionLevel.ObjectId IS NULL) OR (MIObject_PositionLevel.ObjectId = inPositionLevelId))
                             AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                            JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                              ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                             AND ((MIObject_PersonalGroup.ObjectId IS NULL) OR (MIObject_PersonalGroup.ObjectId = inPersonalGroupId))
                             AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                           WHERE MI_SheetWorkTime.ObjectId = inMemberId AND MI_SheetWorkTime.MovementId = vbMovementId);
    IF ioValue = '0' THEN
       inTypeId := 0;
       ioValue := '0';
    ELSE
      ioValue := zfConvert_ViewWorkHourToHour(ioValue);
    END IF;

    PERFORM lpInsertUpdate_MovementItem_SheetWorkTime(
       inMovementItemId      := vbMovementItemId , -- ���� ������� <������� ���������>
       inMovementId          := vbMovementId     , -- ���� ���������
       inMemberId            := inMemberId       , -- ���. ����
       inPositionId          := inPositionId     , -- ���������
       inPositionLevelId     := inPositionLevelId, -- ������
       inPersonalGroupId     := inPersonalGroupId, -- ����������� ����������
       inAmount              := ioValue::TFloat  , -- ���������� ����� ����
       inWorkTimeKindId      := inTypeId);        -- ���� �������� �������

     ioValue := zfGet_ViewWorkHour(zfConvert_ViewWorkHourToHour(ioValue), inTypeId);
                         

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.01.14                         * Replace inPersonalId <> inMemberId
 25.11.13                         * Add inPositionLevelId
 17.10.13                         *
 03.10.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SheetWorkTime (, inSession:= '2')
