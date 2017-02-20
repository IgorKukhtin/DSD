-- Function: gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CompositionGroup (Integer, Integer, TVarChar,  TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CompositionGroup(
 INOUT ioId	      Integer,       -- ���� ������� <>
    IN inCode         Integer,       -- �������� <��� >
    IN inName         TVarChar,      -- ������� �������� 
    IN inSession      TVarChar       -- ������ ������������
)
  RETURNS integer 
  AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_CompositionGroup());
   UserId := inSession;

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_CompositionGroup();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CompositionGroup(), inName); --!!!�������� ����.!!! 
   -- �������� ������������ ��� �������� <��� >
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CompositionGroup(), Code_max);



   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_CompositionGroup(), Code_max, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;
$BODY$

  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
16.02.17                                                          *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CompositionGroup()
