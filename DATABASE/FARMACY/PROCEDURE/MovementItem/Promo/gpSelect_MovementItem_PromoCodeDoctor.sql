--- Function: gpSelect_MovementItem_PromoCodeDoctor()


--DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCodeDoctor (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_PromoCodeDoctor (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PromoCodeDoctor(
    IN inShowAll     Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id         Integer
             , GUID       TVarChar
             , BayerName  TVarChar
             , BayerPhone TVarChar
             , BayerEmail TVarChar
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

        RETURN QUERY
        WITH
        tmpMI AS (SELECT MI_Sign.Id
                       , CASE WHEN MI_Sign.Amount = 1 THEN TRUE ELSE FALSE END AS IsChecked
                       , MI_Sign.IsErased

                  FROM MovementItem AS MI_Sign
                  WHERE MI_Sign.MovementId = 16904771
                    AND MI_Sign.DescId = zc_MI_Sign()
                    AND MI_Sign.isErased = FALSE
                  )
      , tmpUse AS (SELECT DISTINCT MovementFloat.ValueData::Integer AS Id FROM MovementFloat WHERE MovementFloat.DescId = zc_MovementFloat_MovementItemId())  

           SELECT MI_Sign.Id
                , MIString_GUID.ValueData       ::TVarChar AS GUID
                , MIString_Bayer.ValueData      ::TVarChar AS BayerName
                , MIString_BayerPhone.ValueData ::TVarChar AS BayerPhone
                , MIString_BayerEmail.ValueData ::TVarChar AS BayerEmail

           FROM tmpMI AS MI_Sign

               LEFT JOIN MovementItemString AS MIString_GUID
                                            ON MIString_GUID.MovementItemId = MI_Sign.Id
                                           AND MIString_GUID.DescId = zc_MIString_GUID()
               LEFT JOIN MovementItemString AS MIString_Bayer
                                            ON MIString_Bayer.MovementItemId = MI_Sign.Id
                                           AND MIString_Bayer.DescId = zc_MIString_Bayer()
               LEFT JOIN MovementItemString AS MIString_BayerPhone
                                            ON MIString_BayerPhone.MovementItemId = MI_Sign.Id
                                           AND MIString_BayerPhone.DescId = zc_MIString_BayerPhone()
               LEFT JOIN MovementItemString AS MIString_BayerEmail
                                            ON MIString_BayerEmail.MovementItemId = MI_Sign.Id
                                           AND MIString_BayerEmail.DescId = zc_MIString_BayerEmail()
                                           
               LEFT JOIN tmpUse ON tmpUse.ID = MI_Sign.Id
           WHERE COALESCE(tmpUse.ID, 0) <> 0 OR inShowAll = TRUE;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 20.02.20                                                        *
*/


-- select * from gpSelect_MovementItem_PromoCodeDoctor(inShowAll := TRUE, inSession := '3');