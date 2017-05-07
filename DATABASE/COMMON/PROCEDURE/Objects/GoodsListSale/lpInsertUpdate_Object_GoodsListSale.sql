-- Function: lpInsertUpdate_Object_GoodsListSale  (Integer,Integer,TVarChar,TVarChar,TVarChar,TVarChar,Integer,Integer,TVarChar)

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TFloat, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TFloat, TVarChar, Integer);
-- DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer,Integer,Integer,Integer,Integer, TFloat, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_GoodsListSale (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar, Boolean, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_GoodsListSale(
    IN inId                Integer   ,    -- �� ��������
    IN inGoodsId           Integer   ,    -- �����
    IN inGoodsKindId_max   Integer   ,    -- ��� ������
    IN inContractId        Integer   ,    -- �������
    IN inJuridicalId       Integer   ,    -- ��. ����
    IN inPartnerId         Integer   ,    -- ����������
    IN inAmount            TFloat    ,    -- ���-�� � ����������
    IN inAmountChoice      TFloat    ,    -- ���-�� � ���������� ��� ����
    IN inGoodsKindId_List  TVarChar  ,    -- ������ ���� ��� ������
    IN inisErased          Boolean   ,    -- ������� ������ ��/���
    IN inUserId            Integer        -- ������ ������������
)
 RETURNS VOID
AS
$BODY$
   DECLARE vbId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

   IF COALESCE (inId , 0) <> 0 -- AND vbisErased = TRUE             -- ������� ���������� �� ������� �� �������� - ������� ������� ��������
      THEN
         -- ���� ������� ������� �� �������� ����� ����� �������
         IF inisErased = TRUE 
            THEN
                -- �������� ������� <������> + ��� �� ����������� ��������
                PERFORM lpUpdate_Object_isErased (inObjectId:= inId, inUserId:= inUserId); 
         END IF;

         -- ��������� ��-�� <>
         PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_GoodsListSale_Amount(), inId, inAmount);
         -- ��������� ��-�� <���-�� � ���������� ��� ����> - ������������
         PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsListSale_AmountChoice(), inId, inAmountChoice);

         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListSale_GoodsKind(), inId, inGoodsKindId_List);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_GoodsKind(), inId, inGoodsKindId_max);

         -- ��������� �������� <���� ��������/���������> - ����� �.�. ����������� � ���������
         -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), inId, CURRENT_TIMESTAMP);

         -- ��������� ��������
         PERFORM lpInsert_ObjectProtocol (vbId, inUserId);


   ELSE 
       IF COALESCE (inId , 0) = 0
       THEN
       -- ��������� <������>
       vbId := lpInsertUpdate_Object (0, zc_Object_GoodsListSale(), 0, '');
                          
       -- ��������� ����� � < >
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_Contract(), vbId, inContractId);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_Goods(), vbId, inGoodsId);
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_GoodsKind(), vbId, inGoodsKindId_max);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_Juridical(), vbId, inJuridicalId);
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsListSale_Partner(), vbId, inPartnerId);
       -- ��������� ��-�� <���-�� � ����������> - ������������
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsListSale_Amount(), vbId, inAmount);
       -- ��������� ��-�� <���-�� � ���������� ��� ����> - ������������
       PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsListSale_AmountChoice(), vbId, inAmountChoice);

       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsListSale_GoodsKind(), vbId, inGoodsKindId_List);
 
       -- ��������� �������� <���� ��������/���������> - ����� �.�. ����������� � ���������
       -- PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), vbId, CURRENT_TIMESTAMP);

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
 07.12.16         *
 11.10.16         *
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_GoodsListSale(ioId := 0 , inCode := 1 , inName := '�����' , inPhone := '4444' , Mail := '���@kjjkj' , Comment := '' , inGoodsId := 258441 , inJuridicalId := 0 , inContractId := 0 , inGoodsListSaleKindId := 153272 ,  inSession := '5');
