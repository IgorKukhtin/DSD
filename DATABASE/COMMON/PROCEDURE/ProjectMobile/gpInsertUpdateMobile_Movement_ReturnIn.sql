-- Function: gpInsertUpdateMobile_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_ReturnIn (
    IN inGUID             TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ������� ��
    IN inInvNumber        TVarChar  , -- ����� ���������
    IN inInvNumberPartner TVarChar  , -- ����� ��������� � �����������
    IN inOperDate         TDateTime , -- ���� ���������
    IN inOperDatePartner  TDateTime , -- ���� ��������� � �����������
    IN inStatusId         Integer   , -- ���� ��������
    IN inChecked          Boolean   , -- ��������
    IN inPriceWithVAT     Boolean   , -- ���� � ��� (��/���)
    IN inInsertDate       TDateTime , -- ����/����� �������� ���������
    IN inVATPercent       TFloat    , -- % ���
    IN inChangePercent    TFloat    , -- (-)% ������ (+)% �������
    IN inPaidKindId       Integer   , -- ��� ����� ������
    IN inPartnerId        Integer   , -- ����������
    IN inUnitId           Integer   , -- �������������
    IN inContractId       Integer   , -- �������
    IN inComment          TVarChar  , -- ����������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbCurrencyId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- �������� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId 
      INTO vbId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_StoreReal
                         ON Movement_StoreReal.Id = MovementString_GUID.MovementId
                        AND Movement_StoreReal.DescId = zc_Movement_ReturnIn()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbIsInsert:= (COALESCE (vbId, 0) = 0);

      SELECT ObjectLink_Contract_Currency.ChildObjectId
      INTO vbCurrencyId
      FROM ObjectLink AS ObjectLink_Contract_Currency
      WHERE ObjectLink_Contract_Currency.ObjectId = inContractId
        AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency();

      vbCurrencyId:= COALESCE (vbCurrencyId, zc_Enum_Currency_Basis());

      vbId:= lpInsertUpdate_Movement_ReturnIn (ioId                 := vbId            -- ���� ������� <�������� ������� ����������>
                                             , inInvNumber          := inInvNumber     -- ����� ���������
                                             , inInvNumberPartner   := inInvNumberPartner -- ����� ��������� � �����������
                                             , inInvNumberMark      := ''              -- ����� "������������ ������ ����� �i ������"
                                             , inParentId           := NULL
                                             , inOperDate           := inOperDate      -- ����(�����)
                                             , inOperDatePartner    := inOperDatePartner -- ���� ��������� � ����������
                                             , inChecked            := inChecked       -- ��������
                                             , inIsPartner          := false           -- ��������� - ��� ��������
                                             , inPriceWithVAT       := inPriceWithVAT  -- ���� � ��� (��/���)
                                             , inisList             := false           -- ������ ��� ������
                                             , inVATPercent         := inVATPercent    -- % ���
                                             , inChangePercent      := inChangePercent -- (-)% ������ (+)% �������
                                             , inFromId             := inPartnerId     -- �� ���� (� ���������)
                                             , inToId               := inUnitId        -- ���� (� ���������)
                                             , inPaidKindId         := inPaidKindId    -- ���� ���� ������
                                             , inContractId         := inContractId    -- ��������
                                             , inCurrencyDocumentId := vbCurrencyId    -- ������ (���������)
                                             , inCurrencyPartnerId  := vbCurrencyId    -- ������ (�����������)
                                             , inCurrencyValue      := 1.0             -- ���� ������
                                             , inComment            := inComment       -- ����������
                                             , inUserId             := vbUserId        -- ������������
                                              );

      -- ��������� �������� <���������� ���������� �������������>                       
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);   
                                                                                        
      -- ��������� �������� <����/����� �������� �� ��������� ����������>
      PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

      IF vbIsInsert 
      THEN
           -- ��������� ����� � <������������>
           PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), vbId, vbUserId);
           -- ��������� �������� <���� ��������>
           PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), vbId, CURRENT_TIMESTAMP);
      END IF;

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 21.03.17                                                        *
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_Movement_ReturnIn (inGUID          := '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}'
                                                    , inInvNumber        := '-10'
                                                    , inInvNumberPartner := '34523'                   -- ����� ��������� � �����������
                                                    , inOperDate         := CURRENT_DATE
                                                    , inOperDatePartner  := CURRENT_DATE - 1          -- ���� ��������� � ����������
                                                    , inStatusId      := zc_Enum_Status_UnComplete()  -- ���� ��������
                                                    , inChecked       := false                        -- ��������
                                                    , inPriceWithVAT  := false                        -- ���� � ��� (��/���)
                                                    , inInsertDate    := CURRENT_TIMESTAMP            -- ����/����� �������� ���������
                                                    , inVATPercent    := 20.0                         -- % ���
                                                    , inChangePercent := -5.0                         -- (-)% ������ (+)% �������
                                                    , inPaidKindId    := zc_Enum_PaidKind_FirstForm() -- ��� ����� ������
                                                    , inPartnerId     := 0                            -- ����������
                                                    , inUnitId        := 0                            -- �������������
                                                    , inContractId    := 0                            -- �������
                                                    , inComment       := 'Test'                       -- ����������
                                                    , inSession       := zfCalc_UserAdmin()
                                                     );

*/
