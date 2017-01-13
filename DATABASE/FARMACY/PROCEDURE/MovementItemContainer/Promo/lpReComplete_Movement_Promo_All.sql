-- Function: lpReComplete_Movement_Promo_All (Integer)

DROP FUNCTION IF EXISTS lpReComplete_Movement_Promo_All (Integer, Integer);

CREATE OR REPLACE FUNCTION lpReComplete_Movement_Promo_All(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN
    -- ������ ����� ���
    IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('_tmpItem_income'))
    THEN
        DELETE FROM _tmpItem_income;
    ELSE
        -- ������� - ������ ����� ���
        CREATE TEMP TABLE _tmpItem_income (MovementId_income Integer, MovementItemId_income Integer, MovementItemId_promo Integer) ON COMMIT DROP;
    END IF;

    -- ����������
    vbStartDate:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_StartPromo());
    -- ����������
    vbEndDate:= (SELECT MD.ValueData FROM MovementDate AS MD WHERE MD.MovementId = inMovementId AND MD.DescId = zc_MovementDate_EndPromo());


    -- 1.1. ����� ��� MovementItemId - ������, � ���� ��������� ���� ����� ��������� ObjectIntId_analyzer = Promo, ��� zc_MIContainer_Count() + zc_MIContainer_Summ()
    INSERT INTO _tmpItem_income (MovementId_income, MovementItemId_income, MovementItemId_promo)
      WITH -- ������ ���������
           tmpMI AS (SELECT MovementItem.ObjectId AS GoodsId
                          , MAX (MovementItem.Id) AS MovementItemId_promo -- �� ������ ������
                     FROM MovementItem
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.DescId     = zc_MI_Master()
                       AND MovementItem.IsErased   = FALSE
                     GROUP BY MovementItem.ObjectId
                    )
     -- ����� ������� ����� ������ �� ���� �����
   , tmpMIGoods AS (SELECT DISTINCT
                           tmpMI.GoodsId
                         , tmpMI.MovementItemId_promo
                         , ObjectLink_Child_R.ChildObjectId AS GoodsId_all
                    FROM tmpMI
                         INNER JOIN ObjectLink AS ObjectLink_Child
                                               ON ObjectLink_Child.ChildObjectId = tmpMI.GoodsId -- ����� �����"����"
                                              AND ObjectLink_Child.DescId        = zc_ObjectLink_LinkGoods_Goods()
                         INNER JOIN ObjectLink AS ObjectLink_Main ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                                                 AND ObjectLink_Main.DescId   = zc_ObjectLink_LinkGoods_GoodsMain()
                         INNER JOIN ObjectLink AS ObjectLink_Main_R ON ObjectLink_Main_R.ChildObjectId = ObjectLink_Main.ChildObjectId
                                                                   AND ObjectLink_Main_R.DescId        = zc_ObjectLink_LinkGoods_GoodsMain()
                         -- ������ �� ���� �����
                         INNER JOIN ObjectLink AS ObjectLink_Child_R ON ObjectLink_Child_R.ObjectId = ObjectLink_Main_R.ObjectId
                                                                    AND ObjectLink_Child_R.DescId   = zc_ObjectLink_LinkGoods_Goods()
                    WHERE ObjectLink_Child_R.ChildObjectId <> 0
                   )
       -- ���������
       SELECT Movement.Id  AS MovementId_income
            , MI_Goods.Id  AS MovementItemId_income
            , tmpMIGoods.MovementItemId_promo
       FROM Movement
            INNER JOIN MovementItem AS MI_Goods ON MI_Goods.MovementId = Movement.Id
                                               AND MI_Goods.DescId     = zc_MI_Master()
                                              AND MI_Goods.isErased    = FALSE
            INNER JOIN tmpMIGoods ON tmpMIGoods.GoodsId_all = MI_Goods.ObjectId
       WHERE Movement.OperDate BETWEEN vbStartDate AND vbEndDate
         AND Movement.StatusId = zc_Enum_Status_Complete()
         AND Movement.DescId = zc_Movement_Income()
      ;

    -- 1.2. �������� ObjectIntId_analyzer = Promo, ��� zc_MIContainer_Count() + zc_MIContainer_Summ()
    UPDATE MovementItemContainer SET ObjectIntId_analyzer = _tmpItem_income.MovementItemId_promo
    FROM _tmpItem_income
    WHERE MovementItemContainer.MovementId     = _tmpItem_income.MovementId_income
      AND MovementItemContainer.MovementItemId = _tmpItem_income.MovementItemId_income
      -- AND COALESCE (MovementItemContainer.ObjectIntId_analyzer, 0)   <>  _tmpItem_income.MovementItemId_promo
      AND MovementItemContainer.DescId IN (zc_MIContainer_Count(), zc_MIContainer_Summ())
     ;


    -- 2. ��� ������ - ����� ��� �������� - ����, � �������� ObjectIntId_analyzer = Promo, ��� zc_MIContainer_Count()
    UPDATE MovementItemContainer SET ObjectIntId_analyzer = _tmpItem_income.MovementItemId_promo
    FROM _tmpItem_income
    WHERE MovementItemContainer.AnalyzerId = _tmpItem_income.MovementItemId_income
      -- AND COALESCE (MovementItemContainer.ObjectIntId_analyzer, 0)   <>  _tmpItem_income.MovementItemId_promo
      AND MovementItemContainer.MovementDescId IN (zc_Movement_Check())
     ;
    
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 11.01.17         * 
*/