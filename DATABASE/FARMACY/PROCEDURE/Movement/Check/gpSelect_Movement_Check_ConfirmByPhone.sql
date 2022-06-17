-- Function: gpSelect_Movement_Check_ConfirmByPhone()

DROP FUNCTION IF EXISTS gpSelect_Movement_Check_ConfirmByPhone (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Check_ConfirmByPhone(
    IN inUnitId           Integer  ,  -- Подразделение
    IN inSession          TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer -- ключ документа
             , InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UnitId Integer    -- ключ аптеки
             , UnitName TVarChar -- название аптеки
             , IsDeferred Boolean
             , CashMember TVarChar -- ФИО менеджера
             , Bayer TVarChar      -- ФИО Покупателя
             , BayerPhone TVarChar -- Тел Покупателя
             , InvNumberOrder TVarChar  -- № заказа на сайте
             , ConfirmedKindName TVarChar
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
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         )

         SELECT       
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusId AS StatusCode
           , zc_Enum_Status_Erased() :: TVarChar AS StatusName
           , MovementLinkObject_Unit.ObjectId           AS UnitId
           , Object_Unit.ValueData                      AS UnitName
           , COALESCE (MovementBoolean_Deferred.ValueData, FALSE) :: Boolean AS IsDeferred
           , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND MovementLinkObject_CheckMember.ObjectId IS NULL THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
	       , COALESCE(Object_BuyerForSite.ValueData,
                      MovementString_Bayer.ValueData, '')::TVarChar              AS Bayer
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                       MovementString_BayerPhone.ValueData, '')::TVarChar        AS BayerPhone
           , COALESCE (MovementString_InvNumberOrder.ValueData, '')::TVarChar    AS InvNumberOrder
           , Object_ConfirmedKind.ValueData             AS ConfirmedKindName
        FROM Movement
        
             INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                           ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                          AND MovementLinkObject_ConfirmedKind.DescId     = zc_MovementLinkObject_ConfirmedKind()
                                          AND MovementLinkObject_ConfirmedKind.ObjectId   = zc_Enum_ConfirmedKind_Complete()
             INNER JOIN MovementBoolean AS MovementBoolean_ConfirmByPhone
                                        ON MovementBoolean_ConfirmByPhone.MovementId = Movement.Id
                                       AND MovementBoolean_ConfirmByPhone.DescId = zc_MovementBoolean_ConfirmByPhone()
                                       AND MovementBoolean_ConfirmByPhone.ValueData = True
                                          
             LEFT JOIN MovementBoolean AS MovementBoolean_ConfirmedByPhoneCall
                                       ON MovementBoolean_ConfirmedByPhoneCall.MovementId = Movement.Id
                                      AND MovementBoolean_ConfirmedByPhoneCall.DescId = zc_MovementBoolean_ConfirmedByPhoneCall()
                                          
             LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                       ON MovementBoolean_Deferred.MovementId = Movement.Id
			                          AND MovementBoolean_Deferred.DescId     = zc_MovementBoolean_Deferred()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                          ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                         AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
	         LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId

	         LEFT JOIN MovementString AS MovementString_Bayer
                                      ON MovementString_Bayer.MovementId = Movement.Id
                                     AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN MovementString AS MovementString_BayerPhone
                                      ON MovementString_BayerPhone.MovementId = Movement.Id
                                     AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

             LEFT JOIN Object AS Object_ConfirmedKind       ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

        WHERE Movement.OperDate > CURRENT_DATE - INTERVAL '30 DAY'
          AND Movement.DescId = zc_Movement_Check()
          AND Movement.StatusId = zc_Enum_Status_UnComplete()
          AND COALESCE(MovementBoolean_ConfirmedByPhoneCall.ValueData, False) = False
          AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0);

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

SELECT * FROM gpSelect_Movement_Check_ConfirmByPhone (inUnitId:= 4135547, inSession:= '3')
