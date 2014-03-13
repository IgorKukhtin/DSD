-- Function: gpInsertUpdate_Object_GoodsPropertyValue()

-- DROP FUNCTION gpInsertUpdate_Object_GoodsPropertyValue();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue(
 INOUT ioId                  Integer   ,   	-- ���� ������� <�������� ������� ������� ��� ��������������> 
    IN inName                TVarChar  ,    -- �������� ������(����������) 
    IN inAmount              TFloat    ,    -- ���������� ���� � ��������  
    IN inBarCode             TVarChar  ,    -- �����-���                   
    IN inArticle             TVarChar  ,    -- �������                     
    IN inBarCodeGLN          TVarChar  ,    -- �����-��� GLN               
    IN inArticleGLN          TVarChar  ,    -- ������� GLN                 
    IN inGoodsPropertyId     Integer   ,    -- ������������� ������� ������� 
    IN inGoodsId             Integer   ,    -- ������ 
    IN inGoodsKindId         Integer   ,    -- ���� ������            
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
 
 BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsPropertyValue());
   UserId := inSession;
  
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsPropertyValue(), 0, inName);

   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_Amount(), ioId, inAmount);
   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCode(), ioId, inBarCode);
   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_Article(), ioId, inArticle);
   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCodeGLN(), ioId, inBarCodeGLN);
   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_ArticleGLN(), ioId, inArticleGLN);

   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsProperty(), ioId, inGoodsPropertyId);
   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_Goods(), ioId, inGoodsId);
   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKind(), ioId, inGoodsKindId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_GoodsPropertyValue(Integer, TVarChar, TFloat, TVarChar, TVarChar, TVarChar,
                                                        TVarChar, Integer, Integer, Integer, TVarChar)
  OWNER TO postgres;

  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 12.06.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsPropertyValue()