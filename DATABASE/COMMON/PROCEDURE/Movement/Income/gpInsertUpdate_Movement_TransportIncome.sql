-- Function: gpInsertUpdate_Movement_TransportIncome()

 DROP FUNCTION IF EXISTS gpinsertupdate_movement_transportincome (integer, integer, tvarchar, tvarchar, tdatetime, boolean, tfloat, integer, integer, integer, tvarchar, integer, tvarchar, integer, tvarchar, integer, integer, integer, integer, tvarchar, tvarchar, tfloat, tfloat, tfloat, tvarchar);
 DROP FUNCTION IF EXISTS gpinsertupdate_movement_transportincome (integer, integer, tvarchar, tvarchar, tdatetime, boolean, tfloat, tfloat, integer, integer, integer, tvarchar, integer, tvarchar, integer, tvarchar, integer, integer, integer, integer, tvarchar, tvarchar, tfloat, tfloat, tfloat, tvarchar);
 DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_TransportIncome (integer, integer, tvarchar, tdatetime, tdatetime, tvarchar, boolean, tfloat, tfloat, integer, integer, integer, tvarchar, integer, tvarchar, integer, tvarchar, integer, integer, integer, integer, tvarchar, tvarchar, tfloat, tfloat, tfloat, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_TransportIncome(
    IN inParentId            Integer   , -- ���� Master <��������>
 INOUT ioMovementId          Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
 INOUT ioOperDatePartner     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberPartner    TVarChar  , -- ����� ����
 INOUT ioPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
 INOUT ioVATPercent          TFloat    , -- % ���
    IN inChangePrice         TFloat    , -- ������ � ����
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ���� (� ���������)
 INOUT ioPaidKindId          Integer   , -- ���� ���� ���� ������ 
 INOUT ioPaidKindName        TVarChar  , -- �������� ���� ���� ������ 
 INOUT ioContractId          Integer   , -- ���� ��������
 INOUT ioContractName        TVarChar  , -- �������� ��������
 INOUT ioRouteId             Integer   , -- ���� �������
 INOUT ioRouteName           TVarChar  , -- �������� �������
    IN inPersonalDriverId    Integer   , -- ��������� (��������)

 INOUT ioMovementItemId      Integer   , -- ���� ������� <������� ���������>
 INOUT ioGoodsId             Integer   , -- ���� �����
 INOUT ioGoodsCode           Integer   , -- ��� �����
 INOUT ioGoodsName           TVarChar  , -- �������� �����
 INOUT ioFuelName            TVarChar  , -- �������� ��� �������
    IN inAmount              TFloat    , -- ����������
    IN ioPrice               TFloat    , -- ����
 INOUT ioCountForPrice       TFloat    , -- ���� �� ����������
   OUT outAmountSumm         TFloat    , -- ����� ���������
   OUT outAmountSummTotal    TFloat    , -- ����� � ��� (����)

    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_TransportIncome());
     -- ���������� ���� �������
     vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_TransportIncome());

     -- ����������� �����
     inOperDate:= DATE_TRUNC ('DAY', inOperDate);
     ioOperDatePartner:= DATE_TRUNC ('DAY', ioOperDatePartner);

     -- ��������
     IF inOperDate < '01.10.2012'
     THEN
         RAISE EXCEPTION '������.<���� ���������> %.', inOperDate;
     END IF;
     -- ��������
     IF ioOperDatePartner < '01.10.2012'
     THEN
         RAISE EXCEPTION '������.<���� � ����������> %.', ioOperDatePartner;
     END IF;

     -- ��������
     IF COALESCE (inParentId, 0) = 0
     THEN
         RAISE EXCEPTION '������.<������� ����> �� ��������.';
     END IF;

     -- ��������
     IF COALESCE (inFromId, 0) = 0
     THEN
         RAISE EXCEPTION '������.<�������� ��������> �� ������.';
     END IF;

     -- ��������
     IF COALESCE (inToId, 0) = 0
     THEN
         RAISE EXCEPTION '������.<����������> �� ������.';
     END IF;


     -- ��� ������ ��������� ���� ��������� � ������� ��������
     IF COALESCE (ioMovementId, 0) = 0 
     THEN
         -- ��� ���������
         --
         -- ��������� �������� <����� ���������>
         ioInvNumber := CAST (NEXTVAL ('Movement_Income_seq') AS TVarChar);
         -- ���������� �������� �� Default <���� � ��� (��/���)>
         ioPriceWithVAT := TRUE;
         -- ���������� �������� �� Default <% ���>
         ioVATPercent := 20;
         -- ���������� �������� �� Default <���� ���� ������>
         IF COALESCE (ioPaidKindId, 0) = 0
         THEN
             ioPaidKindId := zc_Enum_PaidKind_FirstForm();
             ioPaidKindName := lfGet_Object_ValueData (ioPaidKindId);
         END IF;
         -- ����� �������� <�������> � "�����������"
         IF COALESCE (ioContractId, 0) = 0
         THEN
             ioContractId := 0;
             ioContractName := lfGet_Object_ValueData (ioContractId);
         END IF;
         -- ����� �������� <�������> � Master <���������>
         IF COALESCE (ioRouteId, 0) =0
         THEN
             ioRouteId := (SELECT MovementItem.ObjectId
                           FROM (SELECT MIN (Id) AS Id FROM MovementItem WHERE MovementId = inParentId AND DescId = zc_MI_Master() AND isErased = FALSE
                                ) AS tmpMI
                                JOIN MovementItem ON MovementItem.Id = tmpMI.Id
                          );
             ioRouteId:= COALESCE (ioRouteId, 0);
             ioRouteName := lfGet_Object_ValueData (ioRouteId);
         END IF;
         -- ����� �������� <��������� (��������)> � Master <���������>
         inPersonalDriverId := (SELECT ObjectId FROM MovementLinkObject WHERE MovementId = inParentId AND DescId = zc_MovementLinkObject_PersonalDriver());
         --
         -- ������ ��� ������
         --
         -- ����� �������� <�����> � <��� �������> ��� ����������
         IF COALESCE (ioGoodsId, 0) =0
         THEN
             SELECT Object_Goods.Id             AS GoodsId
                  , COALESCE (Object_Goods.ObjectCode, 0) AS GoodsCode
                  , Object_Goods.ValueData      AS GoodsName
                  , Object_FuelMaster.ValueData AS FuelName
                    INTO ioGoodsId, ioGoodsCode, ioGoodsName, ioFuelName
             FROM ObjectLink AS ObjectLink_Car_FuelMaster
                  LEFT JOIN Object AS Object_FuelMaster ON Object_FuelMaster.Id = ObjectLink_Car_FuelMaster.ChildObjectId
                  LEFT JOIN (SELECT ChildObjectId AS FuelId, MAX (ObjectId) AS GoodsId FROM ObjectLink WHERE DescId = zc_ObjectLink_Goods_Fuel() GROUP BY ChildObjectId
                            ) AS tmpGoods ON tmpGoods.FuelId = ObjectLink_Car_FuelMaster.ChildObjectId
                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoods.GoodsId
             WHERE ObjectLink_Car_FuelMaster.ObjectId = inToId
               AND ObjectLink_Car_FuelMaster.DescId = zc_ObjectLink_Car_FuelMaster();

             -- ��������
             IF COALESCE (ioFuelName, '') = ''
             THEN
                 RAISE EXCEPTION '������.�� ��������� <�������� ��� �������> � <����������>.';
             END IF;

             -- ��������
             IF COALESCE (ioGoodsId, 0) = 0
             THEN
                 RAISE EXCEPTION '������.�� ��������� <�����> ��� ���� ������� <%>.', ioFuelName;
             END IF;

         ELSE
             -- �������� - ����� �� ����� ���� �������
             IF EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_TicketFuel_Goods() AND ChildObjectId = ioGoodsId)
              AND NOT EXISTS (SELECT Id FROM Object WHERE Id = inFromId AND DescId = zc_Object_TicketFuel())
             THEN
                 RAISE EXCEPTION '������.�������� ��� ������ <%> ����� �����������.', ioGoodsName;
             END IF;

             -- ����� �������� <��� �������> ��� <�����> (��� ��� � ��������� � ������ ������ ���� ��� �������)
             SELECT Object_Goods.ValueData AS GoodsName
                  , Object_Fuel.ValueData  AS FuelName
                    INTO ioGoodsName, ioFuelName
             FROM ObjectLink AS ObjectLink_Goods_Fuel
                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Fuel.ObjectId
                  LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId
             WHERE ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                AND ObjectLink_Goods_Fuel.ObjectId = ioGoodsId;
             -- ��������
             IF COALESCE (ioFuelName, '') = ''
             THEN
                 RAISE EXCEPTION '������.�� ��������� <��� �������> � ������ <%>.', ioGoodsName;
             END IF;
         END IF;

     ELSE
         -- �������� - ����� �� ����� ���� �������
         IF EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_TicketFuel_Goods() AND ChildObjectId = ioGoodsId)
          AND NOT EXISTS (SELECT Id FROM Object WHERE Id = inFromId AND DescId = zc_Object_TicketFuel())
         THEN
             RAISE EXCEPTION '������.�������� ��� ������ <%> ����� �����������.', ioGoodsName;
         END IF;

         -- ����� �������� <��� �������> ��� <�����> (��� ��� � ��������� � ������ ������ ���� ��� �������)
         SELECT Object_Goods.ValueData AS GoodsName
              , Object_Fuel.ValueData  AS FuelName
                INTO ioGoodsName, ioFuelName
         FROM ObjectLink AS ObjectLink_Goods_Fuel
              LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Fuel.ObjectId
              LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId
         WHERE ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
            AND ObjectLink_Goods_Fuel.ObjectId = ioGoodsId;
         -- ��������
         IF COALESCE (ioFuelName, '') = ''
         THEN
             RAISE EXCEPTION '������.�� ��������� <��� �������> � ������ <%>.', ioGoodsName;
         END IF;
     END IF;

     -- ��������
     IF NOT EXISTS (SELECT MovementItem.ObjectId FROM MovementItem
                    WHERE MovementItem.MovementId = inParentId
                      AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.isErased   = FALSE
                       AND MovementItem.ObjectId   = ioRouteId
                   )
     THEN
         RAISE EXCEPTION '������.��������� <�������> �� ������ � <������� �����>.';
     END IF;


     -- ��������� <��������>
     ioMovementId := lpInsertUpdate_Movement_IncomeFuel (ioId               := ioMovementId
                                                       , inParentId         := inParentId
                                                       , inInvNumber        := ioInvNumber
                                                       , inOperDate         := inOperDate
                                                       , inOperDatePartner  := ioOperDatePartner
                                                       , inInvNumberPartner := inInvNumberPartner
                                                       , inPriceWithVAT     := ioPriceWithVAT
                                                       , inVATPercent       := ioVATPercent
                                                       , inChangePrice      := inChangePrice
                                                       , inFromId           := inFromId
                                                       , inToId             := inToId
                                                       , inPaidKindId       := ioPaidKindId
                                                       , inContractId       := ioContractId
                                                       , inRouteId          := ioRouteId
                                                       , inPersonalDriverId := inPersonalDriverId
                                                       , inAccessKeyId      := vbAccessKeyId 
                                                       , inUserId           := vbUserId
                                                        );

     -- ��������� <������� ���������> � ������� ���������
     SELECT tmp.ioId, tmp.ioCountForPrice, tmp.outAmountSumm
            INTO ioMovementItemId, ioCountForPrice, outAmountSumm
     FROM lpInsertUpdate_MovementItem_IncomeFuel (ioId            := ioMovementItemId
                                                , inMovementId    := ioMovementId
                                                , inGoodsId       := ioGoodsId
                                                , inAmount        := inAmount
                                                , ioPrice         := ioPrice
                                                , ioCountForPrice := ioCountForPrice
                                                , inUserId        := vbUserId
                                                 ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 31.10.13                                        * add ioOperDatePartner
 26.10.13                                        * ����������� �����
 23.10.13                                        * add NEXTVAL
 19.10.13                                        * add inChangePrice
 07.10.13                                        * add lpCheckRight
 05.10.13                                        *
*/

-- update MovementItemContainer set OperDate = DATE_TRUNC ('DAY', OperDate) where DATE_TRUNC ('DAY', OperDate) <> OperDate;
-- update Movement set OperDate = DATE_TRUNC ('DAY', OperDate) where DATE_TRUNC ('DAY', OperDate) <> OperDate;

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_TransportIncome (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inOperDatePartner:= '01.01.2013', inInvNumberPartner:= 'xxx', inPriceWithVAT:= true, inVATPercent:= 20, inChangePrice:= 0, inFromId:= 1, inToId:= 2, inPaidKindId:= 1, inContractId:= 0, inCarId:= 0, inPersonalDriverId:= 0, inPersonalPackerId:= 0, inSession:= '2')
