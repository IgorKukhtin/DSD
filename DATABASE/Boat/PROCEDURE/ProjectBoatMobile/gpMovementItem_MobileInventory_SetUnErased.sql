-- Function: gpMovementItem_MobileInventory_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_MobileInventory_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_MobileInventory_SetUnErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbGoodsId    Integer;
   DECLARE vbPartNumber TVarChar;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderClient());
  vbUserId:= inSession;
  
  
  -- �������� ������ ������
  SELECT MI.ObjectId
       , COALESCE (MIString_PartNumber.ValueData,'')
       , MI.MovementId
  INTO vbGoodsId, vbPartNumber, vbMovementId
  FROM MovementItem AS MI
       LEFT JOIN MovementItemString AS MIString_PartNumber
                                    ON MIString_PartNumber.MovementItemId = MI.Id
                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
  WHERE MI.Id = inMovementItemId;

  -- ���� ����� ��� ���� ����� ����� ��������
  IF EXISTS(SELECT MI.Id 
            FROM MovementItem AS MI
                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                              ON MIString_PartNumber.MovementItemId = MI.Id
                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
            WHERE MI.MovementId = vbMovementId
              AND MI.DescId     = zc_MI_Master()
              AND MI.ObjectId   = vbGoodsId
              AND MI.isErased   = FALSE
              AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (vbPartNumber,''))
  THEN
    RAISE EXCEPTION '������. ������������� <%> � S/N <%> ��� ��������� � ��������������. ����������� ������ ������.', lfGet_Object_ValueData (inGoodsId), inPartNumber;
  END IF;

  -- ���� �������� S/N �� ����� ������ 1 �� � ���.
  IF COALESCE (vbPartNumber, '') <> ''
  THEN

    IF EXISTS(SELECT MI.Id 
              FROM MovementItem AS MI
                   LEFT JOIN MovementItemString AS MIString_PartNumber
                                                ON MIString_PartNumber.MovementItemId = MI.Id
                                               AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
              WHERE MI.MovementId = vbMovementId
                AND MI.DescId     = zc_MI_Detail()
                AND MI.ObjectId   = vbGoodsId
                AND MI.isErased   = FALSE
                AND MI.Id <> COALESCE (inMovementItemId, 0) 
                AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (vbPartNumber,''))
    THEN
      RAISE EXCEPTION '������. ������������� <%> � S/N <%> ��� ��������� � ��������������. ����������� ������ ������.', lfGet_Object_ValueData (vbGoodsId), vbPartNumber;
    END IF;
 END IF;
     
  -- ������������� ����� ��������
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.03.24                                                       *
*/

-- ����
--