-- Function: gpSelect_Object_Juridical_PrintKindItem()

DROP FUNCTION IF EXISTS gpSelect_Object_Juridical_PrintKindItem (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Juridical_PrintKindItem(
    IN inSession        TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               GLNCode TVarChar, isCorporate Boolean,isTaxSummary Boolean,
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
               StartPromo TDateTime, EndPromo TDateTime,

               isMovement boolean, isAccount boolean, isTransport boolean,
               isQuality boolean, isPack boolean, isSpec boolean, isTax boolean,   


               CountMovement Tfloat, CountAccount Tfloat, CountTransport Tfloat,
               CountQuality Tfloat, CountPack Tfloat, CountSpec Tfloat, CountTax Tfloat,  

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
   vbIsConstraint:= COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbObjectId_Branch_Constraint, 0) > 0;


   -- ���������
   RETURN QUERY
   WITH tmpListBranch_Constraint AS (SELECT ObjectLink_Partner_Juridical.ChildObjectId AS JuridicalId
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
                                     GROUP BY ObjectLink_Partner_Juridical.ChildObjectId
                                    UNION
                                     SELECT ObjectLink_Contract_Juridical.ChildObjectId AS JuridicalId
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
                                     GROUP BY ObjectLink_Contract_Juridical.ChildObjectId
                                    )

  , tmpPrintKindItem AS( SELECT tmp.Id
                              , tmp.isMovement, tmp.isAccount, tmp.isTransport
                              , tmp.isQuality, tmp.isPack, tmp.isSpec, tmp.isTax
                              , tmp.CountMovement, tmp.CountAccount, tmp.CountTransport
                              , tmp.CountQuality, tmp.CountPack, tmp.CountSpec, tmp.CountTax
                         FROM lpSelect_Object_PrintKindItem() AS tmp
                                )

   SELECT 
         Object_Juridical.Id             AS Id 
       , Object_Juridical.ObjectCode     AS Code
       , Object_Juridical.ValueData      AS Name

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
       
       , ObjectDate_StartPromo.ValueData AS StartPromo
       , ObjectDate_EndPromo.ValueData   AS EndPromo  

       , COALESCE (tmpPrintKindItem.isMovement, CAST (False AS Boolean))   AS isMovement
       , COALESCE (tmpPrintKindItem.isAccount, CAST (False AS Boolean))    AS isAccount
       , COALESCE (tmpPrintKindItem.isTransport, CAST (False AS Boolean))  AS isTransport
       , COALESCE (tmpPrintKindItem.isQuality, CAST (False AS Boolean))    AS isQuality
       , COALESCE (tmpPrintKindItem.isPack, CAST (False AS Boolean))       AS isPack
       , COALESCE (tmpPrintKindItem.isSpec, CAST (False AS Boolean))       AS isSpec
       , COALESCE (tmpPrintKindItem.isTax, CAST (False AS Boolean))        AS isTax     

       , COALESCE (tmpPrintKindItem.CountMovement, CAST (0 AS TFloat))   AS CountMovement
       , COALESCE (tmpPrintKindItem.CountAccount, CAST (0 AS TFloat))    AS CountAccount
       , COALESCE (tmpPrintKindItem.CountTransport, CAST (0 AS TFloat))  AS CountTransport
       , COALESCE (tmpPrintKindItem.CountQuality, CAST (0 AS TFloat))    AS CountQuality
       , COALESCE (tmpPrintKindItem.CountPack, CAST (0 AS TFloat))       AS CountPack
       , COALESCE (tmpPrintKindItem.CountSpec, CAST (0 AS TFloat))       AS CountSpec
       , COALESCE (tmpPrintKindItem.CountTax, CAST (0 AS TFloat))        AS CountTax

       , Object_Juridical.isErased AS isErased
       
   FROM Object AS Object_Juridical
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

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_PrintKindItem
                             ON ObjectLink_Juridical_PrintKindItem.ObjectId = Object_Juridical.Id 
                            AND ObjectLink_Juridical_PrintKindItem.DescId = zc_ObjectLink_Juridical_PrintKindItem()
	LEFT JOIN tmpPrintKindItem ON tmpPrintKindItem.Id =  ObjectLink_Juridical_PrintKindItem.ChildObjectId

    WHERE Object_Juridical.DescId = zc_Object_Juridical()
      AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR vbIsConstraint = FALSE)
   ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Juridical_PrintKindItem (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 19.01.16         * add ���-�� ���������
 21.05.15         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_Juridical_PrintKindItem ('2')
