-- Function: gpInsertUpdate_MovementItem_SendAsset()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SendAsset (Integer, Integer, Integer, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SendAsset(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- ����������
    IN inContainerId           Integer   , -- ������ �� 
    IN inStorageId             Integer   , -- ����� ��������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SendAsset());

     -- ���������
     ioId := lpInsertUpdate_MovementItem_SendAsset (ioId          := ioId
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := inGoodsId
                                                  , inAmount      := inAmount
                                                  , inContainerId := inContainerId
                                                  , inStorageId   := inStorageId
                                                  , inUserId      := vbUserId
                                                   ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.06.23         *
 16.03.20         *
*/

-- ����
--