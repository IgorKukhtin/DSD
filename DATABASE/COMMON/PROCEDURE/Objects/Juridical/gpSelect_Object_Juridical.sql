-- Function: gpSelect_Object_Juridical()

-- DROP FUNCTION IF EXISTS gpSelect_Object_Juridical (TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Object_Juridical (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical(
    IN inShowAll        Boolean,   
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               DayTaxSummary TFloat,
               GLNCode TVarChar, isCorporate Boolean, isTaxSummary Boolean,
               JuridicalGroupId Integer, JuridicalGroupName TVarChar,
               GoodsPropertyId Integer, GoodsPropertyName TVarChar,
               RetailId Integer, RetailName TVarChar,
               RetailReportId Integer, RetailReportName TVarChar,
               InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar, 
               InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar, 
               InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar,
               OKPO TVarChar,
               PriceListId Integer, PriceListName TVarChar, 
               PriceListPromoId Integer, PriceListPromoName TVarChar,
               PriceListId_Prior Integer, PriceListName_Prior TVarChar, 
               PriceListId_30103 Integer, PriceListName_30103 TVarChar, 
               PriceListId_30201 Integer, PriceListName_30201 TVarChar, 
               StartPromo TDateTime, EndPromo TDateTime,
               isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbObjectId_Branch_Constraint Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_Juridical());
   vbUserId:= lpGetUserBySession (inSession);


   -- ������������ ������� �������
   vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
   vbObjectId_Branch_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= zfCalc_AccessKey_GuideAll (vbUserId) = FALSE AND (COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbObjectId_Branch_Constraint, 0) > 0);


   -- ���������
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
                                    )
,  tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inShowAll AS isErased WHERE inShowAll = TRUE)

   SELECT 
         Object_Juridical.Id             AS Id 
       , Object_Juridical.ObjectCode     AS Code
       , Object_Juridical.ValueData      AS Name
        
       , COALESCE (ObjectFloat_DayTaxSummary.ValueData, CAST(0 as TFloat)) AS DayTaxSummary

       , ObjectString_GLNCode.ValueData      AS GLNCode
       , ObjectBoolean_isCorporate.ValueData AS isCorporate

       , COALESCE (ObjectBoolean_isTaxSummary.ValueData, False::Boolean)  AS isTaxSummary

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

       , ObjectHistory_JuridicalDetails_View.OKPO

       , Object_PriceList.Id         AS PriceListId
       , Object_PriceList.ValueData  AS PriceListName

       , Object_PriceListPromo.Id         AS PriceListPromoId
       , Object_PriceListPromo.ValueData  AS PriceListPromoName

       , Object_PriceList_Prior.Id         AS PriceListId_Prior
       , Object_PriceList_Prior.ValueData  AS PriceListName_Prior

       , Object_PriceList_30103.Id         AS PriceListId_30103
       , Object_PriceList_30103.ValueData  AS PriceListName_30103

       , Object_PriceList_30201.Id         AS PriceListId_30201
       , Object_PriceList_30201.ValueData  AS PriceListName_30201
       
       , ObjectDate_StartPromo.ValueData AS StartPromo
       , ObjectDate_EndPromo.ValueData   AS EndPromo       

       , Object_Juridical.isErased AS isErased
       
   FROM tmpIsErased
        INNER JOIN Object AS Object_Juridical 
                          ON Object_Juridical.isErased = tmpIsErased.isErased
                         AND Object_Juridical.DescId = zc_Object_Juridical()
                         
        LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.JuridicalId = Object_Juridical.Id
        LEFT JOIN ObjectString AS ObjectString_GLNCode 
                               ON ObjectString_GLNCode.ObjectId = Object_Juridical.Id 
                              AND ObjectString_GLNCode.DescId = zc_ObjectString_Juridical_GLNCode()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_isCorporate
                                ON ObjectBoolean_isCorporate.ObjectId = Object_Juridical.Id 
                               AND ObjectBoolean_isCorporate.DescId = zc_ObjectBoolean_Juridical_isCorporate()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_isTaxSummary
                                ON ObjectBoolean_isTaxSummary.ObjectId = Object_Juridical.Id 
                               AND ObjectBoolean_isTaxSummary.DescId = zc_ObjectBoolean_Juridical_isTaxSummary()

        LEFT JOIN ObjectFloat AS ObjectFloat_DayTaxSummary 
                              ON ObjectFloat_DayTaxSummary.ObjectId = Object_Juridical.Id 
                             AND ObjectFloat_DayTaxSummary.DescId = zc_ObjectFloat_Juridical_DayTaxSummary()

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

        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceList
                             ON ObjectLink_Juridical_PriceList.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_PriceList.DescId = zc_ObjectLink_Juridical_PriceList()
        LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Juridical_PriceList.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PriceListPromo
                             ON ObjectLink_Juridical_PriceListPromo.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_PriceListPromo.DescId = zc_ObjectLink_Juridical_PriceListPromo()
        LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Juridical_PriceListPromo.ChildObjectId

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

   WHERE (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR vbIsConstraint = FALSE)
   ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Juridical (Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.10.15         * add inShowAll
 21.05.15         * add isTaxSummary
 02.02.15                                        * add tmpListBranch_Constraint
 20.11.14         *
 07.11.14         * �������� RetailReport
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

-- ����
-- SELECT * FROM gpSelect_Object_Juridical (FALSE, zfCalc_UserAdmin())
