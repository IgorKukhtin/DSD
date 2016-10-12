-- Function: gpInsertUpdate_Object_GoodsListSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsListSale(
 INOUT ioId                Integer   ,    -- ���� ������� <������ � ���������� �����������> 
    IN inGoodsId           Integer   ,    -- �����
    IN inContractId        Integer   ,    -- �������
    IN inJuridicalId       Integer   ,    -- ��. ����
    IN inPartnerId         Integer   ,    -- ����������
    IN inSession           TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsListSale());
   
   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsListSale(), Null, Null);
                          
   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Partner(), ioId, inPartnerId);
 
    IF vbIsInsert = False THEN
       -- ��������� �������� <���� ����.>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
       -- ��������� �������� <������������ (����.)>
       --PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, inUserId);
    END IF;

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
-- select * from gpInsertUpdate_Object_GoodsListSale(ioId := 0 , inCode := 1 , inName := '�����' , inPhone := '4444' , Mail := '���@kjjkj' , Comment := '' , inGoodsId := 258441 , inJuridicalId := 0 , inContractId := 0 , inGoodsListSaleKindId := 153272 ,  inSession := '5');
