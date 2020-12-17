-- Function: gpInsertUpdate_Object_GoodsPhoto(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsPhoto(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsPhoto(
 INOUT ioId                        Integer   , -- ���� ������� <�������� ��������>
    IN inPhotoName                 TVarChar  , -- ����
    IN inGoodsId                   Integer   , -- �������
    IN inGoodsPhotoData            TBlob     , -- ���� ��������� 	
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
       --RAISE EXCEPTION '������! ������� �� ����������!';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������! ������� �� ����������!' :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_GoodsPhoto' :: TVarChar
                                             , inUserId        := vbUserId
                                             );
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsPhoto(), 0, inPhotoName);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_GoodsPhoto_Data(), ioId, inGoodsPhotoData);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsPhoto_Goods(), ioId, inGoodsId);   

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
-- SELECT * FROM gpInsertUpdate_Object_GoodsPhoto (ioId:=0, inValue:=100, inGoodsId:=5, inGoodsConditionKindId:=6, inSession:='2')

