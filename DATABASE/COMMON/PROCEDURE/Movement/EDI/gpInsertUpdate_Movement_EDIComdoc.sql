-- Function: gpInsertUpdate_Movement_EDI()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_EDIComdoc (TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_EDIComdoc(
    IN inOrderInvNumber      TVarChar  , -- ����� ������ �����������
    IN inOrderOperDate       TDateTime , -- ���� ������ �����������
    IN inPartnerInvNumber    TVarChar  , -- ����� ��������� � �����������
    IN inPartnerOperDate     TDateTime , -- ���� ��������� � �����������
    IN inInvNumberTax        TVarChar  , -- ����� ��������� ��������� � ����������� (�������� ��������)
    IN inOperDateTax         TDateTime , -- ���� ��������� ��������� � ����������� (�������� ��������)
    IN inInvNumberSaleLink   TVarChar  , -- ����� ��������� ������� ����������� (�������� ��������) + �������� ��� ������� �.�. ����� ���� ��� ������ � ���������� �������
    IN inOperDateSaleLink    TDateTime , -- ���� ��������� ������� ����������� (�������� ��������)
    IN inOKPO                TVarChar  , -- 
    IN inJurIdicalName       TVarChar  , --
    IN inDesc                TVarChar  , -- ��� ���������
    IN inGLNPlace            TVarChar  , -- ��� GLN - ����� ��������
    IN inComDocDate          TDateTime , -- ���� ������ �����������
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS TABLE (MovementId Integer, GoodsPropertyId Integer) -- ������������� �������
AS
$BODY$
   DECLARE vbMovementId      Integer;
   DECLARE vbGoodsPropertyId Integer;

   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_EDIComdoc());
     vbUserId:= lpGetUserBySession (inSession);


     -- ������ ��������
     inGLNPlace:= TRIM (inGLNPlace);

     -- ������ ��������
     inDesc:= COALESCE ((SELECT MovementDesc.Code FROM MovementDesc WHERE Id = zc_Movement_Sale() AND inDesc = 'Sale')
                       , COALESCE ((SELECT MovementDesc.Code FROM MovementDesc WHERE Id = zc_Movement_ReturnIn() AND inDesc = 'Return')
                                 , (SELECT MovementDesc.Code FROM MovementDesc WHERE Id IN (zc_Movement_Sale(), zc_Movement_ReturnIn()) AND MovementDesc.Code = inDesc))
                       );

     IF inDesc IS NULL
     THEN
         RAISE EXCEPTION '������ � ���������.<%>', inDesc;
     END IF;

     -- ����� ��������� � ������� EDI
     IF EXISTS (SELECT MovementDesc.Id FROM MovementDesc WHERE MovementDesc.Code = inDesc AND MovementDesc.Id = zc_Movement_Sale())
     THEN
         IF zfConvert_StringToBigInt (inGLNPlace)  = 0
         THEN inGLNPlace:= '';
         END IF;

         IF inGLNPlace <> ''
         THEN
              -- !!!��� ��� �������!!! + !!!�� ����� ��������!!! + !!!inDesc!!!
              vbMovementId:= (SELECT Movement.Id
                              FROM Movement
                                   INNER JOIN MovementString AS MovementString_OKPO
                                                             ON MovementString_OKPO.MovementId =  Movement.Id
                                                            AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                            AND MovementString_OKPO.ValueData = inOKPO
                                   INNER JOIN MovementString AS MovementString_MovementDesc
                                                             ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                            AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                            AND MovementString_MovementDesc.ValueData IN (inDesc)
                                   INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                             ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                            AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                            AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                              WHERE Movement.DescId = zc_Movement_EDI()
                                AND Movement.InvNumber = inOrderInvNumber
                                AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                              ORDER BY 1
                              LIMIT 1 -- !!!��������, �.�. ���� ��������� ������ �������� > 1, ������ - 4437188100 �� '28.08.2015'!!!
                             );
              IF COALESCE (vbMovementId, 0) = 0
              THEN
              -- !!!��� ��� �������!!! + !!!�� ����� ��������!!! + !!!zc_Movement_OrderExternal!!!
              vbMovementId:= (SELECT Movement.Id
                              FROM Movement
                                   INNER JOIN MovementString AS MovementString_OKPO
                                                             ON MovementString_OKPO.MovementId =  Movement.Id
                                                            AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                            AND MovementString_OKPO.ValueData = inOKPO
                                   INNER JOIN MovementString AS MovementString_MovementDesc
                                                             ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                            AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                            AND MovementString_MovementDesc.ValueData IN ((SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal()))
                                   INNER JOIN MovementString AS MovementString_GLNPlaceCode
                                                             ON MovementString_GLNPlaceCode.MovementId =  Movement.Id
                                                            AND MovementString_GLNPlaceCode.DescId = zc_MovementString_GLNPlaceCode()
                                                            AND MovementString_GLNPlaceCode.ValueData = inGLNPlace
                              WHERE Movement.DescId = zc_Movement_EDI()
                                AND Movement.InvNumber = inOrderInvNumber
                                AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                             );
              END IF;

              IF vbMovementId <> 0
              THEN
                   -- !!!�������� � ��������� EDI �������!!!
                   PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Sale()));
              END IF;

         ELSE
              -- !!!��� ��� �������!!! + !!!�� ����� ����� ��������!!!
              vbMovementId:= (SELECT Movement.Id
                              FROM Movement
                                   INNER JOIN MovementString AS MovementString_OKPO
                                                             ON MovementString_OKPO.MovementId =  Movement.Id
                                                            AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                            AND MovementString_OKPO.ValueData = inOKPO
                                   INNER JOIN MovementString AS MovementString_MovementDesc
                                                             ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                            AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                            AND MovementString_MovementDesc.ValueData IN (inDesc, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_OrderExternal()))
                              WHERE Movement.DescId = zc_Movement_EDI()
                                AND Movement.InvNumber = inOrderInvNumber
                                AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                             );

              IF vbMovementId <> 0
              THEN
                   -- !!!�������� � ��������� EDI �������!!!
                   PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, (SELECT MovementDesc.Code FROM MovementDesc WHERE MovementDesc.Id = zc_Movement_Sale()));
              END IF;

         END IF;
     END IF;

     IF EXISTS (SELECT MovementDesc.Id FROM MovementDesc WHERE MovementDesc.Code = inDesc AND MovementDesc.Id = zc_Movement_ReturnIn())
     THEN
         -- !!!��� ��� ��������!!!
         vbMovementId:= (SELECT Movement.Id
                         FROM Movement
                              INNER JOIN MovementString AS MovementString_OKPO
                                                        ON MovementString_OKPO.MovementId =  Movement.Id
                                                       AND MovementString_OKPO.DescId = zc_MovementString_OKPO()
                                                       AND MovementString_OKPO.ValueData = inOKPO
                              INNER JOIN MovementString AS MovementString_InvNumberPartner
                                                        ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                                       AND MovementString_InvNumberPartner.DescId = zc_MovementString_Desc()
                                                       AND MovementString_InvNumberPartner.ValueData = inPartnerInvNumber
                              INNER JOIN MovementString AS MovementString_MovementDesc
                                                        ON MovementString_MovementDesc.MovementId =  Movement.Id
                                                       AND MovementString_MovementDesc.DescId = zc_MovementString_Desc()
                                                       AND MovementString_MovementDesc.ValueData = inDesc
                         WHERE Movement.DescId = zc_Movement_EDI()
                           AND Movement.InvNumber = inOrderInvNumber
                           AND Movement.OperDate BETWEEN (inPartnerOperDate - (INTERVAL '7 DAY')) AND (inPartnerOperDate + (INTERVAL '7 DAY'))
                        );
     END IF;

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (vbMovementId, 0) = 0;

     IF COALESCE (vbMovementId, 0) = 0
     THEN
          -- ��������� <��������>
          vbMovementId := lpInsertUpdate_Movement (vbMovementId, zc_Movement_EDI(), inOrderInvNumber, inOrderOperDate, NULL);
          -- ��������� <����>
          PERFORM lpInsertUpdate_MovementString (zc_MovementString_OKPO(), vbMovementId, inOKPO);

     END IF;

     -- ��������� ��� GLN - ����� ��������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_GLNPlaceCode(), vbMovementId, inGLNPlace);

     -- ���������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDatePartner(), vbMovementId, inPartnerOperDate);
     -- ���������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_COMDOC(), vbMovementId, inComDocDate);

     -- ���������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), vbMovementId, inPartnerInvNumber);

     -- ���������
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateTax(), vbMovementId, inOperDateTax);
     -- ���������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberTax(), vbMovementId, inInvNumberTax);

     -- ��������� ���� ��������� ������� ����������� (�������� ��������)
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSaleLink(), vbMovementId, inOperDateSaleLink);
     -- ���������  ����� ��������� ������� ����������� (�������� ��������)
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberSaleLink(), vbMovementId, TRIM (inInvNumberSaleLink));

     -- ���������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_JurIdicalName(), vbMovementId, inJurIdicalName);
     -- ���������
     PERFORM lpInsertUpdate_MovementString (zc_MovementString_Desc(), vbMovementId, inDesc);

     -- ��������� ��������� ���������
     vbGoodsPropertyId:= lpUpdate_Movement_EDIComdoc_Params (inMovementId       := vbMovementId
                                                           , inPartnerOperDate  := inPartnerOperDate
                                                           , inPartnerInvNumber := inPartnerInvNumber
                                                           , inOrderInvNumber   := inOrderInvNumber
                                                           , inOKPO             := inOKPO
                                                           , inIsCheck          := FALSE
                                                           , inUserId           := vbUserId);

     -- �������� <���-�� � �����.>, �.�. ����� ���-�� �����������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AmountPartner(), MovementItem.Id, 0)
     FROM MovementItem
     WHERE MovementItem.MovementId = vbMovementId
       AND MovementItem.DescId     = zc_MI_Master()
          ;



     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbMovementId);

     -- ��������� ��������
     PERFORM lpInsert_Movement_EDIEvents (vbMovementId, '�������� COMDOC �� EDI', vbUserId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (vbMovementId, vbUserId, vbIsInsert);

     -- ���������
     RETURN QUERY 
     SELECT vbMovementId, vbGoodsPropertyId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.04.15                         * 
 02.04.15                                        * add inGLNPlace
 07.08.14                                        * add calc inDesc
 07.08.14                                        * add inPartnerInvNumber := inPartnerInvNumber
 20.07.14                                        * ALL
 29.05.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_EDI (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inFromId:= 1, inToId:= 2, inSession:= zfCalc_UserAdmin())
