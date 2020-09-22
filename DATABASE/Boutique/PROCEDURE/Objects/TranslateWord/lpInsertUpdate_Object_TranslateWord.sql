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

   IF COALESCE (ioId,0) <> 0
   THEN
       vbCode_calc := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   END IF;
   
   -- ����� ������- ��� ����� ����� � vbCode_calc -> vbCode_calc
   IF COALESCE (ioId, 0) = 0 AND COALESCE (vbCode_calc, 0) <> 0 THEN vbCode_calc := NEXTVAL ('Object_TranslateWord_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (vbCode_calc, 0) = 0  THEN vbCode_calc := NEXTVAL ('Object_TranslateWord_seq'); 
   ELSEIF vbCode_calc = 0
         THEN vbCode_calc := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 
   
      -- ��������
   IF COALESCE (inLanguageId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <����> �� ������.';
   END IF;
   
   -- ���������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TranslateWord(), vbCode_calc ::Integer, inValue);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Language(), ioId, inLanguageId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Parent(), ioId, inParentId);


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