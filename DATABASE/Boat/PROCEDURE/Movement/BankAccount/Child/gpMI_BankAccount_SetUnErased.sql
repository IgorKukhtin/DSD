-- Function: gpMI_BankAccount_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMI_BankAccount_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMI_BankAccount_SetUnErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  --vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_Invoice());
  vbUserId := inSession;

  -- ������������� ����� ��������
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);




  -- ������������� ����� ��������
  -- UPDATE Object_PartionGoods SET isErased = FALSE WHERE MovementItemId = inMovementItemId;

  -- ������������� ����� ��������
  -- UPDATE Object SET isErased = FALSE WHERE Object.Id = (SELECT Object_PartionGoods.GoodsId

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.01.24         *
*/

-- ����
--