-- Function: gpInsertUpdate_MovementItem_PromoUnit_PreviousMonth()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoUnit_PreviousMonth (Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoUnit_PreviousMonth (
    IN inMovementId        Integer   , -- Ключ объекта <Документ ЧЕК>
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS void
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbOperDate TDateTime;
   DECLARE vbStatusId Integer;
   DECLARE vbUnitCategory Integer;
   DECLARE vbMovementId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpGetUserBySession (inSession);

    IF COALESCE(inMovementId,0) = 0
    THEN
        RAISE EXCEPTION 'Документ не записан.';
    END IF;
    
    SELECT 
      Movement.StatusId, Movement.OperDate, MovementLinkObject_UnitCategory.ObjectId
    INTO
      vbStatusId, vbOperDate, vbUnitCategory
    FROM Movement

         LEFT JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                      ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                     AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()

    WHERE Movement.Id = inMovementId;
            

    IF vbStatusId <> zc_Enum_Status_UnComplete() 
    THEN
        RAISE EXCEPTION 'Ошибка.Копирование бонусов в статусе <%> не возможно.', lfGet_Object_ValueData (vbStatusId);
    END IF;

    SELECT 
      Movement.Id
    INTO
      vbMovementId
    FROM Movement

         INNER JOIN MovementLinkObject AS MovementLinkObject_UnitCategory
                                       ON MovementLinkObject_UnitCategory.MovementId = Movement.Id
                                      AND MovementLinkObject_UnitCategory.DescId = zc_MovementLinkObject_UnitCategory()
                                      AND MovementLinkObject_UnitCategory.ObjectId = vbUnitCategory

    WHERE Movement.DescId = zc_Movement_PromoUnit()
      AND Movement.OperDate = vbOperDate - INTERVAL '1 MONTH';
      
    IF COALESCE (vbMovementId, 0) = 0
    THEN
        RAISE EXCEPTION 'Ошибка.Не найден документ по категории за предыдущий месяц.';
    END IF;
    
    PERFORM lpInsertUpdate_MovementItem_PromoUnit(ioId              :=   COALESCE (MI_PromoUnitNew.Id, 0)
                                                , inMovementId      :=   inMovementId
                                                , inGoodsId         :=   MI_PromoUnit.ObjectId 
                                                , inAmount          :=   MI_PromoUnit.Amount
                                                , inAmountPlanMax   :=   COALESCE(MIFloat_AmountPlanMax.ValueData,0) 
                                                , inPrice           :=   COALESCE(MIFloat_Price.ValueData,0)
                                                , inComment         :=   MIString_Comment.ValueData 
                                                , inisFixedPercent  :=   COALESCE (MIBoolean_FixedPercent.ValueData, FALSE)
                                                , inAddBonusPercent :=   COALESCE (MIFloat_AddBonusPercent.ValueData , 0)
                                                , inUserId          :=   vbUserId    -- сессия пользователя
                                                  )
    FROM MovementItem AS MI_PromoUnit

         LEFT JOIN MovementItemString AS MIString_Comment
                                      ON MIString_Comment.MovementItemId = MI_PromoUnit.Id
                                     AND MIString_Comment.DescId = zc_MIString_Comment()

         LEFT JOIN MovementItemFloat AS MIFloat_AmountPlanMax
                                     ON MIFloat_AmountPlanMax.MovementItemId = MI_PromoUnit.Id
                                    AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
         LEFT JOIN MovementItemFloat AS MIFloat_Price
                                     ON MIFloat_Price.MovementItemId = MI_PromoUnit.Id
                                    AND MIFloat_Price.DescId = zc_MIFloat_Price()

         LEFT JOIN MovementItemFloat AS MIFloat_AddBonusPercent
                                     ON MIFloat_AddBonusPercent.MovementItemId = MI_PromoUnit.Id
                                    AND MIFloat_AddBonusPercent.DescId = zc_MIFloat_AddBonusPercent()

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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.01.22                                                       *
*/
-- тест
-- select * from gpInsertUpdate_MovementItem_PromoUnit_PreviousMonth(inMovementId := 31069272 ,  inSession := '3');