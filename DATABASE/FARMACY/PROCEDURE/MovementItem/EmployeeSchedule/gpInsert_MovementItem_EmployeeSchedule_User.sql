-- Function: gpInsert_MovementItem_EmployeeSchedule_User()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_EmployeeSchedule_User(INTEGER, INTEGER, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_EmployeeSchedule_User(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbComingValueDay TVarChar;

   DECLARE vbValue INTEGER;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���� ������������ �� ����� ���������
    IF 758920 <> inSession::Integer AND 4183126 <> inSession::Integer AND 9383066  <> inSession::Integer
    THEN
      RAISE EXCEPTION '��������� <������ ������ �����������> ��� ���������.';
    END IF;
    
    IF COALESCE(inMovementId, 0) = 0 
    THEN
      RAISE EXCEPTION '�� �������� ������ ������ �����������.';
    END IF;
    
    IF EXISTS(SELECT 1 FROM MovementItem
              WHERE MovementItem.MovementId = inMovementId
                AND MovementItem.DescId = zc_MI_Master()
                AND MovementItem.ObjectId = inUserId)
    THEN
      SELECT MovementItem.ID 
      INTO vbId        
      FROM MovementItem
      WHERE MovementItem.MovementId = inMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.ObjectId = inUserId;
    ELSE
      vbId := 0;
    END IF;	

    -- ���������
    PERFORM gpInsertUpdate_MovementItem_EmployeeSchedule (ioId                  := vbId              -- ���� ������� <������� ���������>
                                                        , inMovementId          := inMovementId      -- ���� ���������
                                                        , inUserId              := inUserId          -- ���������
                                                        , ioValue               := ''::TVarChar      -- ������� �� ������ �� ����
                                                        , ioValueUser           := ''::TVarChar      -- ������� �� ������ �� ����
                                                        , ioTypeId              := 0                 -- ������� �� ������ �� ����
                                                        , inSession             := inSession         -- ������������
                                                         );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
10.12.18                                                        *

*/
