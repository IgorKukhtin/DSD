-- Function: gpInsertUpdate_Scale_Movement()

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
*/
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Scale_Movement (Integer, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Scale_Movement(
    IN inId                   Integer   , -- ���� ������� <��������>
    IN inOperDate             TDateTime , -- ���� ���������
    IN inMovementDescId       Integer   , -- ��� ���������
    IN inMovementDescNumber   Integer   , -- ��� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inContractId           Integer   , -- ��������
    IN inPaidKindId           Integer   , -- ����� ������
    IN inPriceListId          Integer   , -- 
    IN inMovementId_Order     Integer   , -- ���� ��������� ������
    IN inMovementId_Transport Integer   , -- ���� ���������
    IN inChangePercent        TFloat    , -- (-)% ������ (+)% �������
    IN inBranchCode           Integer   , -- 
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS TABLE (Id        Integer
             , InvNumber TVarChar
             , OperDate  TDateTime
             , TotalSumm TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbTotalSumm TFloat;

   DECLARE vbPriceListId_Dnepr Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Scale_Movement());
     vbUserId:= lpGetUserBySession (inSession);


     -- ���������� !!!������ ��� ������!!!
     IF inMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnIn(), zc_Movement_Income(), zc_Movement_ReturnOut())
        AND inBranchCode IN (1, 201) -- Dnepr + Dnepr-OBV
     THEN
         -- !!!������!!!
         vbPriceListId_Dnepr:=
        (SELECT tmp.PriceListId
         FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := inContractId
                                                   , inPartnerId      := CASE WHEN inMovementDescId IN (zc_Movement_Sale(), zc_Movement_ReturnOut())
                                                                                   THEN inToId
                                                                              ELSE inFromId
                                                                         END
                                                   , inMovementDescId := inMovementDescId
                                                   , inOperDate_order := CASE WHEN inMovementId_Order <> 0
                                                                                   THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId_Order)
                                                                              ELSE NULL
                                                                         END
                                                   , inOperDatePartner:= CASE WHEN inMovementId_Order <> 0
                                                                                   THEN NULL
                                                                              ELSE inOperDate
                                                                         END
                                                   , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                                   , inIsPrior        := FALSE -- !!!���������� �� ������ ���!!!
                                                    ) AS tmp);
     END IF;


     -- ���������
     inId:= gpInsertUpdate_Movement_WeighingPartner (ioId                  := inId
                                                   , inOperDate            := inOperDate
                                                   , inInvNumberOrder      := CASE WHEN inMovementId_Order <> 0 THEN (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inMovementId_Order) ELSE '' END
                                                   , inMovementDescId      := inMovementDescId
                                                   , inMovementDescNumber  := inMovementDescNumber
                                                   , inWeighingNumber      := CASE WHEN inId <> 0
                                                                                        THEN (SELECT MovementFloat.ValueData FROM MovementFloat WHERE MovementFloat.MovementId = inId AND MovementFloat.DescId = zc_MovementFloat_WeighingNumber())
                                                                                   WHEN inMovementDescId NOT IN (zc_Movement_Sale(), zc_Movement_Inventory(), zc_Movement_SendOnPrice())
                                                                                        THEN 1
                                                                                   ELSE 1 + COALESCE ((SELECT MAX (COALESCE (MovementFloat_WeighingNumber.ValueData, 0))
                                                                                                       FROM Movement
                                                                                                            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                                                                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                                                                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                                                                                                         AND MovementLinkObject_From.ObjectId = inFromId
                                                                                                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                                                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                                                                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                                                                                         AND MovementLinkObject_To.ObjectId = inToId
                                                                                                            LEFT JOIN MovementLinkMovement AS MLM_Order
                                                                                                                                           ON MLM_Order.MovementId = Movement.Id
                                                                                                                                          AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
                                                                                                            INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                                                                                                     ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                                                                                                                    AND MovementFloat_MovementDesc.DescId = zc_MovementFloat_MovementDesc()
                                                                                                                                    AND MovementFloat_MovementDesc.ValueData = inMovementDescId
                                                                                                            INNER JOIN MovementFloat AS MovementFloat_WeighingNumber
                                                                                                                                     ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                                                                                                                    AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
                                                                                                       WHERE Movement.DescId = zc_Movement_WeighingPartner()
                                                                                                         AND Movement.OperDate = inOperDate
                                                                                                         AND Movement.StatusId <> zc_Enum_Status_Erased()
                                                                                                         AND COALESCE (MLM_Order.MovementChildId, 0) = COALESCE (inMovementId_Order, 0)
                                                                                                      ), 0)
                                                                              END :: Integer
                                                   , inFromId              := inFromId
                                                   , inToId                := inToId
                                                   , inContractId          := inContractId
                                                   , inPriceListId         := CASE WHEN vbPriceListId_Dnepr <> 0 THEN vbPriceListId_Dnepr ELSE inPriceListId END
                                                   , inPaidKindId          := inPaidKindId
                                                   , inMovementId_Order    := inMovementId_Order
                                                   , inMovementId_Transport:= inMovementId_Transport
                                                   , inPartionGoods        := '' :: TVarChar
                                                   , inChangePercent       := inChangePercent
                                                   , inSession             := inSession
                                                    );

     -- ���������
     RETURN QUERY
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , MovementFloat_TotalSumm.ValueData AS TotalSumm
       FROM Movement
            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
       WHERE Movement.Id = inId;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 27.01.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Scale_Movement (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
