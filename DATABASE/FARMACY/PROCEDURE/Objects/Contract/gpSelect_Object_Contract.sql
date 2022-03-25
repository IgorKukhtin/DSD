-- Function: gpSelect_Object_Contract()

DROP FUNCTION IF EXISTS gpSelect_Object_Contract(TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_Contract(
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,
               JuridicalBasisId Integer, JuridicalBasisName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               GroupMemberSPId Integer, GroupMemberSPName TVarChar,
               BankAccountId Integer, BankAccountName TVarChar, BankName TVarChar,
               MemberId Integer, MemberName TVarChar,
               Percent_Juridical TFloat,
               Deferment Integer, Percent TFloat, PercentSP TFloat,
               TotalSumm TFloat,
               OrderSumm TFloat, OrderSummComment TVarChar, OrderTime TVarChar,
               Comment TVarChar,
               SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime,
               isReport Boolean,
               isMorionCode Boolean, isBarCode Boolean, 
               isMorionCodeLoad Boolean, isBarCodeLoad Boolean, 
               isPartialPay Boolean, isDefermentContract Boolean,
               isErased Boolean) AS
$BODY$
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Contract());

   RETURN QUERY 
       SELECT 
             Object_Contract_View.Id
           , Object_Contract_View.Code
           , Object_Contract_View.Name
         
           , Object_Contract_View.JuridicalBasisId
           , Object_Contract_View.JuridicalBasisName 
                     
           , Object_Contract_View.JuridicalId
           , Object_Contract_View.JuridicalName 

           , Object_Contract_View.GroupMemberSPId
           , Object_Contract_View.GroupMemberSPName 

           , Object_Contract_View.BankAccountId
           , Object_Contract_View.BankAccountName
           , Object_Bank.ValueData AS BankName

           , Object_Contract_View.MemberId
           , Object_Contract_View.MemberName 

           , ObjectFloat_Percent.ValueData  AS Percent_Juridical
           , Object_Contract_View.Deferment
           , Object_Contract_View.Percent
           , Object_Contract_View.PercentSP
           , COALESCE (ObjectFloat_TotalSumm.ValueData, 0)    :: TFloat AS TotalSumm

           , ObjectFloat_OrderSumm.ValueData  AS OrderSumm
           , ObjectString_OrderSumm.ValueData AS OrderSummComment
           , ObjectString_OrderTime.ValueData AS OrderTime
           
           , Object_Contract_View.Comment

           , COALESCE (ObjectDate_Signing.ValueData, Null) :: TDateTime AS SigningDate
           , ObjectDate_Start.ValueData   AS StartDate 
           , ObjectDate_End.ValueData     AS EndDate   
 
           , COALESCE (ObjectBoolean_Report.ValueData, FALSE)        :: Boolean   AS isReport
           , COALESCE (ObjectBoolean_MorionCode.ValueData, FALSE)    :: Boolean   AS isMorionCode
           , COALESCE (ObjectBoolean_BarCode.ValueData, FALSE)       :: Boolean   AS isBarCode
           , COALESCE (ObjectBoolean_MorionCodeLoad.ValueData, FALSE):: Boolean   AS isMorionCodeLoad
           , COALESCE (ObjectBoolean_BarCodeLoad.ValueData, FALSE)   :: Boolean   AS isBarCodeLoad
           , COALESCE (ObjectBoolean_PartialPay.ValueData, FALSE)    :: Boolean   AS isPartialPay
           , COALESCE (ObjectBoolean_DefermentContract.ValueData, FALSE):: Boolean AS isDefermentContract
           
           , Object_Contract_View.isErased
       FROM Object_Contract_View
            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()  

           LEFT JOIN ObjectDate AS ObjectDate_Signing
                                ON ObjectDate_Signing.ObjectId = Object_Contract_View.ContractId
                               AND ObjectDate_Signing.DescId = zc_ObjectDate_Contract_Signing()

           LEFT JOIN ObjectString AS ObjectString_OrderSumm 
                                  ON ObjectString_OrderSumm.ObjectId = Object_Contract_View.ContractId
                                 AND ObjectString_OrderSumm.DescId = zc_ObjectString_Contract_OrderSumm()
                                 
           LEFT JOIN ObjectString AS ObjectString_OrderTime
                                  ON ObjectString_OrderTime.ObjectId = Object_Contract_View.ContractId
                                 AND ObjectString_OrderTime.DescId = zc_ObjectString_Contract_OrderTime()

           LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm
                                 ON ObjectFloat_OrderSumm.ObjectId = Object_Contract_View.ContractId
                                AND ObjectFloat_OrderSumm.DescId = zc_ObjectFloat_Contract_OrderSumm()

           LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                 ON ObjectFloat_Percent.ObjectId = Object_Contract_View.JuridicalId
                                AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

           LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                                 ON ObjectFloat_TotalSumm.ObjectId = Object_Contract_View.ContractId
                                AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_Contract_TotalSumm()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_Report
                                   ON ObjectBoolean_Report.ObjectId = Object_Contract_View.Id
                                  AND ObjectBoolean_Report.DescId = zc_ObjectBoolean_Contract_Report()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_MorionCode
                                   ON ObjectBoolean_MorionCode.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectBoolean_MorionCode.DescId = zc_ObjectBoolean_Contract_MorionCode()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_BarCode
                                   ON ObjectBoolean_BarCode.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectBoolean_BarCode.DescId = zc_ObjectBoolean_Contract_BarCode()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_MorionCodeLoad
                                   ON ObjectBoolean_MorionCodeLoad.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectBoolean_MorionCodeLoad.DescId = zc_ObjectBoolean_Contract_MorionCodeLoad()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_BarCodeLoad
                                   ON ObjectBoolean_BarCodeLoad.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectBoolean_BarCodeLoad.DescId = zc_ObjectBoolean_Contract_BarCodeLoad()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_PartialPay
                                   ON ObjectBoolean_PartialPay.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectBoolean_PartialPay.DescId = zc_ObjectBoolean_Contract_PartialPay()

           LEFT JOIN ObjectBoolean AS ObjectBoolean_DefermentContract
                                   ON ObjectBoolean_DefermentContract.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectBoolean_DefermentContract.DescId = zc_ObjectBoolean_Contract_DefermentContract()

           LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                ON ObjectLink_BankAccount_Bank.ObjectId = Object_Contract_View.BankAccountId
                               AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
           LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId
;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Object_Contract(TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.09.19         *
 24.09.18         * Member
 20.08.18         * TotalSumm
 14.02.18         *
 08.08.17         * add OrderTime_inf
                        OrderSumm_inf
                        OrderSumm
  03.05.17         * add BankAccount
 11.01.17         * add isReport
 08.12.16         * add Percent
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Object_Contract ('2')