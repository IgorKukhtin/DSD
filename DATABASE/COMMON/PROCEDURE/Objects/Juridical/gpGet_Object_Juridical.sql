-- Function: gpGet_Object_Juridical()

DROP FUNCTION IF EXISTS gpGet_Object_Juridical (Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Juridical(
    IN inId          Integer,       -- Юридические лица 
    IN inName        TVarChar,
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               DayTaxSummary TFloat,
               GLNCode TVarChar,
               isCorporate Boolean,  isTaxSummary Boolean, isDiscountPrice Boolean, isPriceWithVAT Boolean,
               isOrderMin Boolean, isNotRealGoods Boolean,
               JuridicalGroupId Integer, JuridicalGroupName TVarChar,
               GoodsPropertyId Integer, GoodsPropertyName TVarChar,
               RetailId Integer, RetailName TVarChar,
               RetailReportId Integer, RetailReportName TVarChar,
               InfoMoneyId Integer, InfoMoneyName TVarChar,
               PriceListId Integer, PriceListName TVarChar,
               PriceListPromoId Integer, PriceListPromoName TVarChar,
               StartPromo TDateTime, EndPromo TDateTime,
               isVatPrice Boolean,
               isVchasnoEdi Boolean, 
               isEdiInvoice Boolean,
               VatPriceDate TDateTime,
               SectionId Integer, SectionName TVarChar
               ) AS
$BODY$
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_Juridical());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)      AS Id
           , 0 ::Integer              AS Code -- lfGet_ObjectCode(0, zc_Object_Juridical())
           --, inName                 AS NAME
           , '' ::TVarChar            AS NAME

           , CAST (0 as TFloat)       AS DayTaxSummary

           , CAST ('' as TVarChar)    AS GLNCode
           , CAST (false as Boolean)  AS isCorporate
           , CAST (false as Boolean)  AS isTaxSummary
           , CAST (false as Boolean)  AS isDiscountPrice
           , CAST (false as Boolean)  AS isPriceWithVAT
           , CAST (false as Boolean)  AS isOrderMin
           , CAST (false as Boolean)  AS isNotRealGoods

           , CAST (0 as Integer)    AS JuridicalGroupId
           , CAST ('' as TVarChar)  AS JuridicalGroupName
           
           , CAST (0 as Integer)    AS GoodsPropertyId 
           , CAST ('' as TVarChar)  AS GoodsPropertyName
 
           , CAST (0 as Integer)    AS RetailId 
           , CAST ('' as TVarChar)  AS RetailName 

           , CAST (0 as Integer)    AS RetailReportId 
           , CAST ('' as TVarChar)  AS RetailReportName 
 
           , CAST (0 as Integer)    AS InfoMoneyId
           , CAST ('' as TVarChar)  AS InfoMoneyName
           
           , CAST (0 as Integer)    AS PriceListId 
           , CAST ('' as TVarChar)  AS PriceListName 

           , CAST (0 as Integer)    AS PriceListPromoId 
           , CAST ('' as TVarChar)  AS PriceListPromoName 
       
           , CURRENT_DATE :: TDateTime AS StartPromo
           , CURRENT_DATE :: TDateTime AS EndPromo
           
           , CAST (false as Boolean)   AS isVatPrice  
           , CAST (FALSE AS Boolean)   AS isVchasnoEdi 
           , CAST (FALSE AS Boolean)   AS isEdiInvoice

           , NULL         :: TDateTime AS VatPriceDate

           , CAST (0 as Integer)    AS SectionId
           , CAST ('' as TVarChar)  AS SectionName
           ;
   ELSE
       RETURN QUERY 
       SELECT 
             Object_Juridical.Id             AS Id
           , Object_Juridical.ObjectCode     AS Code
           , Object_Juridical.ValueData      AS NAME
           
           , COALESCE (ObjectFloat_DayTaxSummary.ValueData, CAST(0 as TFloat)) AS DayTaxSummary

           , ObjectString_GLNCode.ValueData      AS GLNCode
           , ObjectBoolean_isCorporate.ValueData AS isCorporate
           , COALESCE (ObjectBoolean_isTaxSummary.ValueData, False::Boolean)     AS isTaxSummary
           , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, False::Boolean)  AS isDiscountPrice
           , COALESCE (ObjectBoolean_isPriceWithVAT.ValueData, False::Boolean)   AS isPriceWithVAT
           , COALESCE (ObjectBoolean_isOrderMin.ValueData, False::Boolean)       AS isOrderMin
           , COALESCE (ObjectBoolean_isNotRealGoods.ValueData, False::Boolean)   AS isNotRealGoods
           , Object_JuridicalGroup.Id         AS JuridicalGroupId
           , Object_JuridicalGroup.ValueData  AS JuridicalGroupName
           
           , Object_GoodsProperty.Id          AS GoodsPropertyId
           , Object_GoodsProperty.ValueData   AS GoodsPropertyName
           
           , Object_Retail.Id                 AS RetailId
           , Object_Retail.ValueData          AS RetailName

           , Object_RetailReport.Id           AS RetailReportId
           , Object_RetailReport.ValueData    AS RetailReportName
           
           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyName_all AS InfoMoneyName
           
           , Object_PriceList.Id              AS PriceListId 
           , Object_PriceList.ValueData       AS PriceListName 

           , Object_PriceListPromo.Id         AS PriceListPromoId 
           , Object_PriceListPromo.ValueData  AS PriceListPromoName 
       
           , COALESCE (ObjectDate_StartPromo.ValueData,CAST (CURRENT_DATE as TDateTime)) AS StartPromo
           , COALESCE (ObjectDate_EndPromo.ValueData,CAST (CURRENT_DATE as TDateTime))   AS EndPromo

           , COALESCE (ObjectBoolean_isVatPrice.ValueData, FALSE) :: Boolean   AS isVatPrice
           , COALESCE (ObjectBoolean_VchasnoEdi.ValueData, FALSE) :: Boolean   AS isVchasnoEdi
           , COALESCE (ObjectBoolean_isEdiInvoice.ValueData, FALSE) :: Boolean AS isEdiInvoice
           , COALESCE (ObjectDate_VatPrice.ValueData, NULL)       :: TDateTime AS VatPriceDate

           , Object_Section.Id                AS SectionId
           , Object_Section.ValueData         AS SectionName
       FROM Object AS Object_Juridical
           LEFT JOIN ObjectFloat AS ObjectFloat_DayTaxSummary 
                                 ON ObjectFloat_DayTaxSummary.ObjectId = Object_Juridical.Id 
                                AND ObjectFloat_DayTaxSummary.DescId = zc_ObjectFloat_Juridical_DayTaxSummary()

           LEFT JOIN ObjectString AS ObjectString_GLNCode 
                                  ON ObjectString_GLNCode.ObjectId = Object_Juridical.Id 
                                 AND ObjectString_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                   ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isTaxSummary
                                   ON ObjectBoolean_isTaxSummary.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isTaxSummary.DescId = zc_ObjectBoolean_Juridical_isTaxSummary()
           LEFT JOIN ObjectBoolean AS ObjectBoolean_isDiscountPrice
                                   ON ObjectBoolean_isDiscountPrice.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()
           
           LEFT JOIN ObjectBoolean AS ObjectBoolean_isPriceWithVAT
                                   ON ObjectBoolean_isPriceWithVAT.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isPriceWithVAT.DescId = zc_ObjectBoolean_Juridical_isPriceWithVAT()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isOrderMin
                                   ON ObjectBoolean_isOrderMin.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isOrderMin.DescId = zc_ObjectBoolean_Juridical_isOrderMin()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isNotRealGoods
                                   ON ObjectBoolean_isNotRealGoods.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isNotRealGoods.DescId = zc_ObjectBoolean_Juridical_isNotRealGoods()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isVatPrice
                                   ON ObjectBoolean_isVatPrice.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isVatPrice.DescId = zc_ObjectBoolean_Juridical_isVatPrice()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_VchasnoEdi
                                   ON ObjectBoolean_VchasnoEdi.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_VchasnoEdi.DescId = zc_ObjectBoolean_Juridical_VchasnoEdi()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_isEdiInvoice
                                   ON ObjectBoolean_isEdiInvoice.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isEdiInvoice.DescId = zc_ObjectBoolean_Juridical_isEdiInvoice()

           LEFT JOIN ObjectDate AS ObjectDate_VatPrice
                                ON ObjectDate_VatPrice.ObjectId = Object_Juridical.Id
                               AND ObjectDate_VatPrice.DescId = zc_ObjectDate_Juridical_VatPrice()

           LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                                ON ObjectDate_StartPromo.ObjectId = Object_Juridical.Id
                               AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Juridical_StartPromo()

           LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                                ON ObjectDate_EndPromo.ObjectId = Object_Juridical.Id
                               AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Juridical_EndPromo()
           
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                                ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
           LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_GoodsProperty
                                ON ObjectLink_Juridical_GoodsProperty.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_GoodsProperty.DescId = zc_ObjectLink_Juridical_GoodsProperty()
           LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Juridical_GoodsProperty.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
           LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_RetailReport
                                ON ObjectLink_Juridical_RetailReport.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_RetailReport.DescId = zc_ObjectLink_Juridical_RetailReport()
           LEFT JOIN Object AS Object_RetailReport ON Object_RetailReport.Id = ObjectLink_Juridical_RetailReport.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_InfoMoney
                                ON ObjectLink_Juridical_InfoMoney.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_InfoMoney.DescId = zc_ObjectLink_Juridical_InfoMoney()
           LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = ObjectLink_Juridical_InfoMoney.ChildObjectId
           
           LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                                ON ObjectLink_Juridical_PriceList.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
           LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Juridical_PriceList.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                                ON ObjectLink_Juridical_PriceListPromo.ObjectId = Object_Juridical.Id 
                               AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
           LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Juridical_PriceListPromo.ChildObjectId

           LEFT JOIN ObjectLink AS ObjectLink_Juridical_Section
                                ON ObjectLink_Juridical_Section.ObjectId = Object_Juridical.Id
                               AND ObjectLink_Juridical_Section.DescId = zc_ObjectLink_Juridical_Section()
           LEFT JOIN Object AS Object_Section ON Object_Section.Id = ObjectLink_Juridical_Section.ChildObjectId
       WHERE Object_Juridical.Id = inId;
   END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Object_Juridical (Integer, TVarChar, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 07.04.25         * isEdiInvoice
 14.03.25         * isVchasnoEdi
 02.11.22         * add Section
 30.09.22         * 
 06.05.20         * add isVatPrice, VatPriceDate
 24.10.19         * isOrderMin
 07.02.17         * add isPriceWithVAT
 17.12.15         * add isDiscountPrice
 21.05.15         * add  isTaxSummary
 20,11,14         * add  Retail
 07.11.14         * изменено RetailReport
 23.05.14         * add Retail
 23.01.14                        * 
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo
 12.06.13         * + InfoMoney              
 12.06.13         *
 14.05.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Juridical (1,'', '2'::TVarChar)