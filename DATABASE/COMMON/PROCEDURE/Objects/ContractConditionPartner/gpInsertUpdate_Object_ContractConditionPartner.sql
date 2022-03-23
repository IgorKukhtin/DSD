-- Function: gpInsertUpdate_Object_ContractConditionPartner  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractConditionPartner (Integer,Integer,Integer,Integer,TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractConditionPartner(
 INOUT ioId                      Integer   ,    -- ���� ������� < > 
    IN inCode                    Integer   ,    -- ��� ������� <>
    IN inContractConditionId     Integer   ,    --   
    IN inPartnerId               Integer   ,    --   
    IN inSession                 TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
   DECLARE vbContractConditionKindName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractConditionPartner());
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractConditionPartner()); 
   
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractConditionPartner(), vbCode_calc);

   -- ��������
   IF COALESCE (inPartnerId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.���������� �� ����������.';
   END IF;   
   -- ��������
   IF COALESCE (inContractConditionId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.������� �������� �� �����������.';
   END IF;   

   -- �������� ������������
   IF EXISTS (SELECT 1
              FROM Object AS Object_ContractConditionPartner
                   INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_ContractCondition
                                         ON ObjectLink_ContractConditionPartner_ContractCondition.ObjectId = Object_ContractConditionPartner.Id
                                        AND ObjectLink_ContractConditionPartner_ContractCondition.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition()
                                        AND ObjectLink_ContractConditionPartner_ContractCondition.ChildObjectId = inContractConditionId
            
                   INNER JOIN ObjectLink AS ObjectLink_ContractConditionPartner_Partner
                                         ON ObjectLink_ContractConditionPartner_Partner.ObjectId = Object_ContractConditionPartner.Id
                                        AND ObjectLink_ContractConditionPartner_Partner.DescId = zc_ObjectLink_ContractConditionPartner_Partner()
                                        AND ObjectLink_ContractConditionPartner_Partner.ChildObjectId = inPartnerId

     WHERE Object_ContractConditionPartner.DescId = zc_Object_ContractConditionPartner()
       AND Object_ContractConditionPartner.Id <> COALESCE (ioId, 0))
   THEN
       vbContractConditionKindName := (SELECT Object_ContractConditionKind.ValueData AS ContractConditionKindName
                                       FROM ObjectLink AS ObjectLink_ContractCondition_ContractConditionKind
                                            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = ObjectLink_ContractCondition_ContractConditionKind.ChildObjectId
                                       WHERE ObjectLink_ContractCondition_ContractConditionKind.ObjectId = inContractConditionId
                                        AND ObjectLink_ContractCondition_ContractConditionKind.DescId = zc_ObjectLink_ContractCondition_ContractConditionKind()
                                      );
          
       RAISE EXCEPTION '������.%�������� ������� �������� <%> � ���������� <%> ��� ���� � �����������.%������������ ���������.', CHR(13), vbContractConditionKindName, lfGet_Object_ValueData (inPartnerId), CHR(13);
   END IF;   


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractConditionPartner(), vbCode_calc, '');

   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractConditionPartner_ContractCondition(), ioId, inContractConditionId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractConditionPartner_Partner(), ioId, inPartnerId);
 

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.11.20         *

*/

-- ����
--