-- Function: gpInsertUpdate_MovementItem_FilesToCheck()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_FilesToCheck (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_FilesToCheck(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- ������
    IN inIsChecked           Boolean   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
  
     -- ���������
     ioId:= lpInsertUpdate_MovementItem_FilesToCheck (ioId                 := ioId
                                                  , inMovementId         := inMovementId
                                                  , inUnitId             := inUnitId
                                                  , inIsChecked          := inIsChecked
                                                  , inUserId             := vbUserId
                                                   );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.22                                                       *
*/