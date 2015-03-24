-- Function: gpInsertUpdate_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue(Integer, TVarChar, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue(
 INOUT ioId                  Integer   ,    -- ���� ������� <�������� ������� ������� ��� ��������������>
    IN inName                TVarChar  ,    -- �������� ������(����������)
    IN inAmount              TFloat    ,    -- ���������� ���� � ��������
    IN inBarCode             TVarChar  ,    -- �����-���
    IN inArticle             TVarChar  ,    -- �������
    IN inBarCodeGLN          TVarChar  ,    -- �����-��� GLN
    IN inArticleGLN          TVarChar  ,    -- ������� GLN
    IN inGroupName           TVarChar  ,    -- �������� ������
    IN inGoodsPropertyId     Integer   ,    -- ������������� ������� �������
    IN inGoodsId             Integer   ,    -- ������
    IN inGoodsKindId         Integer   ,    -- ���� ������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());

   -- ��������
   IF COALESCE (inGoodsPropertyId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <������������� ������� �������>.';
   END IF;
   -- ��������
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <�����>.';
   END IF;
   -- �������� ��� ��: ������ + ��������� + ������� ���������
   IF COALESCE (inGoodsKindId, 0) = 0 AND EXISTS (SELECT ObjectId FROM ObjectLink WHERE ObjectId = inGoodsId AND ChildObjectId = zc_Enum_InfoMoney_30101() AND DescId = zc_ObjectLink_Goods_InfoMoney())
   THEN
       RAISE EXCEPTION '������.�� ����������� �������� <��� ������>.';
   END IF;

   -- �������� ������������
   IF EXISTS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                   INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                         ON ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = inGoodsPropertyId
                                        AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                        ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_Goods.ObjectId
                                       AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
              WHERE ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                AND ObjectLink_GoodsPropertyValue_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsPropertyValue_Goods.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION '������.�������� ������������� = <%> + ����� = <%> + ��� ������ = <%> ��� ���� � �����������. ������������ ���������.', lfGet_Object_ValueData (inGoodsPropertyId), lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;   


   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsPropertyValue(), 0, inName);

   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_Amount(), ioId, inAmount);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCode(), ioId, inBarCode);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_Article(), ioId, inArticle);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCodeGLN(), ioId, inBarCodeGLN);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_ArticleGLN(), ioId, inArticleGLN);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_GroupName(), ioId, inGroupName);

   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsProperty(), ioId, inGoodsPropertyId);
   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_Goods(), ioId, inGoodsId);
   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKind(), ioId, inGoodsKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.02.15                                        *
 10.10.14                                                       *
 12.06.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsPropertyValue()
