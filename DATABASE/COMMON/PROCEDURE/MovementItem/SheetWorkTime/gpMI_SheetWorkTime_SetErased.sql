-- Function: gpMI_SheetWorkTime_SetErased()

DROP FUNCTION IF EXISTS gpMI_SheetWorkTime_SetErased(Integer, Integer, Integer, Integer, Integer, TDateTime, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpMI_SheetWorkTime_SetErased(   
    IN inMemberId            Integer   , -- ���� ���. ����
    IN inPositionId          Integer   , -- ���������
    IN inPositionLevelId     Integer   , -- ������
    IN inUnitId              Integer   , -- �������������
    IN inPersonalGroupId     Integer   , -- ����������� ����������
    IN inOperDate            TDateTime , -- ���� ��������� �����
    
 INOUT ioIsErased            Boolean   , -- ����� ��������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbValue TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_SheetWorkTime());

    -- ��� ������ ��������� ID Movement, ���� ������� �������. ������ ����� OperDate � UnitId
    vbMovementId := (SELECT Movement_SheetWorkTime.Id
                     FROM Movement AS Movement_SheetWorkTime
                          JOIN MovementLinkObject AS MovementLinkObject_Unit 
                                                  ON MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                 AND MovementLinkObject_Unit.MovementId = Movement_SheetWorkTime.Id  
                                                 AND MovementLinkObject_Unit.ObjectId = inUnitId
                     WHERE Movement_SheetWorkTime.DescId = zc_Movement_SheetWorkTime() AND Movement_SheetWorkTime.OperDate = inOperDate
                    );
 
    -- ��������� <��������>
    IF COALESCE (vbMovementId, 0) = 0
    THEN
         RAISE EXCEPTION '������� �� ��������.';
    END IF;
    
    -- ����� MovementItemId
    vbMovementItemId := (SELECT MI_SheetWorkTime.Id 
                         FROM MovementItem AS MI_SheetWorkTime
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_Position
                                                                     ON MIObject_Position.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND COALESCE (MIObject_Position.ObjectId, 0) = COALESCE (inPositionId, 0)
                                                                    AND MIObject_Position.DescId = zc_MILinkObject_Position() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PositionLevel
                                                                     ON MIObject_PositionLevel.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND COALESCE (MIObject_PositionLevel.ObjectId, 0) = COALESCE (inPositionLevelId, 0)
                                                                    AND MIObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel() 
                              LEFT OUTER JOIN MovementItemLinkObject AS MIObject_PersonalGroup
                                                                     ON MIObject_PersonalGroup.MovementItemId = MI_SheetWorkTime.Id 
                                                                    AND COALESCE (MIObject_PersonalGroup.ObjectId, 0) = COALESCE (inPersonalGroupId, 0)
                                                                    AND MIObject_PersonalGroup.DescId = zc_MILinkObject_PersonalGroup() 
                          WHERE 
                              MI_SheetWorkTime.MovementId = vbMovementId AND
                              MI_SheetWorkTime.ObjectId = inMemberId);

    -- ��������� <��������>
    IF COALESCE (vbMovementItemId, 0) = 0
    THEN
         RAISE EXCEPTION '������ ������ ��� �� ���������.';
    END IF;
    
    -- ������������� ����� ��������
    IF ioIsErased = False 
    THEN
        ioIsErased:= lpSetErased_MovementItem (inMovementItemId:= vbMovementItemId, inUserId:= vbUserId);
    ELSE
        ioIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= vbMovementItemId, inUserId:= vbUserId);
    END IF;
 
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.12.15         *

*/

-- ����
-- SELECT * FROM gpMI_SheetWorkTime_SetErased (, inSession:= '2')
