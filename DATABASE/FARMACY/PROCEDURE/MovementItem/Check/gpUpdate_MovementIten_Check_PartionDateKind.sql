-- Function: gpUpdate_MovementIten_Check_PartionDateKind()

DROP FUNCTION IF EXISTS gpUpdate_MovementIten_Check_PartionDateKind (Integer, Integer, Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementIten_Check_PartionDateKind(
    IN inMovementId            Integer   , -- ���� ������� <�������� ���>
    IN inMovementItemID        Integer   , -- ���� ������� <������ ���>
    IN inPartionDateKindId     Integer   , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumberOrder TVarChar;
   DECLARE vbPrice TFloat;
   DECLARE vbUnitId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbPricePD TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpGetUserBySession (inSession);
--    vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Check_OperDate());

--    IF 3 <> inSession::Integer AND 375661 <> inSession::Integer AND 4183126 <> inSession::Integer AND 
--      8001630 <> inSession::Integer AND 9560329 <> inSession::Integer
--    THEN
--      RAISE EXCEPTION '��������� <���� ����/�� ����> ��� ���������.';
--    END IF;

    IF COALESCE(inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;

    SELECT Movement.StatusId
         , MovementLinkObject_Unit.ObjectId  
         , COALESCE(MovementString_InvNumberOrder.ValueData, '')
    INTO vbStatusId, vbUnitId, vbInvNumberOrder
    FROM Movement 
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()    
         LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                  ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                 AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
    WHERE Id = inMovementId;
            
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    IF EXISTS(SELECT * FROM MovementItem WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemID)
    THEN
      UPDATE MovementItem SET isErased = True, Amount = 0
      WHERE MovementItem.MovementId = inMovementId AND MovementItem.DescID = zc_MI_Child() AND MovementItem.ParentId = inMovementItemID;
    END IF;

    -- ��������� �������� <��� ����/�� ����>
    IF COALESCE (inPartionDateKindID, 0) <> COALESCE ((SELECT ObjectId FROM MovementItemLinkObject WHERE MovementItemId = inMovementItemID
                                                                                                     AND DescId = zc_MILinkObject_PartionDateKind()), 0)
    THEN
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), inMovementItemID, inPartionDateKindID);
      PERFORM lpInsertUpdate_MovementItemLinkContainer(inMovementItemId := inMovementItemID, inUserId := vbUserId);
    ELSE
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_PartionDateKind(), inMovementItemID, 0);
    END IF;
    
    IF COALESCE(inPartionDateKindId, 0) <> 0 AND COALESCE(vbInvNumberOrder, '') <> ''
    THEN
    
      SELECT MovementItem.ObjectId, MIFloat_Price.ValueData 
      INTO vbGoodsId, vbPrice
      FROM MovementItem 
           LEFT OUTER JOIN MovementItemFloat AS MIFloat_Price
                                             ON MIFloat_Price.MovementItemId = MovementItem.ID
                                            AND MIFloat_Price.DescId = zc_MIFloat_Price()
      WHERE MovementItem.Id = inMovementItemID;
                            
      vbPricePD := COALESCE((SELECT PricePartionDate.outPricePartionDate 
                             FROM gpGet_PricePartionDate_Cash(inUnitId := vbUnitId , inGoodsId := vbGoodsId , inPartionDateKindId := inPartionDateKindId, inSession := inSession) AS PricePartionDate), 0);
                             
      IF COALESCE(vbPrice, 0) > 0 AND COALESCE(vbPricePD, 0) > 0 AND vbPrice > vbPricePD
      THEN
        PERFORM gpUpdate_MovementIten_Check_Price(inMovementId := inMovementId, inMovementItemID := inMovementItemID, inPrice := vbPricePD, inSession := zfCalc_UserAdmin());
      END IF;
    END IF;
    
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (inMovementItemID, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.  ������ �.�.
 17.11.18                                                                                    *
*/
-- ���� select * from gpUpdate_MovementIten_Check_PartionDateKind(inMovementId := 24447136 , inMovementItemID := 449486903 , inPartionDateKindId := 14542625 ,  inSession := '3');