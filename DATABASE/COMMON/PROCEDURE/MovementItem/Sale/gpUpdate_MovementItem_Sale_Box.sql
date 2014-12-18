-- Function: gpUpdate_MovementItem_Sale_Box (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Sale_Box (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Sale_Box(
    IN inMovementId      Integer              , -- ���� ������� <��������>
    IN inSession         TVarChar               -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbBoxId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Update_MI_Sale_Box());

     -- <�����>
     vbBoxId:= (SELECT MIN (Id) FROM Object WHERE DescId = zc_Object_Box());


     -- ��������� �������� <���������� ������> + ��������� ����� � <�����>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_BoxCount(), MovementItem.Id, CASE WHEN MovementItem.isErased = TRUE THEN 0 ELSE COALESCE (tmpWeighingPartner.BoxCount, 0) END)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Box(), MovementItem.Id, CASE WHEN tmpWeighingPartner.BoxCount > 0 THEN vbBoxId ELSE NULL END)
     FROM MovementItem
          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
          LEFT JOIN (SELECT COUNT (*) AS BoxCount
                          , MovementItem.ObjectId AS GoodsId
                          , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                     FROM Movement
                          LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.isErased = FALSE
                          LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                           ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                          AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                     WHERE Movement.ParentId = inMovementId
                       AND Movement.DescId = zc_Movement_WeighingPartner()
                     GROUP BY MovementItem.ObjectId
                            , MILinkObject_GoodsKind.ObjectId
                    ) AS tmpWeighingPartner ON tmpWeighingPartner.GoodsId = MovementItem.ObjectId
                                           AND tmpWeighingPartner.GoodsKindId = COALESCE (MILinkObject_GoodsKind.ObjectId, 0)
     WHERE MovementItem.MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_MovementItem_Sale_Box (Integer, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.12.14                                        *
*/

-- ����
-- SELECT * FROM gpUpdate_MovementItem_Sale_Box (inMovementId:= 752816, inSession:= zfCalc_UserAdmin())
