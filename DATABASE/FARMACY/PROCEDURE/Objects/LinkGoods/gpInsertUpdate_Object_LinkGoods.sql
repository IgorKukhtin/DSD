-- Function: gpInsertUpdate_Object_LinkGoods(Integer, TFloat, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_LinkGoods (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_LinkGoods(
 INOUT ioId               Integer   , -- ���� ������� <������� ��������>
    IN inGoodsMainId      Integer   , -- ������� �����
    IN inGoodsId          Integer   , -- ����� ��� ������
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsUpdate Boolean;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_LinkGoods());
   vbUserId := lpGetUserBySession(inSession);

   -- !!!�����!!!
   IF COALESCE (ioId, 0) = 0 AND COALESCE (inGoodsMainId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
   THEN
       RETURN;
   END IF;

   -- ��������
   IF EXISTS (SELECT Object_LinkGoods_View.Id
              FROM Object_LinkGoods_View
              WHERE Object_LinkGoods_View.GoodsMainId = inGoodsMainId
                AND Object_LinkGoods_View.GoodsId = inGoodsId
                AND Object_LinkGoods_View.Id <> COALESCE (ioId, 0)
             )
   THEN
       RAISE EXCEPTION '����� ����� ������� �������� ��� �����������';
   END IF;

   -- ���������
   ioId := lpInsertUpdate_Object_LinkGoods (ioId, inGoodsMainId, inGoodsId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.02.19                                        *
 26.08.14                         *
 02.07.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_LinkGoods (ioId:=0, inGoodsMainId:=5, inGoodsId:=6, inRetailId:=0, inSession:='2')
