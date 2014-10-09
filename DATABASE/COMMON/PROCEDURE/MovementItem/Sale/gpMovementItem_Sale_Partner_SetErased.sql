-- Function: gpMovementItem_Sale_Partner_SetErased (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Sale_Partner_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Sale_Partner_SetErased(
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
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetErased_MI_Sale_Partner());

  -- ��������, �.�. � ���� ������ ������� ������
  IF EXISTS (SELECT Id FROM MovementItem WHERE Id = inMovementItemId AND Amount <> 0)
  THEN
      RAISE EXCEPTION '������.��� ���� ������� <�������>.';
  END IF;

  -- ������������� ����� ��������
  outIsErased:= lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_PersonalAccount_SetErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 09.10.14                                        * add lpSetErased_MovementItem
 05.05.14                                        *
*/

-- ����
-- SELECT * FROM gpMovementItem_Sale_Partner_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
