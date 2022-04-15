-- Function: gpInsertUpdate_Object_Retail()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Retail(Integer, Integer, TVarChar, Boolean, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Retail(
 INOUT ioId                    Integer   ,     -- ���� ������� <�������� ����> 
    IN inCode                  Integer   ,     -- ��� �������  
    IN inName                  TVarChar  ,     -- �������� ������� 
    IN inOperDateOrder         Boolean   ,     --
    IN inGLNCode               TVarChar  ,     -- ��� GLN - ����������
    IN inGLNCodeCorporate      TVarChar  ,     -- ��� GLN - ��������� 
    IN inOKPO                  TVarChar  ,     -- ���� ��� �����. ����������
    IN inGoodsPropertyId       Integer   ,     -- �������������� ������� �������
    IN inPersonalMarketingId   Integer   ,     -- ��������� (������������� ������������� �������������� ������)
    IN inPersonalTradeId       Integer   ,     -- ��������� (������������� ������������� ������������� ������)
    IN inClientKindId          Integer   ,     -- ��������� �����������     
    IN inRoundWeight           TFloat    ,     -- ���-�� ������ ��� ���������� ����
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Retail());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Retail());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Retail(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Retail(), vbCode_calc);
  
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Retail(), vbCode_calc, inName);
   
   -- ��������� ��-�� <��� GLN - ����������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCode(), ioId, inGLNCode);
   -- ��������� ��-�� <��� GLN - ���������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCodeCorporate(), ioId, inGLNCodeCorporate);
   
   IF inOKPO = ''
   THEN
       -- ��������� ��-�� <>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_OKPO(), ioId, NULL);
   ELSE
       -- ��������� ��-�� <>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_OKPO(), ioId, inOKPO);
   END IF;

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Retail_OperDateOrder(), ioId, inOperDateOrder);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat( zc_ObjectFloat_Retail_RoundWeight(), ioId, inRoundWeight);
   
   -- ��������� ����� � <�������������� ������� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_GoodsProperty(), ioId, inGoodsPropertyId);   
   -- ��������� ����� � <��������� (������������� ������������� �������������� ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_PersonalMarketing(), ioId, inPersonalMarketingId);  
   -- ��������� ����� � <��������� (������������� ������������� ������������� ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_PersonalTrade(), ioId, inPersonalTradeId);  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_ClientKind(), ioId, inClientKindId);  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.04.22         * inRoundWeight
 14.05.19         * inClientKindId
 29.01.19         * add OKPO
 24.11.15         * add inPersonalMarketingId
 02.04.15         * add inOperDateOrder
 19.02.15         * add inGoodsPropertyId
 10.11.14         * add GLNCode
 23.05.14         *
*/

-- ����
-- 