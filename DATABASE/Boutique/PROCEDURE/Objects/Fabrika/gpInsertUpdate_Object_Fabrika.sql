-- Function: gpInsertUpdate_Object_Fabrika (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Fabrika (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Fabrika(
 INOUT ioId           Integer,       -- ���� ������� <Fabrika>
    IN inCode         Integer,       -- �������� <��� Fabrika>
    IN inName         TVarChar,      -- ������� �������� Fabrika
    IN inSession      TVarChar       -- ������ ������������
)
  RETURNS integer
  AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Fabrika());
   UserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Fabrika();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ������������ ��� �������� <������������ Fabrika>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Fabrika(), inName); 
   -- �������� ������������ ��� �������� <��� Fabrika>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Fabrika(), Code_max);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Fabrika(), Code_max, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
19.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Fabrika()
