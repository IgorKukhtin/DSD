DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TaxFromMedoc (integer, TVarChar, TVarChar, tfloat, tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TaxFromMedoc(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsName           TVarChar  , -- ������
    IN inMeasureName         TVarChar  , -- ������� ���������
    IN inAmount              TFloat    , -- ����������
    IN inSumm                TFloat    , -- ����� �� �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsExternalId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Tax());

     -- ���� �����. ���� �� ����� - ���������
     
     SELECT Id INTO vbGoodsExternalId FROM Object WHERE DescId = zc_ObjectExternal() AND ValueData = inGoodsName;

     IF COALESCE(vbGoodsExternalId, 0) = 0 THEN
        vbGoodsExternalId := lpInsertUpdate_Object (vbGoodsExternalId, zc_ObjectExternal(), 0, inGoodsName);
     END IF;

     -- ��������� <������� ���������>
     PERFORM lpInsertUpdate_MovementItem_Tax (ioId              := ioId
                                         , inMovementId         := inMovementId
                                         , inGoodsId            := vbGoodsExternalId
                                         , inAmount             := inAmount
                                         , inPrice              := (inSumm / inAmount)
                                         , ioCountForPrice      := 1
                                         , inGoodsKindId        := NULL
                                         , inUserId             := vbUserId
                                          );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 16.04.15                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Tax (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inPrice:= 1, ioCountForPrice:= 1, inGoodsKindId:= 0, inSession:= '2')