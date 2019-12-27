-- Function: gpInsertUpdate_MovementItem_LoyaltySaveMoney()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LoyaltySaveMoney (Integer, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LoyaltySaveMoney(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inBuyerID             Integer   , -- ����� ������
    IN inComment             TVarChar  , -- ��������
    IN inUnitID              Integer   , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;


    -- ���������
    ioId := lpInsertUpdate_MovementItem_LoyaltySaveMoney  (ioId                 := ioId
                                                         , inMovementId         := inMovementId
                                                         , inBuyerID            := inBuyerID
                                                         , inComment            := inComment
                                                         , inUnitID             := inUnitID
                                                         , inUserId             := vbUserId
                                                         );
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 27.12.19                                                       *
