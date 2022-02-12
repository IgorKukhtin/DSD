-- Function: gpInsertUpdate_Movement_Check_Site()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_Site (Integer, Integer, TDateTime, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TFloat, Boolean, TVarChar, TVarChar);
    
CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_Site(
 INOUT ioId                Integer   , -- ���� ������� <�������� ���>
    IN inUnitId            Integer   , -- ���� ������� <�������������>
    IN inDate              TDateTime , -- ����/����� ���������
    IN inBayerId           Integer   , -- ID ���������� � �����
    IN inBayer             TVarChar  , -- ���������� ��� 
    IN inBayerPhone        TVarChar  , -- ���������� ������� (����������)
    IN inInvNumberOrder    TVarChar  , -- ����� ������ (� �����)
    IN inManagerName       TVarChar  , -- �������� � ���
    IN inisDelivery        Boolean   , -- H��� ��������
    IN inDeliveryPrice     TFloat    , -- ���� ��������
    IN inisCallOrder       Boolean   , -- ����� �� ������ ����������
    IN inComment           TVarChar  , -- ����������� �������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbInvNumber Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbPaidTypeId Integer;
   DECLARE vbManagerId Integer;
   DECLARE vbSiteDiscount TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_...());
    vbUserId := lpGetUserBySession (inSession);
    vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);

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
            Movement_Check_View.UnitId = inUnitId 
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


    -- ����� ���������
    IF TRIM (inManagerName) <> ''
    THEN
        vbManagerId:= (SELECT Object.Id FROM Object WHERE Object.ObjectCode = zfConvert_StringToNumber (TRIM (inManagerName)) AND Object.DescId = zc_Object_Member() AND zfConvert_StringToNumber (inManagerName) <> 0);
        -- vbManagerId:= (SELECT Object.Id FROM Object WHERE Object.ValueData = TRIM (inManagerName) AND Object.DescId = zc_Object_Member());
    END IF;
    -- ��������� ����� � ����������
    IF COALESCE (vbManagerId,0) <> 0
    THEN
        -- ��������� ���������
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), ioId, vbManagerId);
    END IF;

    IF vbIsInsert = TRUE
    THEN
        -- ��������� ����� � <������ ������ (��������� VIP-����)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKindClient(), ioId, zc_Enum_ConfirmedKind_SmsNo());
    END IF;

    -- ��������� ����� � <��������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    -- ��������� ����� � <������ ������ (��������� VIP-����)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_ConfirmedKind(), ioId, zc_Enum_ConfirmedKind_UnComplete());

    inBayer := translate(inBayer, chr('8296')||chr('8297')||chr('8203'), '');

    IF COALESCE (inBayerId, 0) <> 0
    THEN
      -- ��������� ����� � <������ ������ (��������� VIP-����)>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BuyerForSite(), ioId, gpInsertUpdate_Object_BuyerForSite(inBayerID, inBayer, inBayerPhone, inSession));    
    ELSE
      -- ��������� ��� ����������
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_Bayer(), ioId, inBayer);
      -- ��������� ���������� ������� (����������)
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_BayerPhone(), ioId, inBayerPhone);
    END IF;
    
    -- ��������� ����� ������ (� �����)
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberOrder(), ioId, inInvNumberOrder);
    -- �������� �������� ��� ����������
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Deferred(), ioId, TRUE);
    IF COALESCE(vbSiteDiscount, 0) <> 0 THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Site(), ioId, True);
	END IF;

    IF COALESCE(inisDelivery, False) = TRUE
    THEN
      -- ��������� <���� �������� � �����>
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DeliverySite(), ioId, inisDelivery);
      -- ��������� <����� ��������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummaDelivery(), ioId, inDeliveryPrice);
    END IF;
    
    IF COALESCE (inisCallOrder, False) = TRUE THEN
      PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_CallOrder(), ioId, True);
	END IF;

      -- ��������� ����������� �������
    inComment := translate(inComment, chr('8296')||chr('8297')||chr('8203'), '');
    IF COALESCE (TRIM(inComment), '') <> '' THEN
      PERFORM lpInsertUpdate_MovementString (zc_MovementString_CommentCustomer(), ioId, TRIM(inComment));
	END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 29.01.19                                                                                      *
 17.12.15                                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Check_Site (ioId := 0, inUnitId := 183292, inDate := NULL::TDateTime, inBayerId := 333, inBayer := 'Test Bayer'::TVarChar, inBayerPhone:= '11-22-33', inInvNumberOrder:= '12345', inManagerName:= '5', inSession := '3'::TVarChar); -- ������_1 ��_������_6