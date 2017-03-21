-- Function: gpInsertUpdateMobile_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_ReturnIn (
    IN inGUID          TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ������� ��
    IN inInvNumber     TVarChar  , -- ����� ���������
    IN inOperDate      TDateTime , -- ���� ���������
    IN inStatusId      Integer   , -- ���� ��������
    IN inChecked       Boolean   , -- ��������
    IN inPriceWithVAT  Boolean   , -- ���� � ��� (��/���)
    IN inInsertDate    TDateTime , -- ����/����� �������� ���������
    IN inVATPercent    TFloat    , -- % ���
    IN inChangePercent TFloat    , -- (-)% ������ (+)% �������
    IN inPaidKindId    Integer   , -- ��� ����� ������
    IN inPartnerId     Integer   , -- ����������
    IN inContractId    Integer   , -- �������
    IN inComment       TVarChar  , -- ����������
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbCurrencyId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      SELECT UnitId INTO vbUnitId FROM gpGetMobile_Object_Const (inSession);

      -- �������� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId 
      INTO vbId 
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_StoreReal
                         ON Movement_StoreReal.Id = MovementString_GUID.MovementId
                        AND Movement_StoreReal.DescId = zc_Movement_ReturnIn()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      SELECT ObjectLink_Contract_Currency.ChildObjectId
      INTO vbCurrencyId
      FROM ObjectLink AS ObjectLink_Contract_Currency
      WHERE ObjectLink_Contract_Currency.ObjectId = inContractId
        AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency();

      vbCurrencyId:= COALESCE (vbCurrencyId, zc_Enum_Currency_Basis());

      vbId:= lpInsertUpdate_Movement_ReturnIn (ioId                 := vbId            -- ���� ������� <�������� ������� ����������>
                                             , inInvNumber          := inInvNumber     -- ����� ���������
                                             , inInvNumberPartner   := inInvNumber     -- ����� ��������� � �����������
                                             , inInvNumberMark      := ''              -- ����� "������������ ������ ����� �i ������"
                                             , inParentId           := NULL
                                             , inOperDate           := inOperDate      -- ����(�����)
                                             , inOperDatePartner    := inOperDate      -- ���� ��������� � ����������
                                             , inChecked            := inChecked       -- ��������
                                             , inIsPartner          := false           -- ��������� - ��� ��������
                                             , inPriceWithVAT       := inPriceWithVAT  -- ���� � ��� (��/���)
                                             , inisList             := false           -- ������ ��� ������
                                             , inVATPercent         := inVATPercent    -- % ���
                                             , inChangePercent      := inChangePercent -- (-)% ������ (+)% �������
                                             , inFromId             := inPartnerId     -- �� ���� (� ���������)
                                             , inToId               := vbUnitId        -- ���� (� ���������)
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
                                                                                        
      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 16.02.17                                                        *                                          
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_Movement_ReturnIn (inGUID          := '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}'
                                                    , inInvNumber     := '-10'
                                                    , inOperDate      := CURRENT_DATE
                                                    , inStatusId      := zc_Enum_Status_UnComplete()  -- ���� ��������
                                                    , inChecked       := false                        -- ��������
                                                    , inPriceWithVAT  := true                         -- ���� � ��� (��/���)
                                                    , inInsertDate    := CURRENT_TIMESTAMP            -- ����/����� �������� ���������
                                                    , inVATPercent    := 20.0                         -- % ���
                                                    , inChangePercent := -5.0                         -- (-)% ������ (+)% �������
                                                    , inPaidKindId    := zc_Enum_PaidKind_FirstForm() -- ��� ����� ������
                                                    , inPartnerId     := 0                            -- ����������
                                                    , inContractId    := 0                            -- �������
                                                    , inComment       := 'Test'                       -- ����������
                                                    , inSession       := zfCalc_UserAdmin()
                                                     );

*/
