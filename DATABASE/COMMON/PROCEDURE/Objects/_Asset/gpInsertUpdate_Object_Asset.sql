-- Function: gpInsertUpdate_Object_Asset()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Asset(
 INOUT ioId                  Integer   ,    -- ���� ������� < �������� ��������>
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� 
    
    IN inRelease             TDateTime ,    -- ���� �������
    
    IN inInvNumber           TVarChar  ,    -- ����������� �����
    IN inFullName            TVarChar  ,    -- ������ �������� ��
    IN inSerialNumber        TVarChar  ,    -- ��������� �����
    IN inPassportNumber      TVarChar  ,    -- ����� ��������
    IN inComment             TVarChar  ,    -- ����������
    
    IN inAssetGroupId        Integer   ,    -- ������ �� ������ �������� �������
    IN inJuridicalId         Integer   ,    -- ������ �� ����������� ����
    IN inMakerId             Integer   ,    -- ������ �� ������������� (��)
    
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer; 
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Asset());
   vbUserId:= inSession;

    -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Asset()); 

   
   -- �������� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Asset(), inName);
   -- �������� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Asset(), vbCode_calc);
   -- �������� ������������ ��� �������� <����������� �����> 
   PERFORM lpCheckUnique_ObjectString_ValueData(ioId, zc_ObjectString_Asset_InvNumber(), inInvNumber);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Asset(), vbCode_calc, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_InvNumber(), ioId, inInvNumber);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_FullName(), ioId, inFullName);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_SerialNumber(), ioId, inSerialNumber);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_PassportNumber(), ioId, inPassportNumber);
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Asset_Comment(), ioId, inComment);

   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_AssetGroup(), ioId, inAssetGroupId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_Juridical(), ioId, inJuridicalId);
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Asset_Maker(), ioId, inMakerId);


   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Asset_Release(), ioId, inRelease);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Asset(Integer, Integer, TVarChar, TDateTime, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.02.14         * add wiki  
 02.07.13          *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Asset()
