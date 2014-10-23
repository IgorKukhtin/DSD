-- Function: gpInsertUpdate_MovementItem_OrderInternal()

-- DROP FUNCTION gpInsertUpdate_MovementItem_OrderInternal();

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderInternal(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE(Id Integer, Price TFloat, ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

     vbId := lpInsertUpdate_MovementItem_OrderInternal(inId, inMovementId, inGoodsId, inAmount, 0, inUserId);

     CREATE TEMP TABLE _tmpMI (Id integer, MovementItemId Integer
             , Price TFloat
             , GoodsId Integer
             , GoodsCode TVarChar
             , GoodsName TVarChar
             , MainGoodsName TVarChar
             , JuridicalId Integer
             , JuridicalName TVarChar
             , MakerName TVarChar
             , ContractId Integer
             , ContractName TVarChar
             , Deferment Integer
             , Bonus TFloat
             , Percent TFloat
             , SuperFinalPrice TFloat) ON COMMIT DROP;


      PERFORM lpCreateTempTable_OrderInternal(inMovementId, vbObjectId, inGoodsId, vbUserId);


      -- ����������� �������� �����
      PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.07.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_OrderInternal (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
