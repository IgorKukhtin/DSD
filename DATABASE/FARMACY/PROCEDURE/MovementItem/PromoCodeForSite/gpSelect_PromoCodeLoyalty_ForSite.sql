-- Function: gpSelect_PromoCodeLoyalty_ForSite()

DROP FUNCTION IF EXISTS gpSelect_PromoCodeLoyalty_ForSite (TVarChar, Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PromoCodeLoyalty_ForSite(
    IN inGUID          TVarChar,   -- Промо код
    IN inUnitID        Integer,    -- Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               DiscountAmount  TFloat
             , PromoCodeId     Integer
             , DateValid       TDateTime
             , SummRepay       TFloat
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
   DECLARE vbisElectron Boolean;
   DECLARE vbSummRepay TFloat;
BEGIN

      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);


    SELECT MovementItem.ID, 
           MovementItem.MovementID, 
           MovementItem.Amount, 
           MovementItem.isErased, 
           MovementItem.ParentId, 
           MovementFloat_MovementItemId.MovementId, 
           MIDate_OperDate.ValueData
    INTO vbMovementItemId, vbMovementId, vbDiscountAmount, vbisErased, vbParentId, vbMovementChackId, vbOperDate
    FROM MovementItem_Loyalty_GUID
         INNER JOIN MovementItem ON MovementItem.ID = MovementItem_Loyalty_GUID.MovementItemID
         LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                 ON MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                AND MovementFloat_MovementItemId.ValueData = MovementItem.ID
         LEFT JOIN MovementItemDate AS MIDate_OperDate
                                    ON MIDate_OperDate.MovementItemId = MovementItem.ID
                                   AND MIDate_OperDate.DescId = zc_MIDate_OperDate()
    WHERE MovementItem_Loyalty_GUID.GUID = inGUID;

    IF COALESCE(vbMovementChackId, 0) <> 0
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime,  0::TFloat, ('Продажа по промокоду '||COALESCE(inGUID, '')||' уже произведена.')::TVarChar;
      RETURN;
    END IF;

    IF COALESCE(vbMovementItemId, 0) = 0
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime,  0::TFloat, ('Промокод '||COALESCE(inGUID, '')||' не найден.')::TVarChar;
      RETURN;
    END IF;

    IF vbisErased = TRUE
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime,  0::TFloat, ('Промокод '||COALESCE(inGUID, '')||' удален.')::TVarChar;
      RETURN;
    END IF;

    SELECT Movement.InvNumber::Integer, 
           Movement.StatusId, 
           MovementDate_StartSale.ValueData, 
           MovementDate_EndSale.ValueData, 
           MovementFloat_MonthCount.ValueData::Integer,
           COALESCE(MovementBoolean_Electron.ValueData, FALSE) ::Boolean,
           COALESCE(MovementFloat_SummRepay.ValueData, 0)::TFloat
    INTO vbInvNumber, vbStatusId, vbStartSale, vbEndSale, vbMonthCount, vbisElectron, vbSummRepay
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
         LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                   ON MovementBoolean_Electron.MovementId =  Movement.Id
                                  AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
         LEFT JOIN MovementFloat AS MovementFloat_SummRepay
                                 ON MovementFloat_SummRepay.MovementId =  Movement.Id
                                AND MovementFloat_SummRepay.DescId = zc_MovementFloat_SummRepay()
    WHERE Movement.ID = vbMovementId;

    IF COALESCE(vbParentId, 0) = 0 AND vbisElectron = FALSE
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime,  0::TFloat, ('По промокоду '||COALESCE(inGUID, '')||' нет подтверждения продажи.')::TVarChar;
      RETURN;
    END IF;

    -- Если документ неподписан
    IF COALESCE(vbStatusId, 0) <> zc_Enum_Status_Complete()
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime,  0::TFloat, ('Документ "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' не найден.')::TVarChar;
      RETURN;
    END IF;

    -- Если неподходят даты
    IF vbStartSale > CURRENT_DATE OR vbEndSale < CURRENT_DATE
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime,  0::TFloat, ('Срок действия "Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' закончен.')::TVarChar;
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
      SELECT 0::TFloat, 0::Integer, Null::TDateTime,  0::TFloat, ('"Программы лояльности" по промокоду '||COALESCE(inGUID, '')||' на аптеку не распространяеться.')::TVarChar;
      RETURN;
    END IF;

    -- Если просрочен даты
    IF (vbOperDate + (vbMonthCount||' MONTH')::INTERVAL) < CURRENT_DATE
    THEN
      RETURN QUERY
      SELECT 0::TFloat, 0::Integer, Null::TDateTime,  0::TFloat, ('Срок действия промокода '||COALESCE(inGUID, '')||' закончен.')::TVarChar;
      RETURN;
    END IF;

    RETURN QUERY
    SELECT vbDiscountAmount, vbMovementItemId, (vbOperDate + (vbMonthCount||' MONTH' )::INTERVAL)::TDateTime, vbSummRepay, ''::TVarChar;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.11.19                                                       *
 */

-- zfCalc_FromHex

-- SELECT * FROM gpSelect_PromoCodeLoyalty_ForSite ('0720-4215-7340-3485', 0, '3');
-- SELECT DiscountAmount, PromoCodeId, DateValid, Error FROM gpSelect_PromoCodeLoyalty_ForSite (inGUID := '0720-4215-7340-3485', inUnitID := '0', inSession := zfCalc_UserSite());