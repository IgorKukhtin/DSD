-- Function: gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Measure(
 INOUT ioId	          Integer,   	-- ���� ������� <������� ���������>
    IN inCode         Integer,       -- �������� <��� ������� ���������>
    IN inName         TVarChar,      -- ������� �������� ������� ���������
    IN inInternalCode TVarChar,      --
    IN inInternalName TVarChar,      --
    IN inSession      TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;

BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN
       SELECT COALESCE( MAX (ObjectCode), 0) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Measure();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ������������ ��� �������� <������������ ������� ���������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Measure(), inName); --!!!�������� ����.!!! 
   -- �������� ������������ ��� �������� <��� ������� ���������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Measure(), Code_max);



   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Measure(), Code_max, inName);

   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Measure_InternalCode(), ioId, inInternalCode);
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Measure_InternalName(), ioId, inInternalName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 09.10.14                                                       *
 13.06.13          *
 16.06.13                                        * COALESCE( MAX (ObjectCode), 0)

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Measure()
