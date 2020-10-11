-- Function: lpInsertUpdate_Object_TranslateWord  ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_TranslateWord (Integer, Integer, Integer, TVarChar, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_TranslateWord(
 INOUT ioId                       Integer   ,    -- ���� ������� <>
    IN inParentId                 Integer   ,    --
    IN inLanguageId               Integer   ,    -- ���� ��������
    IN inValue                    TVarChar  ,    -- �������
    IN inFormName                 TVarChar  ,    -- ����� ����������
    IN inName                     TVarChar  ,    -- �������� �������� (������� � ���������)
    IN inUserId                   Integer
)
RETURNS Integer
AS
$BODY$
   DECLARE vbCode_calc Integer;
   DECLARE vbFormId    Integer;
BEGIN

   -- ��������
   IF COALESCE (inLanguageId, 0) = 0
   THEN
       RAISE EXCEPTION '������. <����> �� ������.';
   END IF;

   -- �������� - "�������" ���� �������� - ������ ���� �1
   IF COALESCE (inParentId, 0) = 0 AND inLanguageId <> COALESCE ((SELECT MIN (Id) FROM Object WHERE Object.DescId = zc_Object_Language()), 0)
   THEN
       RAISE EXCEPTION '������.������ ���� ������ ������� ���� �������� = <%>.�� ��� ������ <%>.'
                      , lfGet_Object_ValueData_sh ((SELECT MIN (Id) FROM Object WHERE Object.DescId = zc_Object_Language()))
                      , lfGet_Object_ValueData_sh (inLanguageId);
   END IF;
   -- ��������
   IF ioId > 0 AND COALESCE (inParentId, 0) = 0
      AND EXISTS (SELECT 
                  FROM ObjectLink AS ObjectLink_TranslateWord_Language
                       INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                             ON ObjectLink_TranslateWord_Parent.ObjectId      = ObjectLink_TranslateWord_Language.ObjectId
                                            AND ObjectLink_TranslateWord_Parent.ChildObjectId > 0
                                            AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()
                  WHERE ObjectLink_TranslateWord_Language.ObjectId      = ioId
                    AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                    AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId
                 )
   THEN
       RAISE EXCEPTION '������.���� �������� <%> �� ����� ����� �������.', lfGet_Object_ValueData_sh (inLanguageId);
   END IF;
   -- ��������
   IF ioId > 0 AND inParentId > 0
      AND NOT EXISTS (SELECT 
                      FROM ObjectLink AS ObjectLink_TranslateWord_Language
                           INNER JOIN ObjectLink AS ObjectLink_TranslateWord_Parent
                                                 ON ObjectLink_TranslateWord_Parent.ObjectId      = ObjectLink_TranslateWord_Language.ObjectId
                                                AND ObjectLink_TranslateWord_Parent.ChildObjectId > 0
                                                AND ObjectLink_TranslateWord_Parent.DescId        = zc_ObjectLink_TranslateWord_Parent()
                      WHERE ObjectLink_TranslateWord_Language.ObjectId      = ioId
                        AND ObjectLink_TranslateWord_Language.DescId        = zc_ObjectLink_TranslateWord_Language()
                        AND ObjectLink_TranslateWord_Language.ChildObjectId = inLanguageId
                     )
   THEN
       RAISE EXCEPTION '������.���� �������� <%> �� ����� ����� �� �������.', lfGet_Object_ValueData_sh (inLanguageId);
   END IF;


   -- !!! ����� !!! - ���� ��� �� "�������" ���� �������� � "������" ����������
   IF inParentId > 0 AND COALESCE (ioId, 0) = 0 AND COALESCE (TRIM (inValue), '') = ''
   THEN
       ioId:= 0;
       RETURN;
   END IF;


   -- �������� - ��� "��������" ����� �������� - ������ ���� �����
   IF COALESCE (inParentId, 0) = 0 AND COALESCE (TRIM (inValue), '') = ''
   THEN
       RAISE EXCEPTION '������.�������� ����� <%> ������ ��� <%>.', inValue, lfGet_Object_ValueData_sh (inLanguageId);
   END IF;


   IF ioId <> 0
   THEN
       vbCode_calc := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId);
   ELSE
       vbCode_calc := NEXTVAL ('Object_TranslateWord_seq');
   END IF;


   -- ���������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TranslateWord(), vbCode_calc, inValue);

   -- ��������� ����� � <���� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Language(), ioId, inLanguageId);


   -- ���� ���  "�������" ���� ��������
   IF COALESCE (inParentId, 0) = 0
   THEN
       -- �������� - 0.1.
       IF COALESCE (TRIM (inFormName), '') = ''
       THEN
           RAISE EXCEPTION '������.����� ���������� <%> ������ ��� <%> + <%>.', inFormName, inValue, lfGet_Object_ValueData_sh (inLanguageId);
       END IF;
       -- �������� - 0.2.
       IF COALESCE (TRIM (inName), '') = ''
       THEN
           RAISE EXCEPTION '������.������� � ��������� <%> ������ ��� <%> + <%>.', inName, inValue, lfGet_Object_ValueData_sh (inLanguageId);
       END IF;

       -- ��������
       IF 1 < (SELECT COUNT(*) FROM Object WHERE Object.ValueData ILIKE inFormName AND Object.DescId = zc_Object_Form())
       THEN
           RAISE EXCEPTION '������.� ������ zc_Object_Form ������� ������ ����� ����� <%>', inFormName;
       END IF;
       -- ����� �����
       vbFormId:= (SELECT Object.Id FROM Object WHERE Object.ValueData ILIKE inFormName AND Object.DescId = zc_Object_Form());
       -- ��������
       IF COALESCE (vbFormId, 0) = 0 AND inFormName NOT ILIKE 'MainForm'
       THEN
           RAISE EXCEPTION '������.� ������ zc_Object_Form �� ������� ����� <%>', inFormName;
       END IF;

       -- ��������� ����� � <����� ����������>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateWord_Form(), ioId, vbFormId);

       -- ��������� <�������� ��������>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_TranslateWord_Name(), ioId, inName);
   ELSE
       -- ��������� ����� � <"�������" ���� ��������>
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