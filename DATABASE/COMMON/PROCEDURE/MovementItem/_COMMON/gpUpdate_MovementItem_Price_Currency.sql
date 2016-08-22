-- Function: gpUpdate_MovementItem_Price_Currency()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Price_Currency (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Price_Currency(
    IN inMovementId              Integer   , -- ���� ������� <��������>
    IN inSession                 TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbCurrencyDocumentId Integer;
   DECLARE vbCurrencyPartnerId Integer;
   DECLARE vbCurrencyPartnerValue TFloat;
   DECLARE vbParPartnerValue TFloat;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_MI_Price_Currency());


     -- ������������ ��������� ���������
     SELECT Movement.StatusId
          , Movement.InvNumber
          , MovementLinkObject_CurrencyDocument.ObjectId   AS CurrencyDocumentId
          , MovementLinkObject_CurrencyPartner.ObjectId    AS CurrencyPartnerId
          , MovementFloat_CurrencyPartnerValue.ValueData   AS CurrencyPartnerValue
          , MovementFloat_ParPartnerValue.ValueData        AS ParPartnerValue
            INTO vbStatusId, vbInvNumber, vbCurrencyDocumentId, vbCurrencyPartnerId, vbCurrencyPartnerValue, vbParPartnerValue
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyDocument
                                       ON MovementLinkObject_CurrencyDocument.MovementId = Movement.Id
                                      AND MovementLinkObject_CurrencyDocument.DescId = zc_MovementLinkObject_CurrencyDocument()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                       ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                      AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
          LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                  ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
          LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                  ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                 AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()
     WHERE Movement.Id = inMovementId;


     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;
     -- �������� - ������ ������ ���� �����������
     IF COALESCE (vbCurrencyDocumentId, 0) = 0 OR COALESCE (vbCurrencyPartnerId, 0) = 0 
     THEN
         RAISE EXCEPTION '������.�������� <������> ������ ���� �����������.';
     END IF;
     -- �������� - ������ ������ ����������
     IF vbCurrencyDocumentId = vbCurrencyPartnerId
     THEN
         RAISE EXCEPTION '������.�������� <������ (����)> � <������ (����������)> ������ ����������.';
     END IF;

     -- �������� - ���� ������ ���� ����������
     IF COALESCE (vbCurrencyPartnerValue, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <����> ������ ���� �����������.';
     END IF;
     -- �������� - ������� ������ ���� ����������
     IF COALESCE (vbParPartnerValue, 0) = 0
     THEN
         RAISE EXCEPTION '������.�������� <�������> ������ ���� �����������.';
     END IF;


     -- ���������
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), MovementItem.Id, CAST (MIFloat_Price.ValueData / vbCurrencyPartnerValue * vbParPartnerValue AS NUMERIC (16, 3)))
     FROM MovementItem
          LEFT JOIN MovementItemFloat AS MIFloat_Price
                                      ON MIFloat_Price.MovementItemId = MovementItem.Id
                                     AND MIFloat_Price.DescId = zc_MIFloat_Price()
     WHERE MovementId = inMovementId;

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (MovementItem.Id, vbUserId, FALSE)
     FROM MovementItem
     WHERE MovementId = inMovementId;

     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), inMovementId, vbCurrencyPartnerId);
     -- ��������� �������� <���� ��� �������� �� ���. ���. � ������ �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyPartnerValue(), inMovementId, 0);
     -- ��������� �������� <������� ��� �������� �� ���. ���. � ������ �����������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParPartnerValue(), inMovementId, 0);

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 02.12.14                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_Price_Currency (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inAmountPartner:= 0, inAmountPacker:= 0, inPrice:= 1, inCountForPrice:= 1, inLiveWeight:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inAssetId:= 0, inSession:= '2')
