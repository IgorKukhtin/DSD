-- Function: gpInsertUpdate_Object_GoodsNormDiff()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsNormDiff (Integer, Integer, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsNormDiff(
 INOUT ioId              Integer   , -- ���� ������� <������������ ��������>
    IN inGoodsId         Integer   , -- ������ �� ������
    IN inGoodsKindId     Integer   , --
    IN inValueGP         TFloat    , 
    IN inValuePF         TFloat    ,
    IN inComment         TVarChar  ,
    IN inSession         TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsNormDiff());

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsNormDiff(), 0, '');

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsNormDiff_Goods(), ioId, inGoodsId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsNormDiff_GoodsKind(), ioId, inGoodsKindId);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsNormDiff_ValuePF(), ioId, inValuePF);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_GoodsNormDiff_ValueGP(), ioId, inValueGP);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsNormDiff_Comment(), ioId, inComment);

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
-- SELECT * FROM gpInsertUpdate_Object_GoodsNormDiff ()
