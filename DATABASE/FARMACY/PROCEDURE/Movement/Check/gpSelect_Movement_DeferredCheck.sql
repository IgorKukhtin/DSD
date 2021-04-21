-- Function: gpSelect_Movement_DeferredCheck()

DROP FUNCTION IF EXISTS gpSelect_Movement_DeferredCheck (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_DeferredCheck(
    IN inUnitId        Integer,    -- Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, 
               TotalCount TFloat, TotalSumm TFloat,
               Bayer TVarChar
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
         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , COALESCE(Object_BuyerForSite.ValueData,
                      MovementString_Bayer.ValueData)           AS Bayer
        FROM (SELECT Movement.*
                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
              FROM  MovementBoolean AS MovementBoolean_Deferred
              
                    INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                       AND Movement.DescId = zc_Movement_Check()
                                       AND Movement.StatusId = zc_Enum_Status_UnComplete()

                    LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()   
                                                 
                    WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                      AND MovementBoolean_Deferred.ValueData = TRUE
              ) AS Movement_Check 
              
             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
 
             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
	         LEFT JOIN MovementString AS MovementString_Bayer
                                      ON MovementString_Bayer.MovementId = Movement_Check.Id
                                     AND MovementString_Bayer.DescId = zc_MovementString_Bayer()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
                                  
        WHERE Movement_Check.UnitId = inUnitId

      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В. +
 21.04.21                                                       * add BuyerForSite
 19.07.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_DeferredCheck (inUnitId:= 472116 , inSession:= '3')
