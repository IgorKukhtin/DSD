-- Function: gpInsertUpdate_Movement_Check()

-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, TVarChar, TVarChar);
-- DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar, TVarChar, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);
  
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
    in inUserSession	     TVarChar  , -- ������ ������������ ��� ������� ������ ��� � ���������
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������������ �.�.
 05.02.18                                                                                         * add PromoCode               
 23.05.17         * add zc_Enum_SPKind_SP
 06.10.16         * add ���������� ��-� ����/�����. ��������
 20.07.16                                        *
 03.11.15                                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Check_ver2 (ioId := 0, inUnitId := 183293, inDate := NULL::TDateTime, inBayer := 'Test Bayer'::TVarChar, inSession:= zfCalc_UserAdmin());
