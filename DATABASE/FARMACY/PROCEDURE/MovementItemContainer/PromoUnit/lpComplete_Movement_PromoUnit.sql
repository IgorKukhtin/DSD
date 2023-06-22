-- Function: lpComplete_Movement_PromoUnit (Integer, Integer)

DROP FUNCTION IF EXISTS lpComplete_Movement_PromoUnit (Integer, Integer);

CREATE OR REPLACE FUNCTION lpComplete_Movement_PromoUnit(
    IN inMovementId        Integer  , -- ключ Документа
    IN inUserId            Integer    -- Пользователь
)                              
RETURNS VOID
AS
$BODY$
  DECLARE vbOperDate        TDateTime; -- Дата документа
  DECLARE vbUnitCategoryId  Integer;   -- Категория подразделения
  DECLARE vbMovementId      Integer;   -- ключ Документа следующего месяца
BEGIN

    SELECT Movement.OperDate                          AS OperDate
        , MovementLinkObject_UnitCategory.ObjectId    AS UnitCategoryId
    INTO vbOperDate, vbUnitCategoryId
    FROM Movement
         INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                      ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                     AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
    WHERE Movement.Id = inMovementId;
    
    IF COALESCE (vbUnitCategoryId, 0) <> 0 
    THEN
     
      IF NOT EXISTS(SELECT Movement.Id
                    FROM Movement
                         INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                                      ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                                     AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
                                                     AND MovementLinkObject_UnitCategory.ObjectId  = vbUnitCategoryId
                    WHERE Movement.DescId = zc_Movement_PromoUnit()
                      AND Movement.StatusId <> zc_Enum_Status_Erased()
                      AND Movement.OperDate = vbOperDate + INTERVAL '1 MONTH') 
      THEN
      
        vbMovementId := gpInsertUpdate_Movement_PromoUnit(ioId               := 0
                                                        , inInvNumber        := CAST (NEXTVAL ('movement_PromoUnit_seq') AS TVarChar)
                                                        , inOperDate         := vbOperDate + INTERVAL '1 MONTH'
                                                        , inPersonalId       := COALESCE (MovementLinkObject_Personal.ObjectId, 0)
                                                        , inUnitCategoryId   := MovementLinkObject_UnitCategory.ObjectId
                                                        , inComment          := COALESCE(MovementString_Comment.ValueData, '')
                                                        , inSession          := inUserId::TVarChar   -- сессия пользователя
                                                          )
                        FROM Movement
                        
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                          ON MovementLinkObject_Personal.MovementId = Movement.Id
                                                         AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()

                             INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                                           ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                                          AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

                             LEFT JOIN MovementString AS MovementString_Comment
                                                      ON MovementString_Comment.MovementId = Movement.Id
                                                     AND MovementString_Comment.DescId = zc_MovementString_Comment()
                                                    
                        WHERE Movement.Id = inMovementId;

        PERFORM lpInsertUpdate_MovementItem_PromoUnit(ioId                :=   COALESCE (MI_PromoUnitNew.Id, 0)
                                                    , inMovementId        :=   vbMovementId
                                                    , inGoodsId           :=   MI_PromoUnit.ObjectId 
                                                    , inAmount            :=   MI_PromoUnit.Amount
                                                    , inAmountPlanMax     :=   COALESCE(MIFloat_AmountPlanMax.ValueData,0) 
                                                    , inPrice             :=   COALESCE(tmpPrice.Price, 0)
                                                    , inComment           :=   MIString_Comment.ValueData 
                                                    , inisFixedPercent    :=   COALESCE (MIBoolean_FixedPercent.ValueData, FALSE)
                                                    , inAddBonusPercent   :=   COALESCE (MIFloat_AddBonusPercent.ValueData , 0)
                                                    , inPercPositionCheck :=   COALESCE (MIFloat_PercPositionCheck.ValueData , 0)
                                                    , inUserId            :=   inUserId    -- сессия пользователя
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
                             -- Фикс цена для всей Сети
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
                                    ON MI_PromoUnitNew.MovementId = vbMovementId
                                   AND MI_PromoUnitNew.DescId = zc_MI_Master()
                                   AND MI_PromoUnitNew.ObjectId  = MI_PromoUnit.ObjectId 
                                   AND MI_PromoUnitNew.isErased = FALSE

         WHERE MI_PromoUnit.MovementId = inMovementId
           AND MI_PromoUnit.DescId = zc_MI_Master()
           AND MI_PromoUnit.isErased = FALSE
           AND COALESCE (MI_PromoUnitNew.isErased, FALSE) = FALSE;      

      END IF;
    
    END IF;
     

    -- 5.2. ФИНИШ - Обязательно меняем статус документа + сохранили протокол
    PERFORM lpComplete_Movement (inMovementId := inMovementId
                               , inDescId     := zc_Movement_PromoUnit()
                               , inUserId     := inUserId
                                );

    -- пересчитали суммы по документу (для суммы закупки, которая считается после проведения документа)
    PERFORM lpInsertUpdate_MovementFloat_TotalSumm(inMovementId);
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Воробкало А.А.
 06.02.17         * 
*/

