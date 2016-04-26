-- Function: gpInsertUpdate_MovementItem_Promo_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Promo_From_Excel (Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Promo_From_Excel(
    IN inMovementId          Integer   , -- ���� ������� <�������� ��������������>
    IN inGoodsCode           Integer   , -- ��� ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , -- ����
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
	 
    vbGoodsId := 0;
     --�������� ����� �� ����
    vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);
    Select Id INTO vbGoodsId from Object_Goods_View Where ObjectId = vbObjectId AND GoodsCodeInt = inGoodsCode;
    --���������, � ���� �� ����� ����� � ����
    IF (COALESCE(vbGoodsId,0) = 0)
    THEN
        RAISE EXCEPTION '������. � ���� ������ �� ������ ����� � ����� <%>', inGoodsCode;
    END IF;
    
    IF inAmount is not null AND (inAmount < 0)
    THEN
        RAISE EXCEPTION '������. ���������� <%> �� ����� ���� ������ ����.', inAmount;
    END IF;
    
    IF inPrice is not null AND (inPrice < 0)
    THEN
        RAISE EXCEPTION '������. ���� <%> �� ����� ���� ������ ����.', inPrice;
    END IF;
    SELECT Id INTO vbId from MovementItem Where MovementId = COALESCE(inMovementId,0) AND ObjectId = vbGoodsId;
    -- ���������
    PERFORM lpInsertUpdate_MovementItem_Promo (ioId                 := COALESCE(vbId,0)
                                                 , inMovementId         := inMovementId
                                                 , inGoodsId            := vbGoodsId
                                                 , inAmount             := inAmount
                                                 , inPrice              := inPrice
                                                 , inUserId             := vbUserId);
    -- ����������� �������� ����� �� ���������
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Promo_From_Excel (Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
  25.04.16        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Promo (ioId:= 0, inMovementId:= 0, inGoodsId:= 1, inAmount:= 0, inSession:= '2')
