-- Function: gpInsertUpdate_Object_Label (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Label(
 INOUT ioId           Integer,       -- ���� ������� <�������� ��� �������>    
    IN inCode         Integer,       -- ��� ������� <�������� ��� �������>     
    IN inName         TVarChar,      -- �������� ������� <�������� ��� �������>
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF inCode = 0 THEN  inCode := NEXTVAL ('Object_Label_seq'); END IF; 

   -- �������� ������������ ��� �������� <������������ �������� ��� �������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Label(), inName); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Label(), inCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
03.03.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Label()
