-- Function: gpInsertUpdate_Object_Currency()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Currency(
 INOUT ioId                  Integer   ,   	-- ���� ������� <������>
    IN inCode                Integer   ,    -- ������������� ��� ������� <������> 
    IN inName                TVarChar  ,    -- �������� ������� <������> 
    IN inInternalName        TVarChar  ,    -- ������������� ������������ ������� <������> 
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Currency());
   UserId := inSession;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Currency();
   ELSE
       Code_max := inCode;
   END IF;

   -- �������� ���� ������������ ��� �������� <������������ ������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Currency(), inName);
   -- �������� ���� ������������ ��� �������� <��� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Currency(), Code_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Currency(), Code_max, inName);
   
   PERFORM lpInsertUpdate_ObjectString(zc_objectString_Currency_InternalName(), ioId, inInternalName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Currency (Integer, Integer, TVarChar, TVarChar, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.12.13                                        *Cyr1251
 11.06.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Currency()       