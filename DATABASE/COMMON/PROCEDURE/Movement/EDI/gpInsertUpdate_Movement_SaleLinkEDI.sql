-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SaleLinkEDI (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SaleLinkEDI(
    IN inMovementId_EDI      Integer   , --
    IN inMovementId          Integer   , --
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS VOID 
AS
$BODY$
DECLARE
   vbMovementId_EDI Integer;
   vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SaleLinkEDI());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!��� ��� �������!!!
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_Sale() WHERE MovementString.MovementId = inMovementId_EDI AND MovementString.DescId = zc_MovementString_Desc())
     THEN

     -- ����� ��������� EDI
     vbMovementId_EDI:= (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementId = inMovementId AND DescId = zc_MovementLinkMovement_Sale());

     -- ��������
     IF COALESCE (vbMovementId_EDI, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <������� ����������> �� ������ � ���������� <EDI>.';
     END IF;
     -- ��������
     IF COALESCE (inMovementId_EDI, 0) <> COALESCE (vbMovementId_EDI, 0)
     THEN
         RAISE EXCEPTION '������.� ��������� <EDI>.';
     END IF;


     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     -- ��������� ���������� � ����������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
       AND MovementItem.MovementId = inMovementId;


     -- ������� ������ �� ComDoc � ��������
     PERFORM lpInsertUpdate_MI_SaleCOMDOC (inMovementId    := inMovementId
                                         , inMovementItemId:= tmpMI.MovementItemId
                                         , inGoodsId       := tmpMI_EDI.GoodsId
                                         , inGoodsKindId   := tmpMI_EDI.GoodsKindId
                                         , inAmountPartner := tmpMI_EDI.AmountPartner
                                         , inPrice         := tmpMI_EDI.Price
                                         , inUserId        := vbUserId
                                          )
     FROM (SELECT MovementItem.ObjectId                               AS GoodsId
                , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                , SUM (COALESCE (MIFloat_AmountPartner.ValueData, 0)) AS AmountPartner
           FROM MovementItem
                LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                            ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                             AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                 ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
           WHERE MovementItem.MovementId = vbMovementId_EDI
             AND MovementItem.DescId =  zc_MI_Master()
           GROUP BY MovementItem.ObjectId
                  , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                  , COALESCE (MIFloat_Price.ValueData, 0)
          ) AS tmpMI_EDI
          LEFT JOIN (SELECT MAX (MovementItem.Id)                               AS MovementItemId
                          , MovementItem.ObjectId                               AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)       AS GoodsKindId
                          , COALESCE (MIFloat_Price.ValueData, 0)               AS Price
                     FROM MovementItem
                          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId = zc_MI_Master()
                       AND MovementItem.isErased = FALSE
                     GROUP BY MovementItem.ObjectId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
                            , COALESCE (MIFloat_Price.ValueData, 0)
                    ) AS tmpMI ON tmpMI.GoodsId = tmpMI_EDI.GoodsId
                              AND tmpMI.GoodsKindId = tmpMI_EDI.GoodsKindId
                              AND tmpMI.Price = tmpMI_EDI.Price
      ;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- �������� ��������
     PERFORM gpComplete_Movement_Sale (inMovementId     := inMovementId
                                     , inIsLastComplete := FALSE
                                     , inSession        := inSession);

     -- ��������� ��������
     PERFORM lpInsert_Movement_EDIEvents (vbMovementId_EDI, '�������� ������� ������ �� ComDoc � �������� (' || (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Sale()) || ').', vbUserId);

     END IF; -- !!!��� ��� �������!!!


     -- !!!��� ��� ��������!!!
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_ReturnIn() WHERE MovementString.MovementId = inMovementId_EDI AND MovementString.DescId = zc_MovementString_Desc())
     THEN
          -- !!!��������� ���-�� <������� �� ����������> � <������������� � ��������� ���������>!!!
          PERFORM lpInsertUpdate_Movement_EDIComdoc_In (inMovementId    := inMovementId_EDI
                                                      , inUserId        := vbUserId
                                                      , inSession       := inSession
                                                       );
     END IF;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.09.14                                        * add lpInsertUpdate_Movement_EDIComdoc_In
 20.07.14                                        * ALL
 13.05.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
