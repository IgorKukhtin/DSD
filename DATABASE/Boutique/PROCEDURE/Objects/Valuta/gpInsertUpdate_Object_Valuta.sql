-- Function: gpInsertUpdate_Object_Valuta (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Valuta (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Valuta(
 INOUT ioId           Integer,       -- ���� ������� <Valuta>
    IN inCode         Integer,       -- �������� <��� Valuta>
    IN inName         TVarChar,      -- ������� �������� Valuta
    IN inSession      TVarChar       -- ������ ������������
)
  RETURNS integer
  AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Valuta());
   UserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Valuta();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ������������ ��� �������� <������������ Valuta>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Valuta(), inName); 
   -- �������� ������������ ��� �������� <��� Valuta>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Valuta(), Code_max);



   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Valuta(), Code_max, inName);


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
-- SELECT * FROM gpInsertUpdate_Object_Valuta()
