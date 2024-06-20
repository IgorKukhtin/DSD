-- Function: gpUpdate_Object_StickerProperty_NormInDays_not()

DROP FUNCTION IF EXISTS gpUpdate_Object_StickerProperty_NormInDays_not(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_StickerProperty_NormInDays_not(
    IN inId                  Integer   , -- ���� ������� <>
    IN inisNormInDays_not                Boolean   , --
   OUT outisNormInDays_not               Boolean   , --
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId            Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_StickerProperty_NormInDays_not());

   outisNormInDays_not := NOT inisNormInDays_not;
   
   IF COALESCE (inId, 0) = 0
   THEN
       RAISE EXCEPTION '������.������� �� ���������.';
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_StickerProperty_NormInDays_not(), inId, outisNormInDays_not);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.06.24         *
*/

-- ����
--