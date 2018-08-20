-- Function: gpGet_Object_Contract()

DROP FUNCTION IF EXISTS gpGet_Object_Contract(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Contract(
    IN inId          Integer,       -- Подразделение 
    IN inSession     TVarChar       -- сессия пользователя 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               JuridicalBasisId Integer, JuridicalBasisName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               GroupMemberSPId Integer, GroupMemberSPName TVarChar,
               BankAccountId Integer, BankAccountName TVarChar, BankName TVarChar, 
               Deferment Integer, Percent TFloat, PercentSP TFloat,
               TotalSumm TFloat,
               OrderSumm TFloat, OrderSummComment TVarChar, OrderTime TVarChar,
               Comment TVarChar,
               SigningDate TDateTime, StartDate TDateTime, EndDate TDateTime,
               isErased boolean) AS
$BODY$
BEGIN

  -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Get_Object_Contract());
   IF COALESCE (inId, 0) = 0
   THEN
       RETURN QUERY 
       SELECT
             CAST (0 as Integer)   AS Id
           , lfGet_ObjectCode(0, zc_Object_Contract()) AS Code
           , CAST ('' as TVarChar) AS Name
           
           , CAST (0 as Integer)   AS JuridicalBasisId
           , CAST ('' as TVarChar) AS JuridicalBasisName 
           
           , CAST (0 as Integer)   AS JuridicalId
           , CAST ('' as TVarChar) AS JuridicalName

           , CAST (0 as Integer)   AS GroupMemberSPId
           , CAST ('' as TVarChar) AS GroupMemberSPName

           , CAST (0 as Integer)   AS BankAccountId
           , CAST ('' as TVarChar) AS BankAccountName
           , CAST ('' as TVarChar) AS BankName

           , 0                     AS Deferment
           , CAST (0 AS TFloat)    AS Percent
           , CAST (0 AS TFloat)    AS PercentSP
           , CAST (0 AS TFloat)    AS TotalSumm

           , CAST (0 AS TFloat)    AS OrderSumm
           , CAST ('' as TVarChar) AS OrderSummComment
           , CAST ('' as TVarChar) AS OrderTime
           
           , CAST (NULL AS TVarChar) AS Comment  

           , CURRENT_DATE :: TDateTime AS SigningDate
           , CURRENT_DATE :: TDateTime AS StartDate
           , CURRENT_DATE :: TDateTime AS EndDate   
       
           , CAST (NULL AS Boolean) AS isErased;
   
   ELSE
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

           , Object_Contract_View.Deferment
           , Object_Contract_View.Percent
           , Object_Contract_View.PercentSP
           , COALESCE (ObjectFloat_TotalSumm.ValueData, 0)         :: TFloat AS TotalSumm

           , ObjectFloat_OrderSumm.ValueData  AS OrderSumm
           , ObjectString_OrderSumm.ValueData AS OrderSummComment
           , ObjectString_OrderTime.ValueData AS OrderTime
           
           , Object_Contract_View.Comment

           , COALESCE (ObjectDate_Signing.ValueData, CURRENT_DATE) :: TDateTime AS SigningDate  
           , COALESCE (ObjectDate_Start.ValueData, CURRENT_DATE)   :: TDateTime AS StartDate 
           , COALESCE (ObjectDate_End.ValueData, CURRENT_DATE)     :: TDateTime AS EndDate  
           
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
  
            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_Contract_View.BankAccountId
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId 

            LEFT JOIN ObjectFloat AS ObjectFloat_OrderSumm
                                  ON ObjectFloat_OrderSumm.ObjectId = Object_Contract_View.ContractId
                                 AND ObjectFloat_OrderSumm.DescId = zc_ObjectFloat_Contract_OrderSumm()

            LEFT JOIN ObjectFloat AS ObjectFloat_TotalSumm
                                  ON ObjectFloat_TotalSumm.ObjectId = Object_Contract_View.ContractId
                                 AND ObjectFloat_TotalSumm.DescId = zc_ObjectFloat_Contract_TotalSumm()

            LEFT JOIN ObjectString AS ObjectString_OrderSumm 
                                   ON ObjectString_OrderSumm.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectString_OrderSumm.DescId = zc_ObjectString_Contract_OrderSumm()
                                  
            LEFT JOIN ObjectString AS ObjectString_OrderTime
                                   ON ObjectString_OrderTime.ObjectId = Object_Contract_View.ContractId
                                  AND ObjectString_OrderTime.DescId = zc_ObjectString_Contract_OrderTime()
                                 
      WHERE Object_Contract_View.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Contract (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.18         * TotalSumm
 14.02.18         *
 08.08.17         *
 03.05.17         * add BankAccount
 08.12.16         *
 01.07.14         *

*/

-- тест
-- SELECT * FROM gpGet_Object_Contract(0,'2')