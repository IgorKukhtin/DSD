-- Function: gpInsertUpdate_Object_GoodsKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportExportLink(Integer, Integer, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportExportLink(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportExportLink(Integer, Integer, TVarChar, Integer, Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportExportLink(
 INOUT ioId	                 Integer   ,    -- ���������� ���� �������  
    IN inIntegerKey              Integer   ,    -- �������� ���� �������  
    IN inStringKey               TVarChar  ,    -- ��������� ���� �������
    IN inObjectMainId            Integer   ,    -- ������ ������ ����� 
    IN inObjectChildId           Integer   ,    -- ������ ������ �����
    IN inImportExportLinkTypeId  Integer   ,    -- ��� �����
    IN inText                    TBlob     ,    -- ��������� ����
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsKind());
   vbUserId:= lpGetUserBySession (inSession);


   --��������� ��� �� ����� ���� zc_Enum_ImportExportLinkType_UploadCompliance ��������������� ������ �������
   IF 1 = 0 AND (inImportExportLinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance())
   THEN
       IF NOT EXISTS (SELECT ObjectLink_UserRole_View.UserId FROM ObjectLink_UserRole_View WHERE ObjectLink_UserRole_View.UserId = vbUserId AND ObjectLink_UserRole_View.RoleId = zc_Enum_Role_Admin())
       THEN
           RAISE EXCEPTION '������. ����� ���� <%> ����� ���������/������������� ������ �������������', (Select ValueData from Object Where Id = zc_Enum_ImportExportLinkType_UploadCompliance());
       END IF;
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ImportExportLink(), inIntegerKey, inStringKey);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ImportExportLink_ObjectMain(), ioId, inObjectMainId);   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ImportExportLink_ObjectChild(), ioId, inObjectChildId);  
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ImportExportLink_LinkType(), ioId, inImportExportLinkTypeId);  

   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ImportExportLink_Text(), ioId, inText);  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);   

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportExportLink(Integer, Integer, TVarChar, Integer, Integer, Integer, TBlob, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 02.12.15                                                         *IF (inImportExportLinkTypeId = zc_Enum_ImportExportLinkType_UploadCompliance())
 23.12.14                         *
 09.12.14                         *
 08.12.14                         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_GoodsKind()
