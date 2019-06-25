-- Function: gpInsertUpdate_Object_GoodsScaleCeh()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsScaleCeh (Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsScaleCeh(
 INOUT ioId              Integer   , -- ���� ������� <������������ ��������>
    IN inFromId          Integer   , --
    IN inToId            Integer   , -- 
    IN inGoodsId         Integer   , -- ������ �� ������
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsScaleCeh());

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsScaleCeh(), 0, '');


   -- ��������� ����� � <�� ����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsScaleCeh_From(), ioId, inFromId);
   -- ��������� ����� � <����>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsScaleCeh_To(), ioId, inToId);
   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsScaleCeh_Goods(), ioId, inGoodsId);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE 
      -- ��������� �������� <���� ����.>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (����.)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);
   END IF;
    
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.06.19         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsScaleCeh ()
