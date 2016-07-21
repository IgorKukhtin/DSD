-- Function: gpInsertUpdate_Movement_Check()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar);
  
CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Check_ver2(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ���>
    IN inDate                TDateTime , --����/����� ���������
    IN inCashRegister        TVarChar  , --�������� ��������� ��������
    IN inPaidType            Integer   , --��� ������
    IN inManagerId           Integer   , --��������
    IN inBayer               TVarChar  , --���������� ��� 
    IN inFiscalCheckNumber   TVarChar  , --����� ����������� ����
    IN inNotMCS              Boolean  ,  --�� ��������� � ������� ���
    IN inDiscountExternalId  Integer  DEFAULT 0,  -- ������ ���������� ����
    IN inDiscountCardNumber  TVarChar DEFAULT '', -- � ���������� �����
    IN inSession             TVarChar DEFAULT ''  -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbInvNumber Integer;
   DECLARE vbCashRegisterId Integer;
   DECLARE vbPaidTypeId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderInternal());
    vbUserId := inSession;

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
	
    --��������� ����� � �������� ���������
    IF COALESCE(inCashRegister,'') <> ''
    THEN
        vbCashRegisterId := gpGet_Object_CashRegister_By_Serial(inSerial := inCashRegister,
                                                                inSession := inSession);
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CashRegister(),ioId,vbCashRegisterId);
    END IF;
    
    -- ��������� ������� <�� ��������� � ������� ���>
    PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_NotMCS(),ioId,inNotMCS);
    
    -- ��������� ����� ���� � �������� ��������
    PERFORM lpInsertUpdate_MovementString(zc_MovementString_FiscalCheckNumber(),ioId,inFiscalCheckNumber);
    
    -- ��������� ����� � <��� ������>
    IF inPaidType <> -1
    THEN
        if inPaidType = 0 then
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),ioId,zc_Enum_PaidType_Cash());
        ELSEIF inPaidType = 1 THEN
            PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_PaidType(),ioId,zc_Enum_PaidType_Card());
        ELSE
            RAISE EXCEPTION '������.�� ��������� ��� ������';
        END IF;
    END IF;
    
    -- ��������� ����� � ���������� � �����������
    IF COALESCE (inManagerId,0) <> 0 THEN
        -- ����������� ���������
        PERFORM lpInsertUpdate_MovementLinkObject(zc_MovementLinkObject_CheckMember(), ioId, inManagerId);
        -- ����������� ��� ����������
        PERFORM lpInsertUpdate_MovementString(zc_MovementString_Bayer(), ioId, inBayer);
        -- �������� �������� ��� ����������
        PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), ioId, True);      
    END IF;
 
    -- ��������� ����� � <���������� �����> + ����� �� � ������������ <���������� �����>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DiscountCard(), ioId, lpInsertFind_Object_DiscountCard (inObjectId:= inDiscountExternalId, inValue:= inDiscountCardNumber, inUserId:= vbUserId));

    -- ��������� ��������
    -- PERFORM lpInsert_MovementProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_Check_ver2 (Integer, TDateTime,  TVarChar, Integer, Integer, TVarChar, TVarChar, Boolean, Integer, TVarChar, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 20.07.16                                        *
 03.11.15                                                                       *
*/
