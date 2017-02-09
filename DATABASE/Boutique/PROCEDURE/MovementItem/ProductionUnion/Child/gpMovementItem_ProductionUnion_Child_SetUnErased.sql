-- Function: gpMovementItem_ProductionUnion_Child_SetUnErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProductionUnion_Child_SetUnErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProductionUnion_Child_SetUnErased(
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
  vbUserId:= lpCheckRight(inSession, zc_Enum_Process_SetUnErased_MI_ProductionUnion());

  -- ������������� ����� ��������
  outIsErased:= lpSetUnErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpMovementItem_ProductionUnion_Child_SetUnErased (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 04.05.15                                        *
 02.06.14                                                       *
*/

-- ����
-- SELECT * FROM gpMovementItem_ProductionUnion_Child_SetUnErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
