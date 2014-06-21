-- Function: gpUpdate_Object_Partner_Address()

DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Partner_Address (Integer, Integer, TVarChar, TVarChar, TVarChar,  TVarChar, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Partner_Address(
 INOUT ioId                  Integer   ,    -- ���� ������� <����������> 
   --OUT outPartnerName        TVarChar  ,    -- ���� ������� <����������> 
    IN inCode                Integer   ,    -- ��� ������� <����������> 
    IN inName                TVarChar  ,    -- <����������> 
    --IN inShortName           TVarChar  ,    -- ������� ������������

    IN inHouseNumber         TVarChar  ,    -- ����� ����
    IN inCaseNumber          TVarChar  ,    -- ����� �������
    IN inRoomNumber          TVarChar  ,    -- ����� ��������
    IN inStreetId            Integer   ,    -- �����/��������  

    --IN inJuridicalId         Integer   ,    -- ����������� ����
    
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbAddress TVarChar;
   
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());
   vbUserId := inSession;

   -- !!! ���� ��� �� ����������, ���������� ��� ��� ���������+1 (!!! ����� ���� ����� ��� �������� !!!)
   -- !!! vbCode:= lfGet_ObjectCode (inCode, zc_Object_Partner());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! � ��� ������ !!!

   vbAddress := (SELECT COALESCE(cityname, '')||', '||COALESCE(streetkindname, '')||' '||
                        COALESCE(name, '')||', '
                   FROM Object_Street_View  WHERE Id = inStreetId);
   vbAddress := vbAddress||inHouseNumber;

   -- ���������� ���������, �.�. �������� ������ ���� ���������������� � �������� <����������� ����>
   --SELECT ValueData INTO outPartnerName FROM Object WHERE Id = inJuridicalId;
   -- !!!� �������� ��������� <����� ����� ��������>!!!
   -- outPartnerName:= outPartnerName || ', ' || vbAddress;


   -- �������� ������������ <������������>
   -- PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Partner(), inName );
   -- �������� ������������ <���>
   IF inCode <> 0 THEN PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Partner(), vbCode); END IF;


   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Partner(), vbCode, inName);
   -- ��������� �������� <������� ������������>
   --PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_ShortName(), ioId, inShortName);
   
   -- ��������� �������� <����� ����� ��������>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_Address(), ioId, vbAddress);
   -- ��������� �������� <���>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_HouseNumber(), ioId, inHouseNumber);
   -- ��������� �������� <������>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_CaseNumber(), ioId, inCaseNumber);
   -- ��������� �������� <��������>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Partner_RoomNumber(), ioId, inRoomNumber);

   -- ��������� ����� � <�����>
   PERFORM lpInsertUpdate_ObjectLink( zc_ObjectLink_Partner_Street(), ioId, inStreetId);
 
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Partner_Address (Integer, Integer,  TVarChar, TVarChar,  TVarChar, TVarChar, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 19.06.14         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Partner_Address()
