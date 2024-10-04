-- Function: gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer)

DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer, Boolean, Boolean, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer, Boolean, Boolean, Boolean, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsByGoodsKind_isOrder(
 INOUT ioId                  Integer  , -- ���� ������� <�����>
    IN inGoodsId             Integer  , -- ������
    IN inGoodsKindId         Integer  , -- ���� �������
    IN inIsOrder             Boolean  , -- ������������ � �������
    IN inIsNotMobile         Boolean  , -- �� ������������ � ���.������
    IN inIsTop               Boolean  , --
   OUT outIsTop              Boolean  , --
    IN inIsNotPack           Boolean  , -- �� ����������
    IN inNormPack            TFloat   , -- ����� ������������ (� ��/���)
    IN inSession             TVarChar 
)
RETURNS Record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsOrder Boolean;
   DECLARE vbIsNotMobile Boolean;
   DECLARE vbIsTop Boolean;
   DECLARE vbNormPack TFloat;
   DECLARE vbisNotPack Boolean;
BEGIN

   vbUserId:= lpGetUserBySession (inSession);
   
   -- �������� ������������
   IF EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
              FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                   LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                        ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                       AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
              WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId <> COALESCE (ioId, 0))
   THEN 
       RAISE EXCEPTION '������.��������  <%> + <%> ��� ���� � �����������. ������������ ���������.', lfGet_Object_ValueData (inGoodsId), lfGet_Object_ValueData (inGoodsKindId);
   END IF;


   IF COALESCE (ioId, 0) = 0 
   THEN
       -- ��������� <������>
       ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsByGoodsKind(), 0, '');
       -- ��������� ����� � <������>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_Goods(), ioId, inGoodsId);

       -- ��������� ����� � <���� �������>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsByGoodsKind_GoodsKind(), ioId, inGoodsKindId);

   ELSE
       -- ��������
       IF NOT EXISTS (SELECT ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId
                      FROM ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                           LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                                ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                               AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()
                      WHERE ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                        AND ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = inGoodsId
                        AND COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) = COALESCE (inGoodsKindId, 0)
                      --AND ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId > 0
                        AND ObjectLink_GoodsByGoodsKind_Goods.ObjectId = ioId)
       THEN 
           RAISE EXCEPTION '������.��� ���� �������� �������� <��� ��������>.';
       END IF;   

   END IF;
   
   -- ���� �������� IsOrder � inIsNotMobile ���� �����
   vbIsOrder     :=(SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId AND ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Order()) :: Boolean;
   vbIsNotMobile :=(SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId AND ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_NotMobile()):: Boolean;
   vbNormPack    :=(SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.ObjectId = ioId AND ObjectFloat.DescId = zc_ObjectFloat_GoodsByGoodsKind_NormPack()) ::TFloat;
   vbisNotPack   :=(SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId AND ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_NotPack()):: Boolean;

   IF COALESCE (vbIsNotMobile,False) <> COALESCE (inIsNotMobile,False) OR COALESCE (vbIsOrder,False) <> COALESCE (inIsOrder,False) OR COALESCE (vbNormPack,0) <> COALESCE (inNormPack,0)
   --OR COALESCE (vbisNotPack,False) <> COALESCE (inisNotPack,False)
   THEN
        -- �������� ���� ������������ �� ����� ���������
        vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsByGoodsKind_isOrder());

        -- ��������� �������� <������������ � �������>
        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Order(), ioId, inIsOrder);

        -- ��������� �������� <>
        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_NotMobile(), ioId, inIsNotMobile);

        -- ��������� �������� <>
        PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsByGoodsKind_NormPack(), ioId, inNormPack);

        -- ��������� �������� <>
        --PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_NotPack(), ioId, inIsNotPack);

   END IF;
   
   IF COALESCE (vbisNotPack,False) <> COALESCE (inisNotPack,False)
   THEN
        -- �������� ���� ������������ �� ����� ���������
        vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_GoodsByGoodsKind_isNotPack());
        -- ��������� �������� <>
        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_NotPack(), ioId, inIsNotPack);
   END IF;

   --����  ������� isTop - ������ �����
   vbIsTop :=(SELECT ObjectBoolean.ValueData FROM ObjectBoolean WHERE ObjectBoolean.ObjectId = ioId AND ObjectBoolean.DescId = zc_ObjectBoolean_GoodsByGoodsKind_Top()):: Boolean;
   outIsTop := vbIsTop;
   IF COALESCE (vbIsTop,False) <> COALESCE (inIsTop,False)
   THEN
        -- �������� ���� ������������ �� ����� ���������
        vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_GoodsByGoodsKind_Top());

        outIsTop := inIsTop;
   
        -- ��������� �������� <>
        PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsByGoodsKind_Top(), ioId, outIsTop);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
   -- �������� - ��� � ����� ������ �� �����
   IF vbUserId = 5
   THEN
       RAISE EXCEPTION '������.��� ���� - ��� � ����� ������ �� �����.';
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.03.22         * add inIsNotPack
 28.10.21         * add inNormPack
 09.06.17         * add NotMobile
 24.03.16                                        * 
 23.02.16         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsByGoodsKind_isOrder (inGoodsId:= 1, inGoodsKindId:= 1, inUserId:= 2)