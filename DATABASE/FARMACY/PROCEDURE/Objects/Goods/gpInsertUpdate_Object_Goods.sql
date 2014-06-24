-- Function: gpInsertUpdate_Object_Goods()

-- DROP FUNCTION gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TFloat, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ���� ������� <�����>
    IN inCode                Integer   ,    -- ��� ������� <�����>
    IN inName                TVarChar  ,    -- �������� ������� <�����>
    IN inMeasureId           Integer   ,    -- ������ �� ������� ���������
    IN inExtraChargeCategoriesId  Integer   ,    -- ��������� �������
    IN inNDS                 TFloat    ,    -- ���
    IN inCashName            TVarChar  ,    -- �������� � �����
    IN inPartyCount          TFloat    ,    -- ����������� ������ � ������
    IN inisReceiptNeed       Boolean   ,    -- ����� �� ������
    IN inPrice               TFloat    ,    -- ����
    IN inPercentReprice      TFloat    ,    -- % �������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   -- !!! IF COALESCE (inCode, 0) = 0
   -- !!! THEN 
   -- !!!     SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Goods();
   -- !!!  ELSE
   -- !!!     Code_max := inCode;
   -- !!! END IF; 
   IF COALESCE (inCode, 0) = 0  THEN Code_max := NULL; ELSE Code_max := inCode; END IF; -- !!! � ��� ������ !!!
   
   -- !!! �������� ������������ <������������>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Goods(), inName);

   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), Code_max, inName);
   -- ��������� ����� � <��������� �������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ExtraChargeCategories(), ioId, inExtraChargeCategoriesId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- ��������� �������� <���>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_NDS(), ioId, inNDS);
   -- ��������� �������� <����������� ������ � ������>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_PartyCount(), ioId, inPartyCount);
   -- ��������� �������� <����>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_Price(), ioId, inPrice);
   -- ��������� �������� <% �������>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_PercentReprice(), ioId, inPercentReprice);
   -- ��������� �������� <�������� � �����>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CashName(), ioId, inCashName);
   -- ��������� �������� <����� �� ������>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Goods_isReceiptNeed(), ioId, inisReceiptNeed);

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TFloat, Boolean, TFloat, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.06.13                        * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Goods
