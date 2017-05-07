
-- Function: gpInsertUpdate_Object_GoodsListSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsListSale(
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
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsListSale());
   
   -- ���� �������, ��������� �����
   vbId := (  SELECT Object_GoodsListSale.Id 
              FROM Object AS Object_GoodsListSale 
                     INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                             ON ObjectLink_GoodsListSale_Goods.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                            AND ObjectLink_GoodsListSale_Goods.ChildObjectId = inGoodsId
                     INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                             ON ObjectLink_GoodsListSale_Partner.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                            AND ObjectLink_GoodsListSale_Partner.ChildObjectId = inPartnerId
                     INNER JOIN ObjectLink AS GoodsListSale_Contract
                             ON GoodsListSale_Contract.ObjectId = Object_GoodsListSale.Id
                            AND GoodsListSale_Contract.DescId = zc_ObjectLink_GoodsListSale_Contract()
                            AND GoodsListSale_Contract.ChildObjectId = inContractId
                     INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Juridical
                             ON ObjectLink_GoodsListSale_Juridical.ObjectId = Object_GoodsListSale.Id
                            AND ObjectLink_GoodsListSale_Juridical.DescId = zc_ObjectLink_GoodsListSale_Juridical()
                            AND ObjectLink_GoodsListSale_Juridical.ChildObjectId = inJuridicalId
              WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale());
 
   IF COALESCE(vbId,0) <> 0
      THEN
          -- ��������� �������� <>
          PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListSale_GoodsKind(), vbId, inGoodsKindId_List);
          --RAISE EXCEPTION '������.������� ��� ����������.';
   END IF;


   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsListSale(), 0,'');
                          
   -- ��������� ����� � < >
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Contract(), ioId, inContractId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Juridical(), ioId, inJuridicalId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Partner(), ioId, inPartnerId);
 
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListSale_GoodsKind(), ioId, inGoodsKindId_List);

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
 10.10.16         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsListSale (ioId := 737011 , inGoodsId := 5005 , inContractId := 439611 , inJuridicalId := 15158 , inPartnerId := 313098 , inGoodsKindId_List := '8339,8351,8333,8329' ,  inSession := '5');
