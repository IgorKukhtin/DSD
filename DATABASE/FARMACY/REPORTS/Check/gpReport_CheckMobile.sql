-- Function: gpReport_CheckMobile()

DROP FUNCTION IF EXISTS gpReport_CheckMobile (TDateTime, TDateTime, Integer, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_CheckMobile(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inUnitId             Integer ,
    IN inIsUnComplete       Boolean ,
    IN inIsErased           Boolean ,
    IN inisEmployeeMessage  Boolean ,
    IN inisDiscountExternal Boolean ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer
             , TotalCount TFloat, TotalSumm TFloat, TotalSummPayAdd TFloat, TotalSummChangePercent TFloat
             , UnitName TVarChar, CashRegisterName TVarChar, PaidTypeName TVarChar
             , CashMember TVarChar, Bayer TVarChar, FiscalCheckNumber TVarChar
             , NotMCS Boolean, IsDeferred Boolean
             , isSite Boolean, isCallOrder Boolean
             , DiscountCardName TVarChar, DiscountExternalName TVarChar
             , BayerPhone TVarChar
             , InvNumberOrder TVarChar
             , ConfirmedKindName TVarChar
             , ConfirmedKindClientName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , OperDateSP TDateTime
             , PartnerMedicalName TVarChar
             , MedicSPName TVarChar
             , Ambulance TVarChar
             , SPKindName TVarChar
             , InvNumber_Invoice_Full TVarChar
             , StatusCode_PromoCode Integer
             , InvNumber_PromoCode_Full TVarChar
             , GUID_PromoCode TVarChar
             , MemberSPId Integer, MemberSPName TVarChar
             , GroupMemberSPId Integer, GroupMemberSPName TVarChar
             , Address_MemberSP  TVarChar
             , INN_MemberSP      TVarChar
             , Passport_MemberSP TVarChar
             , BankPOSTerminalName TVarChar
             , JackdawsChecksName TVarChar
             , Delay Boolean, DateDelay TDateTime
             , SummCard TFloat
             , CancelReason TVarChar
             , isDeliverySite Boolean
             , SummaDelivery TFloat
             , CommentCustomer TVarChar
             , isErrorRRO Boolean 
             , isMobileApplication Boolean, isMobileFirstOrder Boolean
             , UserReferalsName TVarChar, UserUnitReferalsName TVarChar, isConfirmByPhone Boolean, DateComing TDateTime 
             , MobileDiscount TFloat, ApplicationAward TFloat, isEmployeeMessage Boolean
             , Color_UserReferals Integer
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbRetailId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId WHERE inIsUnComplete = TRUE
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         ),
            tmpGoodsDiscountTools AS (SELECT DISTINCT 
                                             ObjectLink_Unit.ChildObjectId              AS UnitId
                                           , ObjectLink_DiscountExternal.ChildObjectId  AS DiscountExternalID
                                      FROM Object AS Object_DiscountExternalTools
                                            LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                                 ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                                AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                            LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                                 ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                                AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                       WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                                         AND Object_DiscountExternalTools.isErased = FALSE),                            
            tmpGoodsDiscount AS (SELECT Object_Goods_Retail.Id                                    AS GoodsId
                                      , Object_Goods_Retail.GoodsMainId                           AS GoodsMainId
                                      , Object_Object.Id                                          AS DiscountExternalID
                                      , COALESCE(ObjectBoolean_StealthBonuses.ValueData, False)   AS isStealthBonuses 
                                      , ROW_NUMBER() OVER (PARTITION BY Object_Goods_Retail.GoodsMainId  ORDER BY COALESCE(ObjectBoolean_StealthBonuses.ValueData, False) DESC) AS ORD
                                 FROM Object AS Object_BarCode
                                      INNER JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                            ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                           AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                      INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = ObjectLink_BarCode_Goods.ChildObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                           ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                          AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                      LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId

                                      LEFT JOIN ObjectBoolean AS ObjectBoolean_StealthBonuses
                                                              ON ObjectBoolean_StealthBonuses.ObjectId = Object_BarCode.Id
                                                             AND ObjectBoolean_StealthBonuses.DescId = zc_ObjectBoolean_BarCode_StealthBonuses()
                                 WHERE Object_BarCode.DescId = zc_Object_BarCode()
                                   AND Object_BarCode.isErased = False
                                 ),
            tmpEmployeeSchedule AS (SELECT DISTINCT
                                           Movement.OperDate                        AS OperDate
                                         , MovementItemMaster.ObjectId              AS UserId
                                         , MILinkObject_Unit.ObjectId               AS UnitId
                                        FROM Movement

                                             INNER JOIN MovementItem AS MovementItemMaster
                                                                     ON MovementItemMaster.MovementId = Movement.Id
                                                                    AND MovementItemMaster.DescId = zc_MI_Master()

                                             INNER JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                                               ON MILinkObject_Unit.MovementItemId = MovementItemMaster.Id
                                                                              AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

                                        WHERE Movement.OperDate BETWEEN date_trunc('Month', inStartDate) AND date_trunc('Month', inEndDate)
                                          AND Movement.DescId = zc_Movement_EmployeeSchedule()
                                          AND Movement.StatusId <> zc_Enum_Status_Erased()),
            tmpCheckGoodsSpecial AS ( SELECT MovementItemContainer.MovementId
                                           , SUM(ROUND(-1 * MovementItemContainer.Amount * MovementItemContainer.Price, 2))      AS Summa
                                           , SUM(CASE WHEN MovementItemContainer.OperDate >= '16.06.2021'
                                                       AND (COALESCE(MovementString_InvNumberOrder.ValueData, '') <> ''
                                                        OR COALESCE(MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0
                                                       AND MovementItemContainer.OperDate < '03.08.2021')
                                                      THEN ROUND(-1 * MovementItemContainer.Amount * MovementItemContainer.Price, 2) 
                                                      ELSE 0 END)                                                                AS SummaSite
                                      FROM MovementItemContainer

                                           LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                                        ON MovementLinkObject_CheckSourceKind.MovementId =  MovementItemContainer.MovementId
                                                                       AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

                                           LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                                                    ON MovementString_InvNumberOrder.MovementId = MovementItemContainer.MovementId
                                                                   AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()

                                      WHERE MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                        AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                                        AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                        AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                        AND MovementItemContainer.ObjectId_analyzer IN (SELECT Object_Goods_Retail.ID
                                                                                        FROM Object_Goods_Retail
                                                                                        
                                                                                             INNER JOIN Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                                                                                             
                                                                                             LEFT JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Object_Goods_Main.Id
                                                                                                                       AND tmpGoodsDiscount.ORD = 1
                                                                                        
                                                                                        WHERE COALESCE (Object_Goods_Retail.SummaWages, 0) <> 0
                                                                                           OR COALESCE (Object_Goods_Retail.PercentWages, 0) <> 0
                                                                                           OR COALESCE(Object_Goods_Main.isStealthBonuses, FALSE) = TRUE
                                                                                           OR COALESCE(tmpGoodsDiscount.isStealthBonuses, FALSE) = TRUE
                                                                                           OR (COALESCE (Object_Goods_Retail.DiscontAmountSite, 0) > 0 OR
                                                                                               COALESCE (Object_Goods_Retail.DiscontPercentSite, 0) > 0) 
                                                                                               AND Object_Goods_Retail.DiscontSiteStart IS NOT NULL
                                                                                               AND Object_Goods_Retail.DiscontSiteEnd IS NOT NULL  
                                                                                               AND Object_Goods_Retail.DiscontSiteStart <= CURRENT_DATE
                                                                                               AND Object_Goods_Retail.DiscontSiteEnd >= CURRENT_DATE)
                                      GROUP BY MovementItemContainer.MovementId),
            tmpMovement_Check AS (SELECT Movement.*
                                  FROM Movement
                                       INNER JOIN tmpStatus ON tmpStatus.StatusId = Movement.StatusId

                                       INNER JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                                                  ON MovementBoolean_MobileApplication.MovementId = Movement.Id
                                                                 AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
                                                                 AND MovementBoolean_MobileApplication.ValueData = True

                                  WHERE Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                    AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                                    AND Movement.DescId = zc_Movement_Check()
                               ),                                          
            tmpMovementBoolean AS (SELECT * FROM MovementBoolean WHERE MovementBoolean.MovementId IN (SELECT DISTINCT tmpMovement_Check.Id FROM tmpMovement_Check)
                                   ),
            tmpMovementString AS (SELECT * FROM MovementString WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement_Check.Id FROM tmpMovement_Check)
                                 ),
            tmpMovementFloat AS (SELECT * FROM MovementFloat WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement_Check.Id FROM tmpMovement_Check)
                                 ),
            tmpMovementDate AS (SELECT * FROM MovementDate WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement_Check.Id FROM tmpMovement_Check)
                                 ),
            tmpMovementLinkObject AS (SELECT * FROM MovementLinkObject WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_Check.Id FROM tmpMovement_Check)
                                     ),
            tmpMI_Check AS (SELECT Movement.Id      AS MovementId
                                 , MovementItem.Id  AS MovementItemId
                                 , MovementItem.Amount
                            FROM tmpMovement_Check AS Movement

                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                        AND MovementItem.DescId = zc_MI_Master()
                                                        AND MovementItem.isErased = False

                                 INNER JOIN MovementItemLinkObject AS MI_PartionDateKind
                                                                   ON MI_PartionDateKind.MovementItemId = MovementItem.Id
                                                                  AND MI_PartionDateKind.DescId = zc_MILinkObject_PartionDateKind()
                                                                  AND MI_PartionDateKind.ObjectId <> zc_Enum_PartionDateKind_Good()

                         ),                                          
            tmpMI AS (SELECT MovementItem.MovementId
                           , SUM(COALESCE(ROUND(MovementItem.Amount * MIFloat_Price.ValueData, 2), 0))::TFloat       AS Summa
                           , SUM(COALESCE(ROUND(MovementItem.Amount * MIFloat_PriceSale.ValueData, 2), 0))::TFloat   AS SummaSale
                      FROM tmpMI_Check AS MovementItem
 
                           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                                       ON MIFloat_Price.MovementItemId = MovementItem.MovementItemId
                                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                           LEFT JOIN MovementItemFloat AS MIFloat_PriceSale
                                                       ON MIFloat_PriceSale.MovementItemId = MovementItem.MovementItemId
                                                      AND MIFloat_PriceSale.DescId = zc_MIFloat_PriceSale()
                                                            
                      GROUP BY MovementItem.MovementId
                      ),
            tmpMovementDiscount AS (SELECT DISTINCT MovementItemContainer.MovementId
                                    FROM tmpGoodsDiscountTools 
                                     
                                         INNER JOIN tmpGoodsDiscount ON tmpGoodsDiscount.DiscountExternalID = tmpGoodsDiscountTools.DiscountExternalID
                                          
                                         INNER JOIN MovementItemContainer ON MovementItemContainer.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                                                         AND MovementItemContainer.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY'
                                                                         AND MovementItemContainer.MovementDescId = zc_Movement_Check()
                                                                         AND MovementItemContainer.DescId = zc_MIContainer_Count()
                                                                         AND MovementItemContainer.ObjectId_analyzer = tmpGoodsDiscount.GoodsId
                                                                         AND MovementItemContainer.WhereObjectId_Analyzer = tmpGoodsDiscountTools.UnitId
                                     
                                    )
                                                    
         SELECT
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , MovementFloat_TotalSummPayAdd.ValueData            AS TotalSummPatAdd
           , MovementFloat_TotalSummChangePercent.ValueData     AS TotalSummChangePercent
           , Object_Unit.ValueData                              AS UnitName
           , Object_CashRegister.ValueData                      AS CashRegisterName
           , Object_PaidType.ValueData                          AS PaidTypeName
           , CASE WHEN MovementString_InvNumberOrder.ValueData <> '' AND COALESCE (Object_CashMember.ValueData, '') = '' THEN zc_Member_Site() ELSE Object_CashMember.ValueData END :: TVarChar AS CashMember
           , COALESCE(Object_BuyerForSite.ValueData,
                      MovementString_Bayer.ValueData)           AS Bayer
           , MovementString_FiscalCheckNumber.ValueData         AS FiscalCheckNumber
           , COALESCE(MovementBoolean_NotMCS.ValueData,FALSE)   AS NotMCS
           , Movement_Check.IsDeferred                          AS IsDeferred
           , COALESCE(MovementBoolean_Site.ValueData,FALSE) :: Boolean AS isSite
           , COALESCE(MovementBoolean_CallOrder.ValueData,FALSE) :: Boolean AS isCallOrder
           , Object_DiscountCard.ValueData                      AS DiscountCardName
           , Object_DiscountExternal.ValueData                  AS DiscountExternalName
           , COALESCE (ObjectString_BuyerForSite_Phone.ValueData, 
                       MovementString_BayerPhone.ValueData)     AS BayerPhone
           , MovementString_InvNumberOrder.ValueData            AS InvNumberOrder
           , Object_ConfirmedKind.ValueData                     AS ConfirmedKindName
           , Object_ConfirmedKindClient.ValueData               AS ConfirmedKindClientName

           , Object_Insert.ValueData                            AS InsertName
           , MovementDate_Insert.ValueData                      AS InsertDate

           , MovementDate_OperDateSP.ValueData                  AS OperDateSP
           , Object_PartnerMedical.ValueData                    AS PartnerMedicalName
           , MovementString_MedicSP.ValueData                   AS MedicSPName
           , MovementString_Ambulance.ValueData                 AS Ambulance
           , Object_SPKind.ValueData                            AS SPKindName
           , ('№ ' || Movement_Invoice.InvNumber || ' от ' || Movement_Invoice.OperDate  :: Date :: TVarChar )     :: TVarChar  AS InvNumber_Invoice_Full

           , Object_Status_PromoCode.ObjectCode                 AS StatusCode_PromoCode
           , ('№ ' || Movement_PromoCode.InvNumber || ' от ' || Movement_PromoCode.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_PromoCode_Full
           , MIString_GUID.ValueData                 ::TVarChar AS GUID_PromoCode

           , Object_MemberSP.Id                                           AS MemberSPId
           , Object_MemberSP.ValueData                                    AS MemberSPName
           , Object_GroupMemberSP.Id                                      AS GroupMemberSPId
           , Object_GroupMemberSP.ValueData                               AS GroupMemberSPName
           , COALESCE (ObjectString_Address.ValueData, '')   :: TVarChar  AS Address_MemberSP
           , COALESCE (ObjectString_INN.ValueData, '')       :: TVarChar  AS INN_MemberSP
           , COALESCE (ObjectString_Passport.ValueData, '')  :: TVarChar  AS Passport_MemberSP
           , Object_BankPOSTerminal.ValueData                             AS BankPOSTerminalName
           , Object_JackdawsChecks.ValueData                              AS JackdawsChecksName
           , COALESCE (MovementBoolean_Delay.ValueData, False)::Boolean   AS Delay
           , MovementDate_Delay.ValueData                                 AS DateDelay
           , MovementFloat_TotalSummCard.ValueData                        AS SummCard
           , CASE WHEN Movement_Check.StatusId = zc_Enum_Status_Erased()
                  THEN COALESCE(Object_CancelReason.ValueData, CancelReasonDefault.Name) END::TVarChar  AS CancelReason
           , COALESCE(MovementBoolean_DeliverySite.ValueData, False)      AS isDeliverySite
           , MovementFloat_SummaDelivery.ValueData                        AS SummaDelivery

           , MovementString_CommentCustomer.ValueData                     AS CommentCustomer
           , COALESCE(MovementBoolean_ErrorRRO.ValueData, False)          AS isErrorRRO
           
           , COALESCE (MovementBoolean_MobileApplication.ValueData, False)::Boolean   AS isMobileApplication
           , COALESCE (MovementBoolean_MobileFirstOrder.ValueData, False)::Boolean    AS isMobileFirstOrder
           
           , Object_UserReferals.ValueData                                            AS UserReferalsName
           , Object_UnitUserReferals.ValueData                                        AS UserUnitReferalsName
           
           , COALESCE(MovementBoolean_ConfirmByPhone.ValueData, False)::Boolean      AS isConfirmByPhone
           , MovementDate_Coming.ValueData                                AS DateComing
           , CASE WHEN Movement_Check.StatusId = zc_Enum_Status_Complete() THEN MovementFloat_MobileDiscount.ValueData END::TFloat AS MobileDiscount
           
           , CASE WHEN COALESCE (MovementBoolean_MobileFirstOrder.ValueData, False) = True AND
                       MovementFloat_TotalSumm.ValueData + COALESCE (MovementFloat_TotalSummChangePercent.ValueData, 0) - 
                       COALESCE(tmpMI.SummaSale, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0) >= 199.50 AND
                       COALESCE (MovementLinkObject_UserReferals.ObjectId, 0) <> 0 AND
                       COALESCE (MovementLinkObject_DiscountExternal.ObjectId, 0) = 0 AND
                       Movement_Check.StatusId = zc_Enum_Status_Complete() THEN 
                       CASE WHEN MovementFloat_TotalSumm.ValueData - COALESCE(tmpMI.Summa, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0) > 1000 
                            THEN ROUND((MovementFloat_TotalSumm.ValueData - COALESCE(tmpMI.Summa, 0) - COALESCE(tmpCheckGoodsSpecial.Summa, 0)) * 0.02, 2)
                            ELSE 20 END END::TFloat  AS ApplicationAward
           
           , Movement_Check.isEmployeeMessage                             AS isEmployeeMessage
           
           , zc_Color_Yelow()                                             AS Color_UserReferals

        FROM (SELECT Movement.*
                   , MovementLinkObject_Unit.ObjectId                    AS UnitId
                   , MovementLinkObject_CheckMember.ObjectId             AS MemberId
                   , COALESCE(MovementBoolean_Deferred.ValueData, False) AS IsDeferred
                   , COALESCE (MovementBoolean_EmployeeMessage.ValueData, False)::Boolean     AS isEmployeeMessage
              FROM tmpMovement_Check AS Movement

                   LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckSourceKind
                                                ON MovementLinkObject_CheckSourceKind.MovementId =  Movement.Id
                                               AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()

                   LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Unit
                                                ON MovementLinkObject_Unit.MovementId = Movement.Id
                                               AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                   LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CheckMember
                                                ON MovementLinkObject_CheckMember.MovementId = Movement.Id
                                               AND MovementLinkObject_CheckMember.DescId = zc_MovementLinkObject_CheckMember()

                   LEFT JOIN tmpMovementBoolean AS MovementBoolean_Deferred
                                                ON MovementBoolean_Deferred.MovementId = Movement.Id
                                               AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                   
                   LEFT JOIN tmpMovementBoolean AS MovementBoolean_EmployeeMessage
                                                ON MovementBoolean_EmployeeMessage.MovementId = Movement.Id
                                               AND MovementBoolean_EmployeeMessage.DescId = zc_MovementBoolean_EmployeeMessage()
                                               
                   LEFT JOIN tmpMovementDiscount ON tmpMovementDiscount.MovementId = Movement.Id

              WHERE COALESCE(MovementBoolean_Deferred.ValueData, FALSE) = TRUE
                AND COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) = 0
                AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE(inUnitId, 0) = 0)
                AND (COALESCE (MovementBoolean_EmployeeMessage.ValueData, False) = TRUE OR COALESCE(inisEmployeeMessage, False) = False)
                AND (COALESCE (tmpMovementDiscount.MovementId, 0) <> 0 OR COALESCE(inisDiscountExternal, False) = False)
           ) AS Movement_Check
             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Check.StatusId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Check.UnitId

             LEFT JOIN tmpMovementDate AS MovementDate_OperDateSP
                                    ON MovementDate_OperDateSP.MovementId = Movement_Check.Id
                                   AND MovementDate_OperDateSP.DescId = zc_MovementDate_OperDateSP()

             LEFT JOIN tmpMovementDate AS MovementDate_Insert
                                    ON MovementDate_Insert.MovementId = Movement_Check.Id
                                   AND MovementDate_Insert.DescId = zc_MovementDate_Insert()

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummCard
                                     ON MovementFloat_TotalSummCard.MovementId = Movement_Check.Id
                                    AND MovementFloat_TotalSummCard.DescId = zc_MovementFloat_TotalSummCard()

             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummPayAdd
                                     ON MovementFloat_TotalSummPayAdd.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSummPayAdd.DescId = zc_MovementFloat_TotalSummPayAdd()
             LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSummChangePercent
                                     ON MovementFloat_TotalSummChangePercent.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSummChangePercent.DescId = zc_MovementFloat_TotalSummChangePercent()

             LEFT JOIN tmpMovementFloat AS MovementFloat_SummaDelivery
                                     ON MovementFloat_SummaDelivery.MovementId =  Movement_Check.Id
                                    AND MovementFloat_SummaDelivery.DescId = zc_MovementFloat_SummaDelivery()

             LEFT JOIN tmpMovementFloat AS MovementFloat_MobileDiscount
                                     ON MovementFloat_MobileDiscount.MovementId =  Movement_Check.Id
                                    AND MovementFloat_MobileDiscount.DescId = zc_MovementFloat_MobileDiscount()

             LEFT JOIN tmpMovementString AS MovementString_InvNumberOrder
                                      ON MovementString_InvNumberOrder.MovementId = Movement_Check.Id
                                     AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()
	         LEFT JOIN tmpMovementString AS MovementString_Bayer
                                      ON MovementString_Bayer.MovementId = Movement_Check.Id
                                     AND MovementString_Bayer.DescId = zc_MovementString_Bayer()
             LEFT JOIN tmpMovementString AS MovementString_BayerPhone
                                      ON MovementString_BayerPhone.MovementId = Movement_Check.Id
                                     AND MovementString_BayerPhone.DescId = zc_MovementString_BayerPhone()
             LEFT JOIN tmpMovementString AS MovementString_FiscalCheckNumber
                                      ON MovementString_FiscalCheckNumber.MovementId = Movement_Check.Id
                                     AND MovementString_FiscalCheckNumber.DescId = zc_MovementString_FiscalCheckNumber()

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_BuyerForSite
                                          ON MovementLinkObject_BuyerForSite.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_BuyerForSite.DescId = zc_MovementLinkObject_BuyerForSite()
             LEFT JOIN Object AS Object_BuyerForSite ON Object_BuyerForSite.Id = MovementLinkObject_BuyerForSite.ObjectId
             LEFT JOIN ObjectString AS ObjectString_BuyerForSite_Phone
                                    ON ObjectString_BuyerForSite_Phone.ObjectId = Object_BuyerForSite.Id 
                                   AND ObjectString_BuyerForSite_Phone.DescId = zc_ObjectString_BuyerForSite_Phone()

             LEFT JOIN tmpMovementString AS MovementString_MedicSP
                                      ON MovementString_MedicSP.MovementId = Movement_Check.Id
                                     AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
             LEFT JOIN tmpMovementString AS MovementString_Ambulance
                                      ON MovementString_Ambulance.MovementId = Movement_Check.Id
                                     AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()

             LEFT JOIN tmpMovementString AS MovementString_OrderId
                                      ON MovementString_OrderId.MovementId = Movement_Check.Id
                                     AND MovementString_OrderId.DescId = zc_MovementString_OrderId()

             LEFT JOIN tmpMovementBoolean AS MovementBoolean_NotMCS
                                       ON MovementBoolean_NotMCS.MovementId = Movement_Check.Id
                                      AND MovementBoolean_NotMCS.DescId = zc_MovementBoolean_NotMCS()

             LEFT JOIN tmpMovementBoolean AS MovementBoolean_Site
                                       ON MovementBoolean_Site.MovementId = Movement_Check.Id
                                      AND MovementBoolean_Site.DescId = zc_MovementBoolean_Site()
             LEFT JOIN tmpMovementBoolean AS MovementBoolean_CallOrder
                                       ON MovementBoolean_CallOrder.MovementId = Movement_Check.Id
                                      AND MovementBoolean_CallOrder.DescId = zc_MovementBoolean_CallOrder()

	         LEFT JOIN tmpMovementBoolean AS MovementBoolean_DeliverySite
                                       ON MovementBoolean_DeliverySite.MovementId = Movement_Check.Id
                                      AND MovementBoolean_DeliverySite.DescId = zc_MovementBoolean_DeliverySite()

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CashRegister
                                          ON MovementLinkObject_CashRegister.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_CashRegister.DescId = zc_MovementLinkObject_CashRegister()
             LEFT JOIN Object AS Object_CashRegister ON Object_CashRegister.Id = MovementLinkObject_CashRegister.ObjectId

   	         LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PaidType
                                          ON MovementLinkObject_PaidType.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PaidType.DescId = zc_MovementLinkObject_PaidType()
             LEFT JOIN Object AS Object_PaidType ON Object_PaidType.Id = MovementLinkObject_PaidType.ObjectId

             LEFT JOIN Object AS Object_CashMember ON Object_CashMember.Id = Movement_Check.MemberId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_DiscountCard
                                          ON MovementLinkObject_DiscountCard.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_DiscountCard.DescId = zc_MovementLinkObject_DiscountCard()
             LEFT JOIN Object AS Object_DiscountCard ON Object_DiscountCard.Id = MovementLinkObject_DiscountCard.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKind
                                          ON MovementLinkObject_ConfirmedKind.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
             LEFT JOIN Object AS Object_ConfirmedKind ON Object_ConfirmedKind.Id = MovementLinkObject_ConfirmedKind.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_ConfirmedKindClient
                                          ON MovementLinkObject_ConfirmedKindClient.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_ConfirmedKindClient.DescId = zc_MovementLinkObject_ConfirmedKindClient()
             LEFT JOIN Object AS Object_ConfirmedKindClient ON Object_ConfirmedKindClient.Id = MovementLinkObject_ConfirmedKindClient.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_PartnerMedical
                                          ON MovementLinkObject_PartnerMedical.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
             LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = MovementLinkObject_PartnerMedical.ObjectId

             LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_SPKind
                                          ON MovementLinkObject_SPKind.MovementId = Movement_Check.Id
                                         AND MovementLinkObject_SPKind.DescId = zc_MovementLinkObject_SPKind()
             LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = MovementLinkObject_SPKind.ObjectId

             LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                  ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountCard.Id
                                 AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountCard_Object()
             LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = ObjectLink_DiscountExternal.ChildObjectId

             LEFT JOIN tmpMovementLinkObject AS MLO_Insert
                                          ON MLO_Insert.MovementId = Movement_Check.Id
                                         AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
             LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

             LEFT JOIN MovementLinkMovement AS MLM_Child
                                            ON MLM_Child.MovementId = Movement_Check.Id
                                           AND MLM_Child.descId = zc_MovementLinkMovement_Child()
             LEFT JOIN Movement AS Movement_Invoice ON Movement_Invoice.Id = MLM_Child.MovementChildId

            -- инфа из документа промо код
            LEFT JOIN tmpMovementFloat AS MovementFloat_MovementItemId
                                    ON MovementFloat_MovementItemId.MovementId = Movement_Check.Id
                                   AND MovementFloat_MovementItemId.DescId     = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MI_PromoCode
                                   ON MI_PromoCode.Id       = MovementFloat_MovementItemId.ValueData :: Integer
                                  AND MI_PromoCode.isErased = FALSE
            LEFT JOIN Movement AS Movement_PromoCode ON Movement_PromoCode.Id = MI_PromoCode.MovementId
            LEFT JOIN Object AS Object_Status_PromoCode ON Object_Status_PromoCode.Id = Movement_PromoCode.StatusId

            LEFT JOIN MovementItemString AS MIString_GUID
                                         ON MIString_GUID.MovementItemId = MI_PromoCode.Id
                                        AND MIString_GUID.DescId = zc_MIString_GUID()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_MemberSP
                                         ON MovementLinkObject_MemberSP.MovementId = Movement_Check.Id
                                        AND MovementLinkObject_MemberSP.DescId = zc_MovementLinkObject_MemberSP()
            LEFT JOIN Object AS Object_MemberSP ON Object_MemberSP.Id = MovementLinkObject_MemberSP.ObjectId

            LEFT JOIN ObjectString AS ObjectString_Address
                                   ON ObjectString_Address.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                  AND ObjectString_Address.DescId = zc_ObjectString_MemberSP_Address()
            LEFT JOIN ObjectString AS ObjectString_INN
                                   ON ObjectString_INN.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                  AND ObjectString_INN.DescId = zc_ObjectString_MemberSP_INN()
            LEFT JOIN ObjectString AS ObjectString_Passport
                                   ON ObjectString_Passport.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                  AND ObjectString_Passport.DescId = zc_ObjectString_MemberSP_Passport()
            LEFT JOIN ObjectLink AS ObjectLink_MemberSP_GroupMemberSP
                                 ON ObjectLink_MemberSP_GroupMemberSP.ObjectId = MovementLinkObject_MemberSP.ObjectId
                                AND ObjectLink_MemberSP_GroupMemberSP.DescId = zc_ObjectLink_MemberSP_GroupMemberSP()
            LEFT JOIN Object AS Object_GroupMemberSP ON Object_GroupMemberSP.Id = ObjectLink_MemberSP_GroupMemberSP.ChildObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_BankPOSTerminal
                                         ON MovementLinkObject_BankPOSTerminal.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_BankPOSTerminal.DescId = zc_MovementLinkObject_BankPOSTerminal()
            LEFT JOIN Object AS Object_BankPOSTerminal ON Object_BankPOSTerminal.Id = MovementLinkObject_BankPOSTerminal.ObjectId

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_JackdawsChecks
                                         ON MovementLinkObject_JackdawsChecks.MovementId =  Movement_Check.Id
                                        AND MovementLinkObject_JackdawsChecks.DescId = zc_MovementLinkObject_JackdawsChecks()
            LEFT JOIN Object AS Object_JackdawsChecks ON Object_JackdawsChecks.Id = MovementLinkObject_JackdawsChecks.ObjectId

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_Delay
                                      ON MovementBoolean_Delay.MovementId = Movement_Check.Id
                                     AND MovementBoolean_Delay.DescId = zc_MovementBoolean_Delay()

            LEFT JOIN tmpMovementDate AS MovementDate_Delay
                                   ON MovementDate_Delay.MovementId = Movement_Check.Id
                                  AND MovementDate_Delay.DescId = zc_MovementDate_Delay()
            LEFT JOIN tmpMovementDate AS MovementDate_Coming
                                   ON MovementDate_Coming.MovementId = Movement_Check.Id
                                  AND MovementDate_Coming.DescId = zc_MovementDate_Coming()

            LEFT JOIN tmpMovementString AS MovementString_CommentCustomer
                                     ON MovementString_CommentCustomer.MovementId = Movement_Check.Id
                                    AND MovementString_CommentCustomer.DescId = zc_MovementString_CommentCustomer()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_CancelReason
                                         ON MovementLinkObject_CancelReason.MovementId = Movement_Check.Id
                                        AND MovementLinkObject_CancelReason.DescId = zc_MovementLinkObject_CancelReason()
            LEFT JOIN Object AS Object_CancelReason ON Object_CancelReason.Id = MovementLinkObject_CancelReason.ObjectId
                                     
            LEFT JOIN (SELECT * FROM gpSelect_Object_CancelReason('3') AS CR ORDER BY CR.Code LIMIT 1) AS CancelReasonDefault ON 1 = 1 

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_ErrorRRO
                                      ON MovementBoolean_ErrorRRO.MovementId = Movement_Check.Id
                                     AND MovementBoolean_ErrorRRO.DescId = zc_MovementBoolean_ErrorRRO()

            LEFT JOIN tmpMovementBoolean AS MovementBoolean_MobileApplication
                                      ON MovementBoolean_MobileApplication.MovementId = Movement_Check.Id
                                     AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_ConfirmByPhone
                                      ON MovementBoolean_ConfirmByPhone.MovementId = Movement_Check.Id
                                     AND MovementBoolean_ConfirmByPhone.DescId = zc_MovementBoolean_ConfirmByPhone()
            LEFT JOIN tmpMovementBoolean AS MovementBoolean_MobileFirstOrder
                                      ON MovementBoolean_MobileFirstOrder.MovementId = Movement_Check.Id
                                     AND MovementBoolean_MobileFirstOrder.DescId = zc_MovementBoolean_MobileFirstOrder()

            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_UserReferals
                                         ON MovementLinkObject_UserReferals.MovementId = Movement_Check.Id
                                        AND MovementLinkObject_UserReferals.DescId = zc_MovementLinkObject_UserReferals()
            LEFT JOIN Object AS Object_UserReferals ON Object_UserReferals.Id = MovementLinkObject_UserReferals.ObjectId
            
            LEFT JOIN tmpEmployeeSchedule ON tmpEmployeeSchedule.OperDate = date_trunc('Month', Movement_Check.OperDate)
                                         AND tmpEmployeeSchedule.UserId =MovementLinkObject_UserReferals.ObjectId 
            LEFT JOIN Object AS Object_UnitUserReferals ON Object_UnitUserReferals.Id = tmpEmployeeSchedule.UnitId
            
            LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_DiscountExternal
                                         ON MovementLinkObject_DiscountExternal.MovementId = Movement_Check.Id
                                        AND MovementLinkObject_DiscountExternal.DescId = zc_MILinkObject_DiscountExternal()

            LEFT JOIN tmpCheckGoodsSpecial ON tmpCheckGoodsSpecial.MovementId = Movement_Check.ID
            
            LEFT JOIN tmpMI ON tmpMI.MovementId = Movement_Check.ID
                        
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.04.21                                                       * add BuyerForSite
 01.07.20                                                       *
*/

-- тест
-- 


select * from gpReport_CheckMobile(inStartDate := ('01.09.2022')::TDateTime , inEndDate := ('30.09.2022')::TDateTime , inUnitId := 0 , inIsUnComplete := 'True' , inIsErased := 'False' , inisEmployeeMessage := 'False' , inisDiscountExternal := 'False',  inSession := '3');