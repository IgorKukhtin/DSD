-- Function: gpSelect_Object_ContractDocument(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_Object_ContractDocument(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_ContractDocument(
    IN inContractId      Integer, 
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer
             , FileName TVarChar) AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Select_Object_ContractCondition());

   RETURN QUERY 
     SELECT 
           Object_ContractDocument.Id        AS Id,
           Object_ContractDocument.ValueData AS FileName
        
     FROM Object AS Object_ContractDocument
     JOIN ObjectLink AS ObjectLink_ContractDocument_Contract
       ON ObjectLink_ContractDocument_Contract.ObjectId = Object_ContractDocument.Id
      AND ObjectLink_ContractDocument_Contract.DescId = zc_ObjectLink_ContractDocument_Contract()
      AND ObjectLink_ContractDocument_Contract.ChildObjectId = inContractId; 
          
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Object_ContractDocument (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 10.12.13                        *
*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractCondition ('2')