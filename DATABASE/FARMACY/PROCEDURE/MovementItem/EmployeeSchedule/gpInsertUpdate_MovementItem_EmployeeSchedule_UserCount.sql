-- Function: gpInsertUpdate_MovementItem_EmployeeSchedule_UserCount ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_EmployeeSchedule_UserCount (TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_EmployeeSchedule_UserCount(
    IN inOperDate            TDateTime , -- ���� � ������
    IN inUnitId              Integer   , -- ������
    IN inUserCount           Integer   , -- ���������� �����������
    IN inSession             TVarChar   -- ������������
 )
RETURNS VOID AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbIsInsert   Boolean;
   DECLARE vbMovementId Integer;
   DECLARE vbId         Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    IF COALESCE (inUnitId, 0) = 0
    THEN
       RAISE EXCEPTION '������. �� ��������� �������������.';
    END IF;

    -- ���� ��������� zc_MI_Child() 
    SELECT Movement.Id                       AS UnitId
         , COALESCE(MovementItemUser.Id, 0)  AS Id
    INTO vbMovementId, vbId
    FROM Movement

         LEFT JOIN MovementItem AS MovementItemUser
                                ON MovementItemUser.MovementId = Movement.Id
                               AND MovementItemUser.ObjectId  = inUnitId
                               AND MovementItemUser.DescId = zc_MI_Second()

    WHERE Movement.OperDate = date_trunc('MONTH', inOperDate)
      AND Movement.DescId = zc_Movement_EmployeeSchedule()
      AND Movement.StatusId <> zc_Enum_Status_Erased();

    IF COALESCE (vbMovementId, 0) = 0
    THEN
       RAISE EXCEPTION '������. �� ������ ������ ������ ����������� �� <%>.', date_trunc('MONTH', inOperDate);
    END IF;
          
    -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (vbId, 0) = 0;

     -- ��������� <������� ���������>
    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Second(), inUnitId, vbMovementId, inUserCount, NULL);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);
    --RETURN inId;

 END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.02.23                                                        *
*/

-- ����
-- 