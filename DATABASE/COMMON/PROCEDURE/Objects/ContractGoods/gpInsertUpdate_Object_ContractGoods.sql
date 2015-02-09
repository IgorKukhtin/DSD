-- Function: gpInsertUpdate_Object_ContractGoods  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ContractGoods (Integer,Integer,Integer,Integer,Integer, Tfloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ContractGoods(
 INOUT ioId                Integer   ,    -- ���� ������� < �����/��������> 
    IN inCode              Integer   ,    -- ��� ������� <>
    IN inContractId        Integer   ,    --   
    IN inGoodsId           Integer   ,    -- 
    IN inGoodsKindId       Integer   ,    --   
    IN inPrice             Tfloat    ,
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ContractGoods());
   
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractGoods()); 
   
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractGoods(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractGoods(), vbCode_calc, '');
                                --, inAccessKeyId:= COALESCE ((SELECT Object_Branch.AccessKeyId FROM ObjectLink LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink.ChildObjectId WHERE ObjectLink.ObjectId = inUnitId AND ObjectLink.DescId = zc_ObjectLink_Unit_Branch()), zc_Enum_Process_AccessKey_TrasportDnepr()));
   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractGoods_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractGoods_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractGoods_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractGoods_Price(), ioId, inPrice);
 

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.02.15         *

*/

-- ����
-- select * from gpInsertUpdate_Object_ContractGoods(ioId := 0 , inCode := 1 , inName := '�����' , inPhone := '4444' , Mail := '���@kjjkj' , Comment := '' , inGoodsId := 258441 , inJuridicalId := 0 , inContractId := 0 , inContractGoodsKindId := 153272 ,  inSession := '5');
