-- Function: gpInsertUpdate_MovementItem_OrderInternal()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_OrderInternal_PrioritetPartner
         (Integer, Integer, TVarChar, Integer, TVarChar, Integer, TVarChar, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_OrderInternal_PrioritetPartner(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
    IN inJuridicalId         Integer   , -- �� ����
    IN inJuridicalName       TVarChar  , 
    IN inContractId          Integer   , -- ��������
    IN inContractName        TVarChar  , 
    IN inGoodsId             Integer   , -- ������
    IN inGoodsCode           TVarChar  , 
    IN inGoodsName           TVarChar  , 
    IN inSuperPrice          TFloat    , 
    IN inPrice               TFloat    , 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS TABLE (JuridicalId Integer, JuridicalName TVarChar, 
               ContractId Integer, ContractName TVarChar,
               GoodsId Integer, GoodsCode TVarChar, GoodsName TVarChar,
               SuperPrice TFloat, Price TFloat)
AS               
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_OrderInternal());
     vbUserId := inSession;

     -- ��������� ����� � <��. �����>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Juridical(), inId, inJuridicalId);

     -- ��������� ����� � <���������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Contract(), inId, inContractId);

     -- ��������� ����� � <�������>
     PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Goods(), inId, inGoodsId);

     RETURN QUERY
     SELECT 
          inJuridicalId AS JuridicalId, 
          inJuridicalName AS JuridicalName, 
          inContractId AS ContractId, 
          inContractName AS ContractName,
          inGoodsId AS GoodsId, 
          inGoodsCode AS GoodsCode, 
          inGoodsName AS GoodsName,
          inSuperPrice AS SuperPrice, 
          inPrice AS Price;


     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.10.14                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_OrderInternal_PrioritetPartner (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')
