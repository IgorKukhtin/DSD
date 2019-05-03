-- Function: gpUpdate_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderInternalPromoPartner (Integer, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderInternalPromoPartner (Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderInternalPromoPartner(
    IN inId                    Integer    , -- ���� ������� <��������>
    IN inComment               TVarChar   , -- ����������
    IN inIsErased              Boolean    , -- ��������� �� �������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), inId, inComment);
    
    --��������������. 
    inIsErased := NOT inIsErased;
    
    IF inIsErased = TRUE
    THEN
        -- ������� ��������
        PERFORM lpSetErased_Movement (inMovementId := inId
                                    , inUserId     := vbUserId);
    ELSE
        PERFORM lpUnComplete_Movement (inMovementId := inId
                                     , inUserId     := vbUserId);
    END IF;
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.04.19         *
*/