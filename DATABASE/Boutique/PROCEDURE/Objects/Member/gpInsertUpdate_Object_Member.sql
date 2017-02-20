-- Function: gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar,TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member(
 INOUT ioId           Integer,       -- ���� ������� <>
    IN inCode         Integer,       -- �������� <>
    IN inName         TVarChar,      -- ������� �������� 
    IN inINN          TVarChar,      --
    IN inComment      TVarChar,      --
    IN inEMail        TVarChar,      --
    IN inSession      TVarChar       -- ������ ������������
)
  RETURNS integer
  AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Member());
   UserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Member();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName); 
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), Code_max);



   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Member(), Code_max, inName);

   -- ��������� <��������>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_INN(), ioId, inINN);
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_Comment(), ioId, inComment);
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Member_EMail(), ioId, inEMail);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
20.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Member()
