-- Function: gpInsertUpdate_Object_ReceiptGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods(Integer, Integer, TVarChar, Integer, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods(Integer, Integer, TVarChar, Integer, Integer, Boolean, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoods(Integer, Integer, TVarChar, Integer, Integer, Integer, Boolean, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoods(
 INOUT ioId               Integer   ,    -- ���� ������� <�����>
    IN inCode             Integer   ,    -- ��� �������
    IN inName             TVarChar  ,    -- �������� �������
    IN inColorPatternId   Integer   ,
    IN inGoodsId          Integer   ,
    IN inUnitId           Integer   ,    ---
    IN inIsMain           Boolean   ,
    IN inUserCode         TVarChar  ,    -- ���������������� ���
    IN inComment          TVarChar  ,
    IN inSession          TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGoodsName TVarChar;
   DECLARE vbGoodsCode TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptGoods());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������
   IF COALESCE (inColorPatternId, 0) = 0
   THEN
       RAISE EXCEPTION '%', '������.�������� <������������ - �������� �������> �� �����������.';
   END IF;
   -- ��������
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '%', '������.�������� <����> �� �����������.';
   END IF;


   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   --
   IF COALESCE (ioId, 0) = 0
   THEN
       -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
       inCode:= lfGet_ObjectCode (inCode, zc_Object_ReceiptGoods());

   ELSEIF COALESCE (inCode, 0) = 0
   THEN
       -- ����� ���
       inCode:= (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   END IF;

   --
   SELECT Goods.ValueData              AS GoodsName
        , Goods.ObjectCode :: TVarChar AS Code
          INTO vbGoodsName, vbGoodsCode
   FROM Object AS Goods
   WHERE Goods.DescId = zc_Object_Goods() AND Goods.Id = inGoodsId;

   inUserCode := (CASE WHEN COALESCE (inUserCode,'') <>'' THEN inUserCode ELSE COALESCE (vbGoodsCode,'') END) :: TVarChar;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptGoods(), inCode
                               , COALESCE (vbGoodsName,'')
                              || CASE WHEN inComment <> '' THEN '-' || inComment ELSE '' END
                            --||'-' || COALESCE (inUserCode,'')
                                );

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReceiptGoods_Comment(), ioId, inComment);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReceiptGoods_Code(), ioId, COALESCE (inUserCode, vbGoodsCode,''));

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ReceiptGoods_Main(), ioId, inIsMain);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoods_ColorPattern(), ioId, inColorPatternId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoods_Object(), ioId, inGoodsId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoods_Unit(), ioId, inUnitId);
   
   
   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- ��������� �������� <���� ����>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (����)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);

   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.22         * inUnitId
 11.12.20         * inColorPatternId
 01.12.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoods()
