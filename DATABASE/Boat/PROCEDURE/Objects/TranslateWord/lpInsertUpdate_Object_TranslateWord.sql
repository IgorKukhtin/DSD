-- Function: lpInsertUpdate_Object_TranslateWord  ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_TranslateWord (Integer, Integer, Integer, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_TranslateWord(
 INOUT ioId                       Integer   ,    -- ���� ������� <> 
    IN inParentId                Integer   ,    -- 
    IN inLanguageId               Integer   ,    -- 
    IN inValue                    TVarChar  ,    -- �������� ������� <>
    IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer; 
BEGIN

   -- ��������
   IF COALESCE (inLanguageId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <����> �� ������.';
   END IF;

   IF ioId <> 0
   THEN
       vbCode_calc := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   ELSE
       vbCode_calc := NEXTVAL ('Object_TranslateWord_seq')
   END IF;
   
   
   -- ���������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TranslateWord(), vbCode_calc ::Integer, inValue);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Language(), ioId, inLanguageId);

   IF ioId <> inParentId
   THEN
       -- ��������� ����� � <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Parent(), ioId, inParentId);
   END IF;


   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.09.20         *
*/

-- ����
--