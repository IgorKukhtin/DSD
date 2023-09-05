-- Function: gpInsertUpdate_Object_GoodsByGoodsKindQuality()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKindQuality (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar, TFloat, Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsByGoodsKindQuality (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar,TVarChar, TVarChar, TFloat, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKindQuality(
 INOUT ioId	          Integer   ,    -- ���� ������� <>
    IN inCode             Integer   ,    -- ��� ������� <>
    IN inGoodsQualityName TVarChar  ,    -- �������� ������� <�������� ����, ����,��, ������� 17>
    IN inValue1           TVarChar  ,    --
    IN inValue2           TVarChar  ,    --
    IN inValue3           TVarChar  ,    --
    IN inValue4           TVarChar  ,    --
    IN inValue5           TVarChar  ,    --
    IN inValue6           TVarChar  ,    --
    IN inValue7           TVarChar  ,    --
    IN inValue8           TVarChar  ,    --
    IN inValue9           TVarChar  ,    --
    IN inValue10          TVarChar  ,    --
    IN inValue1_gk        TVarChar  ,    --
    IN inValue11_gk       TVarChar  ,    --
    IN inNormInDays_gk    TFloat    ,    --
    IN inGoodsId          Integer   ,    -- �����
    IN inGoodsKindId      Integer   ,    --
    IN inQualityId        Integer   ,    -- ������������ �������������
    IN inisKlipsa         Boolean   ,    -- ������������ �����
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbGoodsByGoodsKindId Integer;
 BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Object_GoodsQuality());
     vbUserId:= lpGetUserBySession (inSession);

     -- ��������
     IF COALESCE (inQualityId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <������������ �������������>.';
     END IF;

     -- �������� ������������ ������
     IF COALESCE (inGoodsId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <�����>.';
     ELSE
         IF EXISTS (SELECT ChildObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_GoodsQuality_Goods() AND ChildObjectId = inGoodsId AND COALESCE (ObjectId,0) <> COALESCE (ioId,0))
         THEN
             RAISE EXCEPTION '������. �������� <%> ��� ���� � �����������.', lfGet_Object_ValueData (vbGoodsId);
         END IF;
     END IF;

     -- ��������
     IF COALESCE (inGoodsKindId, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ����������� �������� <��� ������>.';
     END IF;
     --
     vbGoodsByGoodsKindId:= (SELECT ObjectLink_GoodsByGoodsKind_Goods.ObjectId          AS GoodsByGoodsKindId
                             FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                  JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                  ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId      = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId        = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                                                 AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId = inGoodsKindId
                                --INNER JOIN ObjectBoolean AS ObjectBoolean_Order
                                --                         ON ObjectBoolean_Order.ObjectId  = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                --                        AND ObjectBoolean_Order.DescId    = zc_ObjectBoolean_GoodsByGoodsKind_Order()
                                --                        AND ObjectBoolean_Order.ValueData = TRUE
                             WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId        = zc_ObjectLink_GoodsByGoodsKind_Goods()
                               AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                            );
    -- ��������
     IF COALESCE (vbGoodsByGoodsKindId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������ �������� ����� + ��� �� ������� : <%> + <%>.', lfGet_Object_ValueData_sh (inGoodsId), lfGet_Object_ValueData_sh (inGoodsKindId);
     END IF;


   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_GoodsQuality());

   -- �������� ���� ������������ ��� �������� <������������ >
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsQuality(), inGoodsQualityName);
   -- �������� ���� ������������ ��� �������� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsQuality(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsQuality(), inCode, inGoodsQualityName);
                                --, inAccessKeyId:= (SELECT Object_Branch.AccessKeyId FROM Object AS Object_Branch WHERE Object_Branch.Id = inBranchId));

   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value1(), ioId, inValue1);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value2(), ioId, inValue2);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value3(), ioId, inValue3);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value4(), ioId, inValue4);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value5(), ioId, inValue5);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value6(), ioId, inValue6);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value7(), ioId, inValue7);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value8(), ioId, inValue8);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value9(), ioId, inValue9);
   -- ��������� ��-�� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsQuality_Value10(), ioId, inValue10);
   --
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsQuality_Goods(), ioId, inGoodsId);
   --
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsQuality_Quality(), ioId, inQualityId);

   -- ��������� ��-�� <������������ �����>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsQuality_Klipsa(), ioId, inisKlipsa);

   -- ��������� ��-�� ��� GoodsByGoodsKind <��� ��������, �4>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsByGoodsKind_Quality1(), vbGoodsByGoodsKindId, inValue1_gk);
   -- ��������� ��-�� ��� GoodsByGoodsKind <��� ���������/���� ��������� >
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsByGoodsKind_Quality11(), vbGoodsByGoodsKindId, inValue11_gk);
   -- ��������� ��-�� ��� GoodsByGoodsKind <���� �������� � ����>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_NormInDays(), vbGoodsByGoodsKindId, inNormInDays_gk);
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (vbGoodsByGoodsKindId, vbUserId);


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

 /*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.12.20         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsByGoodsKindQuality()
