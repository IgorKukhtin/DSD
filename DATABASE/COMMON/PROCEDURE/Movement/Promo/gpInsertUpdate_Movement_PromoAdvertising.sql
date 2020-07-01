-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoAdvertising (
    Integer    , -- ���� ������� <��������� ���������>
    Integer    , -- ���� ������������� ������� <�������� �����>
    Integer    , -- ��������� ���������
    TVarChar   , -- ����������
    TVarChar     -- ������ ������������
);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoAdvertising(
 INOUT ioId                    Integer    , -- ���� ������� <������� ��� ��������� �����>
    IN inParentId              Integer    , -- ���� ������������� ������� <�������� �����>
    IN inAdvertisingId         Integer    , -- ���� ������� <��������� ���������>
    IN inComment               TVarChar   , -- ����������
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := lpGetUserBySession (inSession);


    -- �������� - ���� ���� �������, �������������� ������
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inParentId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

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
        lpInsertUpdate_Movement (ioId, zc_Movement_PromoAdvertising(), Movement_Promo.InvNumber, Movement_Promo.OperDate, inParentId, 0)
    INTO
        ioId
    FROM
        Movement AS Movement_Promo
    WHERE
        Movement_Promo.Id = inParentId;
    
    -- ��������� ����� � <��������� ���������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Advertising(), ioId, inAdvertisingId);
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
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