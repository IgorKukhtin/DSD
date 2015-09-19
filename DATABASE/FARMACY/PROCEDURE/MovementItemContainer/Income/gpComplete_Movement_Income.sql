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
  DECLARE vbOperDate    TDateTime;
  DECLARE vbUnit        Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
     vbUserId:= inSession;
     
     -- ��������� ��� ����������� ��� �����
     PERFORM lpCheckComplete_Movement_Income (inMovementId);

    -- ���������, ��� �� �� ���� ��������� ����� ���� ���������
    SELECT
        Movement.OperDate,
        Movement_Unit.ObjectId AS Unit
    INTO
        vbOperDate,
        vbUnit
    FROM Movement
        INNER JOIN MovementLinkObject AS Movement_Unit
                                      ON Movement_Unit.MovementId = Movement.Id
                                     AND Movement_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    IF EXISTS(SELECT 1
              FROM Movement AS Movement_Inventory
                  INNER JOIN MovementItem AS MI_Inventory
                                          ON MI_Inventory.MovementId = Movement_Inventory.Id
                                         AND MI_Inventory.DescId = zc_MI_Master()
                                         AND MI_Inventory.IsErased = FALSE
                  INNER JOIN MovementLinkObject AS Movement_Inventory_Unit
                                                ON Movement_Inventory_Unit.MovementId = Movement_Inventory.Id
                                               AND Movement_Inventory_Unit.DescId = zc_MovementLinkObject_Unit()
                                               AND Movement_Inventory_Unit.ObjectId = vbUnit
                  Inner Join MovementItem AS MI_Send
                                          ON MI_Inventory.ObjectId = MI_Send.ObjectId
                                         AND MI_Send.DescId = zc_MI_Master()
                                         AND MI_Send.IsErased = FALSE
                                         AND MI_Send.Amount > 0
                                         AND MI_Send.MovementId = inMovementId
                                         
              WHERE
                  Movement_Inventory.DescId = zc_Movement_Inventory()
                  AND
                  Movement_Inventory.OperDate >= vbOperDate
                  AND
                  Movement_Inventory.StatusId = zc_Enum_Status_Complete()
              )
    THEN
        RAISE EXCEPTION '������. �� ������ ��� ����� ������� ���� �������� ��������� ����� ���� �������� �������. ���������� ��������� ���������!';
    END IF;

     SELECT ObjectId INTO vbJuridicalId
       FROM MovementLinkObject WHERE MovementId = inMovementId AND DescId = zc_MovementLinkObject_From();

     -- ��� ������������� ����� ����� �������� ����������� � ������� �������

      
     PERFORM gpInsertUpdate_Object_LinkGoods(0                                 -- ���� ������� <������� ��������>
                                          , DD.GoodsMainId
                                          , DD.PartnerGoodsId
                                          , inSession )


     FROM (SELECT DISTINCT Object_LinkGoods_View.GoodsMainId -- ������� �����
                         , MovementItem.PartnerGoodsId       -- ����� �� ������
                                    
       FROM MovementItem_Income_View AS MovementItem
                              LEFT JOIN Object_LinkGoods_View ON Object_LinkGoods_View.GoodsId = MovementItem.GoodsId
                                    AND Object_LinkGoods_View.ObjectId = 4
                              LEFT JOIN Object_LinkGoods_View AS LinkGoods_Juridical ON LinkGoods_Juridical.GoodsMainId = Object_LinkGoods_View.GoodsMainId 
                                    AND LinkGoods_Juridical.GoodsId = MovementItem.PartnerGoodsId AND LinkGoods_Juridical.ObjectId = vbJuridicalId
                             WHERE MovementItem.MovementId = inMovementId AND LinkGoods_Juridical.Id IS NULL) AS DD;

      -- ����������� �������� �����
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
     PERFORM lpInsertUpdate_MovementFloat_TotalSummSale (inMovementId);

     -- ���������� ��������
     PERFORM lpComplete_Movement_Income(inMovementId, -- ���� ���������
                                        vbUserId);    -- ������������                          

     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.15                         * 

*/

-- ����
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_Income (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
