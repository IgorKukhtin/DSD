-- Function: gpUpdate_Movement_Sale_Currency()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Sale_Currency (Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Sale_Currency(
    IN inId                  Integer   , -- ���� ������� <��������>
    IN inCurrencyDocumentId  Integer   , -- ������ (���������)
    IN inCurrencyPartnerId   Integer   , -- ������ (�����������)
 INOUT ioCurrencyValue       TFloat    , -- ���� ������
IF vbUserId = 9457 INOUT ioParValue            TFloat    , -- ������� 
    IN inisCurrencyUser      Boolean   ,
    IN inSession             TVarChar     -- ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbIsInsert           Boolean;
   DECLARE vbCurrencyDocumentId Integer;
   DECLARE vbCurrencyPartnerId  Integer;
   DECLARE vbPaidKindId         Integer;
   DECLARE vbUserId             Integer;
   DECLARE vbOperDatePartner    TDateTime; 
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale_Currency());


     -- ��������
     IF COALESCE (inId,0) = 0
     THEN
         RAISE EXCEPTION '������.�������� �� ��������';
     END IF;
     -- ��������
     IF inCurrencyDocumentId <> zc_Enum_Currency_Basis() AND inCurrencyDocumentId <> inCurrencyPartnerId
     THEN
         RAISE EXCEPTION '������.�������� �������� <������ (����)> ��� <������ (����������)>';
     END IF;


     -- ����������� ������ ���������
     vbCurrencyDocumentId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inId AND MLO.DescId = zc_MovementLinkObject_CurrencyDocument()), zc_Enum_Currency_Basis());
     -- ����������� ������ (�����������)
     vbCurrencyPartnerId := COALESCE ((SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inId AND MLO.DescId = zc_MovementLinkObject_CurrencyPartner()), zc_Enum_Currency_Basis());    

     -- ����� ������
     vbPaidKindId := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.MovementId = inId AND MLO.DescId = zc_MovementLinkObject_PaidKind());    
     -- ���� ����������
     vbOperDatePartner := (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inId AND MD.DescId = zc_MovementDate_OperDatePartner());    

     IF COALESCE (inisCurrencyUser,FALSE) = FALSE
     THEN

         -- ������� ����� ��� �������
         IF inCurrencyDocumentId <> zc_Enum_Currency_Basis()
         THEN SELECT Amount, ParValue 
            INTO ioCurrencyValue, ioParValue
              FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyDocumentId, inPaidKindId:= vbPaidKindId);
         ELSE IF inCurrencyPartnerId <> zc_Enum_Currency_Basis()
              THEN SELECT Amount, ParValue
            INTO ioCurrencyValue, ioParValue
                   FROM lfSelect_Movement_Currency_byDate (inOperDate:= vbOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= vbCurrencyPartnerId, inPaidKindId:= vbPaidKindId);
              ELSE ioCurrencyValue:= 0;
                   ioParValue:=0;
              END IF;
         END IF;

     END IF; 

     -- ��������� ����� � <������ (���������)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyDocument(), inId, inCurrencyDocumentId);
     -- ��������� ����� � <������ (�����������) >
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_CurrencyPartner(), inId, inCurrencyPartnerId);
          
     -- ��������� �������� <���� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_CurrencyValue(), inId, ioCurrencyValue);
     -- ��������� �������� <������� ��� �������� � ������ �������>
     PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ParValue(), inId, ioParValue); 
     
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_CurrencyUser(), inId, inisCurrencyUser); 

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inId);

     -- ��������� ��������
     PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);


 if vbUserId = 9457
 then
    RAISE EXCEPTION 'ok.Test %,   %,   %,   %',  lfGet_Object_ValueData (inCurrencyDocumentId), lfGet_Object_ValueData (inCurrencyPartnerId), ioCurrencyValue, ioParValue;
 end if;
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.07.24         *
*/

-- ����
--