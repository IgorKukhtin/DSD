-- Function: gpComplete_Movement_Tax()

DROP FUNCTION IF EXISTS gpComplete_Movement_Tax (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Tax(
    IN inMovementId        Integer               , -- ���� ���������
    IN inIsLastComplete    Boolean  DEFAULT FALSE, -- ��� ��������� ���������� ����� ������� �/� (��� ������� �������� !!!�� ��������������!!!)
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
 RETURNS void
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Tax());


     -- �����
     vbObjectId:= (SELECT MovementItem.ObjectId
                   FROM MovementItem
                        INNER JOIN Object AS Object_GoodsExternal ON Object_GoodsExternal.Id = MovementItem.ObjectId
                                                                 AND Object_GoodsExternal.DescId = zc_Object_GoodsExternal()
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsExternal_Goods
                                             ON ObjectLink_GoodsExternal_Goods.ObjectId = Object_GoodsExternal.Id
                                            AND ObjectLink_GoodsExternal_Goods.DescId = zc_ObjectLink_GoodsExternal_Goods()
                        LEFT JOIN ObjectLink AS ObjectLink_GoodsExternal_GoodsKind
                                             ON ObjectLink_GoodsExternal_GoodsKind.ObjectId = Object_GoodsExternal.Id
                                            AND ObjectLink_GoodsExternal_GoodsKind.DescId = zc_ObjectLink_GoodsExternal_GoodsKind()
                   WHERE MovementItem.MovementId = inMovementId
                     AND MovementItem.isErased = FALSE
                     AND MovementItem.DescId = zc_MI_Master()
                     AND (COALESCE (ObjectLink_GoodsExternal_Goods.ChildObjectId, 0) = 0 OR COALESCE (ObjectLink_GoodsExternal_GoodsKind.ChildObjectId, 0) = 0)
                   LIMIT 1
                  );

     -- ��������
     IF vbObjectId > 0
     THEN
         RAISE EXCEPTION '������.��� ������ ����� <%> �� ��������� �������� <�����> �/��� <��� ������>.',  lfGet_Object_ValueData (vbObjectId);
     END IF;


     -- ������ zc_Object_GoodsExternal -> zc_Object_Goods and zc_Object_GoodsKind
     PERFORM lpInsertUpdate_MovementItem (MovementItem.Id, MovementItem.DescId, ObjectLink_GoodsExternal_Goods.ChildObjectId, MovementItem.MovementId, MovementItem.Amount, MovementItem.ParentId)
           , lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_GoodsKind(), MovementItem.Id, ObjectLink_GoodsExternal_GoodsKind.ChildObjectId)
     FROM MovementItem
          INNER JOIN Object AS Object_GoodsExternal ON Object_GoodsExternal.Id = MovementItem.ObjectId
                                                   AND Object_GoodsExternal.DescId = zc_Object_GoodsExternal()
          INNER JOIN ObjectLink AS ObjectLink_GoodsExternal_Goods
                                ON ObjectLink_GoodsExternal_Goods.ObjectId = Object_GoodsExternal.Id
                               AND ObjectLink_GoodsExternal_Goods.DescId = zc_ObjectLink_GoodsExternal_Goods()
                               AND ObjectLink_GoodsExternal_Goods.ChildObjectId > 0
          INNER JOIN ObjectLink AS ObjectLink_GoodsExternal_GoodsKind
                                ON ObjectLink_GoodsExternal_GoodsKind.ObjectId = Object_GoodsExternal.Id
                               AND ObjectLink_GoodsExternal_GoodsKind.DescId = zc_ObjectLink_GoodsExternal_GoodsKind()
                               AND ObjectLink_GoodsExternal_GoodsKind.ChildObjectId > 0
     WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.isErased = FALSE
         AND MovementItem.DescId = zc_MI_Master()
    ;


     -- �������� ��������
     PERFORM lpComplete_Movement_Tax (inMovementId := inMovementId
                                    , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.05.14                                        * add
*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 10154, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Tax (inMovementId:= 10154, inIsLastComplete:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 10154, inSession:= '2')
