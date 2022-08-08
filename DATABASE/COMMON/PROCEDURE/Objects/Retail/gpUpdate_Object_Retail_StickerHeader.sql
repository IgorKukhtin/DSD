-- Function: gpInsertUpdate_Object_Retail()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_StickerHeader(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_StickerHeader(
    IN inId                    Integer   ,     -- ���� ������� <�������� ����> 
    IN inStickerHeaderId       Integer   ,     -- 
   OUT outStickerHeaderName    TVarChar  ,
    IN inSession               TVarChar        -- ������ ������������
)
  RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Retail());

   IF COALESCE (inId,0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ��������.';
   END IF;
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_StickerHeader(), inId, inStickerHeaderId);  

   outStickerHeaderName:= (SELECT Object.ValueData FROM Object WHERE Object.Id = inStickerHeaderId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 08.08.22         * 
*/

-- ����
-- 