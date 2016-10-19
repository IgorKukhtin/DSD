-- Function: lpInsertUpdate_Object_GoodsListSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsListSale(
    IN inId                Integer   ,    -- �� ��������
    IN inGoodsId           Integer   ,    -- �����
    IN inContractId        Integer   ,    -- �������
    IN inJuridicalId       Integer   ,    -- ��. ����
    IN inPartnerId         Integer   ,    -- ����������
    IN inAmount            TFloat    ,    -- ���-�� � ����������
    IN inUserId            Integer        -- ������ ������������
)
 RETURNS Void AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbisErased Boolean;
BEGIN

   IF COALESCE (inId , 0) <> 0 -- AND vbisErased = TRUE             -- ������� ���������� �� ������� �� �������� - ������� ������� ��������
      THEN
         -- �������� ������� <������> + ��� �� ����������� ��������
         PERFORM lpUpdate_Object_isErased (inObjectId:= inId, inUserId:= inUserId); 
    
         -- ��������� ��-�� <>
         PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsListSale_Amount(), inId, inAmount);

         -- ��������� �������� <���� ��������/���������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);

   ELSE 
       IF COALESCE (inId , 0) = 0
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
   
       -- ��������� ��-�� <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsListSale_Amount(), vbId, inAmount);
 
       -- ��������� �������� <���� ��������/���������>
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
