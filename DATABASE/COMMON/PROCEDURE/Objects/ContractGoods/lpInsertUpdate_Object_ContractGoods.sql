-- Function: gpInsertUpdate_Object_ContractGoods  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_ContractGoods (Integer,Integer,Integer,Integer,Integer, TDateTime, TDateTime, Tfloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_ContractGoods(
 INOUT ioId                Integer   ,    -- ���� ������� <> 
    IN inCode              Integer   ,    -- ��� ������� <>
    IN inContractId        Integer   ,    --   
    IN inGoodsId           Integer   ,    -- 
    IN inGoodsKindId       Integer   ,    --   
    IN inStartDate         TDateTime ,    --
    IN inEndDate           TDateTime ,    --
    IN inPrice             Tfloat    ,
    IN inUserId            Integer       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_ContractGoods()); 
   
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_ContractGoods(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ContractGoods(), vbCode_calc, '');

   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractGoods_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractGoods_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ContractGoods_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ContractGoods_Price(), ioId, inPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractGoods_Start(), ioId, inStartDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ContractGoods_End(), ioId, inEndDate);
 

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.11.20         *

*/

-- ����
--