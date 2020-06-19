-- Function: gpInsertUpdate_MovementItem_SaleAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SaleAsset (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SaleAsset(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inGoodsId               Integer   , -- ������
    IN inContainerId           Integer   , -- ������ ��
    IN inAmount                TFloat    , -- ����������
    IN inPrice                 TFloat    , -- ����
 INOUT ioCountForPrice         TFloat    , -- ���� �� ����������
   OUT outAmountSumm           TFloat    , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SaleAsset());

     -- �������� �������� <���� �� ����������>
     IF COALESCE (ioCountForPrice, 0) = 0 THEN ioCountForPrice := 1; END IF;

     -- ���������
     ioId := lpInsertUpdate_MovementItem_SaleAsset (ioId          := ioId
                                                  , inMovementId  := inMovementId
                                                  , inGoodsId     := inGoodsId
                                                  , inAmount      := inAmount
                                                  , inPrice         := inPrice
                                                  , inCountForPrice := ioCountForPrice
                                                  , inContainerId := inContainerId
                                                  , inUserId      := vbUserId
                                                   ) AS tmp;
     outAmountSumm := ( CASE WHEN COALESCE (ioCountForPrice, 1) > 0 THEN CAST ( COALESCE (inAmount, 0) * COALESCE (inPrice, 0) / COALESCE (ioCountForPrice, 1) AS NUMERIC (16, 2)) 
                             ELSE CAST ( COALESCE (inAmount, 0) * COALESCE (inPrice, 0) AS NUMERIC (16, 2))
                        END) ::TFloat;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 18.06.20         *
*/

-- ����
--