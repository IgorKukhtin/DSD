-- Function: gpInsertUpdateMobile_Movement_OrderExternal()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_OrderExternal (TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, Integer, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_OrderExternal(
    IN inGUID                TVarChar  , -- ���������� ���������� �������������
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPartnerId           Integer   , -- ����������
    IN inPaidKindId          Integer   , -- ���� ���� ������
    IN inContractId          Integer   , -- ��������
    IN inPriceListId         Integer   , -- ����� ����
    IN inPriceWithVAT        Boolean   , -- ���� � ��� (��/���)
    IN inVATPercent          TFloat    , -- % ���
    IN inChangePercent       TFloat    , -- (-)% ������ (+)% �������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbId          Integer;
   DECLARE vbAccessKeyId Integer;
   DECLARE vbIsInsert    Boolean;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

      -- ���������� ���� �������
      vbAccessKeyId:= lpGetAccessKey (vbUserId, zc_Enum_Process_InsertUpdate_Movement_OrderExternal());

      SELECT MovementId INTO vbId FROM MovementString WHERE DescId = zc_MovementString_GUID() AND ValueData = inGUID;

      -- ���������� ������� ��������/�������������
      vbIsInsert:= COALESCE (vbId, 0) = 0;

      -- ��������� <��������>
      vbId:= lpInsertUpdate_Movement (vbId, zc_Movement_OrderExternal(), inInvNumber, inOperDate, NULL, vbAccessKeyId);

      IF vbIsInsert
      THEN
           -- ��������� �������� <���� ��������>
           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), vbId, CURRENT_TIMESTAMP);
           -- ��������� �������� <������������ (��������)>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), vbId, vbUserId);
      END IF;

      -- ��������� �������� <���������� ���������� �������������>
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);

      -- ��������� ����� � <����������>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), vbId, inPartnerId);    

      -- ��������� ����� � <���� ���� ������ >
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), vbId, inPaidKindId);

      -- ��������� ����� � <��������>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), vbId, inContractId);

      -- ��������� ����� � <����� ����>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PriceList(), vbId, inPriceListId);

      -- ��������� �������� <���� � ��� (��/���)>
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PriceWithVAT(), vbId, inPriceWithVAT);
      -- ��������� �������� <% ���>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_VATPercent(), vbId, inVATPercent);
      -- ��������� �������� <(-)% ������ (+)% ������� >
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbId, inChangePercent);

      -- ����������� �������� ����� �� ���������
      PERFORM lpInsertUpdate_MovementFloat_TotalSumm (vbId);

      -- ��������� ��������
      PERFORM lpInsert_MovementProtocol (vbId, vbUserId, vbIsInsert);

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 28.02.17                                                         *
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_Movement_OrderExternal (inGUID:= '{A539F063-B6B2-4089-8741-B40014ED51D7}'
                                                            , inInvNumber:= '-1'
                                                            , inOperDate:= CURRENT_DATE
                                                            , inPartnerId:= NULL
                                                            , inPaidKindId:= NULL
                                                            , inContractId:= NULL
                                                            , inPriceListId:= NULL
                                                            , inPriceWithVAT:= true
                                                            , inVATPercent:= 20
                                                            , inChangePercent:= 5
                                                            , inSession:= zfCalc_UserAdmin()
                                                             )
*/
