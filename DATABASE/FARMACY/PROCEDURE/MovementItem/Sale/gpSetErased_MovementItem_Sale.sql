-- Function: gpSetErased_MovementItem_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetErased_MovementItem_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetErased_MovementItem_Sale(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_???());
  vbUserId:= lpGetUserBySession (inSession);

  -- ������������� ����� ��������
  outIsErased:= gpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- ������� �������� ��� ����������
  IF COALESCE ((SELECT ValueData FROM MovementBoolean 
                WHERE MovementId = (SELECT MovementId FROM MovementItem WHERE ID = inMovementItemId)
                  AND DescId = zc_MovementBoolean_Deferred()), FALSE)= TRUE
  THEN
    -- ����������� ������ ��������
    PERFORM lpDelete_MovementItemContainerOne (inMovementId := (SELECT MovementId FROM MovementItem WHERE ID = inMovementItemId)
                                             , inMovementItemId := inMovementItemId);  
  END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetErased_MovementItem_Sale (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.10.14                                        *
*/

-- ����
-- SELECT * FROM gpSetErased_MovementItem_Sale (inMovementItemId:= 0, inSession:= '2')
