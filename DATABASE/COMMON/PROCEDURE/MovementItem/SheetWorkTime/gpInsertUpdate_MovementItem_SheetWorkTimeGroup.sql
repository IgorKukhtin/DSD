-- Function: gpInsertUpdate_MovementItem_SheetWorkTime()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTimeGroup(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTimeGroup(INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, INTEGER, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTimeGroup(
    IN inMemberId            Integer   , -- ���� ���. ����
    IN inPositionId          Integer   , -- ���������
    IN inPositionLevelId     Integer   , -- ������
    IN inUnitId              Integer   , -- �������������
    IN inPersonalGroupId     Integer   , -- ����������� ����������
    IN inOldMemberId         Integer   , -- ���� ���. ����
    IN inOldPositionId       Integer   , -- ���������
    IN inOldPositionLevelId  Integer   , -- ������
    IN inOldPersonalGroupId  Integer   , -- ����������� ����������
    IN inOperDate            TDateTime , -- ���� ��������� �����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementItemCount Integer;
   DECLARE vbTypeId Integer;
   DECLARE vbValue TVarChar;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    
    vbUserId := inSession;

    vbTypeId := zc_Enum_WorkTimeKind_Work();

    -- ������ ������. ��� ������ ���������� ������ ���������

    -- ������ - ��������� ��������� ����������. 
    IF inOldMemberId = 0 THEN
       PERFORM gpInsertUpdate_MovementItem_SheetWorkTime(inMemberId, inPositionId, inPositionLevelId, inUnitId, inPersonalGroupId, inOperDate, '0', vbTypeId, inSession);
    ELSE
       vbStartDate := date_trunc('month', inOperDate)                            ;    -- ������ ����� ������
       vbEndDate := vbStartDate + interval '1 month' - interval '1 microseconds' ;    -- ��������� ����� ������
       -- ������� ��������� ��� ��� � ������ �������
       SELECT count(*) INTO vbMovementItemCount
        FROM MovementItem AS MI_SheetWorkTime
        JOIN Movement AS Movement_SheetWorkTime
          ON Movement_SheetWorkTime.Id = MI_SheetWorkTime.MovementId 
         AND Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() 
         AND Movement_SheetWorkTime.OperDate::Date BETWEEN vbStartDate AND vbEndDate

        JOIN MovementLinkObject AS MovementLinkObject_Unit 
          ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
         AND MovementLinkObject_Unit.ObjectId = inUnitId 

        LEFT JOIN MovementItemLinkObject AS MIObject_Position
          ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
         AND MIObject_Position.DescId = zc_MILinkObject_Position() 

        LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
          ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
         AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 

        LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
          ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
         AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 

       WHERE MI_SheetWorkTime.ObjectId = inMemberId
         AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inPositionId, 0)
         AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
         AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
       ;
       
       IF COALESCE(vbMovementItemCount, 0) <> 0 THEN
          RAISE EXCEPTION '��������� � ������ ���������� ��� ���� � ������!';
       END IF;

       CREATE TEMP TABLE _tmpMI (Id Integer) ON COMMIT DROP;

       -- ������� �� ����� ���� �� ��������� �� ������� ������� �� ��������� �������.
       INSERT INTO _tmpMI(Id)
       SELECT MI_SheetWorkTime.Id 
        FROM MovementItem AS MI_SheetWorkTime
        JOIN Movement AS Movement_SheetWorkTime
          ON Movement_SheetWorkTime.Id = MI_SheetWorkTime.MovementId 
         AND Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() 
         AND Movement_SheetWorkTime.OperDate::Date BETWEEN vbStartDate AND vbEndDate
        JOIN MovementLinkObject AS MovementLinkObject_Unit 
          ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
         AND MovementLinkObject_Unit.ObjectId = inUnitId 
        LEFT JOIN MovementItemLinkObject AS MIObject_Position
          ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
         AND MIObject_Position.DescId = zc_MILinkObject_Position() 
        LEFT JOIN MovementItemLinkObject AS MIObject_PositionLevel
          ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
         AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
        LEFT JOIN MovementItemLinkObject AS MIObject_PersonalGroup
          ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
         AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
       WHERE MI_SheetWorkTime.ObjectId = inOldMemberId
         AND COALESCE (MIObject_Position.ObjectId, 0)      = COALESCE (inOldPositionId, 0)
         AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inOldPositionLevelId, 0)
         AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inOldPersonalGroupId, 0)
        ;

       -- � ������ ������ �����
       -- ������� ��� ����. � ����� ��� ���������
       UPDATE MovementItem SET ObjectId = inMemberId WHERE Id IN (SELECT Id FROM _tmpMI);
       PERFORM 
           -- ��������� ����� � <����������� �����������>
           lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PersonalGroup(), Id, inPersonalGroupId),
           -- ��������� ����� � <����������>
           lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), Id, inPositionId),
           -- ��������� ����� � <������>
           lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), Id, inPositionLevelId)
        FROM _tmpMI;     
     END IF;                   

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.01.14                        *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_SheetWorkTimeGroup (, inSession:= '2')
