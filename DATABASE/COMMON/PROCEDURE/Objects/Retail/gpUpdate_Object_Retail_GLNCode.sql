-- Function: gpUpdate_Object_Retail_GLNCode()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_GLNCode (Integer, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_GLNCode(
 INOUT ioId                    Integer   ,  -- ���� ������� <�������� ����> 
    IN inGLNCode               TVarChar  ,  -- ��� GLN - ����������
    IN inGLNCodeCorporate      TVarChar  ,  -- ��� GLN - ��������� 
    IN inOKPO                  TVarChar  ,  -- ���� ��� �����. ����������
    IN inGoodsPropertyId       Integer   ,  -- �������������� ������� �������
    IN inPersonalMarketingId   Integer   ,     -- ��������� (������������� ������������� �������������� ������)
    IN inPersonalTradeId       Integer   ,     -- ��������� (������������� ������������� ������������� ������)
    IN inSession               TVarChar     -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- ��������
   IF  inGLNCode <> COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Retail_GLNCode() AND OS.ObjectId = ioId), '')
    OR inGLNCodeCorporate <> COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Retail_GLNCodeCorporate() AND OS.ObjectId = ioId), '')
    OR inOKPO <> COALESCE ((SELECT OS.ValueData FROM ObjectString AS OS WHERE OS.DescId = zc_ObjectString_Retail_OKPO() AND OS.ObjectId = ioId), '')
    OR inGoodsPropertyId <> COALESCE ((SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.DescId = zc_ObjectString_Retail_OKPO() AND OL.ObjectId = ioId), 0)
   THEN
       -- �������� ���� ������������ �� ����� ���������
       vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_GLNCode());

       -- ��������� ��-�� <��� GLN - ����������>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCode(), ioId, inGLNCode);
       -- ��������� ��-�� <��� GLN - ���������>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_GLNCodeCorporate(), ioId, inGLNCodeCorporate);

       -- ��������� ����� � <�������������� ������� �������>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_GoodsProperty(), ioId, inGoodsPropertyId);   

       IF inOKPO = ''
       THEN
           -- ��������� ��-�� <>
           PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_OKPO(), ioId, NULL);
       ELSE
           -- ��������� ��-�� <>
           PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Retail_OKPO(), ioId, inOKPO);
       END IF;

   ELSE 
       vbUserId := lpGetUserBySession (inSession);

   END IF;


   -- ��������� ����� � <��������� (������������� ������������� �������������� ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_PersonalMarketing(), ioId, inPersonalMarketingId);  
   -- ��������� ����� � <��������� (������������� ������������� ������������� ������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_PersonalTrade(), ioId, inPersonalTradeId);  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   

   --RAISE EXCEPTION '������.OK';

END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.01.19         *
 18.03.15         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Retail_GLNCode(ioId:=null, inCode:=null, inName:='�������� ���� 1', inSession:='2')