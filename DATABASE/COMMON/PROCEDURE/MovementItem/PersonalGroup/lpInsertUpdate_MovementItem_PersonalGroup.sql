-- Function: lpInsertUpdate_MovementItem_PersonalGroup()

--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, TFloat, Integer);
--DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementItem_PersonalGroup(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inPersonalId            Integer   , -- ����������
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , --
    IN inWorkTimeKindId        Integer   , --
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar ,   -- 
    IN inUserId                Integer     -- ������������
)                               
RETURNS Integer
AS               
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitId Integer;
   DECLARE vbPersonalGroupId Integer;
   DECLARE vbPairDayId Integer;
BEGIN
     -- ��������
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� �������.';
     END IF;

     -- ��������� ���������
     SELECT Movement.OperDate                         AS OperDate
          , MovementLinkObject_Unit.ObjectId          AS UnitId
          , MovementLinkObject_PersonalGroup.ObjectId AS PersonalGroupId
          , MovementLinkObject_PairDay.ObjectId       AS PairDayId
            INTO vbOperDate, vbUnitId, vbPersonalGroupId, vbPairDayId
     FROM MovementLinkObject AS MovementLinkObject_Unit
          JOIN Movement ON Movement.Id = inMovementId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                       ON MovementLinkObject_PersonalGroup.MovementId = inMovementId
                                      AND MovementLinkObject_PersonalGroup.DescId     = zc_MovementLinkObject_PersonalGroup()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                       ON MovementLinkObject_PairDay.MovementId = inMovementId
                                      AND MovementLinkObject_PairDay.DescId     = zc_MovementLinkObject_PairDay()
     WHERE MovementLinkObject_Unit.MovementId = inMovementId
       AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
    ;


    --
    IF EXISTS (SELECT 1
               FROM Movement
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                 ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                                AND MovementLinkObject_PersonalGroup.DescId     = zc_MovementLinkObject_PersonalGroup()
                    LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                                 ON MovementLinkObject_PairDay.MovementId = Movement.Id
                                                AND MovementLinkObject_PairDay.DescId     = zc_MovementLinkObject_PairDay()
               WHERE Movement.OperDate = vbOperDate
                 AND Movement.DescId   = zc_Movement_PersonalGroup()
                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                 AND Movement.Id       <> inMovementId
                 AND MovementLinkObject_Unit.ObjectId = vbUnitId
                 AND COALESCE (MovementLinkObject_PersonalGroup.ObjectId, 0) = vbPersonalGroupId
                 AND COALESCE (MovementLinkObject_PairDay.ObjectId, 0) = vbPairDayId
              )
    THEN
        RAISE EXCEPTION '������.������ ������ �������� <������ �������> � <%> �� <%>%��� <%>%<%>%<%>.%����� ���� ������ ���� ��������.'
                       , (SELECT Movement.InvNumber
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                            ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                           AND MovementLinkObject_Unit.DescId     = zc_MovementLinkObject_Unit()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                                            ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                                           AND MovementLinkObject_PersonalGroup.DescId     = zc_MovementLinkObject_PersonalGroup()
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                                            ON MovementLinkObject_PairDay.MovementId = Movement.Id
                                                           AND MovementLinkObject_PairDay.DescId     = zc_MovementLinkObject_PairDay()
                          WHERE Movement.OperDate = vbOperDate
                            AND Movement.DescId   = zc_Movement_PersonalGroup()
                            AND Movement.StatusId <> zc_Enum_Status_Erased()
                            AND Movement.Id       <> inMovementId
                            AND MovementLinkObject_Unit.ObjectId = vbUnitId
                            AND COALESCE (MovementLinkObject_PersonalGroup.ObjectId, 0) = vbPersonalGroupId
                            AND COALESCE (MovementLinkObject_PairDay.ObjectId, 0) = vbPairDayId
                         )
                       , zfConvert_DateToString (vbOperDate)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbUnitId)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbPersonalGroupId)
                       , CHR (13)
                       , lfGet_Object_ValueData_sh (vbPairDayId)
                       , CHR (13)
                        ;
    END IF;


     -- �������� ������������
     IF EXISTS (SELECT 1
                FROM MovementItem
                     INNER JOIN MovementItemLinkObject AS MILinkObject_Position
                                                       ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                                      AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
                                                      AND MILinkObject_Position.ObjectId = inPositionId
                     INNER JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                      ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                                                     AND MILinkObject_PositionLevel.ObjectId = inPositionLevelId
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.Id <> ioId
                  AND MovementItem.ObjectId = inPersonalId
                )
     THEN
         RAISE EXCEPTION '������.� ��������� ��� ���������� <%> <%> <%>.������������ ���������.', lfGet_Object_ValueData (inPersonalId), lfGet_Object_ValueData (inPositionId), lfGet_Object_ValueData (inPositionLevelId);
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inPersonalId, inMovementId, inAmount, NULL);

     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Position(), ioId, inPositionId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PositionLevel(), ioId, inPositionLevelId);
     -- ��������� ����� � <>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_WorkTimeKind(), ioId, inWorkTimeKindId);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
-- 