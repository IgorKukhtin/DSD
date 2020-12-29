-- Function: gpSelect_Movement_CheckDelayDeferred()

DROP FUNCTION IF EXISTS gpSelect_Movement_CheckDelayDeferred (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_CheckDelayDeferred(
    IN inType          Integer,    -- 0 - все 1 - VIP 2 - Tabletki 3 - Liki24
    IN inIsShowAll     Boolean,    -- за последнии 10 дней
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

     CREATE TEMP TABLE tmpMov ON COMMIT DROP AS (
     WITH
         tmpMovAll AS (SELECT Movement.Id
                       FROM Movement
                            INNER JOIN MovementBoolean AS MovementBoolean_Delay
                                                       ON Movement.Id = MovementBoolean_Delay.MovementId
                                                      AND MovementBoolean_Delay.DescId    = zc_MovementBoolean_Delay()
                                                      AND MovementBoolean_Delay.ValueData = TRUE
                       WHERE Movement.DescId = zc_Movement_Check()
                         AND zc_Enum_Status_Erased() = Movement.StatusId
                    )
       , tmpMov AS (SELECT Movement.Id
                           , MovementLinkObject_Unit.ObjectId AS UnitId
                      FROM tmpMovAll AS Movement

                        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                     AND (MovementLinkObject_Unit.ObjectId = vbUnitId OR vbUnitId = 0)
                     )
        , tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject
                                    WHERE MovementLinkObject.MovementId in (select tmpMov.ID from tmpMov))

        SELECT Movement.Id
             , Movement.UnitId
             , MovementLinkObject_ConfirmedKind.ObjectId   AS ConfirmedKindId
             , MovementLinkObject_CheckSourceKind.ObjectId AS CheckSourceKindID
             , COALESCE (ObjectBoolean_CheckSourceKind_Site.ValueData, FALSE) AS isShowSite
        FROM tmpMov AS Movement

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckSourceKind
                                            ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                           AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_CheckSourceKind_Site
                                    ON ObjectBoolean_CheckSourceKind_Site.ObjectId = MovementLinkObject_CheckSourceKind.ObjectId
                                   AND ObjectBoolean_CheckSourceKind_Site.DescId = zc_ObjectBoolean_CheckSourceKind_Site()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                            ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                           AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
        WHERE (inType = 0 OR
               inType = 1 AND COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) 
                          NOT IN (zc_Enum_CheckSourceKind_Liki24(), zc_Enum_CheckSourceKind_Tabletki())  OR
               inType = 2 AND COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Tabletki() OR
               inType in (1, 3) AND COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = zc_Enum_CheckSourceKind_Liki24())
        );

    OPEN Cursor1 FOR (
       WITH
            tmpMI_all AS (SELECT tmpMov.Id AS MovementId, tmpMov.UnitId, MovementItem.ObjectId AS GoodsId, SUM (MovementItem.Amount) AS Amount
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

            , CASE WHEN Object_ConfirmedKind.Id = zc_Enum_ConfirmedKind_UnComplete() AND tmpErr.MovementId > 0 THEN 16440317 -- бледно крассный / розовый
                   WHEN Object_ConfirmedKind.Id = zc_Enum_ConfirmedKind_UnComplete() AND tmpErr.MovementId IS NULL THEN zc_Color_Yelow() -- желтый
                   ELSE zc_Color_White()
             END  AS Color_CalcDoc
            , MovementFloat_ManualDiscount.ValueData::Integer AS ManualDiscount

            , MI_PromoCode.Id AS PromoCodeID
            , Object_PromoCode.ValueData AS PromoName
            , MIString_GUID.ValueData AS PromoCodeGUID
            , COALESCE(MovementFloat_ChangePercent.ValueData,0)::TFloat AS PromoCodeChangePercent
            , Object_MemberSP.Id                                        AS MemberSPId
            , CASE WHEN COALESCE(MovementBoolean_Site.ValueData, False) = True THEN vbSiteDiscount ELSE 0 END::TFloat  AS SiteDiscount

            , Object_PartionDateKind.ID                     AS PartionDateKindId
            , Object_PartionDateKind.ValueData              AS PartionDateKindName
            , MovementDate_Delay.ValueData                  AS DateDelay
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

            LEFT JOIN MovementDate AS MovementDate_Delay
                                   ON MovementDate_Delay.MovementId = Movement.Id
                                  AND MovementDate_Delay.DescId = zc_MovementDate_Delay()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PartionDateKind
                                         ON MovementLinkObject_PartionDateKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PartionDateKind.DescId = zc_MovementLinkObject_PartionDateKind()
            LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MovementLinkObject_PartionDateKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                         ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                        AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
            LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId

            LEFT JOIN MovementString AS MovementString_OrderId
                                     ON MovementString_OrderId.MovementId = Movement.Id
                                    AND MovementString_OrderId.DescId = zc_MovementString_OrderId()

       WHERE inIsShowAll OR COALESCE(MovementDate_Delay.ValueData, Movement.OperDate) >= CURRENT_DATE - INTERVAL '10 DAY'
       );
    RETURN NEXT Cursor1;

    OPEN Cursor2 FOR (
        WITH

            tmpMI_all AS (SELECT MovementItem.Id, MovementItem.Amount, MovementItem.ObjectId, MovementItem.MovementId
                          FROM MovementItem
                          WHERE MovementItem.MovementId in (SELECT DISTINCT tmpMov.Id FROM tmpMov)
                            AND MovementItem.DescId     = zc_MI_Master()
                            AND MovementItem.isErased   = FALSE
                     )
          , tmpMI AS (SELECT tmpMov.UnitId, tmpMI_all.ObjectId AS GoodsId, SUM (tmpMI_all.Amount) AS Amount
                      FROM tmpMI_all
                           INNER JOIN tmpMov ON tmpMov.ID = tmpMI_all.MovementId
                      GROUP BY tmpMov.UnitId, tmpMI_all.ObjectId
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
          , tmpMovementBoolean AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMI_all.MovementId FROM tmpMI_all)
                          )
          , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpMIString AS (SELECT * FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI_all.Id FROM tmpMI_all)
                          )
          , tmpOF_NDSKind_NDS AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId, ObjectFloat_NDSKind_NDS.valuedata FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                          )
          , tmpNDSKind AS (SELECT ObjectFloat_NDSKind_NDS.ObjectId
                                , ObjectFloat_NDSKind_NDS.ValueData
                          FROM ObjectFloat AS ObjectFloat_NDSKind_NDS
                          WHERE ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
                         )
           , tmpMovSendPartion AS (SELECT
                                          Movement.Id                               AS Id
                                        , MovementFloat_ChangePercent.ValueData     AS ChangePercent
                                        , MovementFloat_ChangePercentMin.ValueData  AS ChangePercentMin
                                   FROM Movement

                                        LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                                                ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                                        LEFT JOIN MovementFloat AS MovementFloat_ChangePercentMin
                                                                ON MovementFloat_ChangePercentMin.MovementId =  Movement.Id
                                                               AND MovementFloat_ChangePercentMin.DescId = zc_MovementFloat_ChangePercentMin()

                                        LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                                     ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                                   WHERE Movement.DescId = zc_Movement_SendPartionDate()
                                     AND Movement.StatusId = zc_Enum_Status_Complete()
                                     AND MovementLinkObject_Unit.ObjectId = vbUnitKey::Integer
                                   ORDER BY Movement.OperDate
                                   LIMIT 1
                                  )
           , tmpMovItemSendPartion AS (SELECT
                                              MovementItem.ObjectId    AS GoodsId
                                            , MIFloat_ChangePercent.ValueData    AS ChangePercent
                                            , MIFloat_ChangePercentMin.ValueData AS ChangePercentMin

                                       FROM MovementItem

                                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                                        ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()
                                            LEFT JOIN MovementItemFloat AS MIFloat_ChangePercentMin
                                                                        ON MIFloat_ChangePercentMin.MovementItemId = MovementItem.Id
                                                                       AND MIFloat_ChangePercentMin.DescId = zc_MIFloat_ChangePercentMin()

                                       WHERE MovementItem.MovementId = (select tmpMovSendPartion.Id from tmpMovSendPartion)
                                         AND MovementItem.DescId = zc_MI_Master()
                                         AND (MIFloat_ChangePercent.ValueData is not Null OR MIFloat_ChangePercentMin.ValueData is not Null)
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
           , Object_Goods_Main.Name   AS GoodsName
           , tmpRemains.Amount_remains :: TFloat AS Amount_remains
           , MovementItem.Amount      AS Amount
           , MovementItem.Price       AS Price
           , MovementItem.AmountSumm
           , COALESCE (ObjectFloat_NDSKind_NDS.ValueData, 0)::TFloat  AS NDS
           , MovementItem.PriceSale              AS PriceSale
           , MovementItem.ChangePercent          AS ChangePercent
           , MovementItem.SummChangePercent      AS SummChangePercent
           , MovementItem.AmountOrder            AS AmountOrder
           , MovementItem.List_UID               AS List_UID
           , True                                AS isErased

           , CASE WHEN Movement.ConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete() AND tmpRemains.GoodsId > 0 THEN 16440317 -- бледно крассный / розовый
                  -- WHEN tmpMov.ConfirmedKindId = zc_Enum_ConfirmedKind_UnComplete() AND tmpRemains.GoodsId IS NULL THEN zc_Color_Yelow() -- желтый
                  ELSE zc_Color_White()
             END  AS Color_Calc

           , CASE WHEN tmpRemains.GoodsId > 0 THEN zc_Color_Red()
                  ELSE zc_Color_Black()
             END  AS Color_CalcError
           , Object_PartionDateKind.Id                                           AS PartionDateKindId
           , Object_PartionDateKind.ValueData                                    AS PartionDateKindName
           , Null::TFloat                                                        AS PartionDateDiscount
           , COALESCE (ObjectFloat_Month.ValueData, 0) :: TFLoat AS AmountMonth

       FROM tmpMI_Sum AS MovementItem

          INNER JOIN tmpMov AS Movement ON Movement.ID = MovementItem.MovementId

          LEFT JOIN Object_Goods_Retail AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
          LEFT JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods.GoodsMainId

          LEFT JOIN tmpNDSKind AS ObjectFloat_NDSKind_NDS
                               ON ObjectFloat_NDSKind_NDS.ObjectId = Object_Goods_Main.NDSKindId


          LEFT JOIN tmpRemains ON tmpRemains.GoodsId = MovementItem.ObjectId
                              AND tmpRemains.UnitId  = Movement.UnitId

          --Типы срок/не срок
          LEFT JOIN MovementItemLinkObject AS MI_PartionDateKind
                                           ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                          AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
          LEFT JOIN Object AS Object_PartionDateKind ON Object_PartionDateKind.Id = MI_PartionDateKind.ObjectId

          LEFT JOIN ObjectFloat AS ObjectFloat_Month
                                ON ObjectFloat_Month.ObjectId = Object_PartionDateKind.Id
                               AND ObjectFloat_Month.DescId = zc_ObjectFloat_PartionDateKind_Month()
       );

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_CheckDelayDeferred (Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.  Шаблий О.В.
 06.09.20                                                                                    *
*/

-- тест
--
SELECT * FROM gpSelect_Movement_CheckDelayDeferred (inType := 3, inIsShowAll := true, inSession:= '3')