-- Function: gpSelect_Object_ContractTradeMark_all (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractTradeMark_Choice (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractTradeMark_Choice(
    IN inisErased    Boolean ,      --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, Code Integer
             , ContractId Integer, ContractCode Integer, ContractName TVarChar
             , TradeMarkId Integer, TradeMarkName TVarChar
             , isErased boolean
             ) AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAccessKeyAll Boolean;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractTradeMark());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
     RETURN QUERY 
       SELECT 
             Object_ContractTradeMark.Id          AS Id
           , Object_ContractTradeMark.ObjectCode  AS Code
         
           , Object_Contract_View.ContractId      AS ContractId
           , Object_Contract_View.ContractCode    AS ContractCode
           , Object_Contract_View.InvNumber       AS ContractName

           , Object_TradeMark.Id                  AS TradeMarkId
           , Object_TradeMark.ValueData           AS TradeMarkName
       
           , Object_ContractTradeMark.isErased    AS isErased
                     
    FROM Object AS Object_ContractTradeMark
            LEFT JOIN ObjectLink AS ContractTradeMark_Contract
                                 ON ContractTradeMark_Contract.ObjectId = Object_ContractTradeMark.Id
                                AND ContractTradeMark_Contract.DescId = zc_ObjectLink_ContractTradeMark_Contract()
            LEFT JOIN Object_Contract_View ON Object_Contract_View.ContractId = ContractTradeMark_Contract.ChildObjectId

            LEFT JOIN ObjectLink AS ObjectLink_ContractTradeMark_TradeMark
                                 ON ObjectLink_ContractTradeMark_TradeMark.ObjectId = Object_ContractTradeMark.Id
                                AND ObjectLink_ContractTradeMark_TradeMark.DescId = zc_ObjectLink_ContractTradeMark_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_ContractTradeMark_TradeMark.ChildObjectId

     WHERE Object_ContractTradeMark.DescId = zc_Object_ContractTradeMark()
      AND (Object_ContractTradeMark.isErased = FALSE OR inisErased = TRUE)
    ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.11.20         *
*/

-- ����
--SELECT * FROM gpSelect_Object_ContractTradeMark_Choice (false, zfCalc_UserAdmin())