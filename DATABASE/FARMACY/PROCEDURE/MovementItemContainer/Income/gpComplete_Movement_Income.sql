-- Function: gpComplete_Movement_Income()

DROP FUNCTION IF EXISTS gpComplete_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Income(
    IN inMovementId        Integer              , -- ���� ���������
    IN inSession           TVarChar DEFAULT ''     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());

     -- ��������� ��� ����������� ��� �����
     PERFORM lpCheckComplete_Movement_Income (inMovementId);


     SELECT ObjectId INTO vbJuridicalId
       FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From();

     -- ��� ������������� ����� ����� �������� ����������� � ������� �������

     PERFORM
            gpInsertUpdate_Object_LinkGoods(0                                 -- ���� ������� <������� ��������>
                                          , Object_LinkGoods_View.GoodsMainId -- ������� �����
                                          , MovementItem.PartnerGoodsId       -- ����� �� ������
                                          , inSession )
       FROM MovementItem_Income_View AS MovementItem
           LEFT JOIN Object_LinkGoods_View ON   Object_LinkGoods_View.GoodsId = MovementItem.GoodsId
                 AND Object_LinkGoods_View.ObjectId = 4
          WHERE MovementItem.MovementId = inMovementId
           AND (Object_LinkGoods_View.GoodsMainId, MovementItem.PartnerGoodsId) NOT IN 
               (SELECT GoodsMainId, GoodsId FROM Object_LinkGoods_View
                       WHERE ObjectId = vbJuridicalId);

      -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.01.15                         * ��������� ������ ��� ����������
 26.12.14                         *
 03.07.14                                                       *

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
