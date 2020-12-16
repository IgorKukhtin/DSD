-- Function: lpInsertUpdate_Object_TranslateMessage  ()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_TranslateMessage (Integer, Integer, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_TranslateMessage(
 INOUT ioId                       Integer   ,    -- ���� ������� <>
    IN inParentId                 Integer   ,    --
    IN inLanguageId               Integer   ,    -- ���� ��������
    IN inValue                    TVarChar  ,    -- �������
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
                  FROM ObjectLink AS ObjectLink_TranslateMessage_Language
                       INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                             ON ObjectLink_TranslateMessage_Parent.ObjectId      = ObjectLink_TranslateMessage_Language.ObjectId
                                            AND ObjectLink_TranslateMessage_Parent.ChildObjectId > 0
                                            AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()
                  WHERE ObjectLink_TranslateMessage_Language.ObjectId      = ioId
                    AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                    AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId
                 )
   THEN
       RAISE EXCEPTION '������.���� �������� <%> �� ����� ����� �������.', lfGet_Object_ValueData_sh (inLanguageId);
   END IF;
   -- ��������
   IF ioId > 0 AND inParentId > 0
      AND NOT EXISTS (SELECT 
                      FROM ObjectLink AS ObjectLink_TranslateMessage_Language
                           INNER JOIN ObjectLink AS ObjectLink_TranslateMessage_Parent
                                                 ON ObjectLink_TranslateMessage_Parent.ObjectId      = ObjectLink_TranslateMessage_Language.ObjectId
                                                AND ObjectLink_TranslateMessage_Parent.ChildObjectId > 0
                                                AND ObjectLink_TranslateMessage_Parent.DescId        = zc_ObjectLink_TranslateMessage_Parent()
                      WHERE ObjectLink_TranslateMessage_Language.ObjectId      = ioId
                        AND ObjectLink_TranslateMessage_Language.DescId        = zc_ObjectLink_TranslateMessage_Language()
                        AND ObjectLink_TranslateMessage_Language.ChildObjectId = inLanguageId
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
       vbCode_calc := NEXTVAL ('Object_TranslateMessage_seq');
   END IF;


   -- ���������
   ioId := lpInsertUpdate_Object (ioId, zc_Object_TranslateMessage(), vbCode_calc, inValue);

   -- ��������� ����� � <���� ��������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateMessage_Language(), ioId, inLanguageId);


   -- ���� ���  "�������" ���� ��������
   IF COALESCE (inParentId, 0) = 0
   THEN
       -- ��������
       IF COALESCE (TRIM (inName), '') = ''
       THEN
           RAISE EXCEPTION '������.������� � ��������� <%> ������ ��� <%> + <%>.', inName, inValue, lfGet_Object_ValueData_sh (inLanguageId);
       END IF;

       -- ��������� <�������� ��������>
       PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_TranslateMessage_Name(), ioId, inName);
   ELSE
       -- ��������� ����� � <"�������" ���� ��������>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_TranslateMessage_Parent(), ioId, inParentId);
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
 15.12.20         *
*/

-- ����
--