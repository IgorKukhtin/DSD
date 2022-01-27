-- Function: gpUpdate_MovementItem_Sale_PriceIn()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_PriceIn (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_PriceIn(
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
   DECLARE vbPriceListInId Integer;

BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Sale_Price());

     -- ������������ ��������� ���������
     SELECT Movement.StatusId
          , Movement.InvNumber
          , Movement.OperDate
          , MovementLinkObject_PriceListIn.ObjectId AS PriceListInId

            INTO vbStatusId, vbInvNumber, vbOperDate, vbPriceListInId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_PriceListIn
                                       ON MovementLinkObject_PriceListIn.MovementId = Movement.Id
                                      AND MovementLinkObject_PriceListIn.DescId = zc_MovementLinkObject_PriceListIn()
     WHERE Movement.Id = inMovementId;


     -- �������� - �����������/��������� ��������� �������� ������
     /*IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     */
     
     /*-- �������� - ����� ���� ������ ���� ����������
     IF COALESCE (vbPriceListInId, 0) = 0 
     THEN
         RAISE EXCEPTION '������.�������� <����� ����> ������ ���� �����������.';
     END IF;*/
   
     --��������� ����� ��.
     IF COALESCE (vbPriceListInId,0) = 0
     THEN
         vbPriceListInId = 3552610;  -- "*����� -20"
         -- ��������� �����
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceListIn(), inMovementId, vbPriceListInId);
     END IF;


     -- �������� ��������
     -- !!!������!!!
     SELECT tmp.OperDate
            INTO vbOperDate
     FROM lfGet_Object_Partner_PriceList_onDate (inContractId     := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_Contract())
                                               , inPartnerId      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inMovementId AND MLO.DescId = zc_MovementLinkObject_To())
                                               , inMovementDescId := zc_Movement_Sale()
                                               , inOperDate_order := vbOperDate ::TDateTime
                                               , inOperDatePartner:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_OperDatePartner())::TDateTime
                                               , inDayPrior_PriceReturn:= 0 -- !!!�������� ����� �� �����!!!
                                               , inIsPrior        := FALSE -- !!!�������� ����� �� �����!!!
                                               , inOperDatePartner_order:= NULL ::TDateTime
                                                ) AS tmp;


     -- ���������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), tmp.Id, tmp.PriceIn)
     FROM 
         (WITH
          -- ���� �� ������ ��.
          tmpPriceListIn AS (SELECT lfSelect.GoodsId     AS GoodsId
                                  , lfSelect.GoodsKindId AS GoodsKindId
                                  , lfSelect.ValuePrice
                             FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListInId, inOperDate:= vbOperDate) AS lfSelect
                            )

          SELECT MovementItem.Id
               , COALESCE (tmpPriceListIn_kind.ValuePrice, tmpPriceListIn.ValuePrice, 0) AS PriceIn
          FROM MovementItem
               -- ��� ������
               LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                               AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()

               -- ����������� 2 ���� �� ���� ������ � � ������ �����
               LEFT JOIN tmpPriceListIn AS tmpPriceListIn
                                        ON tmpPriceListIn.GoodsId = MovementItem.ObjectId
                                       AND tmpPriceListIn.GoodsKindId IS NULL
                                                 
               LEFT JOIN tmpPriceListIn AS tmpPriceListIn_kind 
                                        ON tmpPriceListIn_kind.GoodsId = MovementItem.ObjectId
                                       AND COALESCE (tmpPriceListIn_kind.GoodsKindId,0) = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
          WHERE MovementId = inMovementId
         ) AS tmp
     ;

if vbUserId = 5 OR vbUserId = 9457
then
    RAISE EXCEPTION '������.<%>', vbOperDate;
end if;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- ����������� �������� ����� �� ���������
     --PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.22         *
*/
