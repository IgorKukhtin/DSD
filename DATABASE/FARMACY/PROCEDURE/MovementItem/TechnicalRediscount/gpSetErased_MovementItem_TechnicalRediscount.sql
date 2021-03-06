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
   DECLARE vbUserId      Integer;
   DECLARE vbMovementId  Integer;
   DECLARE vbOperDate    TDateTime;
   DECLARE vbMISendId    Integer;
   DECLARE vbAmount      TFloat;
BEGIN

  SELECT MovementItem.MovementId, Movement.OperDate, MIFloat_MISendId.ValueData, MovementItem.Amount
  INTO vbMovementId, vbOperDate, vbMISendId, vbAmount
  FROM MovementItem 
       INNER JOIN Movement ON Movement.ID = MovementItem.MovementId
       LEFT JOIN MovementItemFloat AS MIFloat_MISendId
                                   ON MIFloat_MISendId.MovementItemId = MovementItem.Id
                                  AND MIFloat_MISendId.DescId = zc_MIFloat_MovementItemId()
  WHERE MovementItem.ID = inMovementItemId;

  -- �������� ���� ������������ �� ����� ���������
/*  IF vbAmount = 0 AND vbMISendId IS NOT NULL
  THEN
    vbUserId:= lpGetUserBySession (inSession);  
  ELSE*/
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_TechnicalRediscount());
--  END IF;

  IF COALESCE (inMovementItemId, 0) = 0
  THEN
      RAISE EXCEPTION '������.������� ��������� �� ��������.';
  END IF;
  

  IF COALESCE (vbMISendId, 0) <> 0 AND COALESCE (vbAmount, 0) <> 0
  THEN
      RAISE EXCEPTION '������.������� ��������� ������ �� ����������� ��� �������� ���������.';
  END IF;


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
