-- Function: gpSelect_PromoCodeUnit_ForSite()

DROP FUNCTION IF EXISTS gpSelect_PromoCodeUnit_ForSite (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_PromoCodeUnit_ForSite (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_PromoCodeUnit_ForSite (
    IN inUnitID        Integer ,   -- Подразделение
    IN inGUID          TVarChar,   -- Промо код
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
               ObjectId Integer
             , ObjectName TVarChar
             , StartPromo    TDateTime
             , EndPromo      TDateTime
             , ChangePercent TFloat
             , PromoCodeId   Integer
             , PromoCodeName TVarChar
             , Comment       TVarChar
             , AllGoods      Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
    WITH
       tmpMovement_GUID AS (
          SELECT MI_Sign.MovementId AS MovementId
          FROM MovementItem AS MI_Sign 

            INNER JOIN MovementItemString AS MIString_GUID
                                          ON MIString_GUID.MovementItemId = MI_Sign.Id
                                         AND MIString_GUID.DescId = zc_MIString_GUID()
                                         AND MIString_GUID.ValueData = inGUID
          WHERE MI_Sign.DescId = zc_MI_Sign()
            AND MI_Sign.isErased = FALSE),

      tmpMovement AS (
         SELECT Movement.Id                                                    AS MovementId
              , MovementDate_StartPromo.ValueData                              AS StartPromo
              , MovementDate_EndPromo.ValueData                                AS EndPromo
              , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat      AS ChangePercent
              , MovementLinkObject_PromoCode.ObjectId                          AS PromoCodeId
              , Object_PromoCode.ValueData                                     AS PromoCodeName
              , MovementString_Comment.ValueData                               AS Comment
         FROM Movement

            INNER JOIN tmpMovement_GUID AS Movement_GUID ON Movement_GUID. MovementId = Movement.Id

            LEFT JOIN MovementDate AS MovementDate_StartPromo
                                   ON MovementDate_StartPromo.MovementId = Movement.Id
                                  AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
            LEFT JOIN MovementDate AS MovementDate_EndPromo
                                   ON MovementDate_EndPromo.MovementId = Movement.Id
                                  AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

            LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                      ON MovementBoolean_Electron.MovementId =  Movement.Id
                                     AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoCode
                                         ON MovementLinkObject_PromoCode.MovementId = Movement.Id
                                        AND MovementLinkObject_PromoCode.DescId = zc_MovementLinkObject_PromoCode()
            LEFT JOIN Object AS Object_PromoCode ON Object_PromoCode.Id = MovementLinkObject_PromoCode.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

         WHERE Movement.DescId = zc_Movement_PromoCode()
           AND Movement.StatusId = zc_Enum_Status_Complete()
           AND MovementDate_StartPromo.ValueData <= current_date
           AND MovementDate_EndPromo.ValueData >= current_date
--           AND COALESCE(MovementBoolean_Electron.ValueData, FALSE) = True
         ORDER BY MovementDate_StartPromo.ValueData LIMIT 1)

    SELECT

        Object_Object.Id                   AS ObjectId
      , Object_Object.ValueData            AS ObjectName
      , M_PromoCode.StartPromo
      , M_PromoCode.EndPromo
      , M_PromoCode.ChangePercent
      , M_PromoCode.PromoCodeId
      , M_PromoCode.PromoCodeName
      , M_PromoCode.Comment
      , CASE WHEN EXISTS(SELECT 1 FROM MovementItem AS L 
                     WHERE L.MovementId = M_PromoCode.MovementId
                       AND L.DescId = zc_MI_Master()
                       AND L.isErased = FALSE
                       AND COALESCE (L.Amount, 0) = 1 LIMIT 1) 
        THEN FALSE ELSE TRUE END           AS AllGoods  

    FROM tmpMovement AS M_PromoCode
        LEFT JOIN MovementItem AS MI_PromoCode ON MI_PromoCode.MovementId = M_PromoCode.MovementId
                               AND MI_PromoCode.DescId = zc_MI_Child()
                               AND MI_PromoCode.isErased = FALSE
                               AND COALESCE (MI_PromoCode.Amount, 0) = 1

        LEFT JOIN Object AS Object_Object ON Object_Object.Id = MI_PromoCode.ObjectId
                         AND (Object_Object.Id  = inUnitID or COALESCE(inUnitID, 0) = 0)
    WHERE (Object_Object.Id  = inUnitID or COALESCE(inUnitID, 0) = 0 
       AND EXISTS(SELECT * FROM MovementItem AS L 
                     WHERE L.MovementId = M_PromoCode.MovementId
                       AND L.DescId = zc_MI_Child()
                       AND L.isErased = FALSE
                       AND COALESCE (L.Amount, 0) = 1) 
       OR NOT EXISTS(SELECT * FROM MovementItem AS L 
                     WHERE L.MovementId = M_PromoCode.MovementId
                       AND L.DescId = zc_MI_Child()
                       AND L.isErased = FALSE
                       AND COALESCE (L.Amount, 0) = 1)) 
    ORDER BY Object_Object.Id;

END;

$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 03.12.18        *
 14.06.18        *
*/
-- SELECT * FROM gpSelect_PromoCodeUnit_ForSite('0', '7a604a6b', zfCalc_UserSite())
