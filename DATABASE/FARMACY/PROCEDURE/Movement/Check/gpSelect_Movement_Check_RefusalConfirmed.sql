-- Function: gpSelect_Movement_Check_RefusalConfirmed()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_RefusalConfirmed (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_RefusalConfirmed(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer -- ключ документа
             , InvNumber TVarChar, OperDate TDateTime, DateDelay TDateTime,  StatusCode Integer, StatusName TVarChar
             , UnitId Integer    -- ключ аптеки
             , UnitName TVarChar -- название аптеки
             , Bayer TVarChar      -- ФИО Покупателя
             , BayerPhone TVarChar -- Тел Покупателя
             , InvNumberOrder TVarChar  -- № заказа на сайте
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
     WITH
         tmpMovAll AS (SELECT Movement.*
                            , MovementDate_Delay.ValueData AS DateDelay
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_Delay
                                                       ON MovementBoolean_Delay.MovementId = Movement.Id
                                                      AND MovementBoolean_Delay.DescId    = zc_MovementBoolean_Delay()
                                                      AND MovementBoolean_Delay.ValueData = TRUE
                            LEFT JOIN MovementBoolean AS MovementBoolean_RefusalConfirmed
                                                      ON MovementBoolean_RefusalConfirmed.MovementId = Movement.Id
                                                     AND MovementBoolean_RefusalConfirmed.DescId    = zc_MovementBoolean_RefusalConfirmed()
                            LEFT JOIN MovementDate AS MovementDate_Delay
                                                   ON MovementDate_Delay.MovementId = Movement.Id
                                                  AND MovementDate_Delay.DescId = zc_MovementDate_Delay()
                                                     
                       WHERE Movement.DescId = zc_Movement_Check()
                         AND Movement.StatusId = zc_Enum_Status_Erased()
                         AND Movement.OperDate >= CURRENT_TIMESTAMP - INTERVAL '10 DAY'
                         AND MovementDate_Delay.ValueData  >= '21.06.2022'
                         AND COALESCE (MovementBoolean_RefusalConfirmed.ValueData, False) = False
                    )
       , tmpMov AS (SELECT Movement.*
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                      FROM tmpMovAll AS Movement

                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                     )
        , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject
                                    WHERE MovementLinkObject.MovementId in (select tmpMov.ID from tmpMov))

        SELECT 
               Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
             , Movement.DateDelay
             , Movement.StatusId AS StatusCode
             , zc_Enum_Status_Erased() :: TVarChar AS StatusName
             
             , Object_Unit.Id                      AS UnitId
             , Object_Unit.ValueData               AS UnitName

             , COALESCE(Object_BuyerForSite.ValueData,
                        MovementString_Bayer.ValueData)::TVarChar              AS Bayer
             , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                         MovementString_BayerPhone.ValueData)::TVarChar        AS BayerPhone

             , COALESCE(MovementString_InvNumberOrder.ValueData, MovementString_OrderId.ValueData) AS InvNumberOrder

        FROM tmpMov AS Movement

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckSourceKind
                                            ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                           AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                            ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                           AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                                                      
            LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                     ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                    AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                                     
            LEFT JOIN MovementString AS MovementString_OrderId
                                     ON MovementString_OrderId.MovementId = Movement.Id
                                    AND MovementString_OrderId.DescId = zc_MovementString_OrderId()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement.UnitId

            LEFT JOIN MovementString AS MovementString_Bayer
                                     ON MovementString_Bayer.MovementId = Movement.Id
                                    AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
            LEFT JOIN MovementString AS MovementString_BayerPhone
                                     ON MovementString_BayerPhone.MovementId = Movement.Id
                                    AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_BuyerForSite
                                            ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                           AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
            LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
            LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                   ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                  AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
                                   
        WHERE COALESCE (MovementString_InvNumberOrder.ValueData, '') <> ''
          AND COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = 0; 


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 16.06.22                                                       * 
*/

-- тест
-- 

SELECT * FROM gpSelect_Movement_Check_RefusalConfirmed (inUnitId:= 0, inSession:= '3')
        