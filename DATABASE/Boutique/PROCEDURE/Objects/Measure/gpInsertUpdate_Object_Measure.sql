-- Function: gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Measure (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Measure(
 INOUT ioId           Integer,       -- ���� ������� <������� ���������>    
 INOUT ioCode         Integer,       -- ��� ������� <������� ���������>     
    IN inName         TVarChar,      -- �������� ������� <������� ���������>
    IN inInternalCode TVarChar,      -- ������������� ���
    IN inInternalName TVarChar,      -- ������������� ������������
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS record
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Measure());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Measure_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Measure_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- �������� ������������ ��� �������� <������������ ������� ���������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Measure(), inName); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Measure(), ioCode, inName);
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
13.05.17                                                          *
08.05.17                                                          *
02.03.17                                                          *
16.02.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Measure()
