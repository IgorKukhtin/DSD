-- Function: gpInsertUpdate_Object_Period (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Period (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Period(
 INOUT ioId           Integer,       -- ���� ������� <Period>
    IN inCode         Integer,       -- �������� <��� Period>
    IN inName         TVarChar,      -- ������� �������� Period
    IN inSession      TVarChar       -- ������ ������������
)
  RETURNS integer
  AS
$BODY$
  DECLARE UserId Integer;
  DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Period());
   UserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Period();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ������������ ��� �������� <������������ Period>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Period(), inName); 
   -- �������� ������������ ��� �������� <��� Period>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Period(), Code_max);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Period(), Code_max, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
22.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Period()
