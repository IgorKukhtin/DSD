-- Function: gpInsertUpdate_Object_GoodsListIncome  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsListIncome (Integer,Integer,Integer,Integer,Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsListIncome(
 INOUT ioId                Integer   ,    -- ���� ������� <������ � ���������� �����������> 
    IN inGoodsId           Integer   ,    -- �����
    IN inContractId        Integer   ,    -- �������
    IN inJuridicalId       Integer   ,    -- ��. ����
    IN inPartnerId         Integer   ,    -- ����������
    IN inGoodsKindId_List  TVarChar  ,    -- ������ ���� ��� ������
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsListIncome());
   
   -- ���� �������, ��������� �����
   vbId := (  SELECT Object_GoodsListIncome.Id 
              FROM Object AS Object_GoodsListIncome 
                     INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Goods
                             ON ObjectLink_GoodsListIncome_Goods.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Goods.DescId = zc_ObjectLink_GoodsListIncome_Goods()
                            AND ObjectLink_GoodsListIncome_Goods.ChildObjectId = inGoodsId
                     INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Partner
                             ON ObjectLink_GoodsListIncome_Partner.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Partner.DescId = zc_ObjectLink_GoodsListIncome_Partner()
                            AND ObjectLink_GoodsListIncome_Partner.ChildObjectId = inPartnerId
                     INNER JOIN ObjectLink AS GoodsListIncome_Contract
                             ON GoodsListIncome_Contract.ObjectId = Object_GoodsListIncome.Id
                            AND GoodsListIncome_Contract.DescId = zc_ObjectLink_GoodsListIncome_Contract()
                            AND GoodsListIncome_Contract.ChildObjectId = inContractId
                     INNER JOIN ObjectLink AS ObjectLink_GoodsListIncome_Juridical
                             ON ObjectLink_GoodsListIncome_Juridical.ObjectId = Object_GoodsListIncome.Id
                            AND ObjectLink_GoodsListIncome_Juridical.DescId = zc_ObjectLink_GoodsListIncome_Juridical()
                            AND ObjectLink_GoodsListIncome_Juridical.ChildObjectId = inJuridicalId
              WHERE Object_GoodsListIncome.DescId = zc_Object_GoodsListIncome());
 
   IF COALESCE(vbId,0) <> 0
      THEN
          -- ��������� �������� <>
          PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListIncome_GoodsKind(), vbId, inGoodsKindId_List);
          --RAISE EXCEPTION '������.������� ��� ����������.';
   END IF;


   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsListIncome(), 0,'');
                          
   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListIncome_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListIncome_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListIncome_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListIncome_Partner(), ioId, inPartnerId);
 
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListIncome_GoodsKind(), ioId, inGoodsKindId_List);

   -- ��������� �������� <���� ��������/���������> - ����� �.�. ����������� � ���������
   -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.03.17         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsListIncome (ioId := 737011 , inGoodsId := 5005 , inContractId := 439611 , inJuridicalId := 15158 , inPartnerId := 313098 , inGoodsKindId_List := '8339,8351,8333,8329' ,  inSession := '5');
