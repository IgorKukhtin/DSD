-- Function: gpInsertUpdate_Movement_Check_ver2()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Integer, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Integer, Boolean, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Boolean, Integer, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Boolean, Integer, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TVarChar, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Boolean, Integer, Boolean, Boolean, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TVarChar, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, Integer, Boolean, Integer, Integer, Boolean, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Integer, Integer, Boolean, Integer, Boolean, Boolean, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_ver2(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ���>
    IN inUID                 TVarChar  , -- UID �������� ����
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
    IN inLoyaltySignID       Integer   , -- ����������� ��������� "��������� ����������"    
    IN inLoyaltySMID         Integer   , -- ��������� ���������� �������������
    IN inLoyaltySMDiscount   TFloat    , -- ����� ������ �� ��������� ���������� �������������
    IN inMedicForSale        TVarChar  , -- ��� ����� (�� �������)
    IN inBuyerForSale        TVarChar  , -- ��� ���������� (�� �������)
    IN inBuyerForSalePhone   TVarChar  , -- ������� ���������� (�� �������)    
    IN inDistributionPromoList TVarChar  , -- ������� ��������� ����������.
    IN inMedicKashtanID      Integer   , -- ��� ����� (��� �������) 
    IN inMemberKashtanID     Integer   , -- ��� �������� (��� �������)
    IN inisCorrectMarketing  Boolean   , -- ������������� ����� ���������� � �� �� �������������
    IN inisCorrectIlliquidMarketing  Boolean   , -- ������������� ����� ���������� � �� �� �������������
    IN inisDoctors           Boolean   , -- �����
    IN inisDiscountCommit    Boolean   , -- ������� �������� �� �����
    IN inZReport             Integer   , -- ����� Z ������
    IN inMedicalProgramSPID  Integer   , -- ����������� ��������� ���. ��������
    IN inisManual            Boolean   , -- ������ ����� �����������    
    IN inCategory1303Id      Integer   , -- ������ ��������� �� ������������� ��� 1303
    IN inisErrorRRO          Boolean   , -- ��� ��� �� ������ ���
    IN inisPaperRecipeSP     Boolean   , -- �������� ������ �� ��
    IN inUserKeyId           Integer   , -- ��� �������� ���� ������������� ��� �������� ����.
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
   DECLARE vbIndex Integer;
BEGIN

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

    -- !!!��������!!! �� ��������� ������ ��������� ������ �����������
    IF COALESCE (inUserSession, '') <> '' AND inUserSession <> '5'
    THEN
        inSession := inUserSession;
    END IF;
    vbUserId := lpGetUserBySession (inSession);
    
    IF inDate is null
    THEN
        inDate := CURRENT_TIMESTAMP::TDateTime;
    END IF;
    
    -- ���� ID ���� �� inUID
    IF COALESCE (ioId, 0) = 0 AND COALESCE (inUID, '') <> ''
    THEN
      ioId := COALESCE ((SELECT Movement.Id
                         FROM Movement 
                           
                              INNER JOIN MovementString ON MovementString.DescId = zc_MIString_UID()
                                                       AND MovementString.MovementId = Movement.Id
                                                       AND MovementString.ValueData = inUID
                               
                               
                         WHERE Movement.OperDate >= inDate - INTERVAL '3 DAY'
                           AND Movement.DescId = zc_Movement_Check()), 0);
    END IF;

    -- ������� �������� ���� ����� ������
    IF COALESCE (ioId, 0) <> 0
    THEN
      IF EXISTS(SELECT 1 
                FROM  Movement
                WHERE ID = ioId
                  AND DescId = zc_Movement_Check()
                  AND StatusId = zc_Enum_Status_Erased()
                )
      THEN
        PERFORM gpUnComplete_Movement_Check (inMovementId:= ioId, inSession:= zfCalc_UserAdmin());
      END IF;    
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
    
    -- ��������� UID �������� ����
    PERFORM lpInsertUpdate_MovementString(zc_MIString_UID(),ioId,inUID);

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
        IF vbIsInsert = TRUE OR COALESCE(inInvNumberOrder, '') = '' AND 
           NOT EXISTS(SELECT 1 
                      FROM  MovementLinkObject AS MovementLinkObject_CheckSourceKind
                      WHERE MovementLinkObject_CheckSourceKind.MovementId = ioId
                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind())
        THEN
          -- ��������� ���������
          PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), ioId, inManagerId);
          -- ��������� ��� ����������
          IF NOT EXISTS(SELECT * 
                        FROM MovementLinkObject AS MovementLinkObject_BuyerForSite
                        WHERE MovementLinkObject_BuyerForSite.MovementId = ioId
                          AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite())
          THEN
            PERFORM lpInsertUpdate_MovementString(zc_MovementString_Bayer(), ioId, inBayer);
          END IF;
        END IF;
        -- �������� �������� ��� ����������
        PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), ioId, TRUE);
        -- !!! ������ 1 ���!!! ���������
        IF vbIsInsert = TRUE
        THEN
            -- ��������� ����� � <������ ������ (��������� VIP-����)>
            PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), ioId, zc_Enum_ConfirmedKind_Complete());
        END IF;
        
    ELSEIF COALESCE(inisDiscountCommit, FALSE) = TRUE OR COALESCE (inisErrorRRO, False) = True
    THEN
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
    
    IF COALESCE (inisPaperRecipeSP, FALSE) = TRUE AND COALESCE(TRIM(inMedicSP), '') <> ''
    THEN
      IF NOT EXISTS (SELECT Object.Id 
                     FROM Object 
                     WHERE Object.DescId = zc_Object_MedicSP() 
                       AND UPPER(CAST(Object.ValueData AS TVarChar)) LIKE UPPER(TRIM(inMedicSP)))
         THEN 
             -- �� ����� ���������
             PERFORM gpInsertUpdate_Object_MedicSP (ioId               := 0
                                                  , inCode             := lfGet_ObjectCode(0, zc_Object_MedicSP()) 
                                                  , inName             := TRIM(inMedicSP)::TVarChar
                                                  , inPartnerMedicalId := 0
                                                  , inAmbulantClinicSP := 0
                                                  , inSession          := inSession
                                                  );
      END IF;    
    END IF;
    
    -- ��������� <>
    IF inInvNumberSP <> ''
    THEN
       -- ��������� <>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateSP(), ioId, inOperDateSP);

       -- ��������� ����� � <��� ���.�������>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_SPKind(), ioId, inSPKindId);

       -- ��������� ����� � <����������� ��������� ���. ��������>
       IF COALESCE (inMedicalProgramSPId, 0) <> 0
       THEN
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLink_MedicalProgramSP(), ioId, inMedicalProgramSPId);
       END IF;
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

    IF COALESCE(inisPaperRecipeSP, False) = True THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_PaperRecipeSP(), ioId, inisPaperRecipeSP);
	END IF;

    IF COALESCE (inJackdawsChecksCode, 0) <> 0 AND  COALESCE(TRIM(inCashRegister), '') = ''
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

    IF COALESCE(inLoyaltySignID, 0) <> 0
    THEN
      IF EXISTS(SELECT * FROM MovementItem WHERE ID = inLoyaltySignID)
      THEN
         IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.ID = inLoyaltySignID AND MovementItem.ParentId <> ioId AND COALESCE(MovementItem.ParentId, 0) <> 0)
         THEN
             RAISE EXCEPTION '������.�������� % ��������������� �� ������ ���.', inLoyaltySignID;
         ELSE
             UPDATE MovementItem SET ParentId = ioId WHERE MovementItem.ID = inLoyaltySignID;
         END IF;
      ELSE
         RAISE EXCEPTION '������.�� ������� ��������� ��������� %', inLoyaltySignID;
      END IF;
    END IF;

    -- ��������� ���������� �������������
    IF COALESCE(inLoyaltySMID, 0) > 0
    THEN
	   PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LoyaltySMID(), ioId, inLoyaltySMID);
       IF COALESCE(inLoyaltySMDiscount, 0) <> 0
       THEN
   	      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_LoyaltySMDiscount(), ioId, inLoyaltySMDiscount);
          PERFORM gpUpdate_LoyaltySaveMoney_SummaDiscount (inLoyaltySMID, inLoyaltySMDiscount, inSession);
       END IF;
    END IF;

    -- ��� ����� (�� �������)
    IF COALESCE(TRIM(inMedicForSale), '') <> ''
    THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MedicForSale(), ioId, gpInsertUpdate_Object_MedicForSale(0, TRIM(inMedicForSale), inSession));    
    END IF;
    
    -- ��� ���������� (�� �������)
    IF COALESCE(TRIM(inBuyerForSale), '') <> ''
    THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BuyerForSale(), ioId, gpInsertUpdate_Object_BuyerForSale(0, TRIM(inBuyerForSale), inBuyerForSalePhone, inSession));    
    END IF;
    
    IF COALESCE(inDistributionPromoList, '') <> ''    
    THEN
      -- ������ ������
      vbIndex := 1;
      WHILE SPLIT_PART (inDistributionPromoList, ',', vbIndex) <> '' AND SPLIT_PART (inDistributionPromoList, ',', vbIndex + 1) <> '' LOOP
         -- ��������� �� ��� �����
         PERFORM gpInsertUpdate_MovementItem_DistributionPromoSign (inId         := SPLIT_PART (inDistributionPromoList, ',', vbIndex) :: Integer
                                                                  , inMovementId := ioId
                                                                  , isIssuedBy   := CASE WHEN SPLIT_PART (inDistributionPromoList, ',', vbIndex + 1) :: Integer = 0 THEN FALSE ELSE True END
                                                                  , inSession    := inUserSession);
         -- ������ ����������
         vbIndex := vbIndex + 2;
      END LOOP;
    END IF;
    
    IF COALESCE(inMedicKashtanID, 0) <> 0 -- ��� ����� (��� �������) 
    THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MedicKashtan(), ioId, inMedicKashtanID);        
    END IF;
    
    IF COALESCE(inMemberKashtanID, 0) <> 0 -- ��� �������� (��� �������)
    THEN
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_MemberKashtan(), ioId, inMemberKashtanID);            
    END IF;
    
    -- ��������� ������� <������������� ����� ���������� � �� �� �������������>
    IF COALESCE(inisCorrectMarketing, False) = True
    THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_CorrectMarketing(), ioId, inisCorrectMarketing);
    END IF;
    
    -- ��������� ������� <������������� ����� ���������� � �� �� �������������>
    IF COALESCE(inisCorrectIlliquidMarketing, False) = True
    THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_CorrectIlliquidMarketing(), ioId, inisCorrectIlliquidMarketing);
    END IF;

    IF inisDoctors = TRUE OR EXISTS(SELECT * FROM MovementBoolean
                                    WHERE MovementBoolean.MovementId = ioId
                                      AND MovementBoolean.DescId = zc_MovementBoolean_Doctors())
    THEN
      -- ��������� <>
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Doctors(), ioId, inisDoctors);
    END IF;

    IF inisDiscountCommit = TRUE OR EXISTS(SELECT * FROM MovementBoolean
                                         WHERE MovementBoolean.MovementId = ioId
                                           AND MovementBoolean.DescId = zc_MovementBoolean_DiscountCommit())
    THEN
      -- ��������� <>
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DiscountCommit(), ioId, inisDiscountCommit);
    END IF;
    
    IF COALESCE (inZReport, 0) <> 0
    THEN
      -- ��������� <>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ZReport(), ioId, inZReport);
    END IF;
    
    IF COALESCE (inisManual, False) = True
    THEN
      -- ��������� <>
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Manual(), ioId, inisManual);
    END IF;
    
    IF COALESCE (inCategory1303Id, 0) <> 0
    THEN
      -- ��������� <>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Category1303(), ioId, inCategory1303Id);                
    END IF;

    IF COALESCE (inisErrorRRO, False) = True
    THEN
      -- ��������� <>
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ErrorRRO(), ioId, inisErrorRRO);
    END IF;
    
    IF COALESCE (inUserKeyId, 0) <> 0
    THEN
      -- ��������� <��� �������� ���� ������������� ��� �������� ����.>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_UserKeyId(), ioId, inUserKeyId);                    
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);


    -- !!!�������� ��� �����!!!
    IF inSession = zfCalc_UserAdmin()
    THEN
        RAISE EXCEPTION '���� ������ ������� ��� <%> <%> <%> <%>', inUID, inUserKeyId, inUserSession, inSession;
    END IF;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������������ �.�.   ������ �.�.
 15.08.21                                                                                                         * add inDoctors
 22.03.21                                                                                                         * add isCorrectMarketing
 15.01.20                                                                                                         * add inLoyaltySM...
 07.11.19                                                                                                         * add inLoyaltySignID
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