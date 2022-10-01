-- Function: gpSelect_Movement_CheckExpressVIPConfirm()

DROP FUNCTION IF EXISTS gpSelect_Movement_CheckExpressVIPConfirm (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckExpressVIPConfirm(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS SETOF refcursor
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbSiteDiscount TFloat;
   DECLARE Cursor1 refcursor;
   DECLARE Cursor2 refcursor;
   DECLARE vbExpressVIPConfirm Integer;
   DECLARE vbLanguage TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
     IF vbUnitKey = '' THEN
        vbUnitKey := '0';
     END IF;
     vbUnitId := vbUnitKey::Integer;

     SELECT COALESCE(ObjectFloat_CashSettings_ExpressVIPConfirm.ValueData, 0)::Integer   AS ExpressVIPConfirm
     INTO vbExpressVIPConfirm
     FROM Object AS Object_CashSettings
          LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_ExpressVIPConfirm
                                ON ObjectFloat_CashSettings_ExpressVIPConfirm.ObjectId = Object_CashSettings.Id 
                               AND ObjectFloat_CashSettings_ExpressVIPConfirm.DescId = zc_ObjectFloat_CashSettings_ExpressVIPConfirm()
     WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
     LIMIT 1;

     vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);

     SELECT COALESCE (ObjectString_Language.ValueData, 'RU')::TVarChar                AS Language
     INTO vbLanguage
     FROM Object AS Object_User
                 
          LEFT JOIN ObjectString AS ObjectString_Language
                 ON ObjectString_Language.ObjectId = Object_User.Id
                AND ObjectString_Language.DescId = zc_ObjectString_User_Language()
              
     WHERE Object_User.Id = vbUserId;    

     --raise notice 'Value 01: %', CLOCK_TIMESTAMP();


     CREATE TEMP TABLE tmpMov ON COMMIT DROP AS (
       WITH
            tmpMovementCheck AS (SELECT Movement.Id
                                 FROM Movement
                                 WHERE Movement.DescId = zc_Movement_Check()
                                   AND Movement.StatusId = zc_Enum_Status_UnComplete()
                                 )
          , tmpMovReserveId AS (
                             SELECT Movement.Id
                                  , COALESCE(MovementBoolean_Deferred.ValueData, FALSE) AS  isDeferred
                                  ,  MovementString_CommentError.ValueData              AS  CommentError
                             FROM tmpMovementCheck AS Movement
                                  LEFT JOIN MovementBoolean AS MovementBoolean_Deferred ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                            AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                  LEFT JOIN MovementString AS MovementString_CommentError ON Movement.Id     = MovementString_CommentError.MovementId
                                                          AND MovementString_CommentError.DescId = zc_MovementString_CommentError()
                                                          AND MovementString_CommentError.ValueData <> ''                             )

          , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject
                                      WHERE MovementLinkObject.MovementId in (select tmpMovReserveId.ID from tmpMovReserveId))

          , tmpMov AS (
                             SELECT Movement.Id
                                  , Movement.isDeferred
                                  , MovementLinkObject_Unit.ObjectId            AS UnitId
                                  , MovementLinkObject_ConfirmedKind.ObjectId   AS ConfirmedKindId
                                  , Movement.CommentError
                             FROM tmpMovReserveId AS Movement
                                  INNER JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                                                   ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                  AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                  AND MovementLinkObject_Unit.ObjectId = vbUnitId
                                  LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                  ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                                 AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                             WHERE isDeferred = TRUE OR COALESCE(CommentError, '') <> '')

        SELECT Movement.Id
             , Movement.isDeferred
             , Movement.UnitId
             , Movement.ConfirmedKindId
             , Movement.CommentError
             , MovementLinkObject_CheckSourceKind.ObjectId AS CheckSourceKindID
             , COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) 
               NOT IN (zc_Enum_CheckSourceKind_Liki24(), zc_Enum_CheckSourceKind_Tabletki())                  AS isShowVIP
             , COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Liki24()   AS isShowLiki24
             , COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Tabletki() AS isShowTabletki
        FROM tmpMov AS Movement
            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckSourceKind
                                            ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                           AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
        );
        
     --raise notice 'Value 02: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpErr ON COMMIT DROP AS (
     WITH
          tmpMI_All AS (SELECT MovementItem.MovementId AS MovementId, MovementItem.ObjectId AS GoodsId, MovementItem.Amount
                        FROM MovementItem
                        WHERE MovementItem.MovementId in (SELECT tmpMov.Id FROM tmpMov)
                          AND MovementItem.DescId     = zc_MI_Master()
                          AND MovementItem.isErased   = FALSE
                       )
        , tmpMI AS (SELECT MovementItem.MovementId AS MovementId, MovementItem.GoodsId AS GoodsId, SUM (MovementItem.Amount) AS Amount
                    FROM tmpMI_All AS MovementItem
                    GROUP BY MovementItem.MovementId, MovementItem.GoodsId
                   )
        , tmpMIConfirmedKind AS (SELECT tmpMI.GoodsId, SUM (tmpMI.Amount) AS Amount
                                 FROM tmpMI
                                      INNER JOIN tmpMov ON tmpMov.Id = tmpMI.MovementId
                                                       AND tmpMov.ConfirmedKindId = zc_Enum_ConfirmedKind_Complete() 
                                 GROUP BY tmpMI.GoodsId
                                )
        , tmpContainer AS (SELECT Container.ObjectId
                                , SUM(Container.Amount)  AS Amount
                           FROM Container 
                           WHERE Container.DescId = zc_Container_Count()
                             AND Container.ObjectId in (SELECT DISTINCT tmpMI.GoodsId FROM tmpMI)
                             AND Container.WhereObjectId = vbUnitId
                             AND Container.Amount <> 0
                           GROUP BY Container.ObjectId
                          )
        , tmpRemains AS (SELECT tmpMI.MovementId
                              , tmpMI.GoodsId
                              , tmpMI.Amount           AS Amount_mi
                              , COALESCE ((Container.Amount), 0) - COALESCE ((tmpMIConfirmedKind.Amount), 0) AS Amount_remains
                         FROM tmpMI

                              LEFT JOIN tmpMIConfirmedKind ON tmpMIConfirmedKind.GoodsId = tmpMI.GoodsId

                              LEFT JOIN tmpContainer AS Container 
                                                     ON Container.ObjectId = tmpMI.GoodsId

                         WHERE (COALESCE ( (Container.Amount), 0) - COALESCE ( (tmpMIConfirmedKind.Amount), 0)) < tmpMI.Amount
                        )
                        
    SELECT DISTINCT tmpMov.Id AS MovementId
     FROM tmpMov
          INNER JOIN tmpMI ON tmpMI.MovementId = tmpMov.Id
          INNER JOIN tmpRemains ON tmpRemains.MovementId = tmpMI.MovementId
                               AND tmpRemains.GoodsId = tmpMI.GoodsId);

    -- raise notice 'Value 03: %', CLOCK_TIMESTAMP();

    OPEN Cursor1 FOR (
        WITH
            tmpMovement AS (SELECT Movement.Id
                                 , Movement.isShowTabletki 
                                 , Movement.isShowLiki24
                            FROM tmpMov as Movement
                            
                                 LEFT JOIN tmpErr ON tmpErr.MovementId = Movement.Id

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                              ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                             AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()

                                 LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                                         ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                                        AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

                            WHERE Movement.isDeferred = True
                              --AND (False AND Movement.isShowVIP = TRUE OR Movement.isShowTabletki = TRUE)
                              AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_UnComplete() AND tmpErr.MovementId IS NULL AND 
                                  COALESCE(MovementFloat_TotalCount.ValueData, 0) > 0
                            )
          , tmpMICount AS (SELECT MovementItem.MovementId, COUNT(*) AS CountMI
                           FROM MovementItem
                           WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = FALSE
                           GROUP BY MovementItem.MovementId
                           )
          , tmpMovementBoolean AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          )
          , tmpMovementString AS (SELECT * FROM MovementString WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          )
          , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                          )

       SELECT Movement.Id
            , Movement.InvNumber
            , Movement.OperDate
            , Movement.StatusId
            , Object_Status.ObjectCode                   AS StatusCode
            , MovementFloat_TotalCount.ValueData         AS TotalCount
            , (MovementFloat_TotalSumm.ValueData - 
              CASE WHEN COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) = 0 
                    AND COALESCE(MovementFloat_MobileDiscount.ValueData, 0) > 0
                   THEN COALESCE(MovementFloat_MobileDiscount.ValueData, 0)
                   ELSE 0 END)::TFloat                   AS TotalSumm
            , Object_Unit.ValueData                      AS UnitName
            , Object_CashRegister.ValueData              AS CashRegisterName
            , MovementLinkObject_CheckMember.ObjectId    AS CashMemberId
            , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND COALESCE (Object_CashMember.ValueData, '') = '' THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
	        , COALESCE(Object_BuyerForSite.ValueData,
                      MovementString_Bayer.ValueData)             AS Bayer

            , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                       MovementString_BayerPhone.ValueData)       AS BayerPhone
            , COALESCE(MovementString_InvNumberOrder.ValueData,
              CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Tabletki() THEN MovementString_OrderId.ValueData
                   WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0 THEN Movement.Id::TVarChar END)::TVarChar   AS InvNumberOrder
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

            , CASE WHEN COALESCE(MovementBoolean_AutoVIPforSales.ValueData, False) = TRUE THEN zfCalc_Color (0, 255, 255)
                   WHEN Object_ConfirmedKind.Id = zc_Enum_ConfirmedKind_UnComplete() AND tmpErr.MovementId > 0 AND 
                        COALESCE(MovementFloat_TotalCount.ValueData, 0) > 0 THEN 16440317 -- бледно крассный / розовый
                   WHEN Object_ConfirmedKind.Id = zc_Enum_ConfirmedKind_UnComplete() AND tmpErr.MovementId IS NULL AND 
                        COALESCE(MovementFloat_TotalCount.ValueData, 0) > 0 THEN zc_Color_Yelow() -- желтый
                   ELSE zc_Color_White()
             END  AS Color_CalcDoc
            , MovementFloat_ManualDiscount.ValueData::Integer AS ManualDiscount

            , MI_PromoCode.Id AS PromoCodeID
            , Object_PromoCode.ValueData AS PromoName
            , MIString_GUID.ValueData AS PromoCodeGUID
            , CASE WHEN Movement_PromoCode.DescId <> zc_Movement_Loyalty() THEN
                   COALESCE(MovementFloat_ChangePercent.ValueData,0) END::TFloat AS PromoCodeChangePercent
            , Object_MemberSP.Id                                        AS MemberSPId
            , CASE WHEN COALESCE(MovementBoolean_Site.ValueData, False) = True THEN vbSiteDiscount ELSE 0 END::TFloat  AS SiteDiscount

            , Object_PartionDateKind.ID                         AS PartionDateKindId
            , Object_PartionDateKind.ValueData                  AS PartionDateKindName
            , ObjectFloat_Month.ValueData                       AS AmountMonth
            , MovementDate_Delay.ValueData                      AS DateDelay
            , CASE WHEN Movement_PromoCode.DescId = zc_Movement_Loyalty() THEN
                   CASE WHEN COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) < MI_PromoCode.Amount THEN
                      COALESCE(MovementFloat_TotalSummChangePercent.ValueData, 0) ELSE MI_PromoCode.Amount END ELSE NULL END::TFloat AS LoyaltyChangeSumma
            , MovementFloat_TotalSummCard.ValueData                        AS SummCard
            , CASE WHEN tmpMovement.isShowTabletki = TRUE THEN 'Таблетки' 
                   WHEN tmpMovement.isShowLiki24 = TRUE THEN 'Liki24' 
                   ELSE 'VIP' END::TVarChar  AS TypeChech
            , CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) in (zc_Enum_CheckSourceKind_Tabletki(), zc_Enum_CheckSourceKind_Liki24()) THEN TRUE ELSE FALSE END AS isBanAdd
            , COALESCE(MovementBoolean_DiscountCommit.ValueData, False)    AS isDiscountCommit

            , MovementString_CommentCustomer.ValueData                     AS CommentCustomer
            , COALESCE(MovementBoolean_AutoVIPforSales.ValueData, False)   AS isAutoVIPforSales
            , COALESCE(MovementBoolean_MobileApplication.ValueData, False)::Boolean   AS isMobileApplication
            , COALESCE(MovementFloat_MobileDiscount.ValueData, 0)::TFloat  AS MobileDiscount
            , COALESCE (MovementBoolean_MobileFirstOrder.ValueData, False)::Boolean    AS isMobileFirstOrder

       FROM tmpMovement
            LEFT JOIN tmpErr ON tmpErr.MovementId = tmpMovement.Id
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id


            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

   	        INNER JOIN tmpMovementBoolean AS MovementBoolean_Deferred
		                               ON MovementBoolean_Deferred.MovementId = Movement.Id
		                              AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                    ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CashRegister
                                         ON MovementLinkObject_CashRegister.MovementId = Movement.Id
                                        AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
            LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckMember
                                         ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                        AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()
  	        LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = MovementLinkObject_CheckMember.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_DiscountCard
                                         ON MovementLinkObject_DiscountCard.MovementId = Movement.Id
                                        AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
            LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                 ON ObjectLink_DiscountExternal.ObjectId = MovementLinkObject_DiscountCard.ObjectId
                                AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
            LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId
            LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

	        LEFT JOIN tmpMovementString AS MovementString_Bayer
                                     ON MovementString_Bayer.MovementId = Movement.Id
                                    AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN tmpMovementString AS MovementString_BayerPhone
                                      ON MovementString_BayerPhone.MovementId = Movement.Id
                                     AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

             LEFT JOIN tmpMovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                          ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                         AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
             LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                          ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement.Id
                                         AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PartnerMedical
                                          ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                         AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

             LEFT JOIN tmpMovementString AS MovementString_Ambulance
                                      ON MovementString_Ambulance.MovementId = Movement.Id
                                     AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()
             LEFT JOIN tmpMovementString AS MovementString_MedicSP
                                      ON MovementString_MedicSP.MovementId = Movement.Id
                                     AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
             LEFT JOIN tmpMovementString AS MovementString_InvNumberSP
                                      ON MovementString_InvNumberSP.MovementId = Movement.Id
                                     AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
             LEFT JOIN MovementDate AS MovementDate_OperDateSP
                                    ON MovementDate_OperDateSP.MovementId = Movement.Id
                                   AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_SPKind
                                         ON MovementLinkObject_SPKind.MovementId = Movement.Id
                                        AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
            LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId
            LEFT JOIN ObjectFloat AS ObjectFloat_SPTax
                                  ON ObjectFloat_SPTax.ObjectId = Object_SPKind.Id
                                 AND ObjectFloat_SPTax.DescId   = zc_ObjectFloat_SPKind_Tax()

            -- инфа из документа промо код
            LEFT JOIN MovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.MovementId = Movement.Id
                                   AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_PromoCode
                                   ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                  AND MI_PromoCode.isErased = FALSE
            LEFT JOIN Movement AS Movement_PromoCode ON Movement_PromoCode.Id = MI_PromoCode.MovementId
            LEFT JOIN Object AS Object_Status_PromoCode ON Object_Status_PromoCode.Id = Movement_PromoCode.StatusId

            LEFT JOIN MovementItemString AS MIString_GUID
                                         ON MIString_GUID.MovementItemId = MI_PromoCode.Id
                                        AND MIString_GUID.DescId = zc_MIString_GUID()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PromoCode
                                         ON MovementLinkObject_PromoCode.MovementId = Movement_PromoCode.Id
                                        AND MovementLinkObject_PromoCode.DescId = zc_MovementLinkObject_PromoCode()
            LEFT JOIN Object AS Object_PromoCode ON Object_PromoCode.Id = MovementLinkObject_PromoCode.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = Movement_PromoCode.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_ManualDiscount
                                    ON MovementFloat_ManualDiscount.MovementId =  Movement.Id
                                   AND MovementFloat_ManualDiscount.DescId = zc_MovementFloat_ManualDiscount()

            LEFT JOIN MovementFloat AS MovementFloat_MobileDiscount
                                    ON MovementFloat_MobileDiscount.MovementId =  Movement.Id
                                   AND MovementFloat_MobileDiscount.DescId = zc_MovementFloat_MobileDiscount()


            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_MemberSP
                                         ON MovementLinkObject_MemberSP.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
            LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

   	        LEFT JOIN tmpMovementBoolean AS MovementBoolean_Site
		                               ON MovementBoolean_Site.MovementId = Movement.Id
		                              AND MovementBoolean_Site.DescId = zc_MovementBoolean_Site()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()

            LEFT JOIN MovementDate AS MovementDate_Delay
                                   ON MovementDate_Delay.MovementId = Movement.Id
                                  AND MovementDate_Delay.DescId = zc_MovementDate_Delay()
            LEFT JOIN MovementDate AS MovementDate_Coming
                                   ON MovementDate_Coming.MovementId = Movement.Id
                                  AND MovementDate_Coming.DescId = zc_MovementDate_Coming()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckSourceKind
                                         ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
            LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId

            LEFT JOIN tmpMovementString AS MovementString_OrderId
                                     ON MovementString_OrderId.MovementId = Movement.Id
                                    AND MovementString_OrderId.DescId = zc_MovementString_OrderId()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_CheckSourceKind_Site
                                    ON ObjectBoolean_CheckSourceKind_Site.ObjectId = Object_CheckSourceKind.Id
                                   AND ObjectBoolean_CheckSourceKind_Site.DescId = zc_ObjectBoolean_CheckSourceKind_Site()

            LEFT JOIN tmpMovementString AS MovementString_BookingId
                                     ON MovementString_BookingId.MovementId = Movement.Id
                                    AND MovementString_BookingId.DescId = zc_MovementString_BookingId()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_DiscountCommit
                                      ON MovementBoolean_DiscountCommit.MovementId = Movement.Id
                                     AND MovementBoolean_DiscountCommit.DescId = zc_MovementBoolean_DiscountCommit()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_MobileApplication
                                      ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                     AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
            LEFT JOIN MovementBoolean AS MovementBoolean_ConfirmByPhone
                                      ON MovementBoolean_ConfirmByPhone.MovementId = Movement.Id
                                     AND MovementBoolean_ConfirmByPhone.DescId = zc_MovementBoolean_ConfirmByPhone()

            LEFT JOIN tmpMovementString AS MovementString_CommentCustomer
                                     ON MovementString_CommentCustomer.MovementId = Movement.Id
                                    AND MovementString_CommentCustomer.DescId = zc_MovementString_CommentCustomer()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_AutoVIPforSales
                                      ON MovementBoolean_AutoVIPforSales.MovementId = Movement.Id
                                     AND MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_MobileFirstOrder
                                      ON MovementBoolean_MobileFirstOrder.MovementId = Movement.Id
                                     AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()
                                     
            LEFT JOIN tmpMICount ON tmpMICount.MovementId = Movement.Id
            
       WHERE tmpMICount.CountMI <= vbExpressVIPConfirm

       );

    RETURN NEXT Cursor1;
    
    OPEN Cursor2 FOR (
        WITH
            tmpMovement AS (SELECT Movement.Id
                            FROM tmpMov as Movement
                                 LEFT JOIN tmpErr ON tmpErr.MovementId = Movement.Id

                                 LEFT JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                              ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                                             AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()

                            WHERE Movement.isDeferred = True
                              --AND (False AND Movement.isShowVIP = TRUE OR Movement.isShowTabletki = TRUE)
                              AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_UnComplete() AND tmpErr.MovementId IS NULL 
                            )
           , tmpMI_all AS (SELECT MovementItem.Id
                               , MovementItem.Amount
                               , MovementItem.ObjectId
                               , MovementItem.MovementId
                          FROM MovementItem
                          WHERE MovementItem.MovementId in (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                     )
          , tmpMI AS (SELECT tmpMI_all.MovementId, tmpMov.UnitId, tmpMI_all.ObjectId AS GoodsId, SUM (tmpMI_all.Amount) AS Amount
                      FROM tmpMI_all
                           INNER JOIN tmpMov ON tmpMov.ID = tmpMI_all.MovementId
                      WHERE tmpMov.CommentError <> '' OR tmpMov.ConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete()
                      GROUP BY tmpMI_all.MovementId, tmpMov.UnitId, tmpMI_all.ObjectId
                     )
          , tmpMIConfirmedKind AS (SELECT tmpMov.UnitId, tmpMI_all.ObjectId AS GoodsId, SUM (tmpMI_all.Amount) AS Amount
                                   FROM tmpMI_all
                                        INNER JOIN tmpMov ON tmpMov.ID = tmpMI_all.MovementId
                                        INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                                                      ON MovementLinkObject_ConfirmedKind.MovementId = tmpMI_all.MovementId
                                                                     AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                                                     AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_Complete() 
                                   GROUP BY tmpMov.UnitId, tmpMI_all.ObjectId
                                  )
          , tmpMovementBoolean AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMI_all.MovementId FROM tmpMI_all)
                          )
          , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMIString AS (SELECT * FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
           , tmpMI_Sum AS (SELECT  MovementItem.*
                                 , MIFloat_Price.ValueData             AS Price
                                 , MIFloat_PriceSale.ValueData         AS PriceSale
                                 , MIFloat_ChangePercent.ValueData     AS ChangePercent
                                 , MIFloat_SummChangePercent.ValueData AS SummChangePercent
                                 , MIFloat_AmountOrder.ValueData       AS AmountOrder
                                 , MIFloat_MovementItem.ValueData      AS PricePartionDate
                                 , zfCalc_SummaCheck(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData
                                                   , COALESCE (MB_RoundingDown.ValueData, False)
                                                   , COALESCE (MB_RoundingTo10.ValueData, False)
                                                   , COALESCE (MB_RoundingTo50.ValueData, False)) AS AmountSumm
                                 , MIString_UID.ValueData              AS List_UID
                             FROM tmpMI_all AS MovementItem

                                LEFT JOIN tmpMIFloat AS MIFloat_AmountOrder
                                                            ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                                           AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                                LEFT JOIN tmpMIFloat AS MIFloat_Price
                                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                LEFT JOIN tmpMIFloat AS MIFloat_PriceSale
                                                            ON MIFloat_PriceSale.MovementItemId = MovementItem.Id
                                                           AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                LEFT JOIN tmpMIFloat AS MIFloat_ChangePercent
                                                            ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                LEFT JOIN tmpMIFloat AS MIFloat_SummChangePercent
                                                            ON MIFloat_SummChangePercent.MovementItemId = MovementItem.Id
                                                           AND MIFloat_SummChangePercent.DescId = zc_MIFloat_SummChangePercent()
                                LEFT JOIN tmpMIFloat AS MIFloat_MovementItem
                                                            ON MIFloat_MovementItem.MovementItemId = MovementItem.Id
                                                           AND MIFloat_MovementItem.DescId = zc_MIFloat_PricePartionDate()
                                LEFT JOIN tmpMovementBoolean AS MB_RoundingTo10
                                                          ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                                LEFT JOIN tmpMovementBoolean AS MB_RoundingDown
                                                          ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
                                LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                                          ON MB_RoundingTo50.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()
                                LEFT JOIN tmpMIString AS MIString_UID
                                                             ON MIString_UID.MovementItemId = MovementItem.Id
                                                            AND MIString_UID.DescId = zc_MIString_UID()
                            )


       -- Результат
       SELECT
             MovementItem.Id          AS Id,
             MovementItem.MovementId  AS MovementId
           , MovementItem.ObjectId    AS GoodsId
           , Object_Goods_Main.ObjectCode  AS GoodsCode
           , CASE WHEN vbLanguage = 'UA' AND COALESCE(Object_Goods_Main.NameUkr, '') <> ''
                  THEN Object_Goods_Main.NameUkr
                  ELSE Object_Goods_Main.Name END   AS GoodsName
           , MovementItem.Amount      AS Amount
           , MovementItem.Price       AS Price
           , MovementItem.AmountSumm  AS Summ
           , MovementItem.PriceSale              AS PriceSale
           , MovementItem.ChangePercent          AS ChangePercent
           , MovementItem.SummChangePercent      AS SummChangePercent
           , MovementItem.AmountOrder            AS AmountOrder
           , MovementItem.List_UID               AS List_UID
           , False                               AS isErased

           , zc_Color_White()                     AS Color_Calc

           , Object_PartionDateKind.Id                                           AS PartionDateKindId
           , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
           , MovementItem.PricePartionDate                                       AS PricePartionDate
           , COALESCE (ObjectFloat_Month.ValueData, 0) :: TFLoat                 AS AmountMonth
           , Object_Accommodation.ValueData                                      AS AccommodationName
           
       FROM tmpMI_Sum AS MovementItem

          INNER JOIN tmpMov AS Movement ON Movement.ID = MovementItem.MovementId

          LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

          --Типы срок/не срок
          LEFT JOIN MovementItemLinkObject AS MI_PartionDateKind
                                           ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                          AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
          LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_PartionDateKind.ObjectId
                                                    AND Object_PartionDateKind.DescId = zc_Object_PartionDateKind()

          LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                               AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()

          LEFT OUTER JOIN AccommodationLincGoods AS Accommodation
                                                 ON Accommodation.UnitId = vbUnitId
                                                AND Accommodation.GoodsId = MovementItem.ObjectId 
                                                AND Accommodation.isErased = False
          -- Размещение товара
          LEFT JOIN Object AS Object_Accommodation  ON Object_Accommodation.ID = Accommodation.AccommodationId


    );

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckExpressVIPConfirm (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.22                                                       * 
*/

-- тест
--

select * from gpSelect_Movement_CheckExpressVIPConfirm(inSession := '3');