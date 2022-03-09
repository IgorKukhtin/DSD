-- Function: lpComplete_Movement_PersonalGroup (Integer, Boolean)

DROP FUNCTION IF EXISTS lpComplete_Movement_PersonalGroup (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PersonalGroup(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbOperDate TDateTime;
   DECLARE vbUnitId Integer;
   DECLARE vbPersonalGroupId Integer;
   DECLARE vbPairDayId Integer;
BEGIN
     -- !!!�����������!!! �������� ������� ��������
     DELETE FROM _tmpMIContainer_insert;
     DELETE FROM _tmpMIReport_insert;
     -- !!!�����������!!! �������� ������� - �������� ���������, �� ����� ���������� ��� ������������ �������� � ���������
     DELETE FROM _tmpItem;


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


    -- ��������
    IF COALESCE (vbUnitId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������������� �� �����������.';
    END IF;

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


     -- 5.1. ����� - ���������/��������� ��������
     PERFORM lpComplete_Movement_Finance (inMovementId := inMovementId
                                        , inUserId     := inUserId);

     -- 5.2. ����� - ����������� ������ ������ ��������� + ��������� ��������
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_PersonalGroup()
                                , inUserId     := inUserId
                                 );


IF inUserId = 5 AND 1=0
THEN
    RAISE EXCEPTION '������.test' ;
END IF;


END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.11.21         *
*/

-- ����
-- SELECT * FROM lpUnComplete_Movement (inMovementId:= 3581, inUserId:= zfCalc_UserAdmin() :: Integer)
-- SELECT * FROM gpComplete_Movement_PersonalGroup (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 3581, inSession:= zfCalc_UserAdmin())
