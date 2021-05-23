-- Function: gpInsertUpdate_ScaleLight_Movement()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleLight_Movement (BigInt, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleLight_Movement (BigInt, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ScaleLight_Movement(
    IN inId                  BigInt    , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inMovementDescNumber  Integer   , -- ��� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inGoodsTypeKindId_1   Integer   , -- ������� - 1-�� �����
    IN inGoodsTypeKindId_2   Integer   , -- ������� - 2-�� �����
    IN inGoodsTypeKindId_3   Integer   , -- ������� - 3-�� �����
    IN inBarCodeBoxId_1      Integer   , -- Id ��� �/� �����
    IN inBarCodeBoxId_2      Integer   , -- Id ��� �/� �����
    IN inBarCodeBoxId_3      Integer   , -- Id ��� �/� �����
    IN inGoodsId             Integer   , -- 
    IN inGoodsKindId         Integer   , -- 
    IN inGoodsId_sh          Integer   , -- 
    IN inGoodsKindId_sh      Integer   , -- 
    IN inBranchCode          Integer   , -- 
    IN inPlaceNumber         Integer   , -- ����� �������� �����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (Id        Integer
          -- , Id        BigInt
             , InvNumber TVarChar
             , OperDate  TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbDocumentKindId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ScaleCeh_Movement());
     vbUserId:= lpGetUserBySession (inSession);

-- if vbUserId = 5
-- then
-- RAISE EXCEPTION '������.ok';
-- end if;

     -- ���������
     inId:= gpInsertUpdate_wms_Movement_WeighingProduction (ioId                  := inId
                                                       -- , inInvNumber           := inInvNumber
                                                          , inOperDate            := inOperDate - INTERVAL '0 DAY'
                                                       -- , inStartWeighing       := inStartWeighing
                                                       -- , inEndWeighing         := inEndWeighing
                                                          , inMovementDescId      := inMovementDescId
                                                          , inMovementDescNumber  := inMovementDescNumber
                                                          , inPlaceNumber         := inPlaceNumber
                                                          , inFromId              := inFromId
                                                          , inToId                := inToId
                                                          , inGoodsTypeKindId_1   := inGoodsTypeKindId_1
                                                          , inGoodsTypeKindId_2   := inGoodsTypeKindId_2
                                                          , inGoodsTypeKindId_3   := inGoodsTypeKindId_3
                                                          , inBarCodeBoxId_1      := inBarCodeBoxId_1
                                                          , inBarCodeBoxId_2      := inBarCodeBoxId_2
                                                          , inBarCodeBoxId_3      := inBarCodeBoxId_3
                                                          , inGoodsId             := inGoodsId
                                                          , inGoodsKindId         := inGoodsKindId
                                                          , inGoodsId_sh          := inGoodsId_sh
                                                          , inGoodsKindId_sh      := inGoodsKindId_sh
                                                          , inSession             := inSession
                                                           );
     -- ���������
     RETURN QUERY
       SELECT Movement.Id :: Integer
            , Movement.InvNumber
            , Movement.OperDate
       FROM wms_Movement_WeighingProduction AS Movement
       WHERE Movement.Id = inId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_ScaleLight_Movement (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
