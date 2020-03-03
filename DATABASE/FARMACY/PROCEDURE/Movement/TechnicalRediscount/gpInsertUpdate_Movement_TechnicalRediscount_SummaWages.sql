-- Function: gpInsertUpdate_Movement_TechnicalRediscount_SummaWages()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TechnicalRediscount_SummaWages(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TechnicalRediscount_SummaWages(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inSummWages           TFloat    , -- � ��������
   OUT outSummWages          TFloat    , -- �����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TFloat
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUnitId   Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TechnicalRediscount());

    IF COALESCE (inId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;

    -- ���������� ������������� ...
    SELECT Movement.OperDate
         , MLO_Unit.ObjectId                   AS UnitId
    INTO vbOperDate, vbUnitId
    FROM Movement
         INNER JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = Movement.Id
                                      AND MLO_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inId;

     -- ��������� ������ ����������� � ������� ������
    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '��������� ������ ���������� ��������������';
    END IF;

     -- ��������� �������� <� ��������>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummaManual(), inId, inSummWages);

    outSummWages := gpInsertUpdate_MovementItem_WagesTechnicalRediscount(vbUnitId, vbOperDate, inSession);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.03.20                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TechnicalRediscount_SummaWages (, inSession:= '2')