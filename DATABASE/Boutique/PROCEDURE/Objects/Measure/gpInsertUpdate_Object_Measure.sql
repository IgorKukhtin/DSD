-- Function: gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Measure(
 INOUT ioId           Integer,       -- ���� ������� <������� ���������>    
    IN inCode         Integer,       -- ��� ������� <������� ���������>     
    IN inName         TVarChar,      -- �������� ������� <������� ���������>
    IN inInternalCode TVarChar,      -- ������������� ���
    IN inInternalName TVarChar,      -- ������������� ������������
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());
   vbUserId:= lpGetUserBySession (inSession);
  
   -- �������� ������������ ��� �������� <������������ ������� ���������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Measure(), inName); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Measure(), inCode, inName);
   -- ��������� ������������� ���
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Measure_InternalCode(), ioId, inInternalCode);
   -- ��������� ������������� ������������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Measure_InternalName(), ioId, inInternalName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

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
-- SELECT * FROM gpInsertUpdate_Object_Measure()
