-- Function: gpInsertUpdate_Object_GoodsPropertyValue()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TVarChar, TVarChar, TVargpInsertUpdate_Object_GoodsPropertyValueChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPropertyValue (Integer, TVarChar, TFloat, TFloat, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPropertyValue(
 INOUT ioId                  Integer   ,    -- ���� ������� <�������� ������� ������� ��� ��������������>
    IN inName                TVarChar  ,    -- �������� ������(����������)
    IN inAmount              TFloat    ,    -- ���-�� ���� ��� ������������
    IN inBoxCount            TFloat    ,    -- ���-�� ������ � �����
    --IN inAmountDoc           TFloat    ,    -- ���������� ��������
   OUT outBarCodeShort       TVarChar  ,    -- �����-���
    IN inBarCode             TVarChar  ,    -- �����-���
    IN inArticle             TVarChar  ,    -- �������
    IN inBarCodeGLN          TVarChar  ,    -- �����-��� GLN
    IN inArticleGLN          TVarChar  ,    -- ������� GLN
    IN inGroupName           TVarChar  ,    -- �������� ������
    IN inGoodsPropertyId     Integer   ,    -- ������������� ������� �������
    IN inGoodsId             Integer   ,    -- ������
    IN inGoodsKindId         Integer   ,    -- ���� ������
    IN inGoodsBoxId          Integer   ,    -- ������ (���������) 
    IN inGoodsKindSubId      Integer   ,    -- ��� ������ (���� ������ � ���������)
    IN inisGoodsKind         Boolean   ,    -- ��������� �������� � ����� ����� ���.
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());

   -- �������� - ��������� �������� ��-� �������
   IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.RoleId IN (11288675, 624406, zc_Enum_Role_Admin())  AND ObjectLink_UserRole_View.UserId = vbUserId)
   THEN
       RAISE EXCEPTION '������.��� ���� ��� ��������� ������.';
   END IF;

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

   IF ioId IN (327114 -- ������� ���������. (�������� �/�)
             , 327115 -- ��������  ���� (��2+��3)
             , 126856 -- ��������� ����(��2+��3)
              )
   THEN 
        PERFORM _lp_Delete_Object (ioId, inSession);
        RETURN;
   END IF;

   -- �������� ������������
   IF /*inGoodsKindId <> 0 AND*/
      EXISTS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
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
       RAISE EXCEPTION '������.��������  <%> + <%> + <%> ��� ���� � �����������. ������������ ���������.', lfGet_Object_ValueData (inGoodsPropertyId), lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;   


   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsPropertyValue(), 0, inName);

   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_Amount(), ioId, inAmount);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_BoxCount(), ioId, inBoxCount);
   -- ��������� 
   --PERFORM lpInsertUpdate_ObjectFloat(zc_objectFloat_GoodsPropertyValue_AmountDoc(), ioId, inAmountDoc);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCode(), ioId, inBarCode);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_Article(), ioId, inArticle);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_BarCodeGLN(), ioId, inBarCodeGLN);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_GoodsPropertyValue_ArticleGLN(), ioId, inArticleGLN);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsPropertyValue_GroupName(), ioId, inGroupName);

   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsProperty(), ioId, inGoodsPropertyId);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_Goods(), ioId, inGoodsId);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKind(), ioId, inGoodsKindId);
   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsBox(), ioId, inGoodsBoxId);

   -- ��������� �����
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsPropertyValue_GoodsKindSub(), ioId, inGoodsKindSubId);
   -- ��������� 
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_GoodsPropertyValue_isGoodsKind(), ioId, inisGoodsKind);


   -- ��������
   PERFORM lpUpdate_Object_GoodsPropertyValue_BarCodeShort (inGoodsPropertyId, ioId, vbUserId);
   -- 
   outBarCodeShort:= (SELECT ObjectString_BarCodeShort.ValueData
                      FROM ObjectString AS ObjectString_BarCodeShort
                      WHERE ObjectString_BarCodeShort.ObjectId = ioId
                        AND ObjectString_BarCodeShort.DescId = zc_ObjectString_GoodsPropertyValue_BarCodeShort()
                     );

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 29.07.22         *
 14.02.18         * 
 27.06.17         * del inAmountDoc
 22.06.17         * add inAmountDoc
 17.09.15         * add BoxCount
 12.02.15                                        *
 10.10.14                                                       *
 12.06.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsPropertyValue()
