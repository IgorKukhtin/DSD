-- Function: gpSelect_Cash_UnitConfig()

DROP FUNCTION IF EXISTS gpSelect_Cash_UnitConfig (TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Cash_UnitConfig (
    IN inCashRegister   TVarChar,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (id Integer, Code Integer, Name TVarChar,
               isNotCashMCS Boolean, isNotCashListDiff Boolean,
               ParentName TVarChar, ShareFromPrice TFloat,
               TaxUnitNight Boolean, TaxUnitStartDate TDateTime, TaxUnitEndDate TDateTime,
               TimePUSHFinal1 TDateTime, TimePUSHFinal2 TDateTime,
               isSP Boolean, DateSP TDateTime, StartTimeSP TDateTime, EndTimeSP TDateTime,
               FtpDir TVarChar, DividePartionDate Boolean,
               eHealthApi integer,
               Helsi_IdSP Integer, Helsi_Id TVarChar, Helsi_be TVarChar, Helsi_ClientId TVarChar,
               Helsi_ClientSecret TVarChar, Helsi_IntegrationClient TVarChar,
               isSpotter boolean,
               LoyaltyID Integer, LoyaltySummCash TFloat,
               ShareFromPriceName TVarChar, ShareFromPriceCode TVarChar,
               CustomerThreshold TFloat,
               PermanentDiscountID Integer, PermanentDiscountPercent TFloat,
               LoyaltySaveMoneyCount Integer, LoyaltySaveMoneyID Integer,
               SPKindId Integer, SPKindName TVarChar, SPTax TFloat, 
               PartnerMedicalID Integer, PartnerMedicalName TVarChar, isSP1303 Boolean, EndDateSP1303 TDateTime,
               isPromoCodeDoctor boolean, isTechnicalRediscount Boolean, 
               isGetHardwareData boolean, isPairedOnlyPromo Boolean, 
               DiscountExternalId integer, DiscountExternalCode integer, DiscountExternalName TVarChar,
               GoodsDiscountId integer, GoodsDiscountCode integer, GoodsDiscountName TVarChar,
               isPromoForSale Boolean, isCheckUKTZED Boolean, isGoodsUKTZEDRRO Boolean, isMessageByTime Boolean, isMessageByTimePD Boolean,
               LikiDneproURL TVarChar, LikiDneproToken TVarChar, LikiDneproId Integer,
               LikiDneproeHealthURL TVarChar, LikiDneproeLocation TVarChar, LikiDneproeHealthToken TVarChar,
               isRemovingPrograms Boolean, ExpressVIPConfirm Integer, isErrorRROToVIP Boolean, LayoutFileCount Integer, LayoutFileID Integer, 
               isSupplementAddCash Boolean, isExpressVIPConfirm Boolean, MinPriceSale TFloat
              ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbRetailId Integer;
   DECLARE vbCashRegisterId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
   vbUserId:= lpGetUserBySession (inSession);
   vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
   IF vbUnitKey = '' THEN
      vbUnitKey := '0';
   END IF;
   vbUnitId := vbUnitKey::Integer;

   vbRetailId := (SELECT ObjectLink_Juridical_Retail.ChildObjectId AS RetailId
                  FROM ObjectLink AS ObjectLink_Unit_Juridical
                       INNER JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                             ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Unit_Juridical.ChildObjectId
                                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
                  WHERE ObjectLink_Unit_Juridical.ObjectId = vbUnitId
                    AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical());

   if EXISTS(SELECT Object_CashRegister.Id
             FROM Object AS Object_CashRegister
             WHERE Object_CashRegister.DescId = zc_Object_CashRegister()
               AND Object_CashRegister.ValueData = inCashRegister)
   THEN
     SELECT Object_CashRegister.Id
     INTO vbCashRegisterId
     FROM Object AS Object_CashRegister
     WHERE Object_CashRegister.DescId = zc_Object_CashRegister()
       AND Object_CashRegister.ValueData = inCashRegister;
   ELSE
     vbCashRegisterId := 0;
   END IF;

   RETURN QUERY
   WITH tmpTaxUnitNight AS (SELECT  ObjectLink_TaxUnit_Unit.ChildObjectId               AS UnitId
                            FROM ObjectLink AS ObjectLink_TaxUnit_Unit

                                 LEFT JOIN Object AS Object_TaxUnit
                                                  ON Object_TaxUnit.Id = ObjectLink_TaxUnit_Unit.ObjectId
                                                 AND COALESCE (Object_TaxUnit.isErased, False) = False

                                 LEFT JOIN ObjectFloat AS ObjectFloat_Value
                                                       ON ObjectFloat_Value.ObjectId = Object_TaxUnit.Id
                                                      AND ObjectFloat_Value.DescId = zc_ObjectFloat_TaxUnit_Value()


                            WHERE ObjectLink_TaxUnit_Unit.DescId = zc_ObjectLink_TaxUnit_Unit()
                              AND Object_TaxUnit.isErased = False
                              AND COALESCE(ObjectFloat_Value.ValueData, 0) <> 0)
       , tmpLoyalty AS (SELECT Movement.Id                                 AS LoyaltyID
                             , MovementFloat_StartSummCash.ValueData       AS LoyaltySummCash
                        FROM Movement

                             INNER JOIN MovementFloat AS MovementFloat_StartSummCash
                                                      ON MovementFloat_StartSummCash.MovementId =  Movement.Id
                                                     AND MovementFloat_StartSummCash.DescId = zc_MovementFloat_StartSummCash()
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                           ON MovementLinkObject_Retail.MovementId = Movement.Id
                                                          AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                                          AND MovementLinkObject_Retail.ObjectId = vbRetailId

                             INNER JOIN MovementDate AS MovementDate_StartPromo
                                                     ON MovementDate_StartPromo.MovementId = Movement.Id
                                                    AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                             INNER JOIN MovementDate AS MovementDate_EndPromo
                                                     ON MovementDate_EndPromo.MovementId = Movement.Id
                                                    AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                             INNER JOIN MovementItem AS MI_Loyalty
                                                     ON MI_Loyalty.MovementId = Movement.Id
                                                    AND MI_Loyalty.DescId = zc_MI_Child()
                                                    AND MI_Loyalty.isErased = FALSE
                                                    AND MI_Loyalty.Amount <> 0
                                                    AND MI_Loyalty.ObjectId = vbUnitId
                                                    
                             LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                                       ON MovementBoolean_Electron.MovementId =  Movement.Id
                                                      AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()

                        WHERE Movement.DescId = zc_Movement_Loyalty()
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND MovementDate_StartPromo.ValueData <= CURRENT_DATE
                          AND MovementDate_EndPromo.ValueData >= CURRENT_DATE
                          AND COALESCE(MovementBoolean_Electron.ValueData, FALSE) = FALSE
                        ORDER BY Movement.OperDate DESC
                        LIMIT 1
                        )
       , tmpLoyaltySaveMoney AS (SELECT MAX(Movement.Id)::Integer               AS LoyaltySaveMoneyID
                                      , count(*)::Integer                       AS LoyaltySaveMoneyCount
                                 FROM Movement

                                      INNER JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                                    ON MovementLinkObject_Retail.MovementId = Movement.Id
                                                                   AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                                                   AND MovementLinkObject_Retail.ObjectId = vbRetailId

                                      INNER JOIN MovementDate AS MovementDate_StartPromo
                                                              ON MovementDate_StartPromo.MovementId = Movement.Id
                                                             AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                      INNER JOIN MovementDate AS MovementDate_EndSale
                                                              ON MovementDate_EndSale.MovementId = Movement.Id
                                                             AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

                                 WHERE Movement.DescId = zc_Movement_LoyaltySaveMoney()
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                   AND MovementDate_StartPromo.ValueData <= CURRENT_DATE
                                   AND MovementDate_EndSale.ValueData >= CURRENT_DATE
                                 )
       , tmpPermanentDiscount AS (SELECT Movement.Id                              AS PermanentDiscountID
                                       , MovementFloat_ChangePercent.ValueData    AS PermanentDiscountPercent
                                  FROM Movement

                                       INNER JOIN MovementFloat AS MovementFloat_ChangePercent
                                                                ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                                               AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

                                       INNER JOIN MovementLinkObject AS MovementLinkObject_Retail
                                                                     ON MovementLinkObject_Retail.MovementId = Movement.Id
                                                                    AND MovementLinkObject_Retail.DescId = zc_MovementLinkObject_Retail()
                                                                    AND MovementLinkObject_Retail.ObjectId = vbRetailId

                                       INNER JOIN MovementDate AS MovementDate_StartPromo
                                                               ON MovementDate_StartPromo.MovementId = Movement.Id
                                                              AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                                       INNER JOIN MovementDate AS MovementDate_EndPromo
                                                               ON MovementDate_EndPromo.MovementId = Movement.Id
                                                              AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()

                                  WHERE Movement.DescId = zc_Movement_PermanentDiscount()
                                    AND Movement.StatusId = zc_Enum_Status_Complete()
                                    AND MovementDate_StartPromo.ValueData <= CURRENT_DATE
                                    AND MovementDate_EndPromo.ValueData >= CURRENT_DATE
                                  ORDER BY Movement.OperDate DESC
                                  LIMIT 1
                                  )
       , tmpCashSettings AS (SELECT Object_CashSettings.Id                     AS Id
                                  , Object_CashSettings.ObjectCode             AS Code
                                  , Object_CashSettings.ValueData              AS Name
                                  , ObjectString_CashSettings_ShareFromPriceName.ValueData  AS ShareFromPriceName
                                  , ObjectString_CashSettings_ShareFromPriceCode.ValueData  AS ShareFromPriceCode
                                  , COALESCE(ObjectBoolean_CashSettings_GetHardwareData.ValueData, FALSE) 
                                    AND (vbRetailId = 4)                                                     AS isGetHardwareData
                                  , COALESCE(ObjectBoolean_CashSettings_PairedOnlyPromo.ValueData, FALSE)    AS isPairedOnlyPromo
                                  , COALESCE(ObjectBoolean_CashSettings_CustomerThreshold.ValueData, 0)::TFLoat  AS CustomerThreshold
                                  , COALESCE(ObjectBoolean_CashSettings_RemovingPrograms.ValueData, FALSE)       AS isRemovingPrograms
                                  , COALESCE(ObjectFloat_CashSettings_ExpressVIPConfirm.ValueData, 0)::Integer   AS ExpressVIPConfirm
                                  , COALESCE(ObjectFloat_CashSettings_MinPriceSale.ValueData, 0)::TFLoat         AS MinPriceSale
                             FROM Object AS Object_CashSettings
                                  LEFT JOIN ObjectString AS ObjectString_CashSettings_ShareFromPriceName
                                                         ON ObjectString_CashSettings_ShareFromPriceName.ObjectId = Object_CashSettings.Id
                                                        AND ObjectString_CashSettings_ShareFromPriceName.DescId = zc_ObjectString_CashSettings_ShareFromPriceName()
                                  LEFT JOIN ObjectString AS ObjectString_CashSettings_ShareFromPriceCode
                                                         ON ObjectString_CashSettings_ShareFromPriceCode.ObjectId = Object_CashSettings.Id
                                                        AND ObjectString_CashSettings_ShareFromPriceCode.DescId = zc_ObjectString_CashSettings_ShareFromPriceCode()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_GetHardwareData
                                                          ON ObjectBoolean_CashSettings_GetHardwareData.ObjectId = Object_CashSettings.Id 
                                                         AND ObjectBoolean_CashSettings_GetHardwareData.DescId = zc_ObjectBoolean_CashSettings_GetHardwareData()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_PairedOnlyPromo
                                                          ON ObjectBoolean_CashSettings_PairedOnlyPromo.ObjectId = Object_CashSettings.Id 
                                                         AND ObjectBoolean_CashSettings_PairedOnlyPromo.DescId = zc_ObjectBoolean_CashSettings_PairedOnlyPromo()
                                  LEFT JOIN ObjectFloat AS ObjectBoolean_CashSettings_CustomerThreshold
                                                        ON ObjectBoolean_CashSettings_CustomerThreshold.ObjectId = Object_CashSettings.Id 
                                                       AND ObjectBoolean_CashSettings_CustomerThreshold.DescId = zc_ObjectFloat_CashSettings_CustomerThreshold()
                                  LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_RemovingPrograms
                                                          ON ObjectBoolean_CashSettings_RemovingPrograms.ObjectId = Object_CashSettings.Id 
                                                         AND ObjectBoolean_CashSettings_RemovingPrograms.DescId = zc_ObjectBoolean_CashSettings_RemovingPrograms()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_ExpressVIPConfirm
                                                        ON ObjectFloat_CashSettings_ExpressVIPConfirm.ObjectId = Object_CashSettings.Id 
                                                       AND ObjectFloat_CashSettings_ExpressVIPConfirm.DescId = zc_ObjectFloat_CashSettings_ExpressVIPConfirm()
                                  LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_MinPriceSale
                                                        ON ObjectFloat_CashSettings_MinPriceSale.ObjectId = Object_CashSettings.Id 
                                                       AND ObjectFloat_CashSettings_MinPriceSale.DescId = zc_ObjectFloat_CashSettings_MinPriceSale()
                             WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
                             LIMIT 1)
       , tmpPromoCodeDoctor AS (SELECT PromoUnit.ID
                                FROM Movement AS Promo
                                     INNER JOIN MovementItem PromoUnit ON Promo.id = PromoUnit.movementid AND promounit.descid = zc_MI_Child()
                                WHERE Promo.id = 16904771 AND promounit.amount > 0 AND PromoUnit.objectid = vbUnitId)
       , tmpContract AS (SELECT Contract.JuridicalBasisId
                              , Contract.JuridicalId
                              , Max(Contract.EndDate)::TDateTime   AS EndDate
                         FROM gpSelect_Object_Contract (inSession) AS Contract 
                         WHERE Contract.isErased = False 
                           AND Contract.StartDate <= CURRENT_DATE 
                           AND Contract.EndDate >= CURRENT_DATE
                         GROUP BY Contract.JuridicalBasisId
                                , Contract.JuridicalId)
       , tmpLayoutFile AS (SELECT
                                  Movement.Id                        AS Id
                                , Movement.InvNumber                 AS InvNumber
                                , Movement.OperDate                  AS OperDate
                                , MovementDate_StartPromo.ValueData  AS StartPromo
                                , MovementDate_EndPromo.ValueData    AS EndPromo
                                , ROW_NUMBER()OVER(ORDER BY Movement.OperDate DESC) as ORD

                           FROM Movement

                                INNER JOIN MovementDate AS MovementDate_StartPromo
                                                       ON MovementDate_StartPromo.MovementId = Movement.Id
                                                      AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()

                                INNER JOIN MovementDate AS MovementDate_EndPromo
                                                       ON MovementDate_EndPromo.MovementId = Movement.Id
                                                      AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                                                      
                                INNER JOIN MovementItem AS MI_LayoutFile
                                                        ON MI_LayoutFile.MovementId = Movement.Id
                                                       AND MI_LayoutFile.DescId = zc_MI_Master()
                                                       AND MI_LayoutFile.Amount = 1
                                                       AND MI_LayoutFile.ObjectId = vbUnitId
                                                          
                           WHERE Movement.DescId = zc_Movement_LayoutFile()
                             AND Movement.StatusId = zc_Enum_Status_Complete()
                             AND MovementDate_StartPromo.ValueData <= CURRENT_DATE
                             AND MovementDate_EndPromo.ValueData >= CURRENT_DATE)
        , tmpLayoutFileCount AS (SELECT COUNT(*)::Integer AS LayoutFileCount
                                 FROM tmpLayoutFile)

   SELECT
         Object_Unit.Id                                      AS Id
       , Object_Unit.ObjectCode                              AS Code
       , Object_Unit.ValueData                               AS Name

       , COALESCE (ObjectBoolean_NotCashMCS.ValueData, FALSE)     :: Boolean   AS isNotCashMCS
       , COALESCE (ObjectBoolean_NotCashListDiff.ValueData, FALSE):: Boolean   AS isNotCashListDiff

       , Object_Parent.ValueData                             AS ParentName
       , CASE WHEN COALESCE (ObjectBoolean_ShareFromPrice.ValueData, FALSE) = TRUE THEN ObjectFloat_ShareFromPrice.ValueData ELSE 0 END::TFloat            AS ShareFromPrice

       , COALESCE (tmpTaxUnitNight.UnitId, 0) <> 0
         AND COALESCE(ObjectDate_TaxUnitStart.ValueData ::Time,'00:00') <> '00:00'
         AND COALESCE(ObjectDate_TaxUnitEnd.ValueData ::Time,'00:00') <> '00:00'                 AS TaxUnitNight

       , CASE WHEN COALESCE(ObjectDate_TaxUnitStart.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_TaxUnitStart.ValueData ELSE Null END ::TDateTime  AS TaxUnitStartDate
       , CASE WHEN COALESCE(ObjectDate_TaxUnitEnd.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_TaxUnitEnd.ValueData ELSE Null END ::TDateTime  AS TaxUnitEndDate

       , COALESCE (ObjectDate_TimePUSHFinal1.ValueData, ('01.01.2019 21:00')::TDateTime) AS TimePUSHFinal1
       , ObjectDate_TimePUSHFinal2.ValueData                                             AS TimePUSHFinal2

       , COALESCE (ObjectBoolean_SP.ValueData, FALSE)  :: Boolean   AS isSP
       , ObjectDate_SP.ValueData                       :: TDateTime AS DateSP
       , CASE WHEN COALESCE (ObjectDate_StartSP.ValueData ::Time,'00:00') <> '00:00' THEN ObjectDate_StartSP.ValueData ELSE Null END :: TDateTime AS StartTimeSP
       , CASE WHEN COALESCE (ObjectDate_EndSP.ValueData ::Time,'00:00')   <> '00:00' THEN ObjectDate_EndSP.ValueData ELSE Null END   :: TDateTime AS EndTimeSP
       , CASE WHEN Object_Parent.ID IN (7433754, 4103484, 10127251)
         THEN 'Franchise'
         ELSE '' END::TVarChar                               AS FtpDir

      , COALESCE (ObjectBoolean_DividePartionDate.ValueData, FALSE)  :: Boolean   AS DividePartionDate

--      , 1                                                    AS eHealthApi
      , CASE WHEN inSession = '3' THEN 1 ELSE 1 END          AS eHealthApi

      , CASE WHEN COALESCE (ObjectBoolean_RedeemByHandSP.ValueData, FALSE) = FALSE THEN Object_Helsi_IdSP.Id
        ELSE NULL::Integer END                                   AS Helsi_IdSP
       , CASE WHEN inSession = '0' 
         THEN 'https://qa2id.helsi.pro'
         ELSE Object_Helsi_Id.ValueData END::TVarChar            AS Helsi_Id
       , CASE WHEN inSession = '0' 
         THEN 'https://qa2api.helsi.pro'
         ELSE Object_Helsi_be.ValueData END::TVarChar            AS Helsi_be
       , CASE WHEN inSession = '0' 
         THEN '65b612a4-7921-422f-8992-a6c4c9e76d2a'
         ELSE Object_Helsi_ClientId.ValueData END::TVarChar      AS Helsi_ClientId
       , CASE WHEN inSession = '0' 
         THEN '395f60acab35de5ff84216eb1154d0562775274a'
         ELSE Object_Helsi_ClientSecret.ValueData END::TVarChar  AS Helsi_ClientSecret
       , Object_Helsi_IntegrationClient.ValueData                AS Helsi_IntegrationClient

       , CASE WHEN EXISTS (SELECT 1 FROM ObjectLink_UserRole_View
         WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Spotter(), zc_Enum_Role_Admin())) THEN TRUE ELSE FALSE END AS isSpotter

       , tmpLoyalty.LoyaltyID
       , tmpLoyalty.LoyaltySummCash
       , tmpCashSettings.ShareFromPriceName
       , tmpCashSettings.ShareFromPriceCode
       , tmpCashSettings.CustomerThreshold

       , tmpPermanentDiscount.PermanentDiscountID          AS PermanentDiscountID
       , tmpPermanentDiscount.PermanentDiscountPercent     AS PermanentDiscountPercent

       , tmpLoyaltySaveMoney.LoyaltySaveMoneyCount         AS LoyaltySaveMoneyCount
       , tmpLoyaltySaveMoney.LoyaltySaveMoneyID            AS LoyaltySaveMoneyID

       , Object_SPKind.ID                                  AS SPKindID
       , Object_SPKind.ValueData                           AS SPKindName
       , COALESCE (ObjectFloat_SPKind_Tax.ValueData, 0) :: TFLoat AS Tax 
       , Object_PartnerMedical.ID                          AS PartnerMedicalID
       , Object_PartnerMedical.ValueData                   AS PartnerMedicalName
       , COALESCE(tmpContract.JuridicalId, 0) <> 0         AS isSP1303
       , tmpContract.EndDate                               AS EndDateSP1303  
       , COALESCE(tmpPromoCodeDoctor.ID, 0) <> 0           AS isPromoCodeDoctor
       , COALESCE (ObjectBoolean_TechnicalRediscount.ValueData, FALSE):: Boolean   AS isTechnicalRediscount
       , COALESCE(ObjectBoolean_GetHardwareData.ValueData, False) OR
         COALESCE(tmpCashSettings.isGetHardwareData, False)                        AS isGetHardwareData
       , tmpCashSettings.isPairedOnlyPromo                                         AS isPairedOnlyPromo
       , Object_DiscountExternal.Id                                                AS DiscountExternalId
       , Object_DiscountExternal.ObjectCode                                        AS DiscountExternalCode
       , Object_DiscountExternal.ValueData                                         AS DiscountExternalName
       , Object_DiscountCheck.Id                                                   AS GoodsDiscountId
       , Object_DiscountCheck.ObjectCode                                           AS GoodsDiscountCode
       , Object_DiscountCheck.ValueData                                            AS GoodsDiscountName
       , COALESCE(ObjectString_PromoForSale.ValueData, '') <> ''                   AS isPromoForSale
       , COALESCE (ObjectBoolean_CheckUKTZED.ValueData, FALSE)                     AS isCheckUKTZED
       , COALESCE (ObjectBoolean_GoodsUKTZEDRRO.ValueData, FALSE)                  AS isGoodsUKTZEDRRO
       , COALESCE (ObjectBoolean_MessageByTime.ValueData, FALSE)                   AS isMessageByTime
       , COALESCE (ObjectBoolean_MessageByTimePD.ValueData, FALSE)                 AS isMessageByTimePD

/*       , 'https://liki-dnepr.nzt.su/api'::TVarChar                                      AS LikiDneproURL
       , '3bc48397885c039ee40586f4781d10006e3c01b0ba4776f4df5ec1f64af38f2a'::TVarChar   AS LikiDneproToken
       , 92                                                                             AS LikiDneproId*/

       , 'https://mis-kashtan.dp.ua/api/pharmacy/api'::TVarChar                         AS LikiDneproURL
       , TRIM(ObjectString_TokenKashtan.ValueData)::TVarChar                            AS LikiDneproToken
       , Object_Unit.ObjectCode                                                         AS LikiDneproId

       , 'https://api.preprod.ciet-holding.com/api/v1'::TVarChar                        AS LikiDneproeHealthURL
       , 'https://preprod.ciet-holding.com/login'::TVarChar                             AS LikiDneproeLocation
       , '98bfd760a1b65cd45641ca2e1d59247d2f846f5a6e75a5d50dc44a213b7f8242'::TVarChar   AS LikiDneproeHealthToken

       , tmpCashSettings.isRemovingPrograms AND
         CASE WHEN EXISTS (SELECT 1 FROM ObjectLink_UserRole_View
         WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin()) THEN FALSE ELSE TRUE END AS isRemovingPrograms
       , tmpCashSettings.ExpressVIPConfirm
       , COALESCE (ObjectBoolean_ErrorRROToVIP.ValueData, FALSE)                  AS isErrorRROToVIP
       
       , tmpLayoutFileCount.LayoutFileCount                                       AS LayoutFileCount
       , tmpLayoutFile.ID                                                         AS LayoutFileID
       
       , COALESCE (ObjectBoolean_SUN_v2_SupplementAddCash.ValueData, FALSE):: Boolean     AS isSupplementAddCash
       , COALESCE (ObjectBoolean_ExpressVIPConfirm.ValueData, FALSE):: Boolean            AS isExpressVIPConfirm
       
       , tmpCashSettings.MinPriceSale

   FROM Object AS Object_Unit

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCashMCS
                                ON ObjectBoolean_NotCashMCS.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_NotCashMCS.DescId = zc_ObjectBoolean_Unit_NotCashMCS()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotCashListDiff
                                ON ObjectBoolean_NotCashListDiff.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_NotCashListDiff.DescId = zc_ObjectBoolean_Unit_NotCashListDiff()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_TechnicalRediscount
                                ON ObjectBoolean_TechnicalRediscount.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_TechnicalRediscount.DescId = zc_ObjectBoolean_Unit_TechnicalRediscount()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_ShareFromPrice
                                ON ObjectBoolean_ShareFromPrice.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_ShareFromPrice.DescId = zc_ObjectBoolean_Unit_ShareFromPrice()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_CheckUKTZED
                                ON ObjectBoolean_CheckUKTZED.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_CheckUKTZED.DescId = zc_ObjectBoolean_Unit_CheckUKTZED()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_GoodsUKTZEDRRO
                                ON ObjectBoolean_GoodsUKTZEDRRO.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_GoodsUKTZEDRRO.DescId = zc_ObjectBoolean_Unit_GoodsUKTZEDRRO()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_MessageByTime
                                ON ObjectBoolean_MessageByTime.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_MessageByTime.DescId = zc_ObjectBoolean_Unit_MessageByTime()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_MessageByTimePD
                                ON ObjectBoolean_MessageByTimePD.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_MessageByTimePD.DescId = zc_ObjectBoolean_Unit_MessageByTimePD()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_ErrorRROToVIP
                                ON ObjectBoolean_ErrorRROToVIP.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_ErrorRROToVIP.DescId = zc_ObjectBoolean_Unit_ErrorRROToVIP()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_ExpressVIPConfirm
                                ON ObjectBoolean_ExpressVIPConfirm.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_ExpressVIPConfirm.DescId = zc_ObjectBoolean_Unit_ExpressVIPConfirm()

        LEFT JOIN ObjectString AS ObjectString_PromoForSale
                               ON ObjectString_PromoForSale.ObjectId = Object_Unit.Id 
                              AND ObjectString_PromoForSale.DescId = zc_ObjectString_Unit_PromoForSale()
        LEFT JOIN ObjectString AS ObjectString_TokenKashtan
                               ON ObjectString_TokenKashtan.ObjectId = Object_Unit.Id
                              AND ObjectString_TokenKashtan.DescId = zc_ObjectString_Unit_TokenKashtan()

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Parent
                             ON ObjectLink_Unit_Parent.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Parent.DescId = zc_ObjectLink_Unit_Parent()
        LEFT JOIN Object AS Object_Parent ON Object_Parent.Id = ObjectLink_Unit_Parent.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                             ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                            AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_ShareFromPrice
                              ON ObjectFloat_ShareFromPrice.ObjectId = Object_Retail.Id
                             AND ObjectFloat_ShareFromPrice.DescId = zc_ObjectFloat_Retail_ShareFromPrice()

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitStart
                             ON ObjectDate_TaxUnitStart.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitStart.DescId = zc_ObjectDate_Unit_TaxUnitStart()

        LEFT JOIN ObjectDate AS ObjectDate_TaxUnitEnd
                             ON ObjectDate_TaxUnitEnd.ObjectId = Object_Unit.Id
                            AND ObjectDate_TaxUnitEnd.DescId = zc_ObjectDate_Unit_TaxUnitEnd()

        LEFT JOIN tmpTaxUnitNight ON tmpTaxUnitNight.UnitID = Object_Unit.Id

        LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal1
                              ON ObjectDate_TimePUSHFinal1.ObjectId = vbCashRegisterId
                             AND ObjectDate_TimePUSHFinal1.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal1()

        LEFT JOIN ObjectDate AS ObjectDate_TimePUSHFinal2
                              ON ObjectDate_TimePUSHFinal2.ObjectId = vbCashRegisterId
                             AND ObjectDate_TimePUSHFinal2.DescId = zc_ObjectDate_CashRegister_TimePUSHFinal2()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_GetHardwareData 
                                ON ObjectBoolean_GetHardwareData.ObjectId = vbCashRegisterId
                               AND ObjectBoolean_GetHardwareData.DescId = zc_ObjectBoolean_CashRegister_GetHardwareData()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SP
                                ON ObjectBoolean_SP.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_SP.DescId = zc_ObjectBoolean_Unit_SP()

        LEFT JOIN ObjectDate AS ObjectDate_SP
                             ON ObjectDate_SP.ObjectId = Object_Unit.Id
                            AND ObjectDate_SP.DescId = zc_ObjectDate_Unit_SP()

        LEFT JOIN ObjectDate AS ObjectDate_StartSP
                             ON ObjectDate_StartSP.ObjectId = Object_Unit.Id
                            AND ObjectDate_StartSP.DescId = zc_ObjectDate_Unit_StartSP()

        LEFT JOIN ObjectDate AS ObjectDate_EndSP
                             ON ObjectDate_EndSP.ObjectId = Object_Unit.Id
                            AND ObjectDate_EndSP.DescId = zc_ObjectDate_Unit_EndSP()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_DividePartionDate
                                ON ObjectBoolean_DividePartionDate.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_DividePartionDate.DescId = zc_ObjectBoolean_Unit_DividePartionDate()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_SUN_v2_SupplementAddCash
                                ON ObjectBoolean_SUN_v2_SupplementAddCash.ObjectId = Object_Unit.Id 
                               AND ObjectBoolean_SUN_v2_SupplementAddCash.DescId = zc_ObjectBoolean_Unit_SUN_SupplementAddCash()

        LEFT JOIN Object AS Object_Helsi_IdSP ON Object_Helsi_IdSP.DescId = zc_Object_SPKind()
                                             AND Object_Helsi_IdSP.ObjectCode  = 1
        LEFT JOIN Object AS Object_Helsi_Id ON Object_Helsi_Id.Id = zc_Enum_Helsi_Id()
        LEFT JOIN Object AS Object_Helsi_be ON Object_Helsi_be.Id = zc_Enum_Helsi_be()
        LEFT JOIN Object AS Object_Helsi_ClientId ON Object_Helsi_ClientId.Id = zc_Enum_Helsi_ClientId()
        LEFT JOIN Object AS Object_Helsi_ClientSecret ON Object_Helsi_ClientSecret.Id = zc_Enum_Helsi_ClientSecret()
        LEFT JOIN Object AS Object_Helsi_IntegrationClient ON Object_Helsi_IntegrationClient.Id = zc_Enum_Helsi_IntegrationClient()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RedeemByHandSP
                                ON ObjectBoolean_RedeemByHandSP.ObjectId = Object_Unit.Id
                               AND ObjectBoolean_RedeemByHandSP.DescId = zc_ObjectBoolean_Unit_RedeemByHandSP()

        LEFT JOIN tmpLoyalty ON 1 = 1
        LEFT JOIN tmpLoyaltySaveMoney ON 1 = 1

        LEFT JOIN tmpCashSettings ON 1 = 1

        LEFT JOIN tmpPermanentDiscount ON 1 = 1


        LEFT JOIN Object AS Object_SPKind ON Object_SPKind.Id = zc_Enum_SPKind_1303()
        LEFT JOIN ObjectFloat AS ObjectFloat_SPKind_Tax
                              ON ObjectFloat_SPKind_Tax.ObjectId = Object_SPKind.Id
                             AND ObjectFloat_SPKind_Tax.DescId = zc_ObjectFloat_SPKind_Tax()        
        LEFT JOIN ObjectLink AS ObjectLink_Unit_PartnerMedical ON ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
                                                              AND ObjectLink_Unit_PartnerMedical.ObjectId = Object_Unit.Id
        LEFT JOIN Object AS Object_PartnerMedical ON Object_PartnerMedical.Id = ObjectLink_Unit_PartnerMedical.ChildObjectId

        LEFT JOIN Object AS Object_DiscountExternal ON Object_DiscountExternal.Id = zfGet_Unit_DiscountExternal(inDiscountExternalID := 13216391 , inUnitId := vbUnitId, inUserID := vbUserId)
        
        LEFT JOIN Object AS Object_DiscountCheck ON Object_DiscountCheck.Id = 13216391

        LEFT JOIN tmpPromoCodeDoctor ON 1 = 1

        LEFT JOIN ObjectLink AS ObjectLink_PartnerMedical_Juridical 
                             ON ObjectLink_PartnerMedical_Juridical.ObjectId = ObjectLink_Unit_PartnerMedical.ChildObjectId
                            AND ObjectLink_PartnerMedical_Juridical.DescId = zc_ObjectLink_PartnerMedical_Juridical()
                                           
        LEFT JOIN tmpContract AS tmpContract
                              ON tmpContract.JuridicalBasisId  = ObjectLink_Unit_Juridical.ChildObjectId
                             AND tmpContract.JuridicalId  =  ObjectLink_PartnerMedical_Juridical.ChildObjectId

        LEFT JOIN tmpLayoutFileCount ON 1 = 1
        LEFT JOIN tmpLayoutFile ON tmpLayoutFile.ORD = 1
        
   WHERE Object_Unit.Id = vbUnitId
   --LIMIT 1
   ;

END;
$BODY$


LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 26.01.20                                                       *
 08.01.20                                                       *
 08.12.19                                                       *
 04.12.19                                                       *
 24.11.19                                                       *
 25.10.19                                                       *
 14.06.19                                                       *
 21.04.19                                                       *
 05.04.19                                                       *
 22.03.19                                                       *
 20.02.19                                                       *

*/

-- тест
-- 
--SELECT LoyaltyID, * FROM gpSelect_Cash_UnitConfig('3000497773', '13543334')
SELECT LoyaltyID, * FROM gpSelect_Cash_UnitConfig('3000497773', '3')