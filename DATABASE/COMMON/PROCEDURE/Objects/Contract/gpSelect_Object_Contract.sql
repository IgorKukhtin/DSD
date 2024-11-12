-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_Contract (TDateTime, TDateTime, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Contract(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsPeriod    Boolean   , --
    IN inIsEndDate   Boolean   , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar, InvNumberArchive TVarChar

             , ContractKeyId Integer, ContractId_Key Integer, Code_Key Integer
             , InvNumber_Key TVarChar, ContractStateKindCode_Key Integer

             , Comment TVarChar, BankAccountExternal TVarChar, BankAccountPartner TVarChar
             , GLNCode TVarChar, PartnerCode TVarChar
             , Term TFloat, EndDate_Term TDateTime
             , SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime, EndDate_real TDateTime
                         
             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, JuridicalGroupName TVarChar
             , RetailId Integer, RetailName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , JuridicalDocumentId Integer, JuridicalDocumentCode Integer, JuridicalDocumentName TVarChar
             , JuridicalInvoiceId Integer, JuridicalInvoiceCode Integer, JuridicalInvoiceName TVarChar
             
             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyGroupCode Integer, InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationCode Integer, InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
                          
             , PersonalTradeId Integer, PersonalTradeCode Integer, PersonalTradeName TVarChar
             , PersonalCollationId Integer, PersonalCollationCode Integer, PersonalCollationName TVarChar
             , PersonalSigningId Integer, PersonalSigningCode Integer, PersonalSigningName TVarChar
            
             , BankAccountId Integer, BankAccountName TVarChar
             , ContractTagId Integer, ContractTagName TVarChar, ContractTagGroupName TVarChar
                          
             , AreaContractId Integer, AreaContractName TVarChar
             , ContractArticleId Integer, ContractArticleName TVarChar
             , ContractStateKindId Integer, ContractStateKindCode Integer
             , ContractTermKindId Integer, ContractTermKindName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar
             
             , OKPO TVarChar
             , BankId Integer, BankName TVarChar
             , BranchId Integer, BranchName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isDefault Boolean, isDefaultOut Boolean
             , isStandart Boolean
             , isPersonal Boolean
             , isUnique Boolean
             , isVat Boolean, isNotVat Boolean
             , isWMS Boolean
             , isRealEx Boolean
             , isIrna Boolean
             , isNotTareReturning Boolean
             , isMarketNot Boolean             

             , DayTaxSummary TFloat
             , DocumentCount TFloat, DateDocument TDateTime

             , StartDate_PriceList TDateTime, PriceListId Integer, PriceListName TVarChar, PriceListName_old TVarChar
             , PriceListGoodsId Integer, PriceListGoodsName TVarChar
             -- , PriceListPromoId Integer, PriceListPromoName TVarChar
             -- , StartPromo TDateTime, EndPromo TDateTime

             , ChangePercent TFloat, ChangePercentPartner TFloat

             , isErased Boolean 
              )
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbIsConstraint Boolean;
   DECLARE vbIsCommerce Boolean;
   DECLARE vbObjectId_Constraint Integer;
   DECLARE vbBranchId_Constraint Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_Contract());
   vbUserId:= lpGetUserBySession (inSession);

   -- определяется уровень доступа
   -- vbObjectId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.JuridicalGroupId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.JuridicalGroupId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.JuridicalGroupId);
   -- vbBranchId_Constraint:= (SELECT Object_RoleAccessKeyGuide_View.BranchId FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.BranchId <> 0 GROUP BY Object_RoleAccessKeyGuide_View.BranchId);
   vbIsConstraint:= zfCalc_AccessKey_GuideAll (vbUserId) = FALSE AND (COALESCE (vbObjectId_Constraint, 0) > 0 OR COALESCE (vbBranchId_Constraint, 0) > 0);
   vbIsCommerce:= (vbIsConstraint OR (EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.AccessKeyId_GuideCommerce <> 0)
                                     AND NOT EXISTS (SELECT 1 FROM Object_RoleAccessKeyGuide_View WHERE Object_RoleAccessKeyGuide_View.UserId = vbUserId AND Object_RoleAccessKeyGuide_View.AccessKeyId_GuideCommerceAll <> 0)
                                    )
                  ) AND zfCalc_AccessKey_GuideAll (vbUserId) = FALSE
                   ;
   -- Галат Е.Н. + Середа Ю.В. + Дмитриева О.В. + Якимчик А.С. + Аналитики Мясо
   vbIsCommerce:= vbIsCommerce = TRUE AND vbUserId NOT IN (106593, 106596, 106594, 602817) AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId = 80536);

   -- Результат
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
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbBranchId_Constraint
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
                                     WHERE ObjectLink_Unit_Branch.ChildObjectId = vbBranchId_Constraint
                                       AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
                                     GROUP BY ObjectLink_Contract_Juridical.ChildObjectId
                                    )
      , tmpContractPriceList AS (SELECT ObjectLink_ContractPriceList_Contract.ChildObjectId AS ContractId
                                      , Object_PriceList.Id                  AS PriceListId
                                      , Object_PriceList.ValueData           AS PriceListName
                                      , ObjectDate_StartDate.ValueData :: TDateTime AS StartDate 
                                 FROM Object AS Object_ContractPriceList
                                      INNER JOIN ObjectDate AS ObjectDate_EndDate
                                                            ON ObjectDate_EndDate.ObjectId = Object_ContractPriceList.Id
                                                           AND ObjectDate_EndDate.DescId = zc_ObjectDate_ContractPriceList_EndDate()
                                                           AND ObjectDate_EndDate.ValueData = zc_DateEnd()
                                      LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                           ON ObjectDate_StartDate.ObjectId = Object_ContractPriceList.Id
                                                          AND ObjectDate_StartDate.DescId = zc_ObjectDate_ContractPriceList_StartDate()
                                
                                      LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_Contract
                                                           ON ObjectLink_ContractPriceList_Contract.ObjectId = Object_ContractPriceList.Id
                                                          AND ObjectLink_ContractPriceList_Contract.DescId = zc_ObjectLink_ContractPriceList_Contract()

                                      LEFT JOIN ObjectLink AS ObjectLink_ContractPriceList_PriceList
                                                           ON ObjectLink_ContractPriceList_PriceList.ObjectId = Object_ContractPriceList.Id
                                                          AND ObjectLink_ContractPriceList_PriceList.DescId = zc_ObjectLink_ContractPriceList_PriceList()
                                      LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_ContractPriceList_PriceList.ChildObjectId  

                                 WHERE Object_ContractPriceList.DescId = zc_Object_ContractPriceList()
                                   AND Object_ContractPriceList.isErased = FALSE
                                 )

   SELECT
         Object_Contract_View.ContractId   AS Id
       , Object_Contract_View.ContractCode AS Code
       , Object_Contract_View.InvNumber
       , ObjectString_InvNumberArchive.ValueData   AS InvNumberArchive

       , View_Contract_InvNumber_Key.ContractKeyId
       , View_Contract_InvNumber_Key.ContractId_Key        AS ContractId_Key
       , View_Contract_InvNumber_Key.ContractCode          AS Code_Key
       , View_Contract_InvNumber_Key.InvNumber             AS InvNumber_Key
       , View_Contract_InvNumber_Key.ContractStateKindCode AS ContractStateKindCode_Key

       , ObjectString_Comment.ValueData            AS Comment 
       , ObjectString_BankAccount.ValueData        AS BankAccountExternal
       , ObjectString_BankAccountPartner.ValueData AS BankAccountPartner
       , ObjectString_GLNCode.ValueData            AS GLNCode
       , ObjectString_PartnerCode.ValueData        AS PartnerCode
       , Object_Contract_View.Term
       , CASE WHEN Object_Contract_View.ContractTermKindId > 0 THEN Object_Contract_View.EndDate_Term ELSE NULL END ::TDateTime AS EndDate_Term

       , ObjectDate_Signing.ValueData AS SigningDate
       , Object_Contract_View.StartDate
       , Object_Contract_View.EndDate
       , Object_Contract_View.EndDate_real
       
       , Object_ContractKind.Id          AS ContractKindId
       , Object_ContractKind.ValueData   AS ContractKindName
       , Object_Juridical.Id             AS JuridicalId
       , Object_Juridical.ObjectCode     AS JuridicalCode
       , Object_Juridical.ValueData      AS JuridicalName
       , Object_JuridicalGroup.ValueData AS JuridicalGroupName
       , Object_Retail.Id                AS RetailId
       , Object_Retail.ValueData         AS RetailName

       , Object_JuridicalBasis.Id           AS JuridicalBasisId
       , Object_JuridicalBasis.ValueData    AS JuridicalBasisName

       , Object_JuridicalDocument.Id             AS JuridicalDocumentId
       , Object_JuridicalDocument.ObjectCode     AS JuridicalDocumentCode
       , Object_JuridicalDocument.ValueData      AS JuridicalDocumentName
       
       , Object_JuridicalInvoice.Id              AS JuridicalInvoiceId
       , Object_JuridicalInvoice.ObjectCode      AS JuridicalInvoiceCode
       , Object_JuridicalInvoice.ValueData       AS JuridicalInvoiceName       

       , Object_PaidKind.Id            AS PaidKindId
       , Object_PaidKind.ValueData     AS PaidKindName

       , Object_InfoMoney_View.InfoMoneyGroupCode
       , Object_InfoMoney_View.InfoMoneyGroupName
       , Object_InfoMoney_View.InfoMoneyDestinationCode
       , Object_InfoMoney_View.InfoMoneyDestinationName
       , Object_InfoMoney_View.InfoMoneyId
       , Object_InfoMoney_View.InfoMoneyCode
       , Object_InfoMoney_View.InfoMoneyName

       , Object_GoodsProperty.Id            AS GoodsPropertyId
       , Object_GoodsProperty.ValueData     AS GoodsPropertyName

       , Object_Personal_View.PersonalId    AS PersonalId
       , Object_Personal_View.PersonalCode  AS PersonalCode
       , Object_Personal_View.PersonalName  AS PersonalName
       
       , Object_PersonalTrade.PersonalId    AS PersonalTradeId
       , Object_PersonalTrade.PersonalCode  AS PersonalTradeCode
       , Object_PersonalTrade.PersonalName  AS PersonalTradeName

       , Object_PersonalCollation.PersonalId    AS PersonalCollationId
       , Object_PersonalCollation.PersonalCode  AS PersonalCollationCode
       , Object_PersonalCollation.PersonalName  AS PersonalCollationName

       , Object_PersonalSigning.PersonalId      AS PersonalSigningId
       , Object_PersonalSigning.PersonalCode    AS PersonalSigningCode
       , Object_PersonalSigning.PersonalName    AS PersonalSigningName

       , Object_BankAccount.Id              AS BankAccountId
       , Object_BankAccount.ValueData       AS BankAccountName

       , Object_Contract_View.ContractTagId
       , Object_Contract_View.ContractTagName
       , Object_Contract_View.ContractTagGroupName

       , Object_AreaContract.Id             AS AreaContractId
       , Object_AreaContract.ValueData      AS AreaContractName

       , Object_ContractArticle.Id          AS ContractArticleId
       , Object_ContractArticle.ValueData   AS ContractArticleName

       , Object_Contract_View.ContractStateKindId
       , Object_Contract_View.ContractStateKindCode

       , Object_ContractTermKind.Id          AS ContractTermKindId
       , Object_ContractTermKind.ValueData   AS ContractTermKindName

       , Object_Currency.Id         AS CurrencyId 
       , Object_Currency.ValueData  AS CurrencyName 

       , ObjectHistory_JuridicalDetails_View.OKPO

       , Object_Bank.Id          AS BankId
       , Object_Bank.ValueData   AS BankName

       , Object_Branch.Id          AS BranchId
       , Object_Branch.ValueData   AS BranchName

       , Object_Insert.ValueData   AS InsertName
       , Object_Update.ValueData   AS UpdateName
       , ObjectDate_Protocol_Insert.ValueData AS InsertDate
       , ObjectDate_Protocol_Update.ValueData AS UpdateDate
       
       , COALESCE (ObjectBoolean_Default.ValueData, False)  AS isDefault
       , COALESCE (ObjectBoolean_DefaultOut.ValueData, False)  AS isDefaultOut
       , COALESCE (ObjectBoolean_Standart.ValueData, False) AS isStandart

       , COALESCE (ObjectBoolean_Personal.ValueData, False) AS isPersonal
       , COALESCE (ObjectBoolean_Unique.ValueData, False)   AS isUnique
       , COALESCE (ObjectBoolean_Vat.ValueData, False)      AS isVat
       , COALESCE (ObjectBoolean_NotVat.ValueData, False)   AS isNotVat
       , COALESCE (ObjectBoolean_isWMS.ValueData, FALSE)              ::Boolean AS isWMS
       , COALESCE (ObjectBoolean_RealEx.ValueData, False)             :: Boolean AS isRealEx
       , COALESCE (ObjectBoolean_Guide_Irna.ValueData, FALSE)         :: Boolean AS isIrna
       , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning
       , COALESCE (ObjectBoolean_MarketNot.ValueData, FALSE)          :: Boolean AS isMarketNot
       
       , ObjectFloat_DayTaxSummary.ValueData AS DayTaxSummary
       , ObjectFloat_DocumentCount.ValueData AS DocumentCount
       , ObjectDate_Document.ValueData AS DateDocument
       
       , tmpContractPriceList.StartDate  ::TDateTime  AS StartDate_PriceList
       , tmpContractPriceList.PriceListId    AS PriceListId 
       , tmpContractPriceList.PriceListName  AS PriceListName
       , Object_PriceList_old.ValueData      AS PriceListName_old

       , Object_PriceListGoods.Id        AS PriceListGoodsId
       , Object_PriceListGoods.ValueData AS PriceListGoodsName

       -- , Object_PriceListPromo.Id         AS PriceListPromoId 
       -- , Object_PriceListPromo.ValueData  AS PriceListPromoName 
       
       -- , COALESCE (ObjectDate_StartPromo.ValueData,CAST (CURRENT_DATE as TDateTime)) AS StartPromo
       -- , COALESCE (ObjectDate_EndPromo.ValueData,CAST (CURRENT_DATE as TDateTime))   AS EndPromo        

       , Object_Contract_View.ChangePercent
       , Object_Contract_View.ChangePercentPartner

       , Object_Contract_View.isErased
       
   FROM Object_Contract_View
        LEFT JOIN tmpListBranch_Constraint ON tmpListBranch_Constraint.JuridicalId = Object_Contract_View.JuridicalId

        LEFT JOIN ObjectDate AS ObjectDate_Signing
                             ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
                            AND Object_Contract_View.InvNumber <> '-'
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                             ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
        LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId

        LEFT JOIN ObjectFloat AS ObjectFloat_DayTaxSummary
                              ON ObjectFloat_DayTaxSummary.ObjectId = Object_Contract_View.ContractId
                             AND ObjectFloat_DayTaxSummary.DescId = zc_ObjectFloat_Contract_DayTaxSummary()

        LEFT JOIN ObjectFloat AS ObjectFloat_DocumentCount
                              ON ObjectFloat_DocumentCount.ObjectId = Object_Contract_View.ContractId
                             AND ObjectFloat_DocumentCount.DescId = zc_ObjectFloat_Contract_DocumentCount()
        LEFT JOIN ObjectDate AS ObjectDate_Document
                             ON ObjectDate_Document.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Document.DescId = zc_ObjectDate_Contract_Document()

        LEFT JOIN ObjectString AS ObjectString_InvNumberArchive
                               ON ObjectString_InvNumberArchive.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_InvNumberArchive.DescId = zc_objectString_Contract_InvNumberArchive()

        LEFT JOIN ObjectString AS ObjectString_Comment
                               ON ObjectString_Comment.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_Comment.DescId = zc_objectString_Contract_Comment()

        LEFT JOIN ObjectString AS ObjectString_BankAccount
                               ON ObjectString_BankAccount.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_BankAccount.DescId = zc_objectString_Contract_BankAccount()

        LEFT JOIN ObjectString AS ObjectString_BankAccountPartner
                               ON ObjectString_BankAccountPartner.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_BankAccountPartner.DescId = zc_objectString_Contract_BankAccountPartner()

        LEFT JOIN ObjectString AS ObjectString_GLNCode
                               ON ObjectString_GLNCode.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_GLNCode.DescId = zc_objectString_Contract_GLNCode()
        LEFT JOIN ObjectString AS ObjectString_PartnerCode
                               ON ObjectString_PartnerCode.ObjectId = Object_Contract_View.ContractId
                              AND ObjectString_PartnerCode.DescId = zc_objectString_Contract_PartnerCode() 

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Default
                                ON ObjectBoolean_Default.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Default.DescId = zc_ObjectBoolean_Contract_Default()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_DefaultOut
                                ON ObjectBoolean_DefaultOut.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_DefaultOut.DescId = zc_ObjectBoolean_Contract_DefaultOut()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Standart
                                ON ObjectBoolean_Standart.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Standart.DescId = zc_ObjectBoolean_Contract_Standart()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal
                                ON ObjectBoolean_Personal.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Personal.DescId = zc_ObjectBoolean_Contract_Personal()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Unique
                                ON ObjectBoolean_Unique.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Unique.DescId = zc_ObjectBoolean_Contract_Unique()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_Vat
                                ON ObjectBoolean_Vat.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Vat.DescId = zc_ObjectBoolean_Contract_Vat()
        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotVat
                                ON ObjectBoolean_NotVat.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_NotVat.DescId = zc_ObjectBoolean_Contract_NotVat()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_isWMS
                                ON ObjectBoolean_isWMS.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_isWMS.DescId = zc_ObjectBoolean_Contract_isWMS()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_RealEx
                                ON ObjectBoolean_RealEx.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_Guide_Irna
                                ON ObjectBoolean_Guide_Irna.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_Guide_Irna.DescId = zc_ObjectBoolean_Guide_Irna()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                                ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()

        LEFT JOIN ObjectBoolean AS ObjectBoolean_MarketNot
                                ON ObjectBoolean_MarketNot.ObjectId = Object_Contract_View.ContractId
                               AND ObjectBoolean_MarketNot.DescId = zc_ObjectBoolean_Contract_MarketNot()

        LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
        LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
        LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
        LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_JuridicalGroup
                             ON ObjectLink_Juridical_JuridicalGroup.ObjectId = Object_Contract_View.JuridicalId
                            AND ObjectLink_Juridical_JuridicalGroup.DescId = zc_ObjectLink_Juridical_JuridicalGroup()
        LEFT JOIN Object AS Object_JuridicalGroup ON Object_JuridicalGroup.Id = ObjectLink_Juridical_JuridicalGroup.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                             ON ObjectLink_Juridical_Retail.ObjectId = Object_Contract_View.JuridicalId
                            AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
        LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Personal
                             ON ObjectLink_Contract_Personal.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Personal.DescId = zc_ObjectLink_Contract_Personal()
        LEFT JOIN Object_Personal_View ON Object_Personal_View.PersonalId = ObjectLink_Contract_Personal.ChildObjectId               

        LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                             ON ObjectLink_Contract_PersonalTrade.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
        LEFT JOIN Object_Personal_View AS Object_PersonalTrade ON Object_PersonalTrade.PersonalId = ObjectLink_Contract_PersonalTrade.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalCollation
                             ON ObjectLink_Contract_PersonalCollation.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_PersonalCollation.DescId = zc_ObjectLink_Contract_PersonalCollation()
        LEFT JOIN Object_Personal_View AS Object_PersonalCollation ON Object_PersonalCollation.PersonalId = ObjectLink_Contract_PersonalCollation.ChildObjectId        
        
        LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalSigning
                             ON ObjectLink_Contract_PersonalSigning.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_PersonalSigning.DescId = zc_ObjectLink_Contract_PersonalSigning()
        LEFT JOIN Object_Personal_View AS Object_PersonalSigning ON Object_PersonalSigning.PersonalId = ObjectLink_Contract_PersonalSigning.ChildObjectId   

        LEFT JOIN ObjectLink AS ObjectLink_Contract_BankAccount
                             ON ObjectLink_Contract_BankAccount.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_BankAccount.DescId = zc_ObjectLink_Contract_BankAccount()
        LEFT JOIN Object AS Object_BankAccount ON Object_BankAccount.Id = ObjectLink_Contract_BankAccount.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_AreaContract
                             ON ObjectLink_Contract_AreaContract.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_AreaContract.DescId = zc_ObjectLink_Contract_AreaContract()
        LEFT JOIN Object AS Object_AreaContract ON Object_AreaContract.Id = ObjectLink_Contract_AreaContract.ChildObjectId                     
            
        LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractArticle
                             ON ObjectLink_Contract_ContractArticle.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_ContractArticle.DescId = zc_ObjectLink_Contract_ContractArticle()
        LEFT JOIN Object AS Object_ContractArticle ON Object_ContractArticle.Id = ObjectLink_Contract_ContractArticle.ChildObjectId                               
      
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Bank
                             ON ObjectLink_Contract_Bank.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_Bank.DescId = zc_ObjectLink_Contract_Bank()
        LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_Contract_Bank.ChildObjectId   

        LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                             ON ObjectLink_Contract_GoodsProperty.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
        LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Contract_GoodsProperty.ChildObjectId 

        LEFT JOIN ObjectLink AS ObjectLink_Contract_Branch
                             ON ObjectLink_Contract_Branch.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_Branch.DescId = zc_ObjectLink_Contract_Branch()
        LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Contract_Branch.ChildObjectId 

        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Insert
                             ON ObjectDate_Protocol_Insert.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Protocol_Insert.DescId = zc_ObjectDate_Protocol_Insert()
        LEFT JOIN ObjectDate AS ObjectDate_Protocol_Update
                             ON ObjectDate_Protocol_Update.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_Protocol_Update.DescId = zc_ObjectDate_Protocol_Update()

        LEFT JOIN ObjectLink AS ObjectLink_Insert
                             ON ObjectLink_Insert.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Insert.DescId = zc_ObjectLink_Protocol_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = ObjectLink_Insert.ChildObjectId   

        LEFT JOIN ObjectLink AS ObjectLink_Update
                             ON ObjectLink_Update.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Update.DescId = zc_ObjectLink_Protocol_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = ObjectLink_Update.ChildObjectId   

        LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                             ON ObjectLink_Contract_JuridicalDocument.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
        LEFT JOIN Object AS Object_JuridicalDocument ON Object_JuridicalDocument.Id = ObjectLink_Contract_JuridicalDocument.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                             ON ObjectLink_Contract_JuridicalInvoice.ObjectId = Object_Contract_View.ContractId 
                            AND ObjectLink_Contract_JuridicalInvoice.DescId = zc_ObjectLink_Contract_JuridicalInvoice()
        LEFT JOIN Object AS Object_JuridicalInvoice ON Object_JuridicalInvoice.Id = ObjectLink_Contract_JuridicalInvoice.ChildObjectId
        
        LEFT JOIN Object AS Object_ContractTermKind ON Object_ContractTermKind.Id = Object_Contract_View.ContractTermKindId

        /*LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                             ON ObjectDate_StartPromo.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Contract_StartPromo()
        LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                             ON ObjectDate_EndPromo.ObjectId = Object_Contract_View.ContractId
                            AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Contract_EndPromo()*/

        --перенесено в отд.справочник ContractPriceList
        LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList_old
                             ON ObjectLink_Contract_PriceList_old.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_PriceList_old.DescId = zc_ObjectLink_Contract_PriceList()
        LEFT JOIN Object AS Object_PriceList_old ON Object_PriceList_old.Id = ObjectLink_Contract_PriceList_old.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceListGoods
                             ON ObjectLink_Contract_PriceListGoods.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_PriceListGoods.DescId = zc_ObjectLink_Contract_PriceListGoods()
        LEFT JOIN Object AS Object_PriceListGoods ON Object_PriceListGoods.Id = ObjectLink_Contract_PriceListGoods.ChildObjectId
        
        LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                             ON ObjectLink_Contract_Currency.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
        LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId


       /*LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceListPromo
                             ON ObjectLink_Contract_PriceListPromo.ObjectId = Object_Contract_View.ContractId
                            AND ObjectLink_Contract_PriceListPromo.DescId = zc_ObjectLink_Contract_PriceListPromo()
        LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Contract_PriceListPromo.ChildObjectId*/

        LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = Object_Juridical.Id 
        LEFT JOIN Object_Contract_InvNumber_Key_View AS View_Contract_InvNumber_Key ON View_Contract_InvNumber_Key.ContractId = Object_Contract_View.ContractId
 
        LEFT JOIN tmpContractPriceList ON tmpContractPriceList.ContractId = Object_Contract_View.ContractId

   WHERE ((inIsPeriod = TRUE AND Object_Contract_View.EndDate_Term BETWEEN inStartDate AND inEndDate AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
          ) OR inIsPeriod = FALSE)
     AND ((inIsEndDate = TRUE AND Object_Contract_View.EndDate_Term <= inEndDate AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close()
          ) OR inIsEndDate = FALSE)

     -- Общефирменные + услуги полученные OR Маркетинг OR Доходы + Продукция
     AND (Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_21400(), zc_Enum_InfoMoneyDestination_21500(), zc_Enum_InfoMoneyDestination_30100())
          OR vbIsCommerce = FALSE)

      AND (ObjectLink_Juridical_JuridicalGroup.ChildObjectId = vbObjectId_Constraint
           OR tmpListBranch_Constraint.JuridicalId > 0
           OR vbIsConstraint = FALSE
           OR vbUserId = 343013
          )

      AND ((Object_Contract_View.isErased = FALSE
        AND Object_Contract_View.ContractStateKindId > 0
        AND Object_Contract_View.ContractStateKindId <> zc_Enum_ContractStateKind_Close())
        OR (inIsPeriod  = FALSE
        AND inIsEndDate = FALSE)
          )
   ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Object_Contract (TDateTime, TDateTime, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.11.24         * isMarketNot
 26.09.23         * isNotTareReturning
 01.05.23         * NotVat
 04.05.22         *
 21.03.22         * isRealEx
 03.11.21         * add BranchId
 21.05.20         * isWMS
 04.02.19         * BankAccountPartner
 18.01.19         * add isDefaultOut
 05.10.18         * add PartnerCode
 30.06.17         * add JuridicalInvoice
 03.03.17         * DayTaxSummary
 13.04.16         * Currency
 05.05.15         * add GoodsProperty
 12.02.15         * add StartPromo, EndPromo,
                        PriceList, PriceListPromo
 15.01.15         * add JuridicalDocument
 10.11.14         * add GLNCode
 18.08.14                                        * add inParams...
 16.08.14                                        * add JuridicalGroupName
 22.05.14         * add zc_ObjectBoolean_Contract_Personal
                        zc_ObjectBoolean_Contract_Unique
 20.05.14                                        * !!!ContractKindName - всегда!!!
 20.05.14                                        * add Object_Contract_View.InvNumber <> '-'
 26.04.14                                        * add View_Contract_InvNumber_Key
 25.04.14                                        * add ContractKeyId
 25.04.14                                        * по другому ContractTag... and ContractStateKind...
 21.04.14         * add zc_ObjectLink_Contract_PersonalTrade
                        zc_ObjectLink_Contract_PersonalCollation
                        zc_ObjectLink_Contract_BankAccount
 19.03.14         * add zc_ObjectBoolean_Contract_Standart
 13.03.14         * add zc_ObjectBoolean_Contract_Default
 25.02.14                                        * add zc_ObjectDate_Protocol_... and zc_ObjectLink_Protocol_...
 21.02.14         * add Bank, BankAccount
 09.01.14         * add PaidKindId
 06.01.14                                        * add OKPO
 14.11.13         * add from redmaine               
 20.10.13                                        * add Object_Contract_View
 20.10.13                                        * add from redmine
 22.07.13         * add  SigningDate, StartDate, EndDate               
 11.06.13         *
 12.04.13                                        *
*/
/*
-- 1.ObjectDate
select lpInsertUpdate_ObjectDate (zc_ObjectDate_Contract_Document(), ObjectId , OperDate)
from (
select MovementLinkObject.ObjectId, count(*) as Count, max (Movement.OperDate) as OperDate
from (select zc_MovementLinkObject_Contract() as DescId union select zc_MovementLinkObject_ContractFrom()  union select zc_MovementLinkObject_ContractTo()) as tmpDesc
      inner join MovementLinkObject on MovementLinkObject.DescId = tmpDesc.DescId
                                   and MovementLinkObject.ObjectId >0
      inner join Movement on Movement.Id = MovementLinkObject.MovementId
                         and Movement.StatusId = zc_Enum_Status_Complete()
group by MovementLinkObject.ObjectId) as xx
-- 2.ObjectFloat
select lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Contract_DocumentCount(), ObjectId , Count)
from (
select MovementLinkObject.ObjectId, count(*) as Count, max (Movement.OperDate) as OperDate
from (select zc_MovementLinkObject_Contract() as DescId union select zc_MovementLinkObject_ContractFrom()  union select zc_MovementLinkObject_ContractTo()) as tmpDesc
      inner join MovementLinkObject on MovementLinkObject.DescId = tmpDesc.DescId
                                   and MovementLinkObject.ObjectId >0
      inner join Movement on Movement.Id = MovementLinkObject.MovementId
                         and Movement.StatusId = zc_Enum_Status_Complete()
group by MovementLinkObject.ObjectId) as xx
*/

-- тест
-- SELECT * FROM gpSelect_Object_Contract (inStartDate:= NULL, inEndDate:= NULL, inIsPeriod:= FALSE, inIsEndDate:= FALSE, inSession := zfCalc_UserAdmin())
