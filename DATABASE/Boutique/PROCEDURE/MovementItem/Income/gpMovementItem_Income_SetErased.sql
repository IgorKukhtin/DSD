-- Function: gpMovementItem_Income_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_Income_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_Income_SetErased(
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
  vbUserId:= lpCheckRight (inSession, zc_Enum_Process_SetErased_MI_Income());

  -- ������������� ����� ��������
  outIsErased := lpSetErased_MovementItem (inMovementItemId:= inMovementItemId, inUserId:= vbUserId);
  
  -- ������������� ����� ��������
  UPDATE Object_PartionGoods SET isErased = FALSE WHERE MovementItemId = inMovementItemId;

  -- ������������� ����� ��������
  UPDATE Object SET isErased = TRUE WHERE Object.Id = (SELECT Object_PartionGoods.GoodsId
                                                       FROM Object_PartionGoods
                                                            LEFT JOIN Object_PartionGoods AS Object_PartionGoods_find
                                                                                          ON Object_PartionGoods_find.GoodsId = Object_PartionGoods.GoodsId
                                                                                         AND Object_PartionGoods_find.MovementItemId <> inMovementItemId
                                                                                         AND Object_PartionGoods_find.isErased       = FALSE
                                                       WHERE Object_PartionGoods.MovementItemId = inMovementItemId
                                                         AND Object_PartionGoods_find.GoodsId IS NULL
                                                      )
                                       AND Object.DescId = zc_Object_Goods();

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 10.04.17         *
*/

-- ����
-- SELECT * FROM gpMovementItem_Income_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
