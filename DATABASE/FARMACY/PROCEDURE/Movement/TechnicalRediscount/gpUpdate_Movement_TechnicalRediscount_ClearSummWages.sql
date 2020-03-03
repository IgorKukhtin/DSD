-- Function: gpUpdate_Movement_TechnicalRediscount_ClearSummWages()

DROP FUNCTION IF EXISTS gpUpdate_Movement_TechnicalRediscount_ClearSummWages(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_TechnicalRediscount_ClearSummWages(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUnitId   Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

     -- ��������� ������ ����������� � ������� ������
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '��������� ������ ���������� ��������������';
    END IF;

    -- ���������� ������������� ...
    SELECT Movement.OperDate
         , MLO_Unit.ObjectId                   AS UnitId
    INTO vbOperDate, vbUnitId
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    IF EXISTS(SELECT * FROM MovementFloat WHERE MovementFloat.DescId = zc_MovementFloat_SummaManual() AND MovementFloat.MovementId = inMovementId)
    THEN
      DELETE FROM MovementFloat WHERE MovementFloat.DescId = zc_MovementFloat_SummaManual() AND MovementFloat.MovementId = inMovementId;
    ELSE
      RAISE EXCEPTION '����� ��������� ������� �� �������...';    
    END IF;

    PERFORM gpInsertUpdate_MovementItem_WagesTechnicalRediscount(vbUnitId, vbOperDate, inSession);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.03.20                                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_TechnicalRediscount_ClearSummWages (, inSession:= '2')