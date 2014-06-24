-- View: Object_Contract_ContractKey_View

CREATE OR REPLACE VIEW Object_Contract_ContractKey_View
AS
  SELECT ObjectLink_Contract_ContractKey.ChildObjectId AS ContractKeyId
       , ObjectLink_Contract_ContractKey.ObjectId      AS ContractId
       , COALESCE (ObjectLink_ContractKey_Contract.ChildObjectId, ObjectLink_Contract_ContractKey.ObjectId) AS ContractId_Key
  FROM ObjectLink AS ObjectLink_Contract_ContractKey
       LEFT JOIN ObjectLink AS ObjectLink_ContractKey_Contract
                            ON ObjectLink_ContractKey_Contract.ObjectId = ObjectLink_Contract_ContractKey.ChildObjectId
                           AND ObjectLink_ContractKey_Contract.DescId = zc_ObjectLink_ContractKey_Contract()
  WHERE ObjectLink_Contract_ContractKey.DescId = zc_ObjectLink_Contract_ContractKey();

ALTER TABLE Object_Contract_ContractKey_View  OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.04.14                                        *
*/

-- ����
-- SELECT * FROM Object_Contract_ContractKey_View