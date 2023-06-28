-- Function: gpInsertUpdate_MovementItem_LossAsset()

--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossAsset (Integer, Integer, Integer, TFloat, TFloat, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LossAsset(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inAmount                TFloat    , -- ����������
    IN inSumm                  TFloat    , -- ����� ������
    IN inContainerId           Integer   , -- ������ �� 
    IN inStorageId           Integer   , -- ����� ��������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossAsset());

     -- ���������
     ioId := lpInsertUpdate_MovementItem_LossAsset (ioId          := ioId
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := inGoodsId
                                                  , inAmount      := inAmount
                                                  , inSumm        := inSumm
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
 18.06.20         *
*/

-- ����
--