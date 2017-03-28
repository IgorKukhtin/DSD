-- Function: gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Position (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Position(
 INOUT ioId           Integer,       -- ���� ������� <���������>    
    IN inCode         Integer,       -- ��� ������� <���������>     
    IN inName         TVarChar,      -- �������� ������� <���������>
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Position());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Position_seq'); END IF; 

   -- �������� ������������ ��� �������� <������������ ���������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Position(), inName); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Position(), inCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
28.03.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Position()
