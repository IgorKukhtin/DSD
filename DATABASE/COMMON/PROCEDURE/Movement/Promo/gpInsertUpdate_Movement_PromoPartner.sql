-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (
    Integer    , -- ���� ������� <������� ��� ��������� �����>
    Integer    , -- ���� ������������� ������� <�������� �����>
    Integer    , -- �������
    TVarChar     -- ������ ������������

);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (
    Integer    , -- ���� ������� <������� ��� ��������� �����>
    Integer    , -- ���� ������������� ������� <�������� �����>
    Integer    , -- �������
    Integer    , -- ��������
    TVarChar     -- ������ ������������

);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoPartner(
 INOUT ioId                    Integer    , -- ���� ������� <������� ��� ��������� �����>
    IN inParentId              Integer    , -- ���� ������������� ������� <�������� �����>
    IN inPartnerId             Integer    , -- ���� ������� <���������� / �� ���� / �������� ����>
    IN inContractId            Integer    , -- ���� ������� <��������>
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPartnerDescId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    -- ��������� <��������>
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    --��������� �������� �� ��������
    IF NOT EXISTS(SELECT 1 FROM Movement 
                  WHERE Movement.Id = inParentId
                    AND Movement.StatusId = zc_Enum_Status_UnComplete())
    THEN
        RAISE EXCEPTION '������. �������� �� �������� ��� �� ��������� � ��������� <�� ��������>.';
    END IF;
    
    -- ��������� <��������>
    SELECT
        lpInsertUpdate_Movement (ioId, zc_Movement_Promo(), Movement_Promo.InvNumber, Movement_Promo.OperDate, inParentId, 0)
    INTO
        ioId
    FROM
        Movement AS Movement_Promo
    WHERE
        Movement_Promo.Id = inParentId;
    
    --��������� ������������ ��������� �������
    IF COALESCE(inContractId,0) <> 0
    THEN
        vbPartnerDescId = (Select DescId from Object Where Id = inPartnerId);
        IF vbPartnerDescId = zc_Object_Juridical()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View 
                          Where Object_Contract_View.ContractId = inContractId 
                            AND Object_Contract_View.JuridicalId = inPartnerId)
            THEN
                RAISE EXCEPTION '������. �������������� ��������� � ��������.';
            END IF;
        END IF;
        IF vbPartnerDescId = zc_Object_Partner()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View
                              Inner Join ObjectLink ON ObjectLink.ChildObjectId = Object_Contract_View.JuridicalId
                                                   AND ObjectLink.DescId = zc_ObjectLink_Partner_Juridical()
                          Where Object_Contract_View.ContractId = inContractId 
                            AND ObjectLink.ObjectId = inPartnerId)
            THEN
                RAISE EXCEPTION '������. �������������� ��������� � ��������.';
            END IF;
        END IF;
        IF vbPartnerDescId = zc_Object_Retail()
        THEN
            IF NOT EXISTS(Select 1 from Object_Contract_View
                              Inner Join ObjectLink ON ObjectLink.ObjectId = Object_Contract_View.JuridicalId
                                                   AND ObjectLink.DescId = zc_ObjectLink_Juridical_Retail()
                          Where Object_Contract_View.ContractId = inContractId 
                            AND ObjectLink.ChildObjectId = inPartnerId)
            THEN
                RAISE EXCEPTION '������. �������������� ��������� � ��������.';
            END IF;
        END IF;
    END IF;
    -- ��������� ����� � <���������� / �� ���� / �������� ����>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Partner(), ioId, inPartnerId);
    -- ��������� ����� � <��������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Contract(), ioId, inContractId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 17.11.15                                                                    *inContractId
 31.10.15                                                                    *
*/