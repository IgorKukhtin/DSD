-- Function: gpSelect_Movement_CheckVIP()

DROP FUNCTION IF EXISTS gpSelect_Movement_CheckVIP (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckVIP(
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (
  Id Integer, 
  InvNumber TVarChar, 
  OperDate TDateTime, 
  StatusId Integer,
  StatusCode Integer, 
  TotalCount TFloat, 
  TotalSumm TFloat, 
  UnitName TVarChar, 
  CashRegisterName TVarChar,
  CashMemberId Integer,
  CashMember TVarCHar,
  Bayer TVarChar,
  BayerPhone TVarChar,
  InvNumberOrder TVarChar,
  ConfirmedKindName TVarChar,
  ConfirmedKindClientName TVarChar,
  DiscountExternalId Integer,
  DiscountExternalName TVarChar,
  DiscountCardNumber TVarChar,
  PartnerMedicalId Integer,
  PartnerMedicalName TVarChar,
  Ambulance TVarChar,
  MedicSP TVarChar,
  InvNumberSP TVarChar,
  OperDateSP TDateTime,
  SPKindId Integer,
  SPKindName TVarChar,
  SPTax TFloat,
  Color_CalcDoc Integer,
  ManualDiscount Integer
 )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;   
     vbUnitId := vbUnitKey::Integer;

     RETURN QUERY
       WITH
           tmpStatus AS (SELECT zc_Enum_Status_UnComplete() AS StatusId UNION ALL SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE)
         , tmpMov AS (SELECT Movement.Id
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                      FROM MovementBoolean AS MovementBoolean_Deferred
                        INNER JOIN Movement ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                           AND Movement.DescId = zc_Movement_Check()
                        INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId
                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0 /*OR MovementLinkObject_Unit.MovementId = 3400557*/)
                                                     -- AND MovementLinkObject_Unit.ObjectId = vbUnitId
                      WHERE MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                        AND MovementBoolean_Deferred.ValueData = TRUE
                      )
      , tmpMI_all AS (SELECT tmpMov.Id AS MovementId, tmpMov.UnitId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                      FROM tmpMov
                           INNER JOIN MovementItem
                                   ON MovementItem.MovementId = tmpMov.Id
                                  AND MovementItem.DescId     = zc_MI_Master()
                                  AND MovementItem.isErased   = FALSE
                      GROUP BY tmpMov.Id, tmpMov.UnitId, MovementItem.ObjectId
                     )
          , tmpMI AS (SELECT tmpMI_all.UnitId, tmpMI_all.GoodsId, SUM (tmpMI_all.Amount) AS Amount
                      FROM tmpMI_all
                      GROUP BY tmpMI_all.UnitId, tmpMI_all.GoodsId
                     )
          , tmpRemains AS (SELECT tmpMI.GoodsId
                                , tmpMI.UnitId
                                , tmpMI.Amount           AS Amount_mi
                                , COALESCE (SUM (Container.Amount), 0) AS Amount_remains
                           FROM tmpMI
                                LEFT JOIN Container ON Container.DescId = zc_Container_Count()
                                                   AND Container.ObjectId = tmpMI.GoodsId
                                                   AND Container.WhereObjectId = tmpMI.UnitId
                                                   AND Container.Amount <> 0
                           GROUP BY tmpMI.GoodsId
                                  , tmpMI.UnitId
                                  , tmpMI.Amount
                           HAVING COALESCE (SUM (Container.Amount), 0) < tmpMI.Amount
                          )
          , tmpErr AS (SELECT DISTINCT tmpMov.Id AS MovementId
                       FROM tmpMov
                            INNER JOIN tmpMI_all ON tmpMI_all.MovementId = tmpMov.Id
                            INNER JOIN tmpRemains ON tmpRemains.GoodsId = tmpMI_all.GoodsId
                                                 AND tmpRemains.UnitId  = tmpMI_all.UnitId
                      )
         
       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , Movement.StatusId
            , Object_Status.ObjectCode                   AS StatusCode
            , MovementFloat_TotalCount.ValueData         AS TotalCount
            , MovementFloat_TotalSumm.ValueData          AS TotalSumm
            , Object_Unit.ValueData                      AS UnitName
            , Object_CashRegister.ValueData              AS CashRegisterName
            , MovementLinkObject_CheckMember.ObjectId    AS CashMemberId
            , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND COALESCE (Object_CashMember.ValueData, '') = '' THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
	    , MovementString_Bayer.ValueData             AS Bayer

            , MovementString_BayerPhone.ValueData        AS BayerPhone
            , MovementString_InvNumberOrder.ValueData    AS InvNumberOrder
            , Object_ConfirmedKind.ValueData             AS ConfirmedKindName
            , Object_ConfirmedKindClient.ValueData       AS ConfirmedKindClientName

	    , Object_DiscountExternal.Id                 AS DiscountExternalId
	    , Object_DiscountExternal.ValueData          AS DiscountExternalName
	    , Object_DiscountCard.ValueData              AS DiscountCardNumber

            , Object_PartnerMedical.Id                   AS PartnerMedicalId
            , Object_PartnerMedical.ValueData            AS PartnerMedicalName
            , MovementString_Ambulance.ValueData         AS Ambulance
            , MovementString_MedicSP.ValueData           AS MedicSP
            , MovementString_InvNumberSP.ValueData       AS InvNumberSP
            , COALESCE (MovementDate_OperDateSP.ValueData, zc_DateStart()) :: TDateTime AS OperDateSP

            , Object_SPKind.Id            AS SPKindId
            , Object_SPKind.ValueData     AS SPKindName
            , ObjectFloat_SPTax.ValueData AS SPTax

            , CASE WHEN Object_ConfirmedKind.Id = zc_Enum_ConfirmedKind_UnComplete() AND tmpErr.MovementId > 0 THEN 16440317 -- бледно крассный / розовый
                   WHEN Object_ConfirmedKind.Id = zc_Enum_ConfirmedKind_UnComplete() AND tmpErr.MovementId IS NULL THEN zc_Color_Yelow() -- желтый
                   ELSE zc_Color_White()
             END  AS Color_CalcDoc
            , MovementFloat_ManualDiscount.ValueData::Integer AS ManualDiscount

       FROM tmpMov
            LEFT JOIN tmpErr ON tmpErr.MovementId = tmpMov.Id 
            LEFT JOIN Movement ON Movement.Id = tmpMov.Id 
                               
                              
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                        
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

   	    INNER JOIN MovementBoolean AS MovementBoolean_Deferred
		                       ON MovementBoolean_Deferred.MovementId = Movement.Id
		                      AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
				      
            LEFT JOIN MovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckMember
                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
  	    LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId
  	    
            LEFT JOIN MovementLinkObject AS MovementLinkObject_DiscountCard
                                         ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                        AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
            LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                 ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
            LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
            LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

	    LEFT JOIN MovementString AS MovementString_Bayer
                                     ON MovementString_Bayer.MovementId = Movement.Id
                                    AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN MovementString AS MovementString_BayerPhone
                                      ON MovementString_BayerPhone.MovementId = Movement.Id
                                     AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

             LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                          ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                         AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
             LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                          ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement.Id
                                         AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId

             LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                          ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                         AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

             LEFT JOIN MovementString AS MovementString_Ambulance
                                      ON MovementString_Ambulance.MovementId = Movement.Id
                                     AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()
             LEFT JOIN MovementString AS MovementString_MedicSP
                                      ON MovementString_MedicSP.MovementId = Movement.Id
                                     AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
             LEFT JOIN MovementString AS MovementString_InvNumberSP
                                      ON MovementString_InvNumberSP.MovementId = Movement.Id
                                     AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
             LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                    ON MovementDate_OperDateSP.MovementId = Movement.Id
                                   AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_SPKind
                                         ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                        AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
            LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_SPTax
                                  ON ObjectFloat_SPTax.ObjectId = Object_SPKind.Id
                                 AND ObjectFloat_SPTax.DescId   = zc_ObjectFloat_SPKind_Tax()

            LEFT JOIN MovementFloat AS MovementFloat_ManualDiscount
                                    ON MovementFloat_ManualDiscount.MovementId =  Movement.Id
                                   AND MovementFloat_ManualDiscount.DescId = zc_MovementFloat_ManualDiscount()
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckVIP (Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 30.06.18                                                                                    *
 31.10.16         *
 10.08.16                                                                     * оптимизация
 07.04.16         * ушли от вьюхи
 12.09.2015                                                                   *[17:23] Кухтин Игорь: вторую кнопку закрыть и перекинуть их в запрос ВИП
 04.07.15                                                                     * 
*/

/*
update MovementBoolean set  ValueData = FALSE
from Movement 
where Movement.Id = MovementBoolean.MovementId
  AND Movement.StatusId <> zc_Enum_Status_UnComplete()
  AND Movement.DescId = zc_Movement_Check()
  AND MovementBoolean.DescId = zc_MovementBoolean_Deferred()
  AND Movement.OperDate < CURRENT_DATE - INTERVAL '1 DAY'
  AND ValueData = TRUE
*/
-- тест
-- SELECT * FROM gpSelect_Movement_CheckVIP (inIsErased := FALSE, inSession:= '3')
-- SELECT * FROM gpSelect_Movement_CheckVIP (inIsErased := FALSE, inSession:= '3')
