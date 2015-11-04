-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoPartner (
    Integer    , -- ���� ������� <������� ��� ��������� �����>
    Integer    , -- ���� ������������� ������� <�������� �����>
    Integer    , -- �������
    TVarChar     -- ������ ������������

);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Promo(
 INOUT ioId                    Integer    , -- ���� ������� <������� ��� ��������� �����>
    IN inParentId              Integer    , -- ���� ������������� ������� <�������� �����>
    IN inPartnerId             Integer    , -- ���� ���������
    IN inPromoKindId           Integer    , -- �������
    IN inSession               TVarChar   , -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
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
        Movement_Promo.Id = inParentId
    
    -- ��������� ����� � <�� ���� (�������������)>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 31.10.15                                                                    *
*/