-- Function: gpInsertUpdate_Movement_EDI() - ��������� ������ �� EDI � �������� !!!������ ������� ������ ��� ����, ��������� - ���������/��������������!!!

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SaleLinkEDI (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SaleLinkEDI(
    IN inMovementId_EDI      Integer   , --
    IN inMovementId          Integer   , --
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar, OperDateTax TDateTime, InvNumberTax TVarChar
             , TotalCountPartner TFloat
             , TotalSumm TFloat
             , OKPO TVarChar, JuridicalName TVarChar
             , GLNCode TVarChar,  GLNPlaceCode TVarChar
             , JuridicalId_Find Integer, JuridicalNameFind TVarChar, PartnerNameFind TVarChar

             , ContractId Integer, ContractCode Integer, ContractName TVarChar, ContractTagName TVarChar
             , UnitId Integer, UnitName TVarChar

             , MovementId_Sale Integer
             , OperDatePartner_Sale TDateTime, InvNumber_Sale TVarChar
             , FromName_Sale TVarChar, ToName_Sale TVarChar
             , TotalCountPartner_Sale TFloat
             , TotalSumm_Sale TFloat

             , MovementId_Tax Integer
             , OperDate_Tax TDateTime, InvNumberPartner_Tax TVarChar

             , MovementId_TaxCorrective Integer
             , OperDate_TaxCorrective TDateTime, InvNumberPartner_TaxCorrective TVarChar

             , MovementId_Order Integer
             , OperDate_Order TDateTime, InvNumber_Order TVarChar

             , DescName TVarChar
             , isCheck Boolean
             , isElectron Boolean
             , isError Boolean

             , MessageText Text
              )
AS
$BODY$
DECLARE
   vbUserId Integer;
   vbMovementId_EDI Integer;
   vbMessageText Text;
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


     -- �������� <������������� �������> !!!�� ���-�� ������!!! + ��������� �������� !!!�� ����� ���� ������ �������� GoodsId and GoodsKindId!!!
     PERFORM lpUpdate_MI_EDI_Params (inMovementId  := vbMovementId_EDI
                                   , inContractId  := (SELECT MLO_Contract.ObjectId FROM MovementLinkObject AS MLO_Contract WHERE MLO_Contract.MovementId = inMovementId AND MLO_Contract.DescId = zc_MovementLinkObject_Contract())
                                   , inJuridicalId := (SELECT MLO_Juridical.ObjectId FROM MovementLinkObject AS MLO_Juridical WHERE MLO_Juridical.MovementId = vbMovementId_EDI AND MLO_Juridical.DescId = zc_MovementLinkObject_Juridical())
                                   , inUserId      := vbUserId
                                    );


     -- ����������� ��������
     PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                  , inUserId     := vbUserId);

     -- ��������� ���������� � ����������
     /*PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.DescId     = zc_MI_Master()
       AND MovementItem.isErased   = FALSE
       AND MovementItem.MovementId = inMovementId;*/


     -- ������� ������ �� ComDoc � ��������
     PERFORM lpInsertUpdate_MI_SaleCOMDOC (inMovementId    := inMovementId
                                         , inMovementItemId:= tmpMI.MovementItemId
                                         , inGoodsId       := COALESCE (tmpMI_EDI.GoodsId, tmpMI.GoodsId)
                                         , inGoodsKindId   := COALESCE (tmpMI_EDI.GoodsKindId, tmpMI.GoodsKindId)
                                         , inAmountPartner := COALESCE (tmpMI_EDI.AmountPartner, 0)
                                         , inPrice         := COALESCE (tmpMI_EDI.Price, tmpMI.Price)
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
          FULL JOIN (SELECT MAX (MovementItem.Id)                               AS MovementItemId
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
                    ) AS tmpMI ON tmpMI.GoodsId     = tmpMI_EDI.GoodsId
                              AND tmpMI.GoodsKindId = tmpMI_EDI.GoodsKindId
                              AND tmpMI.Price       = tmpMI_EDI.Price
      ;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     -- �������� ��������
     PERFORM gpComplete_Movement_Sale (inMovementId     := inMovementId
                                     , inIsLastComplete := FALSE
                                     , inSession        := inSession);

     -- ��������� ��������
     PERFORM lpInsert_Movement_EDIEvents (vbMovementId_EDI, '�������� ������� ������ �� ComDoc � �������� (' || (SELECT MovementDesc.ItemName FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Sale()) || ').', vbUserId);

     -- END !!!��� ��� �������!!!

     ELSE
     -- !!!��� ��� ��������!!!
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_ReturnIn() WHERE MovementString.MovementId = inMovementId_EDI AND MovementString.DescId = zc_MovementString_Desc())
     THEN
          -- !!!��������� ���-�� <������� �� ����������> � <������������� � ��������� ���������>!!!
          vbMessageText:= lpInsertUpdate_Movement_EDIComdoc_In (inMovementId    := inMovementId_EDI
                                                              , inUserId        := vbUserId
                                                              , inSession       := inSession
                                                               );
     -- END !!!��� ��� ��������!!!

     ELSE
     -- !!!��� ��� ������!!!
     IF EXISTS (SELECT MovementString.MovementId FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData AND MovementDesc.Id = zc_Movement_OrderExternal() WHERE MovementString.MovementId = inMovementId_EDI AND MovementString.DescId = zc_MovementString_Desc())
     THEN
          -- !!!��������� ���-� <������ ���������>!!!
          PERFORM lpInsertUpdate_Movement_EDIComdoc_Order (inMovementId    := inMovementId_EDI
                                                         , inUserId        := vbUserId
                                                         , inSession       := inSession
                                                          );
     -- END !!!��� ��� ������!!!

     ELSE
         RAISE EXCEPTION '������.������ ���������� �������� <%>.', COALESCE ((SELECT MovementDesc.ItemName FROM MovementString INNER JOIN MovementDesc ON MovementDesc.Code = MovementString.ValueData WHERE MovementString.MovementId = inMovementId_EDI AND MovementString.DescId = zc_MovementString_Desc()), '');
     END IF;
     END IF;
     END IF;

     -- ���������     
     RETURN QUERY 
     SELECT tmp.*
          , vbMessageText AS MessageText
     FROM lpGet_Movement_EDI (inMovementId:= inMovementId_EDI
                            , inUserId    := vbUserId
                             ) AS tmp;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.10.14                                        * add lpInsertUpdate_Movement_EDIComdoc_Order
 01.09.14                                        * add lpInsertUpdate_Movement_EDIComdoc_In
 20.07.14                                        * ALL
 13.05.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= '2')
