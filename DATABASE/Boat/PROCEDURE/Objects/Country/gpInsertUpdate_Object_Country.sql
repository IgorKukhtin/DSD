-- ������ �������������

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Country (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Country(
 INOUT ioId           Integer,       -- ���� ������� <������ >
    IN inCode         Integer,       -- ��� ������� <������ >
    IN inName         TVarChar,      -- �������� ������� <������>
    IN inShortName    TVarChar,      -- ������� ��������
    IN inSession      TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_Country());
   vbUserId:= lpGetUserBySession (inSession);

   -- 
   IF COALESCE (ioId, 0) = 0 AND COALESCE (inCode, 0) = 0  THEN inCode := NEXTVAL ('Object_Country_seq'); 
   ELSEIF inCode = 0
         THEN inCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   END IF; 

   -- �������� ������������ ��� �������� <������������ ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Country(), inName);
   -- �������� ������������ ��� �������� <��� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Country(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Country(), ioCode, inName);

   -- ��������� ��������
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Country_ShortName(), ioId, inShortName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 09.11.20          *
*/

-- ����
--