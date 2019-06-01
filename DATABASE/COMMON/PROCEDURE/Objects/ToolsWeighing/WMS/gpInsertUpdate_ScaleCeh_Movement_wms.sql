-- Function: gpInsertUpdate_ScaleCeh_Movement_wms()

DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement_wms (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ScaleCeh_Movement_wms(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inMovementDescNumber  Integer   , -- ��� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inGoodsId             Integer   , -- 
    IN inGoodsKindId         Integer   , -- 
    IN inBranchCode          Integer   , -- 
    IN inPlaceNumber         Integer   , -- ����� �������� �����
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (Id        Integer
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


     -- ���������
     inId:= gpInsertUpdate_Movement_WeighingProduction_wms (ioId                  := inId
                                                       -- , inInvNumber           := inInvNumber
                                                          , inOperDate            := inOperDate
                                                       -- , inStartWeighing       := inStartWeighing
                                                       -- , inEndWeighing         := inEndWeighing
                                                          , inMovementDescId      := inMovementDescId
                                                          , inMovementDescNumber  := inMovementDescNumber
                                                          , inPlaceNumber         := inPlaceNumber
                                                          , inFromId              := inFromId
                                                          , inToId                := inToId
                                                          , inGoodsId             := inGoodsId
                                                          , inGoodsKindId         := inGoodsKindId
                                                          , inSession             := inSession
                                                           );
     -- ���������
     RETURN QUERY
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
       FROM Movement_WeighingProduction AS Movement
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
-- SELECT * FROM gpInsertUpdate_ScaleCeh_Movement_wms (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
