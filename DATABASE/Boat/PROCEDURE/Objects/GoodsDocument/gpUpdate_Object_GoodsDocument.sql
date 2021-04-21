-- Function: gpUpdate_Object_GoodsDocument(Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_GoodsDocument(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GoodsDocument(
    IN inId                        Integer   , -- ���� ������� <��������>
    IN inDocTagId                  Integer   , -- 
    IN inComment                   TVarChar  , -- 
    IN inSession                   TVarChar    -- ������ ������������
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- ��������
   IF COALESCE (inId, 0) = 0
   THEN
       --RAISE EXCEPTION '������! ������� �� ����������!';
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := '������! ������� ��������� �� ��������!'        :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_Object_GoodsDocument'   :: TVarChar
                                              , inUserId        := vbUserId
                                              );
   END IF;
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_GoodsDocument_Comment(), inId, inComment);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsDocument_DocTag(), inId, inDocTagId);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.04.21         *
*/

-- ����
--
