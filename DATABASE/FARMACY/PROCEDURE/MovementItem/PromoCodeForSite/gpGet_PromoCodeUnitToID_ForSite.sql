-- Function: gpGet_PromoCodeUnitToID_ForSite()

DROP FUNCTION IF EXISTS gpGet_PromoCodeUnitToID_ForSite (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpGet_PromoCodeUnitToID_ForSite (Integer, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_PromoCodeUnitToID_ForSite (
    IN inUnitID        Integer ,   -- Подразделение
    IN inGUID          TVarChar,   -- Промо код
    IN inCheckUsage    Boolean,    -- Проверить использование
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               MovementID  Integer,
               MovementItemID  Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementID  Integer;
   DECLARE vbMovementItemID  Integer;
BEGIN
    vbUserId := inSession;

    SELECT MI_Sign.MovementId AS MovementId
         , MI_Sign.Id AS MovementItemId
    INTO vbMovementID
       , vbMovementItemID
    FROM MovementItem AS MI_Sign

        INNER JOIN MovementItemString AS MIString_GUID
                                      ON MIString_GUID.MovementItemId = MI_Sign.Id
                                     AND MIString_GUID.DescId = zc_MIString_GUID()
                                     AND MIString_GUID.ValueData = lower(inGUID)
    WHERE MI_Sign.DescId = zc_MI_Sign()
      AND MI_Sign.Amount = 1
      AND MI_Sign.isErased = FALSE;

    IF COALESCE (vbMovementItemID, 0) = 0
    THEN
     -- RAISE EXCEPTION 'Ошибка. Промокод <%> не найден или неактивен.', inGUID;
      RETURN;
    END IF;

    IF NOT EXISTS(SELECT Movement_Promo.Id
         FROM Movement AS Movement_Promo

            INNER JOIN MovementDate AS MovementDate_StartPromo
                                   ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
            INNER JOIN MovementDate AS MovementDate_EndPromo
                                   ON MovementDate_EndPromo.MovementId = Movement_Promo.Id
                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

            INNER JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId =  Movement_Promo.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

         WHERE Movement_Promo.ID = vbMovementID
           AND Movement_Promo.DescId = zc_Movement_PromoCode()
           AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
           AND MovementDate_StartPromo.ValueData <= current_date
           AND MovementDate_EndPromo.ValueData >= current_date
--           AND COALESCE(MovementBoolean_Electron.ValueData, FALSE) = True
)
    THEN
--      RAISE EXCEPTION 'Ошибка. Акция с промо кодом <%> закончена, неактивна или непредназначена для сайта.', inGUID;
      RETURN;
    END IF;

    IF inCheckUsage
    THEN
      IF EXISTS(SELECT MovementFloat.DescId FROM MovementFloat WHERE MovementFloat.DescId = zc_MovementFloat_MovementItemId()
                                                                 AND MovementFloat.ValueData =  vbMovementItemID)
      THEN
--        RAISE EXCEPTION 'Ошибка. Промокод <%> уже использован.', inGUID;
        RETURN;
      END IF;
    END IF;

    RETURN QUERY
      SELECT vbMovementID, vbMovementItemID;
END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 17.07.18        *
 15.06.18        *
*/
-- select * from gpGet_PromoCodeUnitToID_ForSite(183292, 'fc3202ed', False,  zfCalc_UserSite());