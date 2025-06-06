-- Function: gpUpdate_MovementItem_Check_ReLinkContainer()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Check_ReLinkContainer (Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Check_ReLinkContainer(
    IN inId                Integer   , -- ���� ������� <�������� ���>
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);

--    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND 
--      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
--    THEN
--      RAISE EXCEPTION '������������ ��������� ������ � ������� ��� ���������.';
--    END IF;

    SELECT 
      StatusId
    INTO
      vbStatusId
    FROM Movement 
    WHERE Id = inId;
            
    IF COALESCE(inId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.������������ ��������� ������ � ������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    -- ���� ���� ������������� �� ������� �������                                
    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.isErased = False)
    THEN
      PERFORM lpSetErased_MovementItem(MovementItem.ID, vbUserId)
      FROM MovementItem WHERE MovementItem.MovementId = inId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.isErased = False;
    END IF;
    
    PERFORM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := MovementItem.Id, inUserId := vbUserId) 
    FROM MovementItem 
         INNER JOIN MovementItemLinkObject AS MI_PartionDateKind
                                          ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                         AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
    WHERE MovementItem.MovementId = inId 
      AND MovementItem.DescID = zc_MI_Master() 
      AND COALESCE(MI_PartionDateKind.ObjectId, 0) <> 0
      AND MovementItem.isErased = False;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 06.06.19                                                                                    *
*/
-- ����
-- select * from gpUpdate_MovementItem_Check_ReLinkContainer(inId := 7784533 , inSession := '3');