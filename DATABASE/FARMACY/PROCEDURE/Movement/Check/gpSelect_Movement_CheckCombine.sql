-- Function: gpSelect_Movement_CheckCombine()

DROP FUNCTION IF EXISTS gpSelect_Movement_CheckCombine (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckCombine(
    IN inVIPOrder      TVarChar ,
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
   DECLARE Cursor3 refcursor;
   DECLARE Cursor4 refcursor;

   DECLARE vbID Integer;
   DECLARE vbBayer TVarChar;
   DECLARE vbBayerPhone TVarChar;
   DECLARE vbText TBlob;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
    vbUserId:= lpGetUserBySession (inSession);

    vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
    IF vbUnitKey = '' THEN
       vbUnitKey := '0';
    END IF;
    vbUnitId := vbUnitKey::Integer;
    
    vbSiteDiscount := COALESCE (gpGet_GlobalConst_SiteDiscount(inSession), 0);

   SELECT Movement.ID
        , Movement.Bayer
        , Movement.BayerPhone
   INTO vbID
      , vbBayer
      , vbBayerPhone
   FROM gpSelect_Movement_CheckVIP(inIsErased := FALSE, inSession:= inSession) as Movement 
        INNER JOIN MovementString AS MovementString_InvNumberOrder
                                  ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                 AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                                 AND MovementString_InvNumberOrder.ValueData <> ''
   WHERE Movement.InvNumberOrder = inVIPOrder;

   CREATE TEMP TABLE tmpMov ON COMMIT DROP AS (
       WITH
            tmpMovementCheck AS (SELECT Movement.Id
                                 FROM Movement
                                 WHERE Movement.DescId = zc_Movement_Check()
                                   AND Movement.StatusId = zc_Enum_Status_UnComplete())
          , tmpMovReserveId AS (
                             SELECT Movement.Id
                             FROM tmpMovementCheck AS Movement
                                  INNER JOIN MovementBoolean AS MovementBoolean_Deferred ON Movement.Id     = MovementBoolean_Deferred.MovementId
                                                             AND MovementBoolean_Deferred.DescId    = zc_MovementBoolean_Deferred()
                                                             AND MovementBoolean_Deferred.ValueData = TRUE)
          , tmpMov AS (SELECT Movement.Id
                            , MovementLinkObject_Unit.ObjectId            AS UnitId
                       FROM tmpMovReserveId AS Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                             ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                            AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                            AND MovementLinkObject_Unit.ObjectId = vbUnitId
                       )

        SELECT Movement.Id
             , Movement.UnitId
        FROM tmpMov AS Movement
             INNER JOIN MovementString AS MovementString_InvNumberOrder
                                       ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                      AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
                                      AND MovementString_InvNumberOrder.ValueData <> ''
             INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                           ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                          AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                          AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_Complete()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                          ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                         AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

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
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = MovementLinkObject_BuyerForSite.ObjectId
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

        WHERE COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = 0
          AND COALESCE (MovementString_InvNumberOrder.ValueData, '') <> ''
          AND COALESCE(ObjectString_BuyerForSite_Phone.ValueData, MovementString_BayerPhone.ValueData, '') <> '' 
          AND COALESCE(ObjectString_BuyerForSite_Phone.ValueData, MovementString_BayerPhone.ValueData) = vbBayerPhone
        );


    OPEN Cursor1 FOR (
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

            , zc_Color_White() AS Color_CalcDoc
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
            , CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) in (zc_Enum_CheckSourceKind_Tabletki(), zc_Enum_CheckSourceKind_Liki24()) THEN TRUE ELSE FALSE END AS isBanAdd
            , COALESCE(MovementBoolean_NotMCS.ValueData,FALSE)   AS isNotMCS
            , COALESCE(MovementBoolean_DiscountCommit.ValueData, False)    AS isDiscountCommit
       FROM tmpMov

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

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                    ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoCode
                                         ON MovementLinkObject_PromoCode.MovementId = Movement_PromoCode.Id
                                        AND MovementLinkObject_PromoCode.DescId = zc_MovementLinkObject_PromoCode()
            LEFT JOIN Object AS Object_PromoCode ON Object_PromoCode.Id = MovementLinkObject_PromoCode.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = Movement_PromoCode.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_ManualDiscount
                                    ON MovementFloat_ManualDiscount.MovementId =  Movement.Id
                                   AND MovementFloat_ManualDiscount.DescId = zc_MovementFloat_ManualDiscount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                         ON MovementLinkObject_MemberSP.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
            LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

   	        LEFT JOIN MovementBoolean AS MovementBoolean_Site
		                               ON MovementBoolean_Site.MovementId = Movement.Id
		                              AND MovementBoolean_Site.DescId = zc_MovementBoolean_Site()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()

            LEFT JOIN MovementDate AS MovementDate_Delay
                                   ON MovementDate_Delay.MovementId = Movement.Id
                                  AND MovementDate_Delay.DescId = zc_MovementDate_Delay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                         ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
            LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId

            LEFT JOIN MovementString AS MovementString_OrderId
                                     ON MovementString_OrderId.MovementId = Movement.Id
                                    AND MovementString_OrderId.DescId = zc_MovementString_OrderId()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_CheckSourceKind_Site
                                    ON ObjectBoolean_CheckSourceKind_Site.ObjectId = Object_CheckSourceKind.Id
                                   AND ObjectBoolean_CheckSourceKind_Site.DescId = zc_ObjectBoolean_CheckSourceKind_Site()

            LEFT JOIN MovementString AS MovementString_BookingId
                                     ON MovementString_BookingId.MovementId = Movement.Id
                                    AND MovementString_BookingId.DescId = zc_MovementString_BookingId()

            LEFT JOIN MovementBoolean AS MovementBoolean_NotMCS
                                      ON MovementBoolean_NotMCS.MovementId = Movement.Id
                                     AND MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()

            LEFT JOIN MovementBoolean AS MovementBoolean_DiscountCommit
                                      ON MovementBoolean_DiscountCommit.MovementId = Movement.Id
                                     AND MovementBoolean_DiscountCommit.DescId = zc_MovementBoolean_DiscountCommit()

       WHERE Movement.Id = vbID

       );

    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR (
        WITH
            tmpMI_all AS (SELECT MovementItem.Id, MovementItem.Amount, MovementItem.ObjectId, MovementItem.MovementId
                               , COALESCE (MIBoolean_Present.ValueData, False)          AS isPresent                               
                          FROM MovementItem
                               LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                                             ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                                            AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
                          WHERE MovementItem.MovementId in (SELECT DISTINCT tmpMov.Id FROM tmpMov WHERE tmpMov.Id = vbID)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                     )
          , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMBoolean AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov WHERE tmpMov.Id = vbID)
                          )
          , tmpOF_NDSKind_NDS AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId, ObjectFloat_NDSKind_NDS.valuedata FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                          )
          , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                , ObjectFloat_NDSKind_NDS.ValueData
                          FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                          WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
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
                                LEFT JOIN tmpMBoolean AS MB_RoundingTo10
                                                          ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                                LEFT JOIN tmpMBoolean AS MB_RoundingDown
                                                          ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
                                LEFT JOIN MovementBoolean AS MB_RoundingTo50
                                                          ON MB_RoundingTo50.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingTo50.DescId = zc_MovementBoolean_RoundingTo50()
                            )
           , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject 
                                 WHERE MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all))
           , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                       , Object_Object.Id                                          AS GoodsDiscountId
                                       , Object_Object.ValueData                                   AS GoodsDiscountName
                                       , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                       , MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                                       , MAX(ObjectFloat_DiscountProcent.ValueData)::TFloat        AS DiscountProcent 
                                    FROM Object AS Object_BarCode
                                        INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                              ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                             AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                        INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                        LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                             ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                            AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                        LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                                ON ObjectBoolean_GoodsForProject.ObjectId = Object_Object.Id 
                                                               AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()

                                        LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                              ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                             AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                        LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                                              ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                                             AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()

                                    WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                      AND Object_BarCode.isErased = False
                                    GROUP BY Object_Goods_Retail.GoodsMainId
                                           , Object_Object.Id
                                           , Object_Object.ValueData
                                           , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)
                                    HAVING MAX(ObjectFloat_DiscountProcent.ValueData) > 0)
           , tmpGoodsDiscountPrice AS (SELECT MovementItem.Id
                                            , CASE WHEN Object_Goods.isTop = TRUE
                                                    AND Object_Goods.Price > 0
                                                   THEN Object_Goods.Price
                                                   ELSE ObjectFloat_Price_Value.ValueData
                                                   END AS Price
                                            , tmpGoodsDiscount.DiscountProcent
                                            , tmpGoodsDiscount.MaxPrice
                                       FROM tmpGoodsDiscount
                                                    
                                            INNER JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = tmpGoodsDiscount.GoodsMainId
                                                    
                                            INNER JOIN tmpMI_Sum AS MovementItem ON MovementItem.ObjectId = Object_Goods.Id
                                
                                            INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                                  ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                                 AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                            INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                                  ON ObjectLink_Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                                                 AND ObjectLink_Price_Goods.ChildObjectId = Object_Goods.Id 
                                                                 AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                                  ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                 AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                            LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                                                    ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                   AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                       WHERE COALESCE(tmpGoodsDiscount.DiscountProcent, 0) > 0                                        
                                       )

       -- Результат
       SELECT
             MovementItem.Id          AS Id,
             MovementItem.MovementId  AS MovementId
           , MovementItem.ObjectId    AS GoodsId
           , Object_Goods_Main.ObjectCode  AS GoodsCode
           , Object_Goods_Main.Name   AS GoodsName
           , MovementItem.Amount      AS Amount
           , MovementItem.Price       AS Price
           , MovementItem.AmountSumm  AS Summ
           , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat  AS NDS
           , MovementItem.PriceSale              AS PriceSale
           , MovementItem.ChangePercent          AS ChangePercent
           , MovementItem.SummChangePercent      AS SummChangePercent
           , MovementItem.AmountOrder            AS AmountOrder
           , False                               AS isErased

           , zc_Color_White() AS Color_Calc

           , zc_Color_Black() AS Color_CalcError

           , Object_PartionDateKind.Id                                           AS PartionDateKindId
           , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
           , MovementItem.PricePartionDate                                       AS PricePartionDate
           , Object_Accommodation.ValueData                                      AS AccommodationName
           
           , 0::Integer                                                          AS TypeDiscount
           , COALESCE(MovementItem.PricePartionDate, MovementItem.PriceSale)     AS PriceDiscount
           , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId) AS  NDSKindId
           , Object_DiscountExternal.ID                                          AS DiscountCardId
           , Object_DiscountExternal.ValueData                                   AS DiscountCardName
           , Object_DivisionParties.Id                                           AS DivisionPartiesId 
           , Object_DivisionParties.ValueData                                    AS DivisionPartiesName 
           , MovementItem.isPresent                                              AS isPresent
           , Object_Goods_Main.Multiplicity                                      AS MultiplicitySale
           , Object_Goods_Main.isMultiplicityError                               AS isMultiplicityError
           , MILinkObject_Juridical.ObjectId                                     AS JuridicalId 
           , Object_Juridical.ValueData                                          AS JuridicalName
           , tmpGoodsDiscountPrice.DiscountProcent                               AS GoodsDiscountProcent
           , CASE WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 0 OR COALESCE(tmpGoodsDiscountPrice.Price, 0) = 0
                  THEN NULL
                  WHEN COALESCE(tmpGoodsDiscountPrice.MaxPrice, 0) = 0 OR tmpGoodsDiscountPrice.Price < tmpGoodsDiscountPrice.MaxPrice
                  THEN tmpGoodsDiscountPrice.Price 
                  ELSE tmpGoodsDiscountPrice.MaxPrice END :: TFLoat              AS PriceSaleDiscount
           , CASE WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 0 OR COALESCE(tmpGoodsDiscountPrice.Price, 0) = 0
                  THEN FALSE
                  WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 100 AND COALESCE (MovementItem.Price, 0) = 0
                  THEN TRUE
                  ELSE MovementItem.Price <
                      CASE WHEN COALESCE(tmpGoodsDiscountPrice.MaxPrice, 0) = 0 OR tmpGoodsDiscountPrice.Price < tmpGoodsDiscountPrice.MaxPrice
                           THEN tmpGoodsDiscountPrice.Price ELSE tmpGoodsDiscountPrice.MaxPrice END * 98 / 100
                  END :: BOOLEAN                                                 AS isPriceDiscount


       FROM tmpMI_Sum AS MovementItem

          LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

          LEFT JOIN tmpMILinkObject AS MILinkObject_NDSKind
                                           ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

          LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                               ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId)

          --Типы срок/не срок
          LEFT JOIN tmpMILinkObject AS MI_PartionDateKind
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

          LEFT JOIN tmpMILinkObject AS MILinkObject_DiscountExternal
                                           ON MILinkObject_DiscountExternal.MovementItemId = MovementItem.Id
                                          AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()
          LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = MILinkObject_DiscountExternal.ObjectId

          LEFT JOIN tmpMILinkObject AS MILinkObject_DivisionParties
                                           ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                          AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()
          LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = MILinkObject_DivisionParties.ObjectId

          LEFT JOIN tmpMILinkObject AS MILinkObject_Juridical
                                           ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Juridical.DescId         = zc_MILinkObject_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId

          LEFT JOIN tmpGoodsDiscountPrice ON tmpGoodsDiscountPrice.Id = MovementItem.Id
       );

    RETURN NEXT Cursor2;

    OPEN Cursor3 FOR (
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

            , zc_Color_White() AS Color_CalcDoc
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
            , CASE WHEN COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) in (zc_Enum_CheckSourceKind_Tabletki(), zc_Enum_CheckSourceKind_Liki24()) THEN TRUE ELSE FALSE END AS isBanAdd
            , COALESCE(MovementBoolean_NotMCS.ValueData,FALSE)   AS isNotMCS
            , True AS isCheckCombine
       FROM tmpMov

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

            LEFT JOIN MovementFloat AS MovementFloat_TotalSummChangePercent
                                    ON MovementFloat_TotalSummChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

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

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PromoCode
                                         ON MovementLinkObject_PromoCode.MovementId = Movement_PromoCode.Id
                                        AND MovementLinkObject_PromoCode.DescId = zc_MovementLinkObject_PromoCode()
            LEFT JOIN Object AS Object_PromoCode ON Object_PromoCode.Id = MovementLinkObject_PromoCode.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId = Movement_PromoCode.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_ManualDiscount
                                    ON MovementFloat_ManualDiscount.MovementId =  Movement.Id
                                   AND MovementFloat_ManualDiscount.DescId = zc_MovementFloat_ManualDiscount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_MemberSP
                                         ON MovementLinkObject_MemberSP.MovementId = Movement.Id
                                        AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
            LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

   	        LEFT JOIN MovementBoolean AS MovementBoolean_Site
		                               ON MovementBoolean_Site.MovementId = Movement.Id
		                              AND MovementBoolean_Site.DescId = zc_MovementBoolean_Site()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                  ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                                 AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()

            LEFT JOIN MovementDate AS MovementDate_Delay
                                   ON MovementDate_Delay.MovementId = Movement.Id
                                  AND MovementDate_Delay.DescId = zc_MovementDate_Delay()
            LEFT JOIN MovementFloat AS MovementFloat_TotalSummCard
                                    ON MovementFloat_TotalSummCard.MovementId = Movement.Id
                                   AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                         ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
            LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId

            LEFT JOIN MovementString AS MovementString_OrderId
                                     ON MovementString_OrderId.MovementId = Movement.Id
                                    AND MovementString_OrderId.DescId = zc_MovementString_OrderId()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_CheckSourceKind_Site
                                    ON ObjectBoolean_CheckSourceKind_Site.ObjectId = Object_CheckSourceKind.Id
                                   AND ObjectBoolean_CheckSourceKind_Site.DescId = zc_ObjectBoolean_CheckSourceKind_Site()

            LEFT JOIN MovementString AS MovementString_BookingId
                                     ON MovementString_BookingId.MovementId = Movement.Id
                                    AND MovementString_BookingId.DescId = zc_MovementString_BookingId()

            LEFT JOIN MovementBoolean AS MovementBoolean_NotMCS
                                      ON MovementBoolean_NotMCS.MovementId = Movement.Id
                                     AND MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()
       WHERE Movement.Id <> vbID

       );

    RETURN NEXT Cursor3;

    OPEN Cursor4 FOR (
        WITH
            tmpMI_all AS (SELECT MovementItem.Id, MovementItem.Amount, MovementItem.ObjectId, MovementItem.MovementId
                               , COALESCE (MIBoolean_Present.ValueData, False)          AS isPresent                               
                          FROM MovementItem
                               LEFT JOIN MovementItemBoolean AS MIBoolean_Present
                                                             ON MIBoolean_Present.MovementItemId = MovementItem.Id
                                                            AND MIBoolean_Present.DescId         = zc_MIBoolean_Present()
                          WHERE MovementItem.MovementId in (SELECT DISTINCT tmpMov.Id FROM tmpMov WHERE tmpMov.Id <> vbID)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                     )
          , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMBoolean AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMov.Id FROM tmpMov WHERE tmpMov.Id <> vbID)
                          )
          , tmpOF_NDSKind_NDS AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId, ObjectFloat_NDSKind_NDS.valuedata FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                          )
          , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                , ObjectFloat_NDSKind_NDS.ValueData
                          FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                          WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                         )
           , tmpMI_Sum AS (SELECT  MovementItem.*
                                 , MIFloat_Price.ValueData             AS Price
                                 , MIFloat_PriceSale.ValueData         AS PriceSale
                                 , MIFloat_ChangePercent.ValueData     AS ChangePercent
                                 , MIFloat_SummChangePercent.ValueData AS SummChangePercent
                                 , MIFloat_AmountOrder.ValueData       AS AmountOrder
                                 , MIFloat_MovementItem.ValueData      AS PricePartionDate
                                 , CASE WHEN COALESCE (MB_RoundingDown.ValueData, False) = True
                                      THEN TRUNC(COALESCE (MovementItem.Amount, 0) * MIFloat_Price.ValueData, 1)::TFloat
                                      ELSE CASE WHEN COALESCE (MB_RoundingTo10.ValueData, False) = True
                                      THEN (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 1))::TFloat
                                      ELSE (((COALESCE (MovementItem.Amount, 0)) * MIFloat_Price.ValueData)::NUMERIC (16, 2))::TFloat END END AS AmountSumm
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
                                LEFT JOIN tmpMBoolean AS MB_RoundingTo10
                                                          ON MB_RoundingTo10.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingTo10.DescId = zc_MovementBoolean_RoundingTo10()
                                LEFT JOIN tmpMBoolean AS MB_RoundingDown
                                                          ON MB_RoundingDown.MovementId = MovementItem.MovementId
                                                         AND MB_RoundingDown.DescId = zc_MovementBoolean_RoundingDown()
                            )
           , tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject 
                                 WHERE MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all))
           , tmpGoodsDiscount AS (SELECT Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                       , Object_Object.Id                                          AS GoodsDiscountId
                                       , Object_Object.ValueData                                   AS GoodsDiscountName
                                       , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)  AS isGoodsForProject
                                       , MAX(COALESCE(ObjectFloat_MaxPrice.ValueData, 0))::TFloat  AS MaxPrice 
                                       , MAX(ObjectFloat_DiscountProcent.ValueData)::TFloat        AS DiscountProcent 
                                    FROM Object AS Object_BarCode
                                        INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                              ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                             AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                        INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                        LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                             ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                            AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                        LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsForProject
                                                                ON ObjectBoolean_GoodsForProject.ObjectId = Object_Object.Id 
                                                               AND ObjectBoolean_GoodsForProject.DescId = zc_ObjectBoolean_DiscountExternal_GoodsForProject()

                                        LEFT JOIN ObjectFloat AS ObjectFloat_MaxPrice
                                                              ON ObjectFloat_MaxPrice.ObjectId = Object_BarCode.Id
                                                             AND ObjectFloat_MaxPrice.DescId = zc_ObjectFloat_BarCode_MaxPrice()
                                        LEFT JOIN ObjectFloat AS ObjectFloat_DiscountProcent
                                                              ON ObjectFloat_DiscountProcent.ObjectId = Object_BarCode.Id
                                                             AND ObjectFloat_DiscountProcent.DescId = zc_ObjectFloat_BarCode_DiscountProcent()

                                    WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                      AND Object_BarCode.isErased = False
                                    GROUP BY Object_Goods_Retail.GoodsMainId
                                           , Object_Object.Id
                                           , Object_Object.ValueData
                                           , COALESCE(ObjectBoolean_GoodsForProject.ValueData, False)
                                    HAVING MAX(ObjectFloat_DiscountProcent.ValueData) > 0)
           , tmpGoodsDiscountPrice AS (SELECT MovementItem.Id
                                            , CASE WHEN Object_Goods.isTop = TRUE
                                                    AND Object_Goods.Price > 0
                                                   THEN Object_Goods.Price
                                                   ELSE ObjectFloat_Price_Value.ValueData
                                                   END AS Price
                                            , tmpGoodsDiscount.DiscountProcent
                                            , tmpGoodsDiscount.MaxPrice
                                       FROM tmpGoodsDiscount
                                                    
                                            INNER JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.GoodsMainId = tmpGoodsDiscount.GoodsMainId
                                                    
                                            INNER JOIN tmpMI_Sum AS MovementItem ON MovementItem.ObjectId = Object_Goods.Id
                                
                                            INNER JOIN ObjectLink AS ObjectLink_Price_Unit
                                                                  ON ObjectLink_Price_Unit.DescId        = zc_ObjectLink_Price_Unit()
                                                                 AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId
                                            INNER JOIN ObjectLink AS ObjectLink_Price_Goods
                                                                  ON ObjectLink_Price_Goods.ObjectId      = ObjectLink_Price_Unit.ObjectId
                                                                 AND ObjectLink_Price_Goods.ChildObjectId = Object_Goods.Id 
                                                                 AND ObjectLink_Price_Goods.DescId        = zc_ObjectLink_Price_Goods()
                                            LEFT JOIN ObjectFloat AS ObjectFloat_Price_Value
                                                                  ON ObjectFloat_Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                 AND ObjectFloat_Price_Value.DescId = zc_ObjectFloat_Price_Value()
                                            LEFT JOIN ObjectBoolean AS ObjectBoolean_Top
                                                                    ON ObjectBoolean_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                                                   AND ObjectBoolean_Top.DescId = zc_ObjectBoolean_Price_Top()
                                       WHERE COALESCE(tmpGoodsDiscount.DiscountProcent, 0) > 0                                        
                                       )

       -- Результат
       SELECT
             MovementItem.Id          AS Id,
             MovementItem.MovementId  AS MovementId
           , MovementItem.ObjectId    AS GoodsId
           , Object_Goods_Main.ObjectCode  AS GoodsCode
           , Object_Goods_Main.Name   AS GoodsName
           , MovementItem.Amount      AS Amount
           , MovementItem.Price       AS Price
           , MovementItem.AmountSumm  AS Summ
           , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat  AS NDS
           , MovementItem.PriceSale              AS PriceSale
           , MovementItem.ChangePercent          AS ChangePercent
           , MovementItem.SummChangePercent      AS SummChangePercent
           , MovementItem.AmountOrder            AS AmountOrder
           , False                               AS isErased

           , zc_Color_White() AS Color_Calc

           , zc_Color_Black() AS Color_CalcError

           , Object_PartionDateKind.Id                                           AS PartionDateKindId
           , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
           , MovementItem.PricePartionDate                                       AS PricePartionDate
           , Object_Accommodation.ValueData                                      AS AccommodationName
           
           , 0::Integer                                                          AS TypeDiscount
           , COALESCE(MovementItem.PricePartionDate, MovementItem.PriceSale)     AS PriceDiscount
           , COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId) AS  NDSKindId
           , Object_DiscountExternal.ID                                          AS DiscountCardId
           , Object_DiscountExternal.ValueData                                   AS DiscountCardName
           , Object_DivisionParties.Id                                           AS DivisionPartiesId 
           , Object_DivisionParties.ValueData                                    AS DivisionPartiesName 
           , MovementItem.isPresent                                              AS isPresent
           , Object_Goods_Main.Multiplicity                                      AS MultiplicitySale
           , Object_Goods_Main.isMultiplicityError                               AS isMultiplicityError
           , MILinkObject_Juridical.ObjectId                                     AS JuridicalId 
           , Object_Juridical.ValueData                                          AS JuridicalName
           , tmpGoodsDiscountPrice.DiscountProcent                               AS GoodsDiscountProcent
           , CASE WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 0 OR COALESCE(tmpGoodsDiscountPrice.Price, 0) = 0
                  THEN NULL
                  WHEN COALESCE(tmpGoodsDiscountPrice.MaxPrice, 0) = 0 OR tmpGoodsDiscountPrice.Price < tmpGoodsDiscountPrice.MaxPrice
                  THEN tmpGoodsDiscountPrice.Price 
                  ELSE tmpGoodsDiscountPrice.MaxPrice END :: TFLoat              AS PriceSaleDiscount
           , CASE WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 0 OR COALESCE(tmpGoodsDiscountPrice.Price, 0) = 0
                  THEN FALSE
                  WHEN COALESCE (tmpGoodsDiscountPrice.DiscountProcent, 0) = 100 AND COALESCE (MovementItem.Price, 0) = 0
                  THEN TRUE
                  ELSE MovementItem.Price <
                      CASE WHEN COALESCE(tmpGoodsDiscountPrice.MaxPrice, 0) = 0 OR tmpGoodsDiscountPrice.Price < tmpGoodsDiscountPrice.MaxPrice
                           THEN tmpGoodsDiscountPrice.Price ELSE tmpGoodsDiscountPrice.MaxPrice END * 98 / 100
                  END :: BOOLEAN                                                 AS isPriceDiscount

       FROM tmpMI_Sum AS MovementItem

          LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

          LEFT JOIN tmpMILinkObject AS MILinkObject_NDSKind
                                           ON MILinkObject_NDSKind.MovementItemId = MovementItem.Id
                                          AND MILinkObject_NDSKind.DescId = zc_MILinkObject_NDSKind()

          LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                               ON ObjectFloat_NDSKind_NDS.ObjectId = COALESCE (MILinkObject_NDSKind.ObjectId, Object_Goods_Main.NDSKindId)

          --Типы срок/не срок
          LEFT JOIN tmpMILinkObject AS MI_PartionDateKind
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

          LEFT JOIN tmpMILinkObject AS MILinkObject_DiscountExternal
                                           ON MILinkObject_DiscountExternal.MovementItemId = MovementItem.Id
                                          AND MILinkObject_DiscountExternal.DescId         = zc_MILinkObject_DiscountExternal()
          LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = MILinkObject_DiscountExternal.ObjectId

          LEFT JOIN tmpMILinkObject AS MILinkObject_DivisionParties
                                           ON MILinkObject_DivisionParties.MovementItemId = MovementItem.Id
                                          AND MILinkObject_DivisionParties.DescId         = zc_MILinkObject_DivisionParties()
          LEFT JOIN Object AS Object_DivisionParties ON Object_DivisionParties.Id = MILinkObject_DivisionParties.ObjectId

          LEFT JOIN tmpMILinkObject AS MILinkObject_Juridical
                                           ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                          AND MILinkObject_Juridical.DescId         = zc_MILinkObject_Juridical()
          LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MILinkObject_Juridical.ObjectId

          LEFT JOIN tmpGoodsDiscountPrice ON tmpGoodsDiscountPrice.Id = MovementItem.Id
       );

    RETURN NEXT Cursor4;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckCombine (TVarChar, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 12.07.21                                                       *
*/

-- тест
--
--
SELECT * FROM gpSelect_Movement_CheckCombine (inVIPOrder := '350444', inSession:= '3')