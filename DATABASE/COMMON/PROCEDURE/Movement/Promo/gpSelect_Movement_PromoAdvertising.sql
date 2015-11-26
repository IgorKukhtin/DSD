-- Function: gpSelect_Movement_PromoAdvertising()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoAdvertising (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoAdvertising(
    IN inMovementId    Integer , -- Ключ документа <Акция>
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id               Integer     --Идентификатор
             , AdvertisingId    Integer     --Рекламная поддержка
             , AdvertisingCode  Integer     --Рекламная поддержка
             , AdvertisingName  TVarChar    --Рекламная поддержка
             , Comment          TVarChar    --Примечание
             , isErased         Boolean     --Удален
      )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
        SELECT
            Movement_PromoAdvertising.Id                  --Идентификатор
          , Movement_PromoAdvertising.AdvertisingId           --Покупатель для акции
          , Movement_PromoAdvertising.AdvertisingCode::Integer--Покупатель для акции
          , Movement_PromoAdvertising.AdvertisingName         --Покупатель для акции
          , Movement_PromoAdvertising.Comment             --Примечание
          , Movement_PromoAdvertising.isErased            --Удален
        FROM
            Movement_PromoAdvertising_View AS Movement_PromoAdvertising
        WHERE
            Movement_PromoAdvertising.ParentId = inMovementId
            AND
            (
                Movement_PromoAdvertising.isErased = FALSE
                OR
                inIsErased = TRUE
            );

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_PromoAdvertising (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 17.11.15                                                                        *Contract
 05.11.15                                                                        *
*/