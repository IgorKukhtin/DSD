-- Function: gpInsertUpdate_MovementItem_Task()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Task (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Task(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPartnerId           Integer   , -- 
    IN inDescription         TVarChar  , -- �������� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Task());
	    
    -- ���������
    ioId:= lpInsertUpdate_MovementItem_Task (ioId                 := COALESCE(ioId,0)
                                           , inMovementId         := inMovementId
                                           , inPartnerId          := inPartnerId
                                           , inDescription        := inDescription
                                           , inUserId             := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 24.03.17         *
*/

-- ����
-- 