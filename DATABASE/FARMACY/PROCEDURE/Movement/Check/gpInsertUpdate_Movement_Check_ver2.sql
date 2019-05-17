-- Function: gpInsertUpdate_Movement_Check_ver2()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_ver2(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ���>
    IN inDate                TDateTime , -- ����/����� ���������
    IN inCashRegister        TVarChar  , -- �������� ��������� ��������
    IN inPaidType            Integer   , -- ��� ������
    IN inManagerId           Integer   , -- ��������
    IN inBayer               TVarChar  , -- ���������� ���
    IN inFiscalCheckNumber   TVarChar  , -- ����� ����������� ����
    IN inNotMCS              Boolean   , -- �� ��������� � ������� ���
    IN inDiscountExternalId  Integer   , -- ������ ���������� ����
    IN inDiscountCardNumber  TVarChar  , -- � ���������� �����
    IN inBayerPhone          TVarChar  , -- ***���������� ������� (����������)
    IN inConfirmedKindName   TVarChar  , -- ***������ ������ (��������� VIP-����)
    IN inInvNumberOrder      TVarChar  , -- ***����� ������ (� �����)
    IN inPartnerMedicalId    Integer   , -- ����������� ����������(���. ������)
    IN inAmbulance           TVarChar  , --
    IN inMedicSP             TVarChar  , -- ��� ����� (���. ������)
    IN inInvNumberSP         TVarChar  , -- ����� ������� (���. ������)
    IN inOperDateSP          TDateTime , -- ���� ������� (���. ������)
    IN inSPKindId            Integer   , -- ��� ��
    IN inPromoCodeId         Integer   , -- Id ���������
    IN inManualDiscount      Integer   , -- ������ ������
    IN inTotalSummPayAdd     TFloat    , -- ������� �� ����
    IN inMemberSPID          Integer   , -- ��� ��������
    IN inSiteDiscount        Boolean   , -- ������ ����� ����
    IN inBankPOSTerminalId   Integer   , -- ���� POS ���������
    IN inJackdawsChecksCode  Integer   , -- ��� �����
    IN inRoundingDown        Boolean   , -- ���������� � ���
    IN inPartionDateKindID   Integer   , -- ��� ����/�� ����
    IN inConfirmationCodeSP  TVarChar  , -- ��� ������������� ������� (���. ������)
    IN inUserSession	     TVarChar  , -- ������ ������������ ��� ������� ������ ��� � ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbInvNumber Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbPaidTypeId Integer;
   DECLARE vbJackdawsChecksId Integer;
BEGIN
    -- !!!��������!!!
    IF COALESCE (inUserSession, '') <> '' AND inUserSession <> '5'
    THEN
        inSession := inUserSession;
    END IF;

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);

    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
        vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;

    IF COALESCE(vbUnitId, 0) = 0 THEN
        RAISE EXCEPTION '��� ������������ �� ����������� �������� ��������� �������������';
    END IF;

    IF inDate is null
    THEN
        inDate := CURRENT_TIMESTAMP::TDateTime;
    END IF;

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    IF COALESCE(ioId,0) = 0
    THEN
        SELECT
            COALESCE(MAX(zfConvert_StringToNumber(InvNumber)), 0) + 1
        INTO
            vbInvNumber
        FROM
            Movement_Check_View
        WHERE
            Movement_Check_View.UnitId = vbUnitId
            AND
            Movement_Check_View.OperDate > CURRENT_DATE;
    ELSE
        SELECT
            InvNumber
        INTO
            vbInvNumber
        FROM
            Movement_Check_View
        WHERE
            Movement_Check_View.Id = ioId;
    END IF;


    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Check(), vbInvNumber::TVarChar, inDate, NULL);

    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, vbUnitId);

    -- ��������� ����� � �������� ���������
    IF COALESCE(inCashRegister,'') <> ''
    THEN
        vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister,
                                                                inSession := inSession);
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(),ioId,vbCashRegisterId);
    END IF;

    -- ��������� ������� <�� ��������� � ������� ���>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_NotMCS(), ioId, inNotMCS);

    -- ��������� ����� ���� � �������� ��������
    PERFORM lpInsertUpdate_MovementString(zc_MovementString_FiscalCheckNumber(),ioId,inFiscalCheckNumber);

    -- ��������� ����� � <��� ������>
    IF inPaidType <> -1
    THEN
        if inPaidType = 0
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(),ioId,zc_Enum_PaidType_Cash());
        ELSEIF inPaidType = 1
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(),ioId,zc_Enum_PaidType_Card());
        ELSEIF inPaidType = 2
        THEN
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidType(),ioId,zc_Enum_PaidType_CardAdd());
        ELSE
            RAISE EXCEPTION '������.�� ��������� ��� ������';
        END IF;
    END IF;

    -- ��������� ����� � ���������� � ����������� + <������ ������ (��������� VIP-����)>
    IF COALESCE (inManagerId,0) <> 0
    THEN
        -- ��������� ���������
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), ioId, inManagerId);
        -- ��������� ��� ����������
        PERFORM lpInsertUpdate_MovementString(zc_MovementString_Bayer(), ioId, inBayer);
        -- �������� �������� ��� ����������
        PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), ioId, TRUE);
        -- !!! ������ 1 ���!!! ���������
        IF vbIsInsert = TRUE
        THEN
            -- ��������� ����� � <������ ������ (��������� VIP-����)>
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), ioId, zc_Enum_ConfirmedKind_Complete());
        END IF;

    END IF;

    -- ��������� ����� � <���������� �����> + ����� �� � ������������ <���������� �����>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DiscountCard(), ioId, CASE WHEN inDiscountExternalId > 0 THEN lpInsertFind_Object_DiscountCard (inObjectId:= inDiscountExternalId, inValue:= inDiscountCardNumber, inUserId:= vbUserId) ELSE 0 END);

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartnerMedical(), ioId, inPartnerMedicalId);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Ambulance(), ioId, inAmbulance);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_MedicSP(), ioId, inMedicSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberSP(), ioId, inInvNumberSP);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RoundingTo10(), ioId, True);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_RoundingDown(), ioId, inRoundingDown);
    -- ��������� <>
    IF inInvNumberSP <> ''
    THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSP(), ioId, inOperDateSP);

       -- ��������� ����� � <��� ���.�������>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SPKind(), ioId, inSPKindId);
    END IF;
	-- ��������� Id ���������
	IF InPromoCodeId <> 0 THEN
	   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MovementItemId(), ioId, inPromoCodeId);
	END IF;
    -- ��������� ������ ������
    IF inManualDiscount <> 0 OR EXISTS(SELECT 1 FROM MovementFloat WHERE DescId = zc_MovementFloat_ManualDiscount() AND MovementId = ioId) THEN
	   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ManualDiscount(), ioId, inManualDiscount);
	END IF;
    -- ��������� ������� �� ����
    IF inTotalSummPayAdd <> 0 OR EXISTS(SELECT 1 FROM MovementFloat WHERE DescId = zc_MovementFloat_TotalSummPayAdd() AND MovementId = ioId) THEN
	   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSummPayAdd(), ioId, inTotalSummPayAdd);
	END IF;

    -- ��������� ����� � <>
    IF inMemberSPID <> 0 OR EXISTS(SELECT 1 FROM MovementLinkObject WHERE DescId = zc_MovementLinkObject_MemberSP() AND MovementId = ioId) THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberSP(), ioId, inMemberSPID);
	END IF;

    IF COALESCE(inSiteDiscount, False) = True OR EXISTS(SELECT 1 FROM MovementBoolean WHERE DescId = zc_MovementBoolean_Site() AND MovementId = ioId) THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Site(), ioId, inSiteDiscount);
	END IF;
    
    IF COALESCE (inBankPOSTerminalId, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BankPOSTerminal(), ioId, inBankPOSTerminalId);    
    END IF;
    
    IF COALESCE (inPartionDateKindID, 0) <> 0
    THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PartionDateKind(), ioId, inPartionDateKindID);    
    END IF;
    
    IF COALESCE (inConfirmationCodeSP, '') <> ''
    THEN
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_ConfirmationCodeSP(), ioId, inConfirmationCodeSP);
    END IF;


    IF COALESCE (inJackdawsChecksCode, 0) <> 0
    THEN
      SELECT Object.ID
      INTO vbJackdawsChecksId
      FROM Object
      WHERE Object.DescId = zc_Object_JackdawsChecks()
        AND Object.ObjectCode = inJackdawsChecksCode;
    
      IF COALESCE (vbJackdawsChecksId, 0) <> 0
      THEN
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_JackdawsChecks(), ioId, vbJackdawsChecksId);    
      END IF;        
    END IF;

    IF vbIsInsert = TRUE
      THEN
          -- ��������� �������� <���� ��������>
          PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
          -- ��������� �������� <������������ (��������)>
          PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);


    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%>', inUserSession, inSession;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������������ �.�.   ������ �.�.
 15.05.19                                                                                                         * add inPartionDateKindID, inConfirmationCodeSP
 28.11.18                                                                                                         * add SiteDiscount
 02.11.18                                                                                                         * add TotalSummPayAdd
 29.06.18                                                                                                         * add ManualDiscount
 05.02.18                                                                                         * add PromoCode
 23.05.17         * add zc_Enum_SPKind_SP
 06.10.16         * add ���������� ��-� ����/�����. ��������
 20.07.16                                        *
 03.11.15                                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Check_ver2 (ioId := 0, inUnitId := 183293, inDate := NULL::TDateTime, inBayer := 'Test Bayer'::TVarChar, inSession:= zfCalc_UserAdmin());