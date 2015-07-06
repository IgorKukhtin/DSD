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
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsPropertyValue());


   -- !!!����������� ������ ��������!!!
   IF (inGoodsPropertyId = 83955 AND inGoodsId = 2507 AND inGoodsKindId = 8329) OR ioId = 109684 -- select * from gpGet_Object_GoodsPropertyValue (inId := 109684 ,  inSession := '5') where GoodsPropertyId = 83955 AND GoodsId = 2507 AND GoodsKindId = 8329
   THEN
       CREATE TEMP TABLE _tmpBAD_HARKOD (tmp Integer) ON COMMIT DROP;
       INSERT INTO _tmpBAD_HARKOD (tmp)
       WITH tmpGoodsProperty AS (SELECT Object_GoodsProperty.Id            AS GoodsPropertyId
                                      , ObjectFloat_StartPosInt.ValueData  AS StartPosInt
                                 FROM Object AS Object_GoodsProperty
                                      INNER JOIN ObjectFloat AS ObjectFloat_StartPosInt
                                                             ON ObjectFloat_StartPosInt.ObjectId = Object_GoodsProperty.Id
                                                            AND ObjectFloat_StartPosInt.DescId = zc_ObjectFloat_GoodsProperty_StartPosInt()
                                 WHERE Object_GoodsProperty.DescId = zc_Object_GoodsProperty()
                                )
           , tmpGoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            , tmpGoodsProperty.StartPosInt
                                            , ObjectString_BarCode.ValueData
                                            , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh()
                                                        THEN zfFormat_BarCodeShort (ObjectString_BarCode.ValueData)
                                                   ELSE zfFormat_BarCodeShort (SUBSTRING (ObjectString_BarCode.ValueData FROM 1 FOR (tmpGoodsProperty.StartPosInt - 1) :: Integer))
                                              END AS Value
                                       FROM tmpGoodsProperty
                                            INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                            LEFT JOIN ObjectString AS ObjectString_BarCode
                                                                    ON ObjectString_BarCode.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                   -- AND ObjectString_BarCode.ValueData <> ''
                                                                   AND ObjectString_BarCode.DescId = zc_ObjectString_GoodsPropertyValue_BarCode()
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods
                                                                 ON ObjectLink_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                AND ObjectLink_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                                 ON ObjectLink_Goods_Measure.ObjectId = ObjectLink_Goods.ChildObjectId
                                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                      )
         SELECT lpInsertUpdate_ObjectString (zc_ObjectString_GoodsPropertyValue_BarCodeShort(), tmpGoodsPropertyValue.ObjectId, tmpGoodsPropertyValue.Value) :: Integer
         FROM tmpGoodsPropertyValue;
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
        PERFORM lpDelete_Object (ioId, inSession);
        RETURN;
   END IF;

   -- �������� ������������
   IF inGoodsKindId <> 0 AND EXISTS (SELECT ObjectLink_GoodsPropertyValue_Goods.ChildObjectId
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
