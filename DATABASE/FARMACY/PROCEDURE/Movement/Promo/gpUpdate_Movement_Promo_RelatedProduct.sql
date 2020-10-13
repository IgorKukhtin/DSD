-- Function: gpUpdate_Movement_Promo_RelatedProduct()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_RelatedProduct (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_RelatedProduct(
    IN inMovementId                    Integer    , -- ���� ������� <��������>
    IN inRelatedProductId              Integer    , -- ������ �������� ������������� ������
    IN inSession                       TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
           
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;
    
    -- ��������� <������������� ������>
    PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_RelatedProduct(), inMovementId, inRelatedProductId);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 13.10.20                                                       *
*/