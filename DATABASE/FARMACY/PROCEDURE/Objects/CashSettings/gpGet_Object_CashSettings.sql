-- Function: gpGet_Object_CashSettings()

DROP FUNCTION IF EXISTS gpGet_Object_CashSettings(TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_CashSettings(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar
             , ShareFromPriceName TVarChar
             , ShareFromPriceCode TVarChar
             , isGetHardwareData Boolean
             , DateBanSUN TDateTime
             , SummaFormSendVIP TFloat
             , PriceFormSendVIP TFloat
             , SummaUrgentlySendVIP TFloat
             , DaySaleForSUN Integer
             , DayNonCommoditySUN Integer
             , isBlockVIP Boolean
             , isPairedOnlyPromo Boolean
             , AttemptsSub Integer
             , UpperLimitPromoBonus TFloat
             , LowerLimitPromoBonus TFloat
             , MinPercentPromoBonus TFloat
             , DayCompensDiscount Integer
             , MethodsAssortmentId Integer
             , MethodsAssortmentName TVarChar
             , AssortmentGeograph Integer
             , AssortmentSales Integer
             , CustomerThreshold TFloat
             , PriceCorrectionDay Integer
             , isRequireUkrName Boolean
             , isRemovingPrograms Boolean
             , PriceSamples TFloat
             , Samples21 TFloat
             , Samples22 TFloat
             , Samples3 TFloat
             , TelegramBotToken TVarChar
             , PercentIC TFloat
             , PercentUntilNextSUN TFloat
             , isEliminateColdSUN Boolean
             , TurnoverMoreSUN2 TFloat
             , DeySupplOutSUN2 Integer
             , DeySupplInSUN2 Integer
             , ExpressVIPConfirm Integer
             , MinPriceSale TFloat
             , DeviationsPrice1303 TFloat
             , isWagesCheckTesting Boolean
             , NormNewMobileOrders Integer
             , UserUpdateMarketingId Integer
             , UserUpdateMarketingName TVarChar
             , LimitCash TFloat
             ) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_User());

   RETURN QUERY 
   SELECT Object_CashSettings.Id                                                   AS Id
        , Object_CashSettings.ObjectCode                                           AS Code
        , Object_CashSettings.ValueData                                            AS Name
        , ObjectString_CashSettings_ShareFromPriceName.ValueData                   AS ShareFromPriceName
        , ObjectString_CashSettings_ShareFromPriceCode.ValueData                   AS ShareFromPriceCode
        , COALESCE(ObjectBoolean_CashSettings_GetHardwareData.ValueData, FALSE)    AS isGetHardwareData
        , ObjectDate_CashSettings_DateBanSUN.ValueData                             AS DateBanSUN
        , ObjectFloat_CashSettings_SummaFormSendVIP.ValueData                      AS SummaFormSendVIP
        , ObjectFloat_CashSettings_PriceFormSendVIP.ValueData                      AS PriceFormSendVIP
        , ObjectFloat_CashSettings_SummaUrgentlySendVIP.ValueData                  AS SummaUrgentlySendVIP
        , ObjectFloat_CashSettings_DaySaleForSUN.ValueData::Integer                AS DaySaleForSUN
        , ObjectFloat_CashSettings_DayNonCommoditySUN.ValueData::Integer           AS DayNonCommoditySUN
        , COALESCE(ObjectBoolean_CashSettings_BlockVIP.ValueData, FALSE)           AS isBlockVIP
        , COALESCE(ObjectBoolean_CashSettings_PairedOnlyPromo.ValueData, FALSE)    AS isPairedOnlyPromo
        , ObjectFloat_CashSettings_AttemptsSub.ValueData::Integer                  AS AttemptsSub
        , ObjectFloat_CashSettings_UpperLimitPromoBonus.ValueData                  AS UpperLimitPromoBonus
        , ObjectFloat_CashSettings_LowerLimitPromoBonus.ValueData                  AS LowerLimitPromoBonus
        , ObjectFloat_CashSettings_MinPercentPromoBonus.ValueData                  AS MinPercentPromoBonus
        , ObjectFloat_CashSettings_DayCompensDiscount.ValueData::Integer           AS DayCompensDiscount
        , Object_MethodsAssortment.Id                                              AS MethodsAssortmentId
        , Object_MethodsAssortment.ValueData                                       AS MethodsAssortmentName
        , ObjectFloat_CashSettings_AssortmentGeograph.ValueData::Integer           AS AssortmentGeograph
        , ObjectFloat_CashSettings_AssortmentSales.ValueData::Integer              AS AssortmentSales
        , ObjectFloat_CashSettings_CustomerThreshold.ValueData                     AS CustomerThreshold
        , ObjectFloat_CashSettings_PriceCorrectionDay.ValueData::Integer           AS PriceCorrectionDay
        , COALESCE(ObjectBoolean_CashSettings_RequireUkrName.ValueData, FALSE)     AS isRequireUkrName
        , COALESCE(ObjectBoolean_CashSettings_RemovingPrograms.ValueData, FALSE)   AS isRemovingPrograms
        , ObjectFloat_CashSettings_PriceSamples.ValueData                          AS PriceSamples
        , ObjectFloat_CashSettings_Samples21.ValueData                             AS Samples21
        , ObjectFloat_CashSettings_Samples22.ValueData                             AS Samples22
        , ObjectFloat_CashSettings_Samples3.ValueData                              AS Samples3
        , ObjectString_CashSettings_TelegramBotToken.ValueData                     AS TelegramBotToken
        , ObjectFloat_CashSettings_PercentIC.ValueData                             AS PercentIC
        , ObjectFloat_CashSettings_PercentUntilNextSUN.ValueData                   AS PercentUntilNextSUN
        , COALESCE(ObjectBoolean_CashSettings_EliminateColdSUN.ValueData, FALSE)   AS isEliminateColdSUN
        , ObjectFloat_CashSettings_TurnoverMoreSUN2.ValueData                      AS TurnoverMoreSUN2
        , ObjectFloat_CashSettings_DeySupplOutSUN2.ValueData::Integer              AS DeySupplOutSUN2
        , ObjectFloat_CashSettings_DeySupplInSUN2.ValueData::Integer               AS DeySupplInSUN2
        , ObjectFloat_CashSettings_ExpressVIPConfirm.ValueData::Integer            AS ExpressVIPConfirm
        , ObjectFloat_CashSettings_MinPriceSale.ValueData                          AS MinPriceSale
        , ObjectFloat_CashSettings_DeviationsPrice1303.ValueData                   AS DeviationsPrice1303
        , COALESCE(ObjectBoolean_CashSettings_WagesCheckTesting.ValueData, FALSE)  AS isWagesCheckTesting
        , ObjectFloat_CashSettings_NormNewMobileOrders.ValueData::Integer          AS NormNewMobileOrders
        , Object_UserUpdateMarketing.Id                                            AS UserUpdateMarketingId
        , Object_UserUpdateMarketing.ValueData                                     AS UserUpdateMarketingName
        , ObjectFloat_CashSettings_LimitCash.ValueData                             AS LimitCash
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
        LEFT JOIN ObjectDate AS ObjectDate_CashSettings_DateBanSUN
                             ON ObjectDate_CashSettings_DateBanSUN.ObjectId = Object_CashSettings.Id 
                            AND ObjectDate_CashSettings_DateBanSUN.DescId = zc_ObjectDate_CashSettings_DateBanSUN()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_SummaFormSendVIP
                              ON ObjectFloat_CashSettings_SummaFormSendVIP.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_SummaFormSendVIP.DescId = zc_ObjectFloat_CashSettings_SummaFormSendVIP()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceFormSendVIP
                              ON ObjectFloat_CashSettings_PriceFormSendVIP.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_PriceFormSendVIP.DescId = zc_ObjectFloat_CashSettings_PriceFormSendVIP()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_SummaUrgentlySendVIP
                              ON ObjectFloat_CashSettings_SummaUrgentlySendVIP.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_SummaUrgentlySendVIP.DescId = zc_ObjectFloat_CashSettings_SummaUrgentlySendVIP()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DaySaleForSUN
                              ON ObjectFloat_CashSettings_DaySaleForSUN.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_DaySaleForSUN.DescId = zc_ObjectFloat_CashSettings_DaySaleForSUN()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DayNonCommoditySUN
                              ON ObjectFloat_CashSettings_DayNonCommoditySUN.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_DayNonCommoditySUN.DescId = zc_ObjectFloat_CashSettings_DayNonCommoditySUN()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AttemptsSub
                              ON ObjectFloat_CashSettings_AttemptsSub.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_AttemptsSub.DescId = zc_ObjectFloat_CashSettings_AttemptsSub()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_UpperLimitPromoBonus
                              ON ObjectFloat_CashSettings_UpperLimitPromoBonus.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_UpperLimitPromoBonus.DescId = zc_ObjectFloat_CashSettings_UpperLimitPromoBonus()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_LowerLimitPromoBonus
                              ON ObjectFloat_CashSettings_LowerLimitPromoBonus.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_LowerLimitPromoBonus.DescId = zc_ObjectFloat_CashSettings_LowerLimitPromoBonus()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_MinPercentPromoBonus
                              ON ObjectFloat_CashSettings_MinPercentPromoBonus.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_MinPercentPromoBonus.DescId = zc_ObjectFloat_CashSettings_MinPercentPromoBonus()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DayCompensDiscount
                              ON ObjectFloat_CashSettings_DayCompensDiscount.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_DayCompensDiscount.DescId = zc_ObjectFloat_CashSettings_DayCompensDiscount()

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AssortmentGeograph
                              ON ObjectFloat_CashSettings_AssortmentGeograph.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_AssortmentGeograph.DescId = zc_ObjectFloat_CashSettings_AssortmentGeograph()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_AssortmentSales
                              ON ObjectFloat_CashSettings_AssortmentSales.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_AssortmentSales.DescId = zc_ObjectFloat_CashSettings_AssortmentSales()

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_CustomerThreshold
                              ON ObjectFloat_CashSettings_CustomerThreshold.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_CustomerThreshold.DescId = zc_ObjectFloat_CashSettings_CustomerThreshold()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceCorrectionDay
                              ON ObjectFloat_CashSettings_PriceCorrectionDay.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_PriceCorrectionDay.DescId = zc_ObjectFloat_CashSettings_PriceCorrectionDay()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_BlockVIP
                                ON ObjectBoolean_CashSettings_BlockVIP.ObjectId = Object_CashSettings.Id 
                               AND ObjectBoolean_CashSettings_BlockVIP.DescId = zc_ObjectBoolean_CashSettings_BlockVIP()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_PairedOnlyPromo
                                ON ObjectBoolean_CashSettings_PairedOnlyPromo.ObjectId = Object_CashSettings.Id 
                               AND ObjectBoolean_CashSettings_PairedOnlyPromo.DescId = zc_ObjectBoolean_CashSettings_PairedOnlyPromo()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_EliminateColdSUN
                                ON ObjectBoolean_CashSettings_EliminateColdSUN.ObjectId = Object_CashSettings.Id 
                               AND ObjectBoolean_CashSettings_EliminateColdSUN.DescId = zc_ObjectBoolean_CashSettings_EliminateColdSUN()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_RequireUkrName
                                ON ObjectBoolean_CashSettings_RequireUkrName.ObjectId = Object_CashSettings.Id 
                               AND ObjectBoolean_CashSettings_RequireUkrName.DescId = zc_ObjectBoolean_CashSettings_RequireUkrName()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_RemovingPrograms
                                ON ObjectBoolean_CashSettings_RemovingPrograms.ObjectId = Object_CashSettings.Id 
                               AND ObjectBoolean_CashSettings_RemovingPrograms.DescId = zc_ObjectBoolean_CashSettings_RemovingPrograms()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_CashSettings_WagesCheckTesting
                                ON ObjectBoolean_CashSettings_WagesCheckTesting.ObjectId = Object_CashSettings.Id 
                               AND ObjectBoolean_CashSettings_WagesCheckTesting.DescId = zc_ObjectBoolean_CashSettings_WagesCheckTesting()

        LEFT JOIN ObjectLink AS ObjectLink_CashSettings_MethodsAssortment
               ON ObjectLink_CashSettings_MethodsAssortment.ObjectId = Object_CashSettings.Id
              AND ObjectLink_CashSettings_MethodsAssortment.DescId = zc_ObjectLink_CashSettings_MethodsAssortment()
        LEFT JOIN Object AS Object_MethodsAssortment ON Object_MethodsAssortment.Id = ObjectLink_CashSettings_MethodsAssortment.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PriceSamples
                              ON ObjectFloat_CashSettings_PriceSamples.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_PriceSamples.DescId = zc_ObjectFloat_CashSettings_PriceSamples()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples21
                              ON ObjectFloat_CashSettings_Samples21.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_Samples21.DescId = zc_ObjectFloat_CashSettings_Samples21()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples22
                              ON ObjectFloat_CashSettings_Samples22.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_Samples22.DescId = zc_ObjectFloat_CashSettings_Samples22()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_Samples3
                              ON ObjectFloat_CashSettings_Samples3.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_Samples3.DescId = zc_ObjectFloat_CashSettings_Samples3()
        LEFT JOIN ObjectString AS ObjectString_CashSettings_TelegramBotToken
                               ON ObjectString_CashSettings_TelegramBotToken.ObjectId = Object_CashSettings.Id 
                              AND ObjectString_CashSettings_TelegramBotToken.DescId = zc_ObjectString_CashSettings_TelegramBotToken()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PercentIC
                              ON ObjectFloat_CashSettings_PercentIC.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_PercentIC.DescId = zc_ObjectFloat_CashSettings_PercentIC()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_PercentUntilNextSUN
                              ON ObjectFloat_CashSettings_PercentUntilNextSUN.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_PercentUntilNextSUN.DescId = zc_ObjectFloat_CashSettings_PercentUntilNextSUN()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_TurnoverMoreSUN2
                              ON ObjectFloat_CashSettings_TurnoverMoreSUN2.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_TurnoverMoreSUN2.DescId = zc_ObjectFloat_CashSettings_TurnoverMoreSUN2()

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DeySupplOutSUN2
                              ON ObjectFloat_CashSettings_DeySupplOutSUN2.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_DeySupplOutSUN2.DescId = zc_ObjectFloat_CashSettings_DeySupplOutSUN2()
        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DeySupplInSUN2
                              ON ObjectFloat_CashSettings_DeySupplInSUN2.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_DeySupplInSUN2.DescId = zc_ObjectFloat_CashSettings_DeySupplInSUN2()

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_ExpressVIPConfirm
                              ON ObjectFloat_CashSettings_ExpressVIPConfirm.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_ExpressVIPConfirm.DescId = zc_ObjectFloat_CashSettings_ExpressVIPConfirm()

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_MinPriceSale
                              ON ObjectFloat_CashSettings_MinPriceSale.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_MinPriceSale.DescId = zc_ObjectFloat_CashSettings_MinPriceSale()

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_DeviationsPrice1303
                              ON ObjectFloat_CashSettings_DeviationsPrice1303.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_DeviationsPrice1303.DescId = zc_ObjectFloat_CashSettings_DeviationsPrice1303()

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_NormNewMobileOrders
                              ON ObjectFloat_CashSettings_NormNewMobileOrders.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_NormNewMobileOrders.DescId = zc_ObjectFloat_CashSettings_NormNewMobileOrders()

        LEFT JOIN ObjectFloat AS ObjectFloat_CashSettings_LimitCash
                              ON ObjectFloat_CashSettings_LimitCash.ObjectId = Object_CashSettings.Id 
                             AND ObjectFloat_CashSettings_LimitCash.DescId = zc_ObjectFloat_CashSettings_LimitCash()

        LEFT JOIN ObjectLink AS ObjectLink_CashSettings_UserUpdateMarketing
               ON ObjectLink_CashSettings_UserUpdateMarketing.ObjectId = Object_CashSettings.Id
              AND ObjectLink_CashSettings_UserUpdateMarketing.DescId = zc_ObjectLink_CashSettings_UserUpdateMarketing()
        LEFT JOIN Object AS Object_UserUpdateMarketing ON Object_UserUpdateMarketing.Id = ObjectLink_CashSettings_UserUpdateMarketing.ChildObjectId

   WHERE Object_CashSettings.DescId = zc_Object_CashSettings()
   LIMIT 1;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_CashSettings(TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.08.19                                                       *

*/

-- тест
-- SELECT * FROM gpGet_Object_CashSettings ('3')