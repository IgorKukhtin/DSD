-- Function: gpInsertUpdate_MovementItem_WagesVIP()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesVIP(Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesVIP(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUserId              Integer   , -- ���������
    IN inisIssuedBy          Boolean   , -- �������������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTime());
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF COALESCE (ioId, 0) = 0
    THEN
      IF EXISTS(SELECT 1  FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUserId
                  AND MovementItem.DescId = zc_MI_Master())
      THEN
        SELECT MovementItem.ID
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.ObjectID = inUserId
          AND MovementItem.DescId = zc_MI_Master();
      END IF;
    ELSE
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID <> inUserId
                  AND MovementItem.ID = ioId
                  AND MovementItem.DescId = zc_MI_Master())
      THEN
        RAISE EXCEPTION '������. ��������� ���������� ���������.';
      END IF;
    END IF;

    -- ���������
    IF COALESCE (ioId, 0) = 0
    THEN
    
        IF inisIssuedBy = TRUE
        THEN
          RAISE EXCEPTION '������. ������ �� ��������� ��������� �������� ������ ���������.';        
        END IF;
        
        ioId := lpInsertUpdate_MovementItem_WagesVIP_Calc (ioId                  := ioId                  -- ���� ������� <������� ���������>
                                                         , inMovementId          := inMovementId          -- ���� ���������
                                                         , inUserWagesId         := inUserId              -- ���������
                                                         , inAmountAccrued       := 0                     -- ����������� �/� ����������	
                                                         , inHoursWork           := 0                     -- ���������� �����
                                                         , inUserId              := vbUserId              -- ������������
                                                           );
    END IF;

    -- ��������� �������� <���� ������>
    IF inisIssuedBy <> COALESCE ((SELECT ValueData FROM MovementItemBoolean WHERE DescID = zc_MIBoolean_isIssuedBy() AND MovementItemID = ioId), FALSE)
    THEN
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_IssuedBy(), ioId, CURRENT_TIMESTAMP);
      
       -- ��������� �������� <������>
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), ioId, inisIssuedBy);
      

      -- ��������� ��������
      PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, False);    
    END IF;

    --
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.09.21                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesVIP (, inSession:= '2')
