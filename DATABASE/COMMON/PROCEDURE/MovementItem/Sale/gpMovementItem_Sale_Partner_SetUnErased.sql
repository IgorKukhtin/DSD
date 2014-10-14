-- Function: gpMovementItem_Sale_Partner_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Sale_Partner_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Sale_Partner_SetUnErased(
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
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_Sale_Partner());


  -- ��������, �.�. � ���� ������ ��������������� ������
  IF EXISTS (SELECT Id FROM MovementItem WHERE Id = inMovementItemId AND Amount <> 0)
  THEN
      RAISE EXCEPTION '������.��� ���� ������������ <�������>.';
  END IF;

  -- ������������� ����� ��������
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_Sale_Partner_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 09.10.14                                        * add lpSetUnErased_MovementItem
 05.05.14                                        *
*/

-- ����
-- SELECT * FROM gpMovementItem_Sale_Partner_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
