-- Function: gpInsertUpdate_Object_GoodsSeparate()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSeparate (Integer, Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsSeparate (Integer, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsSeparate(
 INOUT ioId              Integer   , -- ���� ������� <������������ ��������>
    IN inGoodsMasterId   Integer   , --
    IN inGoodsId         Integer   , -- ������ �� ������
    IN inGoodsKindId     Integer   , -- ������ �� ���� �������
    IN inIsCalculated    Boolean   , -- ������ � ���. ����� (100 ��.)
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsSeparate());

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsSeparate(), 0, '');


   -- ��������� ����� � <�������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsSeparate_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <����� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsSeparate_GoodsKind(), ioId, inGoodsKindId);

   -- ��������� ����� � <�� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsSeparate_GoodsMaster(), ioId, inGoodsMasterId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_GoodsSeparate_Calculated(), ioId, inIsCalculated);


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
 09.11.18         *
 07.10.18         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsSeparate ()
