-- Function: gpUpdate_Movement_EDIComdoc_Params()

DROP FUNCTION IF EXISTS gpUpdate_Movement_EDIComdoc_Params (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_EDIComdoc_Params(
    IN inMovementId      Integer   , --
    IN inSession         TVarChar    -- ������ ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbGoodsPropertyId Integer;

   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_EDIComdoc_Params());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!������ ��� �������!!!
     /*IF NOT EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_Sale() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
         RAISE EXCEPTION '������.������ ��������� ����� ������ ��� ��������� <������� ����������>.';
     END IF;*/

     -- ��������� ��������� ���������
     vbGoodsPropertyId:= (SELECT lpUpdate_Movement_EDIComdoc_Params (inMovementId      := Movement.Id
                                                                   , inPartnerOperDate := MovementDate_OperDatePartner.ValueData
                                                                   , inPartnerInvNumber:= MovementString_InvNumberPartner.ValueData
                                                                   , inOrderInvNumber  := Movement.InvNumber
                                                                   , inOKPO            := MovementString_OKPO.ValueData
                                                                   , inUserId          := vbUserId)
                          FROM Movement
                               LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                      ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                                     AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                               LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                               LEFT JOIN MovementString AS MovementString_OKPO
                                                        ON MovementString_OKPO.MovementId =  Movement.Id
                                                       AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                          WHERE Movement.Id = inMovementId);


     -- �������� ������ - 2 ����� ������ ���� �����������
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_Sale() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
         -- ��� ��� �������
         IF NOT EXISTS (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementChildId = inMovementId AND DescId = zc_MovementLinkMovement_Sale())
         THEN 
             RAISE EXCEPTION '������.����� � ���������� <%> �� �����������', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Sale());
         END IF;
         -- ��� ��� ���������
         IF NOT EXISTS (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementChildId = inMovementId AND DescId = zc_MovementLinkMovement_Tax())
         THEN 
             RAISE EXCEPTION '������.����� � ���������� <%> �� �����������', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_Tax());
         END IF;
     ELSE
         -- ��� ��� ��������
         IF NOT EXISTS (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementChildId = inMovementId AND DescId = zc_MovementLinkMovement_MasterEDI())
         THEN 
             RAISE EXCEPTION '������.����� � ���������� <%> �� �����������', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_ReturnIn());
         END IF;
         -- ��� ��� �������������
         IF NOT EXISTS (SELECT MovementChildId FROM MovementLinkMovement WHERE MovementChildId = inMovementId AND DescId = zc_MovementLinkMovement_ChildEDI())
         THEN 
             RAISE EXCEPTION '������.����� � ���������� <%> �� �����������', (SELECT ItemName FROM MovementDesc WHERE Id = zc_Movement_TaxCorrective());
         END IF;
     END IF;


     -- ��������� ��������
     PERFORM lpInsertUpdate_MovementItem (ioId         := MovementItem.Id
                                        , inDescId     := MovementItem.DescId
                                        , inObjectId   := tmpGoodsPropertyValue.GoodsId
                                        , inMovementId := MovementItem.MovementId
                                        , inAmount     := MovementItem.Amount
                                        , inParentId   := MovementItem.ParentId
                                         )
           , lpInsertUpdate_MovementItemLinkObject (inDescId         := zc_MILinkObject_GoodsKind()
                                                  , inMovementItemId := MovementItem.Id
                                                  , inObjectId       := tmpGoodsPropertyValue.GoodsKindId
                                                   )
     FROM MovementItem
          LEFT JOIN MovementItemString AS MIString_GLNCode
                                       ON MIString_GLNCode.MovementItemId = MovementItem.Id
                                      AND MIString_GLNCode.DescId = zc_MIString_GLNCode()
          LEFT JOIN (SELECT ObjectString_ArticleGLN.ValueData AS ArticleGLN
                          , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId AS GoodsId
                          , ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId AS GoodsKindId
                     FROM (SELECT MAX (Id) AS Id FROM Object_GoodsPropertyValue_View WHERE GoodsPropertyId = vbGoodsPropertyId AND ArticleGLN <> '' GROUP BY ArticleGLN
                          ) AS tmpGoodsPropertyValue
                          LEFT JOIN ObjectString AS ObjectString_ArticleGLN
                                                 ON ObjectString_ArticleGLN.ObjectId = tmpGoodsPropertyValue.Id
                                                AND ObjectString_ArticleGLN.DescId = zc_ObjectString_GoodsPropertyValue_ArticleGLN()
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                               ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = tmpGoodsPropertyValue.Id
                                              AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                          LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                               ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = tmpGoodsPropertyValue.Id
                                              AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                    ) AS tmpGoodsPropertyValue ON tmpGoodsPropertyValue.ArticleGLN = MIString_GLNCode.ValueData
     WHERE MovementItem.MovementId = inMovementId
    ;


     -- !!!������ ��� ��������!!!
     /*IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_ReturnIn() WHERE MovementString.MovementId = inMovementId AND MovementString.DescId = zc_MovementString_Desc())
     THEN
          -- !!!��������� ���-�� <������� �� ����������> � <������������� � ��������� ���������>!!!
          PERFORM lpInsertUpdate_Movement_EDIComdoc_In (inMovementId    := inMovementId
                                                      , inUserId        := vbUserId
                                                      , inSession       := inSession
                                                       );
     END IF;*/


     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- ��������� �������� - ��������
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

     -- ��������� �������� - ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementItem.MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.09.14                                        * del !!!������ ��� �������!!!
 07.08.14                                        * add !!!������ ��� �������!!!
 07.08.14                                        * add zc_MovementString_InvNumberPartner
 31.07.14                                        * add lpInsertUpdate_Movement_EDIComdoc_In
 20.07.14                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_EDIComdoc_Params (inMovementId:= 0, inSession:= '2')
