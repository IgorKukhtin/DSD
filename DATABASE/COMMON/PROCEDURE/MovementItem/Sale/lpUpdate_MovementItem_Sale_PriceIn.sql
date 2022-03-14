-- Function: lpUpdate_MovementItem_Sale_PriceIn()

DROP FUNCTION IF EXISTS lpUpdate_MovementItem_Sale_PriceIn (Integer, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_MovementItem_Sale_PriceIn(
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inUserId                  Integer     -- ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbOperDate TDateTime;
   DECLARE vbPriceListInId Integer;
   DECLARE vbPartnerId Integer;
BEGIN

     -- ������������ ��������� ���������
     SELECT Movement.StatusId
          , Movement.InvNumber
          , COALESCE (MovementDate_OperDatePartner.ValueData, Movement.OperDate)
          , MovementLinkObject_PriceListIn.ObjectId AS PriceListInId
          , CASE WHEN Movement.DescId = zc_Movement_Sale() THEN MovementLinkObject_To.ObjectId ELSE MovementLinkObject_From.ObjectId END AS PartnerId

            INTO vbStatusId, vbInvNumber, vbOperDate, vbPriceListInId, vbPartnerId

     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceListIn
                                       ON MovementLinkObject_PriceListIn.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceListIn.DescId = zc_MovementLinkObject_PriceListIn()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                 ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
     WHERE Movement.Id = inMovementId;


     -- �������� - ��������� �������� �������� ������
     IF vbStatusId = zc_Enum_Status_Erased()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;


     -- ��������� ����� ��.
     IF COALESCE (vbPriceListInId, 0) = 0
        AND EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Partner_Unit())
     THEN
         -- "*����� -20"
         vbPriceListInId = 3552610;

         -- ��������� �����
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceListIn(), inMovementId, vbPriceListInId);

         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

     ELSEIF vbPriceListInId > 0
        AND NOT EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = vbPartnerId AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_Partner_Unit())
     THEN
         -- �������� �����
         vbPriceListInId:= 0;
         -- �������� �����
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceListIn(), inMovementId, vbPriceListInId);

         -- ��������� ��������
         PERFORM lpInsert_MovementProtocol (inMovementId, inUserId, FALSE);

     END IF;


     -- �������� ��������
     -- !!!������!!!
     /*SELECT tmp.OperDate
            INTO vbOperDate
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , inPartnerId      := vbPartnerId
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := vbOperDate ::TDateTime
                                               , inOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())::TDateTime
                                               , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                               , inIsPrior        := FALSE -- !!!�������� ����� �� �����!!!
                                               , inOperDatePartner_order:= NULL ::TDateTime
                                                ) AS tmp;*/


     -- ���������
     PERFORM lpInsert_MovementItemProtocol (tmp.Id, inUserId, FALSE)
     FROM (-- ���������
           SELECT tmp.Id
                , lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn(), tmp.Id, tmp.PriceIn)
           FROM
               (WITH -- ���� �� ������ ��.
                     tmpPriceListIn AS (SELECT lfSelect.GoodsId     AS GoodsId
                                             , lfSelect.GoodsKindId AS GoodsKindId
                                             , lfSelect.ValuePrice
                                        FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListInId, inOperDate:= vbOperDate) AS lfSelect
                                       )
                --
                SELECT MovementItem.Id
                     , COALESCE (tmpPriceListIn_kind.ValuePrice, tmpPriceListIn.ValuePrice, 0) AS PriceIn
                FROM MovementItem
                     -- ��� ������
                     LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                      ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                     AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     --
                     LEFT JOIN MovementItemFloat AS MIFloat
                                                 ON MIFloat.MovementItemId = MovementItem.Id
                                                AND MIFloat.DescId         = zc_MIFloat_PriceIn()

                     -- ����������� 2 ���� �� ���� ������ � � ������ �����
                     LEFT JOIN tmpPriceListIn AS tmpPriceListIn
                                              ON tmpPriceListIn.GoodsId = MovementItem.ObjectId
                                             AND tmpPriceListIn.GoodsKindId IS NULL

                     LEFT JOIN tmpPriceListIn AS tmpPriceListIn_kind
                                              ON tmpPriceListIn_kind.GoodsId = MovementItem.ObjectId
                                             AND COALESCE (tmpPriceListIn_kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                WHERE MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId     = zc_MI_Master()
                  AND COALESCE (MIFloat.ValueData, 0) <> COALESCE (tmpPriceListIn_kind.ValuePrice, tmpPriceListIn.ValuePrice, 0)
               ) AS tmp
          ) AS tmp
     ;

    --
    if inUserId IN (5, 9457) AND 1=0
    then
        RAISE EXCEPTION '������.<%>', vbOperDate;
    end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.03.22                                        *
*/
