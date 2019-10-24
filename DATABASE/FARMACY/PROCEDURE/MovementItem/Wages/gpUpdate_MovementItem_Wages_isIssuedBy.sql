-- Function: gpUpdate_MovementItem_Wages_isIssuedBy()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Wages_isIssuedBy(INTEGER, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Wages_isIssuedBy(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inisIssuedBy          Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    IF COALESCE (inId, 0) = 0
    THEN
      RAISE EXCEPTION '������. �������� �� ��������.';
    END IF;

    -- ���������� <������>
    SELECT Movement.StatusId, Movement.OperDate
    INTO vbStatusId, vbOperDate
    FROM Movement 
    WHERE Id = (SELECT MovementItem.MovementID FROM MovementItem WHERE MovementItem.ID = inId);
    
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF inisIssuedBy = FALSE AND vbOperDate >= '01.10.2019'  AND 
       NOT EXISTS(SELECT 1
                  FROM Movement

                       LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                              AND MovementItem.DescId = zc_MI_Master()

                  WHERE Movement.DescId = zc_Movement_TestingUser()
                    AND Movement.OperDate = (SELECT Movement.OperDate 
                                             FROM MovementItem 
                                                  INNER JOIN Movement ON Movement.Id = MovementItem.MovementId 
                                             WHERE MovementItem.ID = inId)
                    AND MovementItem.ObjectId = (SELECT MovementItem.ObjectId FROM MovementItem WHERE MovementItem.ID = ioId)
                    AND MovementItem.Amount >= 85)
    THEN
      RAISE EXCEPTION '������. ��������� �� ���� �������. ������ �������� ���������.';            
    END IF;

     -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), inId, NOT inisIssuedBy);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.08.19                                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_Wages_isIssuedBy (, inSession:= '2')

