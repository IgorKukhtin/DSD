-- �������� ��� �������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Label (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Label(
 INOUT ioId           Integer,       -- ���� ������� <�������� ��� �������>    
 INOUT ioCode         Integer,       -- ��� ������� <�������� ��� �������>     
    IN inName         TVarChar,      -- �������� ������� <�������� ��� �������>
    IN inName_UKR     TVarChar,      -- �������� ������� <�������� ��� �������> ���
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Label());
   vbUserId:= lpGetUserBySession (inSession);

   -- ����� ������- ��� ����� ����� � ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) <> 0 THEN ioCode := NEXTVAL ('Object_Label_seq'); 
   END IF; 

   -- ����� ��� �������� �� Sybase �.�. ��� ��� = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Label_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- �������� ������������ ��� �������� <������������ �������� ��� �������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Label(), inName); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Label(), ioCode, inName);

   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Label_UKR(), ioId, inName_UKR);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
09.06.20          *
13.05.17                                                          *
08.05.17                                                          *
03.03.17                                                          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Label()
