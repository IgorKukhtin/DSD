-- Function: gpGet_Object_Contract()

DROP FUNCTION IF EXISTS gpGet_Object_Contract(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Object_Contract(
    IN inId          Integer,       -- ������������� 
    IN inSession     TVarChar       -- ������ ������������ 
)
RETURNS TABLE (Id Integer, Code Integer, Name TVarChar,  
               JuridicalBasisId Integer, JuridicalBasisName TVarChar,
               JuridicalId Integer, JuridicalName TVarChar,
               GroupMemberSPId Integer, GroupMemberSPName TVarChar,
               BankAccountId Integer, BankAccountName TVarChar, BankName TVarChar, 
               Deferment Integer, Percent TFloat, PercentSP TFloat,
               Comment TVarChar,
               StartDate TDateTime, EndDate TDateTime,
               isErased boolean) AS
$BODY$
BEGIN

  -- �������� ���� ������������ �� ����� ���������
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

           , CAST (NULL AS TVarChar) AS Comment  

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

           , Object_Contract_View.Comment

           , COALESCE (ObjectDate_Start.ValueData, CURRENT_DATE) :: TDateTime   AS StartDate 
           , COALESCE (ObjectDate_End.ValueData, CURRENT_DATE) :: TDateTime     AS EndDate   
           
           , Object_Contract_View.isErased
       FROM Object_Contract_View
            LEFT JOIN ObjectDate AS ObjectDate_Start
                                 ON ObjectDate_Start.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_Start.DescId = zc_ObjectDate_Contract_Start()
            LEFT JOIN ObjectDate AS ObjectDate_End
                                 ON ObjectDate_End.ObjectId = Object_Contract_View.ContractId
                                AND ObjectDate_End.DescId = zc_ObjectDate_Contract_End()     
            LEFT JOIN ObjectLink AS ObjectLink_BankAccount_Bank
                                 ON ObjectLink_BankAccount_Bank.ObjectId = Object_Contract_View.BankAccountId
                                AND ObjectLink_BankAccount_Bank.DescId = zc_ObjectLink_BankAccount_Bank()
            LEFT JOIN Object AS Object_Bank ON Object_Bank.Id = ObjectLink_BankAccount_Bank.ChildObjectId 

      WHERE Object_Contract_View.Id = inId;
   END IF;
  
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Object_Contract (integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.05.17         * add BankAccount
 08.12.16         *
 01.07.14         *

*/

-- ����
-- SELECT * FROM gpGet_Object_Contract(0,'2')