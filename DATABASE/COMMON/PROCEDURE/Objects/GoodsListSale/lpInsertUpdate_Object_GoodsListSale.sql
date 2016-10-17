-- Function: lpInsertUpdate_Object_GoodsListSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsListSale(
    IN inGoodsId           Integer   ,    -- �����
    IN inContractId        Integer   ,    -- �������
    IN inJuridicalId       Integer   ,    -- ��. ����
    IN inPartnerId         Integer   ,    -- ����������
    IN inUserId            Integer        -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbisErased Boolean;
BEGIN

    -- �������� ����� ������� 
    SELECT Object_GoodsListSale.Id 
         , Object_GoodsListSale.isErased 
  INTO vbId, vbisErased
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
    WHERE Object_GoodsListSale.DescId = zc_Object_GoodsListSale();

   IF COALESCE (vbId , 0) <> 0 AND vbisErased = TRUE             -- ������� ���������� �� ������� �� �������� - ������� ������� ��������
      THEN
         -- �������� ������� <������> + ��� �� ����������� ��������
         PERFORM lpUpdate_Object_isErased (inObjectId:= vbId, inUserId:= inUserId); 
         -- ��������� �������� <���� ����.>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), vbId, CURRENT_TIMESTAMP);
 
   ELSE 
       IF COALESCE (vbId , 0) = 0
       THEN
       -- ��������� <������>
       vbId := lpInsertUpdate_Object (0, zc_Object_GoodsListSale(), 0, '');
                          
       -- ��������� ����� � < >
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Contract(), vbId, inContractId);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Goods(), vbId, inGoodsId);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Juridical(), vbId, inJuridicalId);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsListSale_Partner(), vbId, inPartnerId);
 
       -- ��������� �������� <���� ����.>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), vbId, CURRENT_TIMESTAMP);

       -- ��������� ��������
       PERFORM lpInsert_ObjectProtocol (vbId, inUserId);

       END IF;
   END IF;
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.10.16         *

*/

-- ����
-- select * from lpInsertUpdate_Object_GoodsListSale(ioId := 0 , inCode := 1 , inName := '�����' , inPhone := '4444' , Mail := '���@kjjkj' , Comment := '' , inGoodsId := 258441 , inJuridicalId := 0 , inContractId := 0 , inGoodsListSaleKindId := 153272 ,  inSession := '5');
