-- Function: gpSetUnErased_MovementItem_WriteOffHouseholdInventory (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpSetUnErased_MovementItem_WriteOffHouseholdInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSetUnErased_MovementItem_WriteOffHouseholdInventory(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)                              
  RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsName  TVarChar;
   DECLARE vbAmount     TFloat;
   DECLARE vbSaldo      TFloat;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_WriteOffHouseholdInventory());

  -- ������������� ����� ��������
  outIsErased:= gpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inSession:= inSession);

  -- ����������� �������� ����� �� ���������
  PERFORM lpInsertUpdate_WriteOffHouseholdInventory_TotalSumm ((SELECT MovementItem.MovementId FROM MovementItem WHERE MovementItem.ID = inMovementItemId));
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSetUnErased_MovementItem (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 09.07.20                                                                      * 
*/

-- ����
-- SELECT * FROM gpSetUnErased_MovementItem_WriteOffHouseholdInventory (inMovementItemId:= 0, inSession:= '2')
