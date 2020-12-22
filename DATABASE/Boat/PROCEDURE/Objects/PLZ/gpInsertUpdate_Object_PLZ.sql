-- Function: gpInsertUpdate_Object_PLZ (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PLZ (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PLZ(
 INOUT ioId           Integer,       -- ���� ������� <���������� ����>    
 INOUT ioCode         Integer,       -- ��� ������� <���������� ����>     
    IN inName         TVarChar,      -- �������� ������� ��� <���������� ����>
    IN inCity         TVarChar,      -- ���
    IN inAreaCode     TVarChar,      -- E-Mail
    IN inComment      TVarChar,      -- ����������
    IN inCountryId    Integer ,      --
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_PLZ());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���������� ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   ioCode:= lfGet_ObjectCode (ioCode, zc_Object_PLZ()); 
   
   -- �������� ������������ ��� �������� <������������>
   --PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_PLZ(), inName, vbUserId); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PLZ(), ioCode, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_PLZ_Country(), ioId, inCountryId);

   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PLZ_City(), ioId, inCity);
   -- ��������� ����������  
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PLZ_Comment(), ioId, inComment);
   -- ��������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_PLZ_AreaCode(), ioId, inAreaCode);

   IF vbIsInsert = TRUE THEN
      -- ��������� �������� <���� ��������>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- ��������� �������� <������������ (��������)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;



/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.20         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PLZ()
