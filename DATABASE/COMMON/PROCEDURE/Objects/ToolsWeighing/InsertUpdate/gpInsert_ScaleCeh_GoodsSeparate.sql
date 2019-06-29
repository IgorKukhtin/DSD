-- Function: gpInsert_ScaleCeh_GoodsSeparate()

DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_GoodsSeparate (TDateTime, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, TVarChar, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleCeh_GoodsSeparate(
    IN inOperDate            TDateTime , -- ���� ���������
    IN inMovementDescId      Integer   , -- ��� ���������
    IN inMovementDescNumber  Integer   , -- ��� ���������
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
    IN inIsProductionIn      Boolean   , -- 
    IN inBranchCode          Integer   , -- 
    IN inGoodsId             Integer   , --
    IN inPartionGoods        TVarChar  , --
    IN inAmount              TFloat    , --
    IN inHeadCount           TFloat    , --
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (MovementId        Integer
             , InvNumber         TVarChar
             , OperDate          TDateTime
             , MovementId_begin  Integer
             , InvNumber_begin   TVarChar
             , OperDate_begin    TDateTime
              )
AS
$BODY$
   DECLARE vbUserId           Integer;
   DECLARE vbMovementId       Integer;
   DECLARE vbMovementId_begin Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_ScaleCeh_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������
     IF inMovementDescId <> zc_Movement_ProductionSeparate()
     THEN
         RAISE EXCEPTION '������.�������� ��� �������� <%>.', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId);
     END IF;


     -- ����� �������� zc_Movement_WeighingProduction
     vbMovementId:= (SELECT tmp.Id
                     FROM gpInsertUpdate_ScaleCeh_Movement (inId                  := 0
                                                          , inOperDate            := inOperDate
                                                          , inMovementDescId      := inMovementDescId
                                                          , inMovementDescNumber  := inMovementDescNumber
                                                          , inFromId              := inFromId
                                                          , inToId                := inToId
                                                          , inIsProductionIn      := FALSE               -- ������ ������
                                                          , inBranchCode          := inBranchCode
                                                          , inSession             := inSession
                                                           ) AS tmp
                    );

     -- ��������� �������� <�������������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId, TRUE);

     -- ����� ������� zc_Movement_WeighingProduction
     PERFORM gpInsert_ScaleCeh_MI (ioId                  := 0
                                 , inMovementId          := vbMovementId
                                 , inGoodsId             := inGoodsId
                                 , inAmount              := inAmount
                                 , inIsStartWeighing     := TRUE
                                 , inRealWeight          := inAmount
                                 , inWeightTare          := 0
                                 , inLiveWeight          := 0
                                 , inHeadCount           := inHeadCount
                                 , inCount               := 0
                                 , inCountPack           := 0
                                 , inCountSkewer1        := 0
                                 , inWeightSkewer1       := 0
                                 , inCountSkewer2        := 0
                                 , inWeightSkewer2       := 0
                                 , inWeightOther         := 0
                                 , inPartionGoodsDate    := NULL
                                 , inPartionGoods        := inPartionGoods
                                 , inMovementItemId      := 0
                                 , inGoodsKindId         := zc_GoodsKind_Basis()
                                 , inStorageLineId       := NULL
                                 , inSession             := inSession
                                  );

     -- ��������� zc_Movement_ProductionSeparate
     vbMovementId_begin:= (SELECT tmp.Id
                           FROM gpInsert_ScaleCeh_Movement_all (inBranchCode:= inBranchCode
                                                              , inMovementId:= vbMovementId
                                                              , inOperDate  := inOperDate
                                                              , inSession   := inSession
                                                               ) AS tmp
                          );
     -- ��������� �������� <�������������>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_isAuto(), vbMovementId_begin, TRUE);

     -- ���������
     RETURN QUERY
       SELECT Movement.Id              AS MovementId
            , Movement.InvNumber       AS InvNumber
            , Movement.OperDate        AS OperDate
            , Movement_begin.Id        AS MovementId_begin
            , Movement_begin.InvNumber AS InvNumber_begin
            , Movement_begin.OperDate  AS OperDate_begin
       FROM Movement
            LEFT JOIN Movement AS Movement_begin ON Movement_begin.Id = vbMovementId_begin
       WHERE Movement.Id = vbMovementId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 10.05.15                                        *
*/

-- ����
-- SELECT * FROM gpInsert_ScaleCeh_GoodsSeparate (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
