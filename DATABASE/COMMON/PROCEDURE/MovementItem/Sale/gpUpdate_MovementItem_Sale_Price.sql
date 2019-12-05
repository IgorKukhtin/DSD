-- Function: gpUpdate_MovementItem_Sale_Price()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_Price (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_Price(
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPriceListId Integer;
   DECLARE vbMovementId_order Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());


     -- ������������ ��������� ���������
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
          , MovementLinkObject_PriceList.ObjectId AS PriceListId
          , MLM_Order.MovementChildId             AS MovementId_order

            INTO vbStatusId, vbInvNumber, vbOperDate, vbPriceListId, vbMovementId_order
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceList
                                       ON MovementLinkObject_PriceList.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceList.DescId = zc_MovementLinkObject_PriceList()
          LEFT JOIN MovementLinkMovement AS MLM_Order
                                         ON MLM_Order.MovementId = Movement.Id
                                        AND MLM_Order.DescId = zc_MovementLinkMovement_Order()
     WHERE Movement.Id = inMovementId;


     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- �������� - ����� ���� ������ ���� ����������
     IF COALESCE (vbPriceListId, 0) = 0 
     THEN
         RAISE EXCEPTION '������.�������� <����� ����> ������ ���� �����������.';
     END IF;
   

     -- �������� ��������
     -- !!!������!!!
     SELECT tmp.OperDate
            INTO vbOperDate
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := CASE WHEN vbMovementId_order <> 0
                                                                               THEN (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_order)
                                                                          ELSE NULL
                                                                     END
                                               , inOperDatePartner:= CASE WHEN vbMovementId_order <> 0 AND vbOperDate + INTERVAL '1 DAY' >= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = vbMovementId_order)
                                                                               THEN NULL
                                                                          ELSE vbOperDate
                                                                     END
                                               , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                               , inIsPrior        := FALSE -- !!!�������� ����� �� �����!!!
                                                ) AS tmp;


     -- ���������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), MovementItem.Id, COALESCE (lfObjectHistory_PriceListItem_kind.ValuePrice, lfObjectHistory_PriceListItem.ValuePrice, 0))
     FROM MovementItem
          -- ��� ������
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

          -- ����������� 2 ���� �� ���� ������ � � ������ �����
          LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate)
                 AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = MovementItem.ObjectId
                                                 AND lfObjectHistory_PriceListItem.GoodsKindId IS NULL
                                                 
          LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= vbOperDate)
                 AS lfObjectHistory_PriceListItem_kind 
                 ON lfObjectHistory_PriceListItem_kind.GoodsId = MovementItem.ObjectId
                AND COALESCE (lfObjectHistory_PriceListItem_kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
     WHERE MovementId = inMovementId;


     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- ��������� ����� � <PriceList>
     -- PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), inMovementId, vbPriceListId);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.12.19         *
 22.08.15         *

*/
