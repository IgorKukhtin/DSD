-- Function: gpSelect_Movement_isCheckCombine()

DROP FUNCTION IF EXISTS gpSelect_Movement_isCheckCombine (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_isCheckCombine (
    IN inVIPOrder         TVarChar ,
   OUT outIsCheckCombine Boolean,    -- 
   OUT outBayer           TVarChar,    -- 
   OUT outText            TBlob,    -- 
    IN inSession          TVarChar    -- сессия пользователя
)

RETURNS Record 
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbBayer TVarChar;
   DECLARE vbBayerPhone TVarChar;
   DECLARE vbID Integer;
   DECLARE vbConfirmedKindId Integer;
   DECLARE vbisNeBoley Boolean;
   DECLARE vbText TBlob;
BEGIN
-- if inSession = '3' then return; end if;


   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;
   
   outIsCheckCombine := False;
      
   SELECT Movement.ID
        , MovementLinkObject_ConfirmedKind.ObjectId
        , Movement.Bayer
        , Movement.BayerPhone
        , COALESCE (MovementString_InvNumberOrder.ValueData, '') <> ''
   INTO vbID
      , vbConfirmedKindId
      , vbBayer
      , vbBayerPhone
      , vbisNeBoley
   FROM gpSelect_Movement_CheckVIP(inIsErased := FALSE, inSession:= inSession) as Movement 
        LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                     ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                    AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
        LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                 ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
   WHERE Movement.InvNumberOrder = inVIPOrder;
     
--   raise notice 'Value 05: % %', vbBayer, vbBayerPhone;

   if COALESCE(vbID, 0) = 0
   THEN
     RAISE EXCEPTION 'Такого заказа нет';
   END IF;
   
   if COALESCE(vbConfirmedKindId, zc_Enum_ConfirmedKind_UnComplete()) = zc_Enum_ConfirmedKind_UnComplete()
   THEN
     RAISE EXCEPTION 'Данный заказ не подтвержден';
   END IF;
      
   IF vbisNeBoley = FALSE
   THEN
     RETURN;
   END IF;

   WITH tmpMovement AS (SELECT Movement_Check.Id                                      AS Id    
                             , Movement_Check.UnitId                                  AS UnitId
                             , COALESCE (MovementString_InvNumberOrder.ValueData, '') AS InvNumberOrder  
                             , Object_BuyerForSite.Id                                 AS BuyerForSiteId
                             , COALESCE(Object_BuyerForSite.ValueData,
                                        MovementString_Bayer.ValueData)               AS Bayer
                             , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                                         MovementString_BayerPhone.ValueData)         AS BayerPhone
                             , MovementFloat_TotalCount.ValueData                     AS TotalCount
                             , MovementFloat_TotalSumm.ValueData                      AS TotalSumm
                        FROM (SELECT Movement.*
                                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
                                   , COALESCE(MovementBoolean_Deferred.ValueData, False) AS IsDeferred
                              FROM Movement

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                 ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                                AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_Complete()

                                   INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                 ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()                                                                  

                                   LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                                             ON MovementBoolean_Deferred.MovementId = Movement.Id
                                                            AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                           
                              WHERE Movement.OperDate >= DATE_TRUNC ('DAY', CURRENT_DATE) - INTERVAL '5 DAY' 
                                AND Movement.DescId = zc_Movement_Check()
                                AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                AND COALESCE(MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                                AND Movement.ID <> vbID
                           ) AS Movement_Check

                             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                     ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

                             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                                     ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

                             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                      ON MovementString_InvNumberOrder.MovementId = Movement_Check.Id
                                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()


                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                         ON MovementLinkObject_CheckSourceKind.MovementId =  Movement_Check.Id
                                                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                                                                
                            LEFT JOIN MovementString AS MovementString_Bayer
                                                     ON MovementString_Bayer.MovementId = Movement_Check.Id
                                                    AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
                            LEFT JOIN MovementString AS MovementString_BayerPhone
                                                     ON MovementString_BayerPhone.MovementId = Movement_Check.Id
                                                    AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_BuyerForSite
                                                         ON MovementLinkObject_BuyerForSite.MovementId = Movement_Check.Id
                                                        AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
                            LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
                            LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                                   ON ObjectString_BuyerForSite_Phone.ObjectId = MovementLinkObject_BuyerForSite.ObjectId
                                                  AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()
                                                                
                            LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId
                        WHERE COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = 0
                          AND COALESCE (MovementString_InvNumberOrder.ValueData, '') <> ''
                          AND Movement_Check.UnitId  = vbUnitId
                          AND COALESCE(Object_BuyerForSite.ValueData, MovementString_Bayer.ValueData) = vbBayer
                          AND COALESCE (ObjectString_BuyerForSite_Phone.ValueData, MovementString_BayerPhone.ValueData) = vbBayerPhone

                        )
                              
   SELECT string_agg(tmpMovement.InvNumberOrder, ', ')
   INTO vbText
   FROM tmpMovement;
   
   outIsCheckCombine := COALESCE (vbText, '') <> '';
   outText := COALESCE (vbText, '');
   outBayer := vbBayer;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_isCheckCombine (TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.07.21                                                       *

*/

--тест
--
 SELECT * FROM gpSelect_Movement_isCheckCombine ('350444', '3');