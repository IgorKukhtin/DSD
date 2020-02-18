-- Function: gpSetErased_MovementItem_TechnicalRediscount (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_MovementItem_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem_TechnicalRediscount(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId  Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_TechnicalRediscount());

  IF COALESCE (inMovementItemId, 0) = 0
  THEN
      RAISE EXCEPTION '������.������� ��������� �� ��������.';
  END IF;
  
  SELECT MovementItem.MovementId
  INTO vbMovementId
  FROM MovementItem 
  WHERE MovementItem.ID = inMovementItemId;

  -- ������������� ����� ��������
  outIsErased:= gpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- ������������� �����
  PERFORM lpUpdate_Movement_TechnicalRediscount_TotalDiff (vbMovementId);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem_TechnicalRediscount (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.14                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_MovementItem_TechnicalRediscount (inMovementItemId:= 0, inSession:= '2')
