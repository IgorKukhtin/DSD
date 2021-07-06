-- Function: gpUpdate_Object_StickerProperty_CK()

DROP FUNCTION IF EXISTS gpUpdate_Object_StickerProperty_CK(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_StickerProperty_CK(
    IN inId                  Integer   , -- ���� ������� <>
    IN inisCK                Boolean   , --
   OUT outisCK               Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId            Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_StickerProperty_CK());

   outisCK := NOT inisCK;
   
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ���������.';
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerProperty_CK(), inId, outisCK);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.04.21         *
*/

-- ����
--