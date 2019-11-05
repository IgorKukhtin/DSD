-- Function: gpInsertUpdate_MovementItem_Loyalty()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Loyalty (Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Loyalty(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inAmount              TFloat    , -- ����� ������
    IN inCount               Integer   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    
    -- ���������
    ioId := lpInsertUpdate_MovementItem_Loyalty  (ioId                 := ioId
                                                , inMovementId         := inMovementId
                                                , inAmount             := inAmount
                                                , inCount              := inCount
                                                , inUserId             := vbUserId
                                                );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.11.19                                                       *
*/