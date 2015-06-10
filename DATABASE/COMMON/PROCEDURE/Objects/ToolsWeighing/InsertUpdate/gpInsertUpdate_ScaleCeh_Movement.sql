-- Function: gpInsertUpdate_ScaleCeh_Movement()

DROP FUNCTION IF EXISTS gpInsertUpdate_ScaleCeh_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_ScaleCeh_Movement(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inMovementDescNumber  Integer   , -- ��� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inIsProductionIn      Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (Id        Integer
             , InvNumber TVarChar
             , OperDate  TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ScaleCeh_Movement());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     inId:= gpInsertUpdate_Movement_WeighingProduction (ioId                  := inId
                                                      , inOperDate            := inOperDate
                                                      , inMovementDescId      := inMovementDescId
                                                      , inMovementDescNumber  := inMovementDescNumber
                                                      , inWeighingNumber      := COALESCE ((SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inId AND MovementFloat.DescId = zc_MovementFloat_WeighingNumber()), 0) :: Integer
                                                      , inFromId              := inFromId
                                                      , inToId                := inToId
                                                      , inPartionGoods        := (SELECT MovementString.ValueData FROM MovementString WHERE MovementString.MovementId = inId AND MovementString.DescId = zc_MovementString_PartionGoods())
                                                      , inIsProductionIn      := inIsProductionIn
                                                      , inSession             := inSession
                                                       );
     -- ���������
     RETURN QUERY
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
       FROM Movement
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
-- SELECT * FROM gpInsertUpdate_ScaleCeh_Movement (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
