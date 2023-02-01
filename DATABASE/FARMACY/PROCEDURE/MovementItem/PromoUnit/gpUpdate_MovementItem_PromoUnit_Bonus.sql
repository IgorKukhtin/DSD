-- Function: gpUpdate_MovementItem_PromoUnit_Bonus()

DROP FUNCTION IF EXISTS gpUpdate_MovementItem_PromoUnit_Bonus (Integer, TVarChar);
  
CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_PromoUnit_Bonus(
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
    
    PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_AddBonusPercent(), MI_PromoUnit.Id, COALESCE (MIFloat_AddBonusPercentPrew.ValueData , 0))
          , lpInsertUpdate_MovementItemBoolean(zc_MIBoolean_FixedPercent(), MI_PromoUnit.Id, COALESCE (MIBoolean_FixedPercentPrew.ValueData, FALSE))
          , lpInsert_MovementItemProtocol (MI_PromoUnit.Id, vbUserId, False)
    FROM MovementItem AS MI_PromoUnit

         LEFT JOIN MovementItemFloat AS MIFloat_AddBonusPercent
                                     ON MIFloat_AddBonusPercent.MovementItemId = MI_PromoUnit.Id
                                    AND MIFloat_AddBonusPercent.DescId = zc_MIFloat_AddBonusPercent()

         LEFT JOIN MovementItemBoolean AS MIBoolean_FixedPercent
                                       ON MIBoolean_FixedPercent.MovementItemId = MI_PromoUnit.Id
                                      AND MIBoolean_FixedPercent.DescId = zc_MIBoolean_FixedPercent()
                                      
         INNER JOIN MovementItem AS MI_PromoUnitPrew
                                 ON MI_PromoUnitPrew.MovementId = vbMovementId
                                AND MI_PromoUnitPrew.DescId = zc_MI_Master()
                                AND MI_PromoUnitPrew.ObjectId  = MI_PromoUnit.ObjectId 
                                AND MI_PromoUnitPrew.isErased = FALSE

         LEFT JOIN MovementItemFloat AS MIFloat_AddBonusPercentPrew
                                     ON MIFloat_AddBonusPercentPrew.MovementItemId = MI_PromoUnitPrew.Id
                                    AND MIFloat_AddBonusPercentPrew.DescId = zc_MIFloat_AddBonusPercent()

         LEFT JOIN MovementItemBoolean AS MIBoolean_FixedPercentPrew
                                       ON MIBoolean_FixedPercentPrew.MovementItemId = MI_PromoUnitPrew.Id
                                      AND MIBoolean_FixedPercentPrew.DescId = zc_MIBoolean_FixedPercent()

     WHERE MI_PromoUnit.MovementId = inMovementId
       AND MI_PromoUnit.DescId = zc_MI_Master()
       AND MI_PromoUnit.isErased = FALSE
       AND (COALESCE (MIFloat_AddBonusPercent.ValueData, 0) <> COALESCE (MIFloat_AddBonusPercentPrew.ValueData, 0) OR
           COALESCE (MIBoolean_FixedPercentPrew.ValueData, False) <> COALESCE (MIBoolean_FixedPercentPrew.ValueData, False));      
    
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.01.22                                                       *
*/
-- тест
-- select * from gpUpdate_MovementItem_PromoUnit_Bonus(inMovementId := 30890062 ,  inSession := '3');

