-- Function: gpSelect_PromoCodeLoyalty_ForSite()

DROP FUNCTION IF EXISTS gpSelect_PromoCodeLoyalty_ForSite (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PromoCodeLoyalty_ForSite(
    IN inGUID          TVarChar,   -- Промо код
    IN inUnitID        Integer,    -- Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               DiscountAmount  TFloat
             , PromoCodeId     Integer
             , DateValid       TDateTime
             , Error           TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbMovementId Integer;
   DECLARE vbMovementItemId Integer;
   DECLARE vbDiscountAmount TFloat;
   DECLARE vbisErased Boolean;
   DECLARE vbParentId Integer;
   DECLARE vbOperDate TDateTime;

   DECLARE vbInvNumber Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbStartSale TDateTime;
   DECLARE vbEndSale TDateTime;
   DECLARE vbMovementChackId Integer;
   DECLARE vbMonthCount Integer;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    SELECT MovementItem.ID, MovementItem.MovementID, MovementItem.Amount, MovementItem.isErased, MovementItem.ParentId, MovementFloat_MovementItemId.MovementId, MIDate_OperDate.ValueData
    INTO vbMovementItemId, vbMovementId, vbDiscountAmount, vbisErased, vbParentId, vbMovementChackId, vbOperDate
    FROM MovementItemString
         INNER JOIN MovementItem ON MovementItem.ID = MovementItemString.MovementItemID
         LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                 ON MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                AND MovementFloat_MovementItemId.ValueData = MovementItem.ID
         LEFT JOIN MovementItemDate AS MIDate_OperDate
                                    ON MIDate_OperDate.MovementItemId = MovementItem.ID
                                   AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
    WHERE MovementItemString.DescId = zc_MIString_GUID()
      AND MovementItemString.ValueData = inGUID;

    IF COALESCE(vbMovementChackId, 0) <> 0
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime, ('Продажа по промокоду '||COALESCE(inGUID, '')||' уже произведена.')::TVarChar;
      RETURN;
    END IF;

    IF COALESCE(vbMovementItemId, 0) = 0
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime, ('Промокод '||COALESCE(inGUID, '')||' не найден.')::TVarChar;
      RETURN;
    END IF;

    IF vbisErased = TRUE
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime, ('Промокод '||COALESCE(inGUID, '')||' удален.')::TVarChar;
      RETURN;
    END IF;

    IF COALESCE(vbParentId, 0) = 0
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime, ('По промокоду '||COALESCE(inGUID, '')||' нет подтверждения продажи.')::TVarChar;
      RETURN;
    END IF;

    SELECT Movement.InvNumber::Integer, Movement.StatusId, MovementDate_StartSale.ValueData, MovementDate_EndSale.ValueData, MovementFloat_MonthCount.ValueData::Integer
    INTO vbInvNumber, vbStatusId, vbStartSale, vbEndSale, vbMonthCount
    FROM Movement
         LEFT JOIN MovementDate AS MovementDate_StartSale
                                ON MovementDate_StartSale.MovementId = Movement.Id
                               AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
         LEFT JOIN MovementDate AS MovementDate_EndSale
                                ON MovementDate_EndSale.MovementId = Movement.Id
                               AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
         LEFT JOIN MovementFloat AS MovementFloat_MonthCount
                                 ON MovementFloat_MonthCount.MovementId =  Movement.Id
                                AND MovementFloat_MonthCount.DescId = zc_MovementFloat_MonthCount()
    WHERE Movement.ID = vbMovementId;

    -- Если документ неподписан
    IF COALESCE(vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime, ('Документ "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' не найден.')::TVarChar;
      RETURN;
    END IF;

    -- Если неподходят даты
    IF vbStartSale > CURRENT_DATE OR vbEndSale < CURRENT_DATE
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime, ('Срок действия "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' закончен.')::TVarChar;
      RETURN;
    END IF;

    -- Если аптека невходит
    IF COALESCE(inUnitID, 0) <> 0 AND
       NOT EXISTS(SELECT 1 FROM MovementItem AS MI_Loyalty
                  WHERE MI_Loyalty.MovementId = vbMovementId
                    AND MI_Loyalty.DescId = zc_MI_Child()
                    AND MI_Loyalty.isErased = FALSE
                    AND MI_Loyalty.ObjectId = inUnitID)
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime, ('"Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' на аптеку не распространяеться.')::TVarChar;
      RETURN;
    END IF;

    -- Если просрочен даты
    IF (vbOperDate + (vbMonthCount||' MONTH')::INTERVAL) < CURRENT_DATE
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime, ('Срок действия промокода '||COALESCE(inGUID, '')||' закончен.')::TVarChar;
      RETURN;
    END IF;

    RETURN QUERY
    SELECT vbDiscountAmount, vbMovementItemId, (vbOperDate + (vbMonthCount||' MONTH' )::INTERVAL)::TDateTime, ''::TVarChar;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.11.19                                                       *
 */

-- zfCalc_FromHex

-- SELECT * FROM gpSelect_PromoCodeLoyalty_ForSite ('1119-A887-001F-A46F', '3');
-- SELECT DiscountAmount, PromoCodeId, DateValid, Error FROM gpSelect_PromoCodeLoyalty_ForSite (inGUID := '1119-2300-7A19-8EDC', inUnitID := '0', inSession := zfCalc_UserSite());