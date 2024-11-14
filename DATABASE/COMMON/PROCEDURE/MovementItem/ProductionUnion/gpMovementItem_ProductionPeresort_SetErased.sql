--select * from gpMovementItem_ProductionPeresort_SetErased(inMovementItemId := 7160388 ,  inSession := '5');

-- Function: gpMovementItem_ProductionPeresort_SetErased (Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpMovementItem_ProductionPeresort_SetErased (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpMovementItem_ProductionPeresort_SetErased(
    IN inMovementItemId      Integer              , -- ���� ������� <������� ���������>
   OUT outIsErased           Boolean              , -- ����� ��������
    IN inSession             TVarChar               -- ������� ������������
)
RETURNS Boolean
AS
$BODY$
BEGIN


   outIsErased := (SELECT dd.outIsErased FROM gpMovementItem_ProductionUnion_Master_SetErased(inMovementItemId, inSession) as dd);

   IF COALESCE (inMovementItemId,0) <> 0
   THEN
      PERFORM gpMovementItem_ProductionUnion_Child_SetErased (MovementItem.Id, inSession)
      FROM MovementItem
      WHERE MovementItem.ParentId   = inMovementItemId
        AND MovementItem.DescId     = zc_MI_Child()
        AND MovementItem.isErased   = FALSE
      ;

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 13.12.14         *
*/

-- ����
-- SELECT * FROM gpMovementItem_ProductionPeresort_SetErased (inMovementId:= 55, inJuridicalId = 1, inSession:= '2')
