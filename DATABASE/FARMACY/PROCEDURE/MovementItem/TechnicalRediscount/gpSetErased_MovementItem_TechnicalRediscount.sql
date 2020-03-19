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
   DECLARE vbOperDate TDateTime;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_TechnicalRediscount());

  IF COALESCE (inMovementItemId, 0) = 0
  THEN
      RAISE EXCEPTION '������.������� ��������� �� ��������.';
  END IF;
  
  SELECT MovementItem.MovementId, Movement.OperDate
  INTO vbMovementId, vbOperDate
  FROM MovementItem 
       INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
  WHERE MovementItem.ID = inMovementItemId;

/*  IF date_part('DAY',  vbOperDate)::Integer <= 15
  THEN
      vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '14 DAY';
  ELSE
      vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
  END IF;

  -- ��� ���� "������" ��������� ������
  IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
            WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
     AND  vbOperDate < CURRENT_DATE
  THEN
      RAISE EXCEPTION '������. �� ��������� ����������� �������������� ����� ���� ������������� ��� �������� �����.';
  END IF;
*/
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
