-- Function: gpMovementItem_MobileSend_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_MobileSend_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_MobileSend_SetUnErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbStatusId   Integer;
   DECLARE vbInsertId   Integer;
   DECLARE vbGoodsId    Integer;
   DECLARE vbPartNumber TVarChar;
   DECLARE vbInvNumber TVarChar;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_OrderClient());
  vbUserId:= inSession;
  
  
  -- �������� ������ ������
  SELECT MI.ObjectId
       , COALESCE (MIString_PartNumber.ValueData,'')
       , MI.MovementId
       , Movement.StatusId
       , Movement.InvNumber
       , MLO_Insert.ObjectId
  INTO vbGoodsId, vbPartNumber, vbMovementId, vbStatusId, vbInvNumber, vbInsertId
  FROM MovementItem AS MI
       LEFT JOIN MovementItemString AS MIString_PartNumber
                                    ON MIString_PartNumber.MovementItemId = MI.Id
                                   AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
       LEFT JOIN Movement ON Movement.Id = MI.MovementId
       LEFT JOIN MovementLinkObject AS MLO_Insert
                                    ON MLO_Insert.MovementId = Movement.Id
                                   AND MLO_Insert.DescId     = zc_MovementLinkObject_Insert()
  WHERE MI.Id = inMovementItemId;

  IF vbUserId <> COALESCE(vbInsertId, 0)
  THEN
    RAISE EXCEPTION '������.��������� ��������� � <%> ���������� ����������� <%> ��� ���������.', vbInvNumber, lfGet_Object_ValueData (vbInsertId);
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
                AND MI.DescId     = zc_MI_Scan()
                AND MI.ObjectId   = vbGoodsId
                AND MI.isErased   = FALSE
                AND MI.Id <> COALESCE (inMovementItemId, 0) 
                AND COALESCE (MIString_PartNumber.ValueData,'') = COALESCE (vbPartNumber,''))
    THEN
      RAISE EXCEPTION '������. ������������� <%> � S/N <%> ��� ��������� � ����������. ����������� ������ ������.', lfGet_Object_ValueData (vbGoodsId), vbPartNumber;
    END IF;
  END IF;
    
  -- �������� ���������� ��������� ���� ��������
  IF COALESCE(vbStatusId, zc_Enum_Status_Erased()) = zc_Enum_Status_Complete()
  THEN
    PERFORM gpUnComplete_Movement_Send (vbMovementId, inSession);
  END IF;
     
  -- ������������� ����� ��������
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

  -- �������� �������� 
  IF EXISTS (SELECT MovementItem.ObjectId AS GoodsId
                  , SUM(MovementItem.Amount)::TFloat             AS Amount
                  , COALESCE (MIString_PartNumber.ValueData, '') AS PartNumber
             FROM MovementItem 

                  LEFT JOIN MovementItemString AS MIString_PartNumber
                                               ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                              AND MIString_PartNumber.DescId = zc_MIString_PartNumber()
                                                                     
             WHERE MovementItem.MovementId = vbMovementId
               AND MovementItem.DescId     = zc_MI_Scan()
               AND MovementItem.isErased   = False
             GROUP BY MovementItem.ObjectId
                    , COALESCE (MIString_PartNumber.ValueData, '')
             HAVING SUM(MovementItem.Amount) <> 0)
  THEN
    PERFORM gpComplete_Movement_Send (vbMovementId, inSession);
  END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.04.24                                                       *
*/

-- ����
--