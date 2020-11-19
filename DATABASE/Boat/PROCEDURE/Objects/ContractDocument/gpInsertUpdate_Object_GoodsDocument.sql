-- Function: gpInsertUpdate_Object_GoodsDocument(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsDocument(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsDocument(
 INOUT ioId                        Integer   , -- ���� ������� <�������� ��������>
    IN inDocumentName              TVarChar  , -- ����
    IN inGoodsId                   Integer   , -- �������
    IN inGoodsDocumentData         TBlob     , -- ���� ��������� 	
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- ��������
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '������! ������� �� ����������!';
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsDocument(), 0, inDocumentName);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_GoodsDocument_Data(), ioId, inGoodsDocumentData);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsDocument_Goods(), ioId, inGoodsId);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsDocument (ioId:=0, inValue:=100, inGoodsId:=5, inGoodsConditionKindId:=6, inSession:='2')

