-- Function: gpInsertUpdate_Movement_SaleAsset()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SaleAsset (Integer, TVarChar, TDateTime,TDateTime, Boolean
                                                         , Integer, Integer, Integer, Integer, Integer, Integer
                                                         , TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);


gpInsertUpdate_Movement_SaleAsset
(ioId := 0 , inInvNumber := '4' , inOperDate := ('19.06.2020')::TDateTime , inOperDatePartner := ('19.06.2020')::TDateTime
 , inPriceWithVAT := 'False' , inFromId := 8395 , inToId := 8395 , inContractId := 0 , inCurrencyDocumentId := 14461 , inCurrencyPartnerId := 0 , inVATPercent := 20 , ioCurrencyValue := 1 , inCurrencyPartnerValue := 1 , inParPartnerValue := 1 , inComment := '' ,  inSession := '5');



CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SaleAsset(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
    IN inInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inOperDatePartner      TDateTime , -- ���� ��������� � �����������
    IN inPriceWithVAT         Boolean   , -- ���� � ��� (��/���)

    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inContractId           Integer   , -- ��������
    IN inPaidKindId           Integer   , -- ���� ���� ������ 

    IN inCurrencyDocumentId   Integer   , -- ������ (���������)
    IN inCurrencyPartnerId    Integer   , -- ������ (�����������)
    IN inVATPercent           TFloat    , -- % ���
 INOUT ioCurrencyValue        TFloat    , -- ���� ������
 INOUT ioParValue             TFloat    , -- �������
    IN inCurrencyPartnerValue TFloat    , -- ���� ������
    IN inParPartnerValue      TFloat    , -- �������
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_SaleAsset());
                                              
     -- ��������� <��������>
     SELECT tmp.ioId, tmp.ioCurrencyValue, tmp.ioParValue
            INTO ioId, ioCurrencyValue, ioParValue
     FROM lpInsertUpdate_Movement_SaleAsset (ioId                := ioId
                                           , inInvNumber            := inInvNumber
                                           , inOperDate             := inOperDate
                                           , inOperDatePartner      := inOperDatePartner
                                           , inPriceWithVAT         := inPriceWithVAT
                                           , inFromId               := inFromId
                                           , inToId                 := inToId
                                           , inContractId           := inContractId
                                           , inPaidKindId           := inPaidKindId
                                           , inCurrencyDocumentId   := inCurrencyDocumentId
                                           , inCurrencyPartnerId    := inCurrencyPartnerId
                                           , inVATPercent           := inVATPercent
                                           , ioCurrencyValue        := ioCurrencyValue
                                           , ioParValue             := ioParValue
                                           , inCurrencyPartnerValue := inCurrencyPartnerValue
                                           , inParPartnerValue      := inParPartnerValue
                                           , inComment              := inComment
                                           , inUserId               := vbUserId
                                           ) AS tmp;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 19.06.20         *
*/

-- ����
-- ������� gpinsertupdate_movement_saleasset(integer, tvarchar, tdatetime, tdatetime, boolean, integer, integer, integer, integer, integer, tfloat, tfloat, tfloat, tfloat, tvarchar, tvarchar) �� ����������
LINE 1: select * from gpInsertUpdate_Movement_SaleAsset($1::integer,...
                      ^
HINT:  ������� � ������� ������ � ������ ���������� �� �������. ��������, ��� ������� �������� ����� ���������� �����.
 context: select * from 