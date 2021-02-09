-- Function: gpInsertUpdate_Object_ProdColorPatternPhoto(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProdColorPatternPhoto(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProdColorPatternPhoto(
 INOUT ioId                           Integer   , -- ���� ������� <�������� ��������>
    IN inPhotoName                    TVarChar  , -- ����
    IN inProdColorPatternId           Integer   , -- �������
    IN inProdColorPatternPhotoData    TBlob     , -- ���� ��������� 	
    IN inSession                      TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbGoodsId  Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ProdColorPattern());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� Goods
   vbGoodsId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_ProdColorPattern_Goods() AND ObjectLink.ObjectId = inProdColorPatternId);

   IF COALESCE (vbGoodsId,0) <> 0
   THEN 
       -- ���� �������� zc_ObjectLink_ProdColorPattern_Goods - ����� ����� � ��������� ���� � ������
       ioId := gpInsertUpdate_Object_GoodsPhoto (ioId
                                               , inPhotoName
                                               , vbGoodsId
                                               , inProdColorPatternPhotoData
                                               , inSession
                                               );
   ELSE
        -- ��������
       IF COALESCE (inProdColorPatternId, 0) = 0
       THEN
           --RAISE EXCEPTION '������! Boat Structure �� ����������!';
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������! Boat Structure �� ����������!' :: TVarChar
                                                 , inProcedureName := 'gpInsertUpdate_Object_ProdColorPatternPhoto' :: TVarChar
                                                 , inUserId        := vbUserId
                                                 );
       END IF;
       
       -- ��������� <������>
       ioId := lpInsertUpdate_Object (ioId, zc_Object_ProdColorPatternPhoto(), 0, inPhotoName);
       
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ProdColorPatternPhoto_Data(), ioId, inProdColorPatternPhotoData);
       
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProdColorPatternPhoto_ProdColorPattern(), ioId, inProdColorPatternId);   
    
       -- ��������� ��������
       PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.02.21         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ProdColorPatternPhoto (ioId:=0, inValue:=100, inProdColorPatternId:=5, inProdColorPatternConditionKindId:=6, inSession:='2')

