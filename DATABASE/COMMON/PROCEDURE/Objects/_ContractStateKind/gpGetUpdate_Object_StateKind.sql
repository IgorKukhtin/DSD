-- Function: gpSelect_Object_ContractStateKind (TVarChar)

DROP FUNCTION IF EXISTS gpGetUpdate_Object_StateKind (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGetUpdate_Object_StateKind(
    IN inContractStateKindCode Integer,
   OUT Id        Integer,
   OUT TextValue TVarChar, 
    IN inSession TVarChar       -- ������ ������������
)
RETURNS RECORD AS
$BODY$
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_ContractStateKind());
                              
   SELECT
        Object_ContractStateKind.Id  
      , Object_ContractStateKind.ValueData INTO Id, TextValue   
      
   FROM OBJECT AS Object_ContractStateKind
                              
  WHERE Object_ContractStateKind.DescId = zc_Object_ContractStateKind()
    AND Object_ContractStateKind.ObjectCode = inContractStateKindCode;
  
END;$BODY$

LANGUAGE plpgsql VOLATILE;

ALTER FUNCTION gpGetUpdate_Object_StateKind (Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.02.14                         *

*/

-- ����
-- SELECT * FROM gpSelect_Object_ContractStateKind('2')
