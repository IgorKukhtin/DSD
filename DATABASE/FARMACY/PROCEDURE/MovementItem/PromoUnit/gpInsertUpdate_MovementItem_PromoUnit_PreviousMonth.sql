-- Function: gpInsertUpdate_MovementItem_PromoUnit_PreviousMonth()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoUnit_PreviousMonth (Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoUnit_PreviousMonth (
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbStatusId Integer;
   DECLARE vbUnitCategoryId Integer;
   DECLARE vbMovementId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION '�������� �� �������.';
    END IF;
    
    SELECT 
      Movement.StatusId, Movement.OperDate, MovementLinkObject_UnitCategory.ObjectId
    INTO
      vbStatusId, vbOperDate, vbUnitCategoryId
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                      ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                     AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

    WHERE Movement.Id = inMovementId;
            

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION '������.����������� ������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    SELECT 
      Movement.Id
    INTO
      vbMovementId
    FROM Movement

         INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                       ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                      AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
                                      AND MovementLinkObject_UnitCategory.ObjectId = vbUnitCategoryId

    WHERE Movement.DescId = zc_Movement_PromoUnit()
      AND Movement.OperDate = vbOperDate - INTERVAL '1 MONTH';
      
    IF COALESCE (vbMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.�� ������ �������� �� ��������� �� ���������� �����.';
    END IF;
    
    PERFORM lpInsertUpdate_MovementItem_PromoUnit(ioId                :=   COALESCE (MI_PromoUnitNew.Id, 0)
                                                , inMovementId        :=   inMovementId
                                                , inGoodsId           :=   MI_PromoUnit.ObjectId 
                                                , inAmount            :=   MI_PromoUnit.Amount
                                                , inAmountPlanMax     :=   COALESCE(MIFloat_AmountPlanMax.ValueData,0) 
                                                , inPrice             :=   COALESCE(tmpPrice.Price, 0)
                                                , inComment           :=   MIString_Comment.ValueData 
                                                , inisFixedPercent    :=   COALESCE (MIBoolean_FixedPercent.ValueData, FALSE)
                                                , inAddBonusPercent   :=   COALESCE (MIFloat_AddBonusPercent.ValueData , 0)
                                                , inPercPositionCheck :=   COALESCE (MIFloat_PercPositionCheck.ValueData , 0)
                                                , inUserId            :=   vbUserId    -- ������ ������������
                                                  )
    FROM MovementItem AS MI_PromoUnit

         LEFT JOIN MovementItemString AS MIString_Comment
                                      ON MIString_Comment.MovementItemId = MI_PromoUnit.Id
                                     AND MIString_Comment.DescId = zc_MIString_Comment()

         LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                     ON MIFloat_AmountPlanMax.MovementItemId = MI_PromoUnit.Id
                                    AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                                    
         LEFT JOIN (SELECT Price_Goods.ChildObjectId               AS GoodsId
                         , ROUND(SUM(CASE WHEN ObjectBoolean_Goods_TOP.ValueData = TRUE
                                           AND ObjectFloat_Goods_Price.ValueData > 0
                                          THEN ObjectFloat_Goods_Price.ValueData
                                          ELSE Price_Value.ValueData END) / COUNT(*), 2)::TFloat  AS Price 
                    FROM ObjectLink AS ObjectLink_Price_Unit
                         LEFT JOIN ObjectLink AS Price_Goods
                                ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                               AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                         LEFT JOIN ObjectFloat AS Price_Value
                                ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                               AND Price_Value.DescId =  zc_ObjectFloat_Price_Value()
                         -- ���� ���� ��� ���� ����
                         LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_Price
                                                ON ObjectFloat_Goods_Price.ObjectId = Price_Goods.ChildObjectId
                                               AND ObjectFloat_Goods_Price.DescId   = zc_ObjectFloat_Goods_Price()
                         LEFT JOIN ObjectBoolean AS ObjectBoolean_Goods_TOP
                                                 ON ObjectBoolean_Goods_TOP.ObjectId = Price_Goods.ChildObjectId
                                                AND ObjectBoolean_Goods_TOP.DescId   = zc_ObjectBoolean_Goods_TOP()
                    WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                      AND ObjectLink_Price_Unit.ChildObjectId in (SELECT ObjectLink.ObjectId 
                                                                  FROM ObjectLink 
                                                                  WHERE ObjectLink.DescId = zc_ObjectLink_Unit_Category() 
                                                                    AND ObjectLink.ChildObjectId = vbUnitCategoryId)
                     GROUP BY Price_Goods.ChildObjectId
                     ) AS tmpPrice ON tmpPrice.GoodsId = MI_PromoUnit.ObjectId 

         LEFT JOIN MovementItemFloat AS MIFloat_AddBonusPercent
                                     ON MIFloat_AddBonusPercent.MovementItemId = MI_PromoUnit.Id
                                    AND MIFloat_AddBonusPercent.DescId = zc_MIFloat_AddBonusPercent()
         LEFT JOIN MovementItemFloat AS MIFloat_PercPositionCheck
                                     ON MIFloat_PercPositionCheck.MovementItemId = MI_PromoUnit.Id
                                    AND MIFloat_PercPositionCheck.DescId = zc_MIFloat_PercPositionCheck()

         LEFT JOIN MovementItemBoolean AS MIBoolean_FixedPercent
                                       ON MIBoolean_FixedPercent.MovementItemId = MI_PromoUnit.Id
                                      AND MIBoolean_FixedPercent.DescId = zc_MIBoolean_FixedPercent()
                                      
         LEFT JOIN MovementItem AS MI_PromoUnitNew
                                ON MI_PromoUnitNew.MovementId = inMovementId
                               AND MI_PromoUnitNew.DescId = zc_MI_Master()
                               AND MI_PromoUnitNew.ObjectId  = MI_PromoUnit.ObjectId 
                               AND MI_PromoUnitNew.isErased = FALSE

     WHERE MI_PromoUnit.MovementId = vbMovementId
       AND MI_PromoUnit.DescId = zc_MI_Master()
       AND MI_PromoUnit.isErased = FALSE
       AND COALESCE (MI_PromoUnitNew.isErased, FALSE) = FALSE;      
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.01.22                                                       *
*/
-- ����
-- select * from gpInsertUpdate_MovementItem_PromoUnit_PreviousMonth(inMovementId := 31069272 ,  inSession := '3');