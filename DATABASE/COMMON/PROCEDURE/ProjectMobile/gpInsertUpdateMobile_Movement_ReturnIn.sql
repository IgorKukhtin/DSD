-- Function: gpInsertUpdateMobile_Movement_ReturnIn()

--DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TVarChar, TDateTime, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TDateTime, Integer, Boolean, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TDateTime, Integer, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdateMobile_Movement_ReturnIn (TVarChar, TVarChar, TDateTime, Integer, Boolean, TDateTime, TFloat, TFloat, Integer, Integer, Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdateMobile_Movement_ReturnIn (
    IN inGUID             TVarChar  , -- ���������� ���������� ������������� ��� ������������� � ������� ��
    IN inInvNumber        TVarChar  , -- ����� ���������
    IN inOperDate         TDateTime , -- ���� ���������
    IN inStatusId         Integer   , -- ���� ��������
    IN inPriceWithVAT     Boolean   , -- ���� � ��� (��/���)
    IN inInsertDate       TDateTime , -- ����/����� �������� ���������
    IN inVATPercent       TFloat    , -- % ���
    IN inChangePercent    TFloat    , -- (-)% ������ (+)% �������
    IN inPaidKindId       Integer   , -- ��� ����� ������
    IN inPartnerId        Integer   , -- ����������
    IN inUnitId           Integer   , -- �������������
    IN inContractId       Integer   , -- �������
    IN inComment          TVarChar  , -- ����������
    IN inSubjectDocId     Integer   , -- ��������� ��� �����������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbUserId Integer;
   DECLARE vbInvNumberPartner TVarChar;
   DECLARE vbInvNumberMark TVarChar;
   DECLARE vbChecked Boolean;
   DECLARE vbisPartner Boolean;
   DECLARE vbisList Boolean;
   DECLARE vbCurrencyId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbStatusId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
      vbUserId:= lpGetUserBySession (inSession);

      -- testm
      IF vbUserId = 1123966 -- testm
      THEN
          RAISE EXCEPTION '������.��� ����.';
      END IF;

      -- ������� �.�. + ����� �.�. + ����� �.�. + �������� �.�.
      IF vbUserId IN (5416822, 5416811, 5416834, 5416838)
         AND COALESCE (inVATPercent, 0) = 0
      THEN
           -- RAISE EXCEPTION '������. % ��� = 0', '%';
           inVATPercent:= 20;
      END IF;


      -- �������� �.�.
      /*IF vbUserId IN (5416838)
      THEN
          -- inVATPercent:= 20;
          RAISE EXCEPTION '������. % ��� = %', '% ';
      END IF;*/

      -- �������� Id ��������� �� GUID
      SELECT MovementString_GUID.MovementId 
           , COALESCE (MovementString_InvNumberPartner.ValueData, '')::TVarChar AS InvNumberPartner
           , COALESCE (MovementString_InvNumberMark.ValueData, '')::TVarChar    AS InvNumberMark
           , COALESCE (MovementBoolean_Checked.ValueData, false)::Boolean       AS Checked
           , COALESCE (MovementBoolean_isPartner.ValueData, false)::Boolean     AS isPartner
           , COALESCE (MovementBoolean_List.ValueData, false)::Boolean          AS isList
           , Movement_ReturnIn.StatusId
      INTO vbId
         , vbInvNumberPartner
         , vbInvNumberMark   
         , vbChecked         
         , vbisPartner       
         , vbisList   
         , vbStatusId        
      FROM MovementString AS MovementString_GUID
           JOIN Movement AS Movement_ReturnIn
                         ON Movement_ReturnIn.Id = MovementString_GUID.MovementId
                        AND Movement_ReturnIn.DescId = zc_Movement_ReturnIn()
           LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                    ON MovementString_InvNumberPartner.MovementId = Movement_ReturnIn.Id
                                   AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
           LEFT JOIN MovementString AS MovementString_InvNumberMark
                                    ON MovementString_InvNumberMark.MovementId = Movement_ReturnIn.Id
                                   AND MovementString_InvNumberMark.DescId = zc_MovementString_InvNumberMark()
           LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                     ON MovementBoolean_Checked.MovementId = Movement_ReturnIn.Id
                                    AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
           LEFT JOIN MovementBoolean AS MovementBoolean_isPartner
                                     ON MovementBoolean_isPartner.MovementId = Movement_ReturnIn.Id
                                    AND MovementBoolean_isPartner.DescId = zc_MovementBoolean_isPartner()
           LEFT JOIN MovementBoolean AS MovementBoolean_List
                                     ON MovementBoolean_List.MovementId = Movement_ReturnIn.Id
                                    AND MovementBoolean_List.DescId = zc_MovementBoolean_List()
      WHERE MovementString_GUID.DescId = zc_MovementString_GUID() 
        AND MovementString_GUID.ValueData = inGUID;

      vbIsInsert:= (COALESCE (vbId, 0) = 0);

      vbInvNumberPartner := COALESCE (vbInvNumberPartner, '')::TVarChar;
      vbInvNumberMark    := COALESCE (vbInvNumberMark, '')::TVarChar;
      vbChecked          := COALESCE (vbChecked, false)::Boolean;
      vbisPartner        := COALESCE (vbisPartner, false)::Boolean;
      vbisList           := COALESCE (vbisList, false)::Boolean;

      IF vbIsInsert = TRUE
      THEN
           PERFORM lpInsert_LockUnique (inKeyData:= inGUID, inUserId:= vbUserId);
      END IF;
                                                                                       
      SELECT ObjectLink_Contract_Currency.ChildObjectId
             INTO vbCurrencyId
      FROM ObjectLink AS ObjectLink_Contract_Currency
      WHERE ObjectLink_Contract_Currency.ObjectId = inContractId
        AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency();

      vbCurrencyId:= COALESCE (vbCurrencyId, zc_Enum_Currency_Basis());
   


      -- !!! �������� - 04.07.17 !!!
      IF vbStatusId = zc_Enum_Status_Complete()
      THEN
           -- !!! �������� !!!
           RETURN vbId;
      END IF;
      -- !!! �������� - 04.07.17 !!!




      IF (vbIsInsert = true) OR (vbStatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased()))
      THEN 
           IF vbStatusId = zc_Enum_Status_Erased()
           THEN -- ����������� ��������
                PERFORM lpUnComplete_Movement (inMovementId:= vbId, inUserId:= vbUserId);
           END IF;

           -- ��������� �������
           vbId:= lpInsertUpdate_Movement_ReturnIn (ioId                 := vbId               -- ���� ������� <�������� ������� ����������>
                                                  , inInvNumber          := (zfConvert_StringToNumber (inInvNumber) + lfGet_User_BillNumberMobile (vbUserId)) :: TVarChar
                                                  , inInvNumberPartner   := vbInvNumberPartner -- ����� ��������� � �����������
                                                  , inInvNumberMark      := vbInvNumberMark    -- ����� "������������ ������ ����� �i ������"
                                                  , inParentId           := NULL
                                                  , inOperDate           := inOperDate         -- ����(�����)
                                                  , inOperDatePartner    := inOperDate         -- ���� ��������� � ����������
                                                  , inChecked            := vbChecked          -- ��������
                                                  , inIsPartner          := vbisPartner        -- ��������� - ��� ��������
                                                  , inPriceWithVAT       := inPriceWithVAT     -- ���� � ��� (��/���)
                                                  , inisList             := vbisList           -- ������ ��� ������
                                                  , inVATPercent         := inVATPercent       -- % ���
                                                  , inChangePercent      := inChangePercent    -- (-)% ������ (+)% �������
                                                  , inFromId             := inPartnerId        -- �� ���� (� ���������)
                                                  , inToId               := inUnitId           -- ���� (� ���������)
                                                  , inPaidKindId         := inPaidKindId       -- ���� ���� ������
                                                  , inContractId         := inContractId       -- ��������
                                                  , inCurrencyDocumentId := vbCurrencyId       -- ������ (���������)
                                                  , inCurrencyPartnerId  := vbCurrencyId       -- ������ (�����������)
                                                  , inCurrencyValue      := NULL               -- ���� ������
                                                  , inParValue           := NULL
                                                  , inCurrencyPartnerValue:= NULL
                                                  , inParPartnerValue     := NULL
                                                  , inMovementId_OrderReturnTare:= NULL
                                                  , inComment            := inComment          -- ����������
                                                  , inUserId             := vbUserId           -- ������������
                                                   );

           -- ��������� �������� <���������� ���������� �������������>                       
           PERFORM lpInsertUpdate_MovementString (zc_MovementString_GUID(), vbId, inGUID);   
                                                                                             
           -- ��������� �������� <����/����� �������� �� ��������� ����������>
           PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_InsertMobile(), vbId, inInsertDate);

           -- ��������� �������� <>
           PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SubjectDoc(), vbId, inSubjectDocId);

           /*IF vbIsInsert 
           THEN
                -- ��������� ����� � <������������>
                PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_Insert(), vbId, vbUserId);
           END IF;
           -- ��������� �������� <���� ��������> - ��� �������� � ��� ����., ����� ���� ��������
           PERFORM lpInsertUpdate_MovementDate(zc_MovementDate_Insert(), vbId, CURRENT_TIMESTAMP);
           */

           -- ��������� ��������
           PERFORM lpInsert_MovementProtocol (vbId, vbUserId, FALSE);
      END IF;

      RETURN vbId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.   ������ �.�.
 22.11.23                                                                       *
 21.03.17                                                        *
*/

-- ����
/* SELECT * FROM gpInsertUpdateMobile_Movement_ReturnIn (inGUID          := '{D2399D25-513D-4F68-A1ED-FCD21C63A0B7}'
                                                    , inInvNumber     := '-10'
                                                    , inOperDate      := CURRENT_DATE
                                                    , inStatusId      := zc_Enum_Status_UnComplete()  -- ���� ��������
                                                    , inPriceWithVAT  := false                        -- ���� � ��� (��/���)
                                                    , inInsertDate    := CURRENT_TIMESTAMP            -- ����/����� �������� ���������
                                                    , inVATPercent    := 20.0                         -- % ���
                                                    , inChangePercent := -5.0                         -- (-)% ������ (+)% �������
                                                    , inPaidKindId    := zc_Enum_PaidKind_FirstForm() -- ��� ����� ������
                                                    , inPartnerId     := 889758                       -- ����������
                                                    , inUnitId        := 8461                         -- �������������
                                                    , inContractId    := 889761                       -- �������
                                                    , inComment       := 'Test'                       -- ����������
                                                    , inSession       := zfCalc_UserAdmin()
                                                     );

*/

/* SELECT * FROM gpInsertUpdateMobile_Movement_ReturnIn (inGUID          := '{4CEA41E8-6EFA-4BA3-A8E7-F500A5803C61}'
                                                    , inInvNumber     := '-11'
                                                    , inOperDate      := CURRENT_DATE
                                                    , inStatusId      := zc_Enum_Status_UnComplete()  -- ���� ��������
                                                    , inPriceWithVAT  := false                        -- ���� � ��� (��/���)
                                                    , inInsertDate    := CURRENT_TIMESTAMP            -- ����/����� �������� ���������
                                                    , inVATPercent    := 20.0                         -- % ���
                                                    , inChangePercent := -15.0                        -- (-)% ������ (+)% �������
                                                    , inPaidKindId    := zc_Enum_PaidKind_FirstForm() -- ��� ����� ������
                                                    , inPartnerId     := 889758                       -- ����������
                                                    , inUnitId        := 8461                         -- �������������
                                                    , inContractId    := 889761                       -- �������
                                                    , inComment       := 'Test 2'                     -- ����������
                                                    , inSession       := zfCalc_UserAdmin()
                                                     );

*/