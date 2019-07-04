-- Function: gpInsert_ScaleCeh_GoodsSeparate()

-- DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_GoodsSeparate (Integer, TDateTime, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, TVarChar, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_ScaleCeh_GoodsSeparate (Integer, TDateTime, Integer, Integer, Integer, Integer, Boolean, Integer, Integer, TVarChar, TFloat, TFloat, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_ScaleCeh_GoodsSeparate(
    IN inMovementId          Integer   , -- 
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
    IN inStorageLineId       Integer   , --
    IN inIsClose             Boolean   , --
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


     -- ��������
     IF inMovementDescId <> zc_Movement_ProductionSeparate()
     THEN
         RAISE EXCEPTION '������.�������� ��� �������� <%>.', (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = inMovementDescId);
     END IF;

     -- ��������
     IF inIsClose = FALSE AND COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ����������� ������.';
     END IF;

     -- �������� - ���� �� �������� �����������, ���-�� ������� ����� ������� MovementItem � ������ ��������������� inAmount
     IF inIsClose = FALSE AND inAmount <> COALESCE((SELECT SUM (MovementItem.Amount)
                                                    FROM MovementItem
                                                         LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                                                       ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                                                                      AND MIBoolean_isAuto.DescId         = zc_MIBoolean_isAuto()
                                                    WHERE MovementItem.MovementId = inMovementId
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.ObjectId   = inGoodsId
                                                      AND MovementItem.isErased   = FALSE
                                                      AND COALESCE (MIBoolean_isAuto.ValueData, FALSE) = FALSE
                                                   ), 0)
     THEN
         RAISE EXCEPTION '������.�� ������������� ���-�� ��� ������� = <%> � ������� ����������� ������ = <%> .'
                       , inAmount
                       , COALESCE((SELECT SUM (MovementItem.Amount)
                                   FROM MovementItem
                                        LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                                                      ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                                                     AND MIBoolean_isAuto.DescId         = zc_MIBoolean_isAuto()
                                   WHERE MovementItem.MovementId = inMovementId
                                     AND MovementItem.DescId     = zc_MI_Master()
                                     AND MovementItem.ObjectId   = inGoodsId
                                     AND MovementItem.isErased   = FALSE
                                     AND COALESCE (MIBoolean_isAuto.ValueData, FALSE) = FALSE
                                  ), 0)
                       ;
     END IF;


     -- ��������� �������� <�������������> - ������� MovementItem
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isAuto(), MovementItem.Id, TRUE)
     FROM MovementItem
          LEFT JOIN MovementItemBoolean AS MIBoolean_isAuto
                                        ON MIBoolean_isAuto.MovementItemId = MovementItem.Id
                                       AND MIBoolean_isAuto.DescId         = zc_MIBoolean_isAuto()
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.ObjectId   = inGoodsId
       AND MovementItem.isErased   = FALSE
       AND COALESCE (MIBoolean_isAuto.ValueData, FALSE) = FALSE;


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
     PERFORM gpInsert_ScaleCeh_MI (inId                  := 0
                                 , inMovementId          := vbMovementId
                                 , inGoodsId             := inGoodsId
                                 , inGoodsKindId         := zc_GoodsKind_Basis()
                                 , inStorageLineId       := inStorageLineId
                                 , inIsStartWeighing     := TRUE
                                 , inIsPartionGoodsDate  := FALSE
                                 , inOperCount           := inAmount
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
                                 , inBranchCode          := inBranchCode
                                 , inSession             := inSession
                                  );

     -- ��������� zc_Movement_ProductionSeparate
     vbMovementId_begin:= (SELECT tmp.MovementId_begin
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
