-- Function: gpInsertUpdate_Movement_Promo()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoInvoice (Integer, Integer, TVarChar, TVarChar, TDateTime, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoInvoice (Integer, Integer, TVarChar, TVarChar, TDateTime, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoInvoice(
 INOUT ioId                    Integer    , -- ���� ������� <>
    IN inParentId              Integer    , -- ���� ������������� ������� <�������� �����>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inInvNumberPartner      TVarChar   ,
    IN inOperDate              TDateTime  , --
    IN inBonusKindId           Integer    , --
    IN inPaidKindId            Integer    , -- 
    IN inContractId            Integer    , -- 
    IN inTotalSumm             TFloat     , --
    IN inComment               TVarChar   , --
    IN inSession               TVarChar     -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbJuridicalId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoInvoice());
    --vbUserId := lpGetUserBySession (inSession);

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    --��������� �������� �� ��������
    IF  COALESCE (inParentId, 0) = 0 
    THEN
        RAISE EXCEPTION '������. �������� <�����> �� ��������.';
    END IF;
    
    -- ��������� <��������>
    ioId:= lpInsertUpdate_Movement (ioId, zc_Movement_PromoInvoice(), inInvNumber, inOperDate, inParentId, 0);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_BonusKind(), ioId, inBonusKindId);
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PaidKind(), ioId, inPaidKindId);

    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
    
    --�������� ��.���� �� ��������
    vbJuridicalId := (SELECT ObjectLink_Contract_Juridical.ChildObjectId
                      FROM ObjectLink AS ObjectLink_Contract_Juridical
                      WHERE ObjectLink_Contract_Juridical.ObjectId = inContractId 
                        AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                      );
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Juridical(), ioId, vbJuridicalId);

        -- ��������� <>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberPartner(), ioId, inInvNumberPartner);
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    -- ��������� <�������� ���� ���.>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSumm(), ioId, inTotalSumm);
    
     IF vbIsInsert = True
     THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
     ELSE
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, vbUserId);
     END IF;


    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.09.21         *
 04.09.21         *
*/
