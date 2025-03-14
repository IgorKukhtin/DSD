-- Function: gpSelect_Object_Juridical()

-- DROP FUNCTION IF EXISTS gpSelect_Object_Juridical (TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Object_Juridical (Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Juridical (TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical(
    IN inShowDate       TDateTime,
    IN inShowAll        Boolean,
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar, BasisCode Integer,
               DayTaxSummary TFloat,
               SummOrderFinance TFloat,
               SummOrderMin TFloat,
               GLNCode TVarChar, isCorporate Boolean, isTaxSummary Boolean,
               isDiscountPrice Boolean, isPriceWithVAT Boolean,
               isLongUKTZED Boolean,
               isOrderMin Boolean,
               JuridicalGroupId Integer, JuridicalGroupName TVarChar,
               GoodsPropertyId Integer, GoodsPropertyName TVarChar,
               RetailId Integer, RetailName TVarChar,
               RetailReportId Integer, RetailReportName TVarChar,
               InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar,
               InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar,
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar,
               JuridicalAddress TVarChar, OKPO TVarChar, INN TVarChar, InvNumberBranch TVarChar,
               JuridicalAddress_inf TVarChar, OKPO_inf TVarChar, INN_inf TVarChar, isDiff Boolean,
               PriceListId Integer, PriceListName TVarChar,
               PriceListPromoId Integer, PriceListPromoName TVarChar,
               PriceListId_Prior Integer, PriceListName_Prior TVarChar,
               PriceListId_30103 Integer, PriceListName_30103 TVarChar,
               PriceListId_30201 Integer, PriceListName_30201 TVarChar,
               SectionId Integer, SectionName TVarChar,
               StartPromo TDateTime, EndPromo TDateTime,
               GUID TVarChar, isGUID Boolean,
               isBranchAll Boolean,
               isNotTare Boolean,
               isNotRealGoods Boolean,
               isVatPrice Boolean,
               VatPriceDate TDateTime,
               isIrna Boolean,
               isVchasnoEdi Boolean,
               isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsIrna Boolean;
   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbObjectId_Branch_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Juridical());
   vbUserId:= lpGetUserBySession (inSession);


   -- !!!Ирна!!!
   vbIsIrna:= zfCalc_User_isIrna (vbUserId);


   -- определяется уровень доступа
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
   vbObjectId_Branch_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= zfCalc_AccessKey_GuideAll (vbUserId) = FALSE AND (COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbObjectId_Branch_Constraint, 0) > 0);


   -- Результат
   RETURN QUERY
   WITH tmpListBranch_Constraint AS (SELECT DISTINCT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                                                ON ObjectLink_Partner_PersonalTrade.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                          INNER JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                                ON ObjectLink_Partner_Juridical.ObjectId = ObjectLink_Partner_PersonalTrade.ObjectId
                                                               AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Branch_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                    UNION
                                     SELECT DISTINCT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Unit_Branch
                                          INNER JOIN ObjectLink AS ObjectLink_Personal_Unit
                                                                ON ObjectLink_Personal_Unit.ChildObjectId = ObjectLink_Unit_Branch.ObjectId
                                                               AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Personal
                                                                ON ObjectLink_Contract_Personal.ChildObjectId = ObjectLink_Personal_Unit.ObjectId
                                                               AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
                                          INNER JOIN ObjectLink AS ObjectLink_Contract_Juridical
                                                                ON ObjectLink_Contract_Juridical.ObjectId = ObjectLink_Contract_Personal.ObjectId
                                                               AND ObjectLink_Contract_Juridical.DescId = zc_ObjectLink_Contract_Juridical()
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbObjectId_Branch_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                    UNION
                                     SELECT DISTINCT ObjectLink_Contract_JuridicalDocument.ChildObjectId AS JuridicalId
                                     FROM ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                     WHERE ObjectLink_Contract_JuridicalDocument.ChildObjectId > 0
                                       AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
                                    )
 , tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

 , tmpJuridical AS (SELECT Object_Juridical.*
                    FROM Object AS Object_Juridical
                         INNER JOIN tmpIsErased ON tmpIsErased.isErased = Object_Juridical.isErased
                    WHERE Object_Juridical.DescId = zc_Object_Juridical()
                   )
 , tmpObjectString AS (SELECT ObjectString.*
                       FROM ObjectString
                       WHERE ObjectString.ObjectId IN (SELECT DISTINCT tmpJuridical.Id FROM tmpJuridical)
                         AND ObjectString.DescId IN (zc_ObjectString_Juridical_GLNCode()
                                                   , zc_ObjectString_Juridical_GUID()
                                                    )
                       )

 , tmpObjectBoolean AS (SELECT ObjectBoolean.*
                       FROM tmpJuridical
                            JOIN ObjectBoolean ON ObjectBoolean.ObjectId = tmpJuridical.Id
                       /*FROM ObjectBoolean
                       WHERE ObjectBoolean.ObjectId IN (SELECT DISTINCT tmpJuridical.Id FROM tmpJuridical)
                         AND ObjectBoolean.DescId IN (zc_ObjectBoolean_Juridical_isCorporate()
                                                    , zc_ObjectBoolean_Juridical_isTaxSummary()
                                                    , zc_ObjectBoolean_Juridical_isDiscountPrice()
                                                    , zc_ObjectBoolean_Juridical_isPriceWithVAT()
                                                    , zc_ObjectBoolean_Juridical_isLongUKTZED()
                                                    , zc_ObjectBoolean_Juridical_isOrderMin()
                                                    , zc_ObjectBoolean_Juridical_isBranchAll()
                                                    , zc_ObjectBoolean_Juridical_isVatPrice()
                                                    , zc_ObjectBoolean_Juridical_isNotRealGoods()
                                                    , zc_ObjectBoolean_Juridical_isNotTare()
                                                    )*/
                       )

 , tmpObjectFloat AS (SELECT ObjectFloat.*
                      FROM ObjectFloat
                      WHERE ObjectFloat.ObjectId IN (SELECT DISTINCT tmpJuridical.Id FROM tmpJuridical)
                        AND ObjectFloat.DescId IN (zc_ObjectFloat_Juridical_DayTaxSummary()
                                                 , zc_ObjectFloat_Juridical_SummOrderFinance()
                                                 , zc_ObjectFloat_Juridical_SummOrderMin()
                                                   )
                       )
 , tmpObjectDate AS (SELECT ObjectDate.*
                      FROM ObjectDate
                      WHERE ObjectDate.ObjectId IN (SELECT DISTINCT tmpJuridical.Id FROM tmpJuridical)
                        AND ObjectDate.DescId = zc_ObjectDate_Juridical_VatPrice()
                       )


   SELECT
         Object_Juridical.Id             AS Id
       , Object_Juridical.ObjectCode     AS Code
       , Object_Juridical.ValueData      AS Name   
       , ObjectFloat_ObjectCode_Basis.ValueData ::Integer AS BasisCode

       , COALESCE (ObjectFloat_DayTaxSummary.ValueData, CAST(0 as TFloat))    AS DayTaxSummary
       , COALESCE (ObjectFloat_SummOrderFinance.ValueData, CAST(0 as TFloat)) AS SummOrderFinance
       , COALESCE (ObjectFloat_SummOrderMin.ValueData, CAST(0 as TFloat))     AS SummOrderMin

       , ObjectString_GLNCode.ValueData      AS GLNCode
       , ObjectBoolean_isCorporate.ValueData AS isCorporate

       , COALESCE (ObjectBoolean_isTaxSummary.ValueData, False::Boolean)     AS isTaxSummary
       , COALESCE (ObjectBoolean_isDiscountPrice.ValueData, False::Boolean)  AS isDiscountPrice
       , COALESCE (ObjectBoolean_isPriceWithVAT.ValueData, False::Boolean)   AS isPriceWithVAT
       , COALESCE (ObjectBoolean_isLongUKTZED.ValueData, TRUE::Boolean)      AS isLongUKTZED
       , COALESCE (ObjectBoolean_isOrderMin.ValueData, False::Boolean)       AS isOrderMin

       , COALESCE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId, 0)  AS JuridicalGroupId
       , Object_JuridicalGroup.ValueData  AS JuridicalGroupName

       , Object_GoodsProperty.Id         AS GoodsPropertyId
       , Object_GoodsProperty.ValueData  AS GoodsPropertyName

       , Object_Retail.Id                AS RetailId
       , Object_Retail.ValueData         AS RetailName

       , Object_RetailReport.Id          AS RetailReportId
       , Object_RetailReport.ValueData   AS RetailReportName

       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName
       , Object_InfoMoney_View.InfoMoneyName_all

       , ObjectHistory_JuridicalDetails_View.JuridicalAddress
       , ObjectHistory_JuridicalDetails_View.OKPO
       , ObjectHistory_JuridicalDetails_View.INN
       , ObjectHistory_JuridicalDetails_View.InvNumberBranch

       , OH_JuridicalDetails.JuridicalAddress  AS JuridicalAddress_inf
       , OH_JuridicalDetails.OKPO              AS OKPO_inf
       , OH_JuridicalDetails.INN               AS INN_inf
       , CASE WHEN (COALESCE(OH_JuridicalDetails.OKPO,'') <> COALESCE(ObjectHistory_JuridicalDetails_View.OKPO,'')) 
                OR (TRIM (COALESCE(OH_JuridicalDetails.INN,'')) <> TRIM (COALESCE(ObjectHistory_JuridicalDetails_View.INN,'')))
              THEN TRUE
              ELSE FALSE
         END AS isDiff

       , Object_PriceList.Id         AS PriceListId
       , Object_PriceList.ValueData  AS PriceListName

       , NULL :: Integer  AS PriceListPromoId   -- Object_PriceListPromo.Id         AS PriceListPromoId
       , ''   :: TVarChar AS PriceListPromoName -- Object_PriceListPromo.ValueData  AS PriceListPromoName

       , Object_PriceList_Prior.Id         AS PriceListId_Prior
       , Object_PriceList_Prior.ValueData  AS PriceListName_Prior

       , Object_PriceList_30103.Id         AS PriceListId_30103
       , Object_PriceList_30103.ValueData  AS PriceListName_30103

       , Object_PriceList_30201.Id         AS PriceListId_30201
       , Object_PriceList_30201.ValueData  AS PriceListName_30201

       , Object_Section.Id                 AS SectionId
       , Object_Section.ValueData          AS SectionName

       --, ObjectDate_StartPromo.ValueData AS StartPromo
       , NULL :: TDateTime                 AS StartPromo
       --, ObjectDate_EndPromo.ValueData   AS EndPromo
       , NULL :: TDateTime                 AS EndPromo


       , ObjectString_GUID.ValueData AS GUID
       , CASE WHEN ObjectString_GUID.ValueData <> '' THEN TRUE ELSE FALSE END :: Boolean AS isGUID
       , COALESCE (ObjectBoolean_isBranchAll.ValueData, FALSE)                :: Boolean AS isBranchAll
       , COALESCE (ObjectBoolean_isNotTare.ValueData, FALSE)                  :: Boolean AS isNotTare
       , COALESCE (ObjectBoolean_isNotRealGoods.ValueData, FALSE)             :: Boolean AS isNotRealGoods

       , COALESCE (ObjectBoolean_isVatPrice.ValueData, FALSE) :: Boolean   AS isVatPrice
       , COALESCE (ObjectDate_VatPrice.ValueData, NULL)       :: TDateTime AS VatPriceDate

       , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE) :: Boolean   AS isIrna
       , COALESCE (ObjectBoolean_VchasnoEdi.ValueData, FALSE) :: Boolean   AS isVchasnoEdi

       , Object_Juridical.isErased   AS isErased

   FROM tmpIsErased
        INNER JOIN Object AS Object_Juridical
                          ON Object_Juridical.isErased = tmpIsErased.isErased
                         AND Object_Juridical.DescId = zc_Object_Juridical()

        LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.JuridicalId = Object_Juridical.Id
        LEFT JOIN tmpObjectString AS ObjectString_GLNCode
                                  ON ObjectString_GLNCode.ObjectId = Object_Juridical.Id
                                 AND ObjectString_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isCorporate
                                   ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isTaxSummary
                                   ON ObjectBoolean_isTaxSummary.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isTaxSummary.DescId = zc_ObjectBoolean_Juridical_isTaxSummary()
        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isDiscountPrice
                                   ON ObjectBoolean_isDiscountPrice.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isDiscountPrice.DescId = zc_ObjectBoolean_Juridical_isDiscountPrice()
        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isPriceWithVAT
                                   ON ObjectBoolean_isPriceWithVAT.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isPriceWithVAT.DescId = zc_ObjectBoolean_Juridical_isPriceWithVAT()
        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isLongUKTZED
                                   ON ObjectBoolean_isLongUKTZED.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isLongUKTZED.DescId = zc_ObjectBoolean_Juridical_isLongUKTZED()

        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isOrderMin
                                   ON ObjectBoolean_isOrderMin.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isOrderMin.DescId = zc_ObjectBoolean_Juridical_isOrderMin()

        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isNotTare
                                   ON ObjectBoolean_isNotTare.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_isNotTare.DescId   = zc_ObjectBoolean_Juridical_isNotTare()

        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isBranchAll
                                ON ObjectBoolean_isBranchAll.ObjectId = Object_Juridical.Id
                               AND ObjectBoolean_isBranchAll.DescId   = zc_ObjectBoolean_Juridical_isBranchAll()

        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isVatPrice
                                   ON ObjectBoolean_isVatPrice.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isVatPrice.DescId = zc_ObjectBoolean_Juridical_isVatPrice()  

        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_isNotRealGoods
                                   ON ObjectBoolean_isNotRealGoods.ObjectId = Object_Juridical.Id 
                                  AND ObjectBoolean_isNotRealGoods.DescId = zc_ObjectBoolean_Juridical_isNotRealGoods()

        LEFT JOIN tmpObjectBoolean AS ObjectBoolean_Guide_Irna
                                   ON ObjectBoolean_Guide_Irna.ObjectId = Object_Juridical.Id
                                  AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_VchasnoEdi
                                ON ObjectBoolean_VchasnoEdi.ObjectId = Object_Juridical.Id 
                               AND ObjectBoolean_VchasnoEdi.DescId = zc_ObjectBoolean_Juridical_VchasnoEdi()
                                    
        LEFT JOIN tmpObjectDate AS ObjectDate_VatPrice
                             ON ObjectDate_VatPrice.ObjectId = Object_Juridical.Id
                            --AND ObjectDate_VatPrice.DescId = zc_ObjectDate_Juridical_VatPrice()

        LEFT JOIN tmpObjectFloat AS ObjectFloat_DayTaxSummary
                              ON ObjectFloat_DayTaxSummary.ObjectId = Object_Juridical.Id
                             AND ObjectFloat_DayTaxSummary.DescId = zc_ObjectFloat_Juridical_DayTaxSummary()
        LEFT JOIN tmpObjectFloat AS ObjectFloat_SummOrderFinance
                                 ON ObjectFloat_SummOrderFinance.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_SummOrderFinance.DescId = zc_ObjectFloat_Juridical_SummOrderFinance()

        LEFT JOIN tmpObjectFloat AS ObjectFloat_SummOrderMin
                                 ON ObjectFloat_SummOrderMin.ObjectId = Object_Juridical.Id
                                AND ObjectFloat_SummOrderMin.DescId = zc_ObjectFloat_Juridical_SummOrderMin()

        LEFT JOIN ObjectFloat AS ObjectFloat_ObjectCode_Basis
                              ON ObjectFloat_ObjectCode_Basis.ObjectId = Object_Juridical.Id
                             AND ObjectFloat_ObjectCode_Basis.DescId   = zc_ObjectFloat_ObjectCode_Basis()

        LEFT JOIN tmpObjectString AS ObjectString_GUID
                                  ON ObjectString_GUID.ObjectId = Object_Juridical.Id
                                 AND ObjectString_GUID.DescId = zc_ObjectString_Juridical_GUID()


        /*LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                             ON ObjectDate_StartPromo.ObjectId = Object_Juridical.Id
                            AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Juridical_StartPromo()

        LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                             ON ObjectDate_EndPromo.ObjectId = Object_Juridical.Id
                            AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Juridical_EndPromo()*/

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

        LEFT JOIN ObjectHistory_JuridicalDetails_View_two AS ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                             ON ObjectLink_Juridical_PriceList.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
        LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Juridical_PriceList.ChildObjectId

        /*LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                             ON ObjectLink_Juridical_PriceListPromo.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
        LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = NULL -- ObjectLink_Juridical_PriceListPromo.ChildObjectId*/

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList_Prior
                             ON ObjectLink_Juridical_PriceList_Prior.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_PriceList_Prior.DescId = zc_ObjectLink_Juridical_PriceListPrior()
        LEFT JOIN Object AS Object_PriceList_Prior ON Object_PriceList_Prior.Id = ObjectLink_Juridical_PriceList_Prior.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList_30103
                             ON ObjectLink_Juridical_PriceList_30103.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_PriceList_30103.DescId = zc_ObjectLink_Juridical_PriceList30103()
        LEFT JOIN Object AS Object_PriceList_30103 ON Object_PriceList_30103.Id = ObjectLink_Juridical_PriceList_30103.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList_30201
                             ON ObjectLink_Juridical_PriceList_30201.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_PriceList_30201.DescId = zc_ObjectLink_Juridical_PriceList30201()
        LEFT JOIN Object AS Object_PriceList_30201 ON Object_PriceList_30201.Id = ObjectLink_Juridical_PriceList_30201.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Section
                             ON ObjectLink_Juridical_Section.ObjectId = Object_Juridical.Id
                            AND ObjectLink_Juridical_Section.DescId = zc_ObjectLink_Juridical_Section()
        LEFT JOIN Object AS Object_Section ON Object_Section.Id = ObjectLink_Juridical_Section.ChildObjectId    

        LEFT JOIN ObjectHistory_JuridicalDetails_ViewByDate AS OH_JuridicalDetails
                                                            ON OH_JuridicalDetails.JuridicalId = Object_Juridical.Id
                                                           AND COALESCE (inShowDate, CURRENT_DATE) >= OH_JuridicalDetails.StartDate
                                                           AND COALESCE (inShowDate, CURRENT_DATE) <  OH_JuridicalDetails.EndDate

   WHERE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId IN (vbObjectId_Constraint
                                                              , 8359 -- 04-Услуги
                                                               )
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR ObjectBoolean_isBranchAll.ValueData = TRUE
           OR vbIsConstraint = FALSE
           OR Object_Juridical.Id IN (408130 -- АГРО СИРОВИНА ТОВ
                                    , 528407  -- ОПТТОРГ-15 ТОВ
                                    , 3136014 -- СХІДТОРГ 2018 ТОВ
                                    , 425715  -- ДІВІЯ ТРЕЙД ТОВ
                                    , 3470472 -- Українська залізниця АТ
                                    , 3754339 -- Амік Україна ПІІ - 30603572
                                     )
           OR vbIsIrna = TRUE
         --OR ObjectHistory_JuridicalDetails_View.OKPO = '2840114093'
         )
     AND (COALESCE (vbIsIrna, FALSE) = FALSE
     --OR (vbIsIrna = FALSE AND COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE) = FALSE)
       OR (vbIsIrna = TRUE  AND ObjectBoolean_Guide_Irna.ValueData = TRUE)
         )
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Juridical (Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 14.03.25         * isVchasnoEdi
 26.04.23         * inShowDate
 02.11.22         * add Section
 30.09.22         *
 04.05.22         *
 30.01.22
 20.10.21         * SummOrderMin
 24.10.19         * isBranchAll
 24.10.19         * isOrderMin
 30.07.19         * SummOrderFinance
 07.02.17         * isPriceWithVAT
 13.01.17         * isLongUKTZED
 17.12.15         * add isDiscountPrice
 05.10.15         * add inShowAll
 21.05.15         * add isTaxSummary
 02.02.15                                        * add tmpListBranch_Constraint
 20.11.14         *
 07.11.14         * изменено RetailReport
 08.09.14                                        * add Object_RoleAccessKeyGuide_View
 29.08.14                                        * add InfoMoneyName_all
 23.05.14         * add Retail
 12.01.14         * add PriceList,
                        PriceListPromo,
                        StartPromo,
                        EndPromo
 28.12.13                                         * add ObjectHistory_JuridicalDetails_View
 20.10.13                                         * add Object_InfoMoney_View
 03.07.13         * +GoodsProperty, InfoMoney
 14.05.13                                        *
*/

-- тест
--SELECT * FROM gpSelect_Object_Juridical ('01.04.2023',FALSE, zfCalc_UserAdmin())
