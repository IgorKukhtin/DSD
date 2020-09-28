-- Function: gpSetErased_MovementItem_TechnicalRediscount_Auto (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_MovementItem_TechnicalRediscount_Auto (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem_TechnicalRediscount_Auto(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
    IN inSession             TVarChar               -- ������� ������������
)                              
  RETURNS VOID
AS
$BODY$
   DECLARE vbMovementId  Integer;
BEGIN

  SELECT MovementItem.MovementId
  INTO vbMovementId
  FROM MovementItem 
       INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
  WHERE MovementItem.ID = inMovementItemId;
  
  
    -- ������������� ����� ��������
  PERFORM gpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- ������������� �����
  PERFORM lpUpdate_Movement_TechnicalRediscount_TotalDiff (vbMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem_TechnicalRediscount_Auto (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.09.20                                                       *
*/

-- ����
-- SELECT * FROM gpSetErased_MovementItem_TechnicalRediscount_Auto (inMovementItemId:= 0, inSession:= '2')
