-- Function: gpGet_Object_Contract()

DROP FUNCTION IF EXISTS gpGet_Object_Contract (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Contract(
    IN inId             Integer,       -- ключ объекта <Договор>
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , InvNumber TVarChar, InvNumberArchive TVarChar
             , Comment TVarChar, BankAccountExternal TVarChar,BankAccountPartner TVarChar
             , GLNCode TVarChar, PartnerCode TVarChar
             , Term TFloat, DayTaxSummary TFloat
             , SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime
             
             , ContractKindId Integer, ContractKindName TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , JuridicalBasisId Integer, JuridicalBasisName TVarChar
             , JuridicalDocumentId Integer, JuridicalDocumentName TVarChar
             , JuridicalInvoiceId Integer, JuridicalInvoiceName TVarChar

             , PaidKindId Integer, PaidKindName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , GoodsPropertyId Integer, GoodsPropertyName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             
             , PersonalTradeId Integer, PersonalTradeName TVarChar
             , PersonalCollationId Integer, PersonalCollationName TVarChar
             , PersonalSigningId Integer, PersonalSigningName TVarChar

             , BankAccountId Integer, BankAccountName TVarChar
             , ContractTagId Integer, ContractTagName TVarChar
             
             , AreaContractId Integer, AreaContractName TVarChar
             , ContractArticleId Integer, ContractArticleName TVarChar
             , ContractStateKindId Integer, ContractStateKindName TVarChar
             , ContractTermKindId Integer, ContractTermKindName TVarChar
             , CurrencyId Integer, CurrencyName TVarChar

             , BankId Integer, BankName TVarChar
             , BranchId Integer, BranchName TVarChar
             , isDefault Boolean, isDefaultOut Boolean
             , isStandart Boolean

             , isPersonal Boolean
             , isUnique Boolean
             , isRealEx Boolean
             , isNotVat Boolean
             , isNotTareReturning Boolean 
             , isMarketNot Boolean
             
             , PriceListId Integer, PriceListName TVarChar
             , PriceListPromoId Integer, PriceListPromoName TVarChar
             , StartPromo TDateTime, EndPromo TDateTime
             
             , isErased Boolean
              )
AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Object_Contract());

   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             0 :: Integer     AS Id
           , lfGet_ObjectCode(0, zc_Object_Contract()) AS Code
           , '' :: TVarChar   AS InvNumber
           , '' :: TVarChar   AS InvNumberArchive
           , '' :: TVarChar   AS Comment
           , '' :: TVarChar   AS BankAccountExternal
           , '' :: TVarChar   AS BankAccountPartner
           , '' :: TVarChar   AS GLNCode
           , '' :: TVarChar   AS PartnerCode

           , CAST (0 as Tfloat)        AS Term
           , CAST (0 as Tfloat)        AS DayTaxSummary 

           , CURRENT_DATE :: TDateTime AS SigningDate
           , CURRENT_DATE :: TDateTime AS StartDate
           , CURRENT_DATE :: TDateTime AS EndDate

           , 0 :: Integer     AS ContractKindId
           , '' :: TVarChar   AS ContractKindName
           , 0 :: Integer     AS JuridicalId
           , '' :: TVarChar   AS JuridicalName
           , Object_JuridicalBasis.Id        AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData AS JuridicalBasisName
           
           , 0 :: Integer     AS JuridicalDocumentId
           , '' :: TVarChar   AS JuridicalDocumentName
           
           , 0 :: Integer     AS JuridicalInvoiceId
           , '' :: TVarChar   AS JuridicalInvoiceName

           , Object_PaidKind.Id        AS PaidKindId
           , Object_PaidKind.ValueData AS PaidKindName
           , 0 :: Integer     AS InfoMoneyId
           , '' :: TVarChar   AS InfoMoneyName

           , 0 :: Integer     AS GoodsPropertyId
           , '' :: TVarChar   AS GoodsPropertyName

           , 0 :: Integer     AS PersonalId
           , '' :: TVarChar   AS PersonalName
           
           , 0 :: Integer     AS PersonalTradeId
           , '' :: TVarChar   AS PersonalTradeName

           , 0 :: Integer     AS PersonalCollationId
           , '' :: TVarChar   AS PersonalCollationName

           , 0 :: Integer     AS PersonalSigningId
           , '' :: TVarChar   AS PersonalSigningName

           , 0 :: Integer     AS BankAccountId
           , '' :: TVarChar   AS BankAccountName

           , 0 :: Integer     AS ContractTagId
           , '' :: TVarChar   AS ContractTagName           
            
           , 0 :: Integer     AS AreaContractId
           , '' :: TVarChar   AS AreaContractName
           , 0 :: Integer     AS ContractArticleId
           , '' :: TVarChar   AS ContractArticleName
           , 0 :: Integer     AS ContractStateKindId
           , '' :: TVarChar   AS ContractStateKindName 
           , 0 :: Integer     AS ContractTermKindId
           , '' :: TVarChar   AS ContractTermKindName    

           , Object_CurrencyBasis.Id         AS CurrencyId 
           , Object_CurrencyBasis.ValueData  AS CurrencyName 

           , 0 :: Integer     AS BankId
           , '' :: TVarChar   AS BankName

           , 0 :: Integer     AS BranchId
           , '' :: TVarChar   AS BranchName

           , CAST (false as Boolean)   AS isDefault 
           , CAST (false as Boolean)   AS isDefaultOut
           , CAST (false as Boolean)   AS isStandart

           , CAST (false as Boolean)   AS isPersonal 
           , CAST (false as Boolean)   AS isUnique
           , CAST (false as Boolean)   AS isRealEx
           , CAST (FALSE AS Boolean)   AS isNotVat 
           , CAST (FALSE AS Boolean)   AS isNotTareReturning
           , CAST (FALSE AS Boolean)   AS isMarketNot

           , CAST (0 as Integer)       AS PriceListId 
           , CAST ('' as TVarChar)     AS PriceListName 

           , CAST (0 as Integer)       AS PriceListPromoId 
           , CAST ('' as TVarChar)     AS PriceListPromoName 
       
           , CURRENT_DATE :: TDateTime AS StartPromo
           , CURRENT_DATE :: TDateTime AS EndPromo

           , NULL :: Boolean  AS isErased

       FROM Object AS Object_PaidKind
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = 9399 -- ООО АЛАН
            LEFT JOIN Object AS Object_CurrencyBasis ON Object_CurrencyBasis.Id = zc_Enum_Currency_Basis()
       WHERE Object_PaidKind.Id = zc_Enum_PaidKind_FirstForm()
       ;
   ELSE
       RETURN QUERY
       SELECT
             Object_Contract_View.ContractId   AS Id
           , Object_Contract_View.ContractCode AS Code
           
           , Object_Contract_View.InvNumber
           
           , ObjectString_InvNumberArchive.ValueData AS InvNumberArchive
           , ObjectString_Comment.ValueData          AS Comment
           , ObjectString_BankAccount.ValueData      AS BankAccountExternal
           , ObjectString_BankAccountPartner.ValueData AS BankAccountPartner
           , ObjectString_GLNCode.ValueData          AS GLNCode
           , ObjectString_PartnerCode.ValueData      AS PartnerCode
           , ObjectFloat_Term.ValueData              AS Term
           , ObjectFloat_DayTaxSummary.ValueData     AS DayTaxSummary                      

           , ObjectDate_Signing.ValueData  AS SigningDate
           , ObjectDate_Start.ValueData    AS StartDate -- Object_Contract_View.StartDate
           , ObjectDate_End.ValueData      AS EndDate   -- Object_Contract_View.EndDate

           , Object_ContractKind.Id        AS ContractKindId
           , Object_ContractKind.ValueData AS ContractKindName
           , Object_Juridical.Id           AS JuridicalId
           , Object_Juridical.ValueData    AS JuridicalName
           , Object_JuridicalBasis.Id           AS JuridicalBasisId
           , Object_JuridicalBasis.ValueData    AS JuridicalBasisName
           
           , Object_JuridicalDocument.Id        AS JuridicalDocumentId
           , Object_JuridicalDocument.ValueData AS JuridicalDocumentName
           
           , Object_JuridicalInvoice.Id         AS JuridicalInvoiceId
           , Object_JuridicalInvoice.ValueData  AS JuridicalInvoiceName
           
           , Object_PaidKind.Id            AS PaidKindId
           , Object_PaidKind.ValueData     AS PaidKindName

           , Object_InfoMoney_View.InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyName_all AS InfoMoneyName
    
           , Object_GoodsProperty.Id            AS GoodsPropertyId
           , Object_GoodsProperty.ValueData     AS GoodsPropertyName

           , Object_Personal_View.PersonalId    AS PersonalId
           , Object_Personal_View.PersonalName  AS PersonalName
           
           , Object_PersonalTrade.PersonalId    AS PersonalTradeId
           , Object_PersonalTrade.PersonalName  AS PersonalTradeName

           , Object_PersonalCollation.PersonalId    AS PersonalCollationId
           , Object_PersonalCollation.PersonalName  AS PersonalCollationName

           , Object_PersonalSigning.PersonalId      AS PersonalSigningId
           , Object_PersonalSigning.PersonalName    AS PersonalSigningName

           , Object_BankAccount.Id              AS BankAccountId
           , ( '(' || Object_BankAccount.ObjectCode :: TVarChar || ') ' || Object_BankAccount.ValueData) :: TVarChar AS BankAccountName

           , Object_Contract_View.ContractTagId
           , Object_Contract_View.ContractTagName

           , Object_AreaContract.Id                     AS AreaContractId
           , Object_AreaContract.ValueData              AS AreaContractName
           , Object_ContractArticle.Id          AS ContractArticleId
           , Object_ContractArticle.ValueData   AS ContractArticleName
           , Object_Contract_View.ContractStateKindId
           , Object_Contract_View.ContractStateKindName

           , Object_ContractTermKind.Id          AS ContractTermKindId
           , Object_ContractTermKind.ValueData   AS ContractTermKindName

           , COALESCE (Object_Currency.Id, Object_CurrencyBasis.Id)                AS CurrencyId 
           , COALESCE (Object_Currency.ValueData, Object_CurrencyBasis.ValueData)  AS CurrencyName 

           , Object_Bank.Id          AS BankId
           , Object_Bank.ValueData   AS BankName

           , Object_Branch.Id          AS BranchId
           , Object_Branch.ValueData   AS BranchName

           , COALESCE (ObjectBoolean_Default.ValueData, False)     AS isDefault
           , COALESCE (ObjectBoolean_DefaultOut.ValueData, False)  AS isDefaultOut
           , COALESCE (ObjectBoolean_Standart.ValueData, False)    AS isStandart

           , COALESCE (ObjectBoolean_Personal.ValueData, False)  AS isPersonal
           , COALESCE (ObjectBoolean_Unique.ValueData, False)    AS isUnique
           , COALESCE (ObjectBoolean_RealEx.ValueData, False) :: Boolean AS isRealEx
           , COALESCE (ObjectBoolean_NotVat.ValueData, False)             :: Boolean AS isNotVat
           , COALESCE (ObjectBoolean_NotTareReturning.ValueData, FALSE)   :: Boolean AS isNotTareReturning
           , COALESCE (ObjectBoolean_MarketNot.ValueData, FALSE)          :: Boolean AS isMarketNot
           
           , Object_PriceList.Id         AS PriceListId 
           , Object_PriceList.ValueData  AS PriceListName 

           , Object_PriceListPromo.Id         AS PriceListPromoId 
           , Object_PriceListPromo.ValueData  AS PriceListPromoName 
       
           , COALESCE (ObjectDate_StartPromo.ValueData,CAST (CURRENT_DATE as TDateTime)) AS StartPromo
           , COALESCE (ObjectDate_EndPromo.ValueData,CAST (CURRENT_DATE as TDateTime))   AS EndPromo            

           , Object_Contract_View.isErased

       FROM Object_Contract_View
            LEFT JOIN ObjectDate AS ObjectDate_Signing
                                 ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()
            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()                               
            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractKind
                                 ON ObjectLink_Contract_ContractKind.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractKind.DescId = zc_ObjectLink_Contract_ContractKind()
            LEFT JOIN Object AS Object_ContractKind ON Object_ContractKind.Id = ObjectLink_Contract_ContractKind.ChildObjectId
            
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
    
            LEFT JOIN ObjectFloat AS ObjectFloat_DayTaxSummary
                                  ON ObjectFloat_DayTaxSummary.ObjectId = Object_Contract_View.ContractId
                                 AND ObjectFloat_DayTaxSummary.DescId = zc_ObjectFloat_Contract_DayTaxSummary()

            LEFT JOIN ObjectFloat AS ObjectFloat_Term
                                  ON ObjectFloat_Term.ObjectId = Object_Contract_View.ContractId
                                 AND ObjectFloat_Term.DescId = zc_ObjectFloat_Contract_Term()

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

            LEFT JOIN ObjectBoolean AS ObjectBoolean_RealEx
                                    ON ObjectBoolean_RealEx.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_RealEx.DescId = zc_ObjectBoolean_Contract_RealEx()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotVat
                                    ON ObjectBoolean_NotVat.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_NotVat.DescId = zc_ObjectBoolean_Contract_NotVat()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_NotTareReturning
                                    ON ObjectBoolean_NotTareReturning.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_NotTareReturning.DescId = zc_ObjectBoolean_Contract_NotTareReturning()

            LEFT JOIN ObjectBoolean AS ObjectBoolean_MarketNot
                                    ON ObjectBoolean_MarketNot.ObjectId = Object_Contract_View.ContractId
                                   AND ObjectBoolean_MarketNot.DescId = zc_ObjectBoolean_Contract_MarketNot()
                               
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
                                
            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalDocument
                                 ON ObjectLink_Contract_JuridicalDocument.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_JuridicalDocument.DescId = zc_ObjectLink_Contract_JuridicalDocument()
            LEFT JOIN Object AS Object_JuridicalDocument ON Object_JuridicalDocument.Id = ObjectLink_Contract_JuridicalDocument.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_JuridicalInvoice
                                 ON ObjectLink_Contract_JuridicalInvoice.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_JuridicalInvoice.DescId = zc_ObjectLink_Contract_JuridicalInvoice()
            LEFT JOIN Object AS Object_JuridicalInvoice ON Object_JuridicalInvoice.Id = ObjectLink_Contract_JuridicalInvoice.ChildObjectId
            
            LEFT JOIN ObjectLink AS ObjectLink_Contract_GoodsProperty
                                 ON ObjectLink_Contract_GoodsProperty.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_GoodsProperty.DescId = zc_ObjectLink_Contract_GoodsProperty()
            LEFT JOIN Object AS Object_GoodsProperty ON Object_GoodsProperty.Id = ObjectLink_Contract_GoodsProperty.ChildObjectId 

            LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTermKind
                                 ON ObjectLink_Contract_ContractTermKind.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_ContractTermKind.DescId = zc_ObjectLink_Contract_ContractTermKind()
            LEFT JOIN Object AS Object_ContractTermKind ON Object_ContractTermKind.Id = ObjectLink_Contract_ContractTermKind.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Branch
                                 ON ObjectLink_Contract_Branch.ObjectId = Object_Contract_View.ContractId 
                                AND ObjectLink_Contract_Branch.DescId = zc_ObjectLink_Contract_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Contract_Branch.ChildObjectId 

            LEFT JOIN ObjectDate AS ObjectDate_StartPromo
                                 ON ObjectDate_StartPromo.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_StartPromo.DescId = zc_ObjectDate_Contract_StartPromo()
            LEFT JOIN ObjectDate AS ObjectDate_EndPromo
                                 ON ObjectDate_EndPromo.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_EndPromo.DescId = zc_ObjectDate_Contract_EndPromo()
                                
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceList
                                 ON ObjectLink_Contract_PriceList.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_PriceList.DescId = zc_ObjectLink_Contract_PriceList()
            LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = ObjectLink_Contract_PriceList.ChildObjectId
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PriceListPromo
                                 ON ObjectLink_Contract_PriceListPromo.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_PriceListPromo.DescId = zc_ObjectLink_Contract_PriceListPromo()
            LEFT JOIN Object AS Object_PriceListPromo ON Object_PriceListPromo.Id = ObjectLink_Contract_PriceListPromo.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Contract_Currency
                                 ON ObjectLink_Contract_Currency.ObjectId = Object_Contract_View.ContractId
                                AND ObjectLink_Contract_Currency.DescId = zc_ObjectLink_Contract_Currency()
            LEFT JOIN Object AS Object_Currency ON Object_Currency.Id = ObjectLink_Contract_Currency.ChildObjectId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = Object_Contract_View.JuridicalId
            LEFT JOIN Object AS Object_JuridicalBasis ON Object_JuridicalBasis.Id = Object_Contract_View.JuridicalBasisId
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = Object_Contract_View.PaidKindId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = Object_Contract_View.InfoMoneyId
            LEFT JOIN Object AS Object_CurrencyBasis ON Object_CurrencyBasis.Id = zc_Enum_Currency_Basis()

       WHERE Object_Contract_View.ContractId = inId
       --AND Object_Contract_View.EndDate_condition = zc_DateEnd()
       LIMIT 1
       ;

   END IF;
     
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Contract (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.11.24         * isMarketNot
 26.09.23         * isNotTareReturning
 01.05.23         * isNotVat
 21.03.22         * isRealEx
 03.11.21         * add Branch
 04.02.19         * add BankAccountIn
 18.01.19         * add isDefaultOut
 05.10.18         * add PartnerCode
 30.06.17         * add JuridicalInvoice
 03.03.17         * DayTaxSummary
 20.01.16         *
 05.05.15         * add GoodsProperty
 12.02.15         * add StartPromo, EndPromo,
                        PriceList, PriceListPromo
 16.01.15         * add JuridicalDocument
 10.11.14         * add GLNCode
 07.11.14         * AreaContract
 22.05.14         * add zc_ObjectBoolean_Contract_Personal
                        zc_ObjectBoolean_Contract_Unique
 20.05.14                                        * !!! zc_ObjectDate_Contract_Start and zc_ObjectDate_Contract_End and zc_ObjectLink_Contract_ContractKind - всегда!!!
 25.04.14                                        * по другому ContractTag... and ContractStateKind...
 21.04.14         * add zc_ObjectLink_Contract_PersonalTrade
                        zc_ObjectLink_Contract_PersonalCollation
                        zc_ObjectLink_Contract_BankAccount
 19.03.14         * add zc_ObjectBoolean_Contract_Standart
 13.03.14         * add zc_ObjectBoolean_Contract_Default
 21.02.14         * add Bank, BankAccount
 08.11.14                        * 
 14.11.13         * add from redmaine
 20.10.13                                        * add from redmaine
 22.07.13         * add  SigningDate, StartDate, EndDate 
 11.06.13         *
 12.04.13                                        *

*/

-- тест
-- SELECT * FROM gpGet_Object_Contract (inId := 2, inSession := zfCalc_UserAdmin())
-- select * from gpGet_Object_Contract(inId := 3325401 ,  inSession := '5');
