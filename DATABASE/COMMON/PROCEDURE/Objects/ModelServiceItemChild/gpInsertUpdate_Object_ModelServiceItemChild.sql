-- Function: gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelServiceItemChild(
 INOUT ioId                       Integer   , -- ���� ������� <����������� �������� ������ ����������>
    IN inComment                  TVarChar  , -- ����������
    IN inFromId                   Integer   , -- �����(�� ����)
    IN inToId                     Integer   , -- �����(����) 	
    IN inFromGoodsKindId          Integer   , -- ��� ������(�� ����)
    IN inToGoodsKindId            Integer   , -- ��� ������(����) 	
    IN inFromGoodsKindCompleteId  Integer   , -- ��� ������(�� ����, ������� ���������)
    IN inToGoodsKindCompleteId    Integer   , -- ��� ������(����, ������� ���������)	
    IN inModelServiceItemMasterId Integer   , -- ������� �������
    IN inFromStorageLineId        Integer   , -- ����� ��-�� (�� ����)
    IN inToStorageLineId          Integer   , -- ����� ��-�� (����)
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ModelServiceItemChild());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_ModelService())
   THEN
        RAISE EXCEPTION '������.%��� ���� �������������� = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_ModelServiceItemChild())
                       ;
   END IF;

    -- ��������
   IF COALESCE (inModelServiceItemMasterId, 0) = 0
   THEN
       RAISE EXCEPTION '������. �� ���������� ������� �������!';
   END IF;
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ModelServiceItemChild(), 0, '');
   
   -- ��������� �������� <>   
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ModelServiceItemChild_Comment(), ioId, inComment);
   
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_From(), ioId, inFromId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_To(), ioId, inToId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_FromGoodsKind(), ioId, inFromGoodsKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_ToGoodsKind(), ioId, inToGoodsKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_FromGoodsKindComplete(), ioId, inFromGoodsKindCompleteId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_ToGoodsKindComplete(), ioId, inToGoodsKindCompleteId);
   
      -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster(), ioId, inModelServiceItemMasterId);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_FromStorageLine(), ioId, inFromStorageLineId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_ToStorageLine(), ioId, inToStorageLineId);

   -- ��������� �������� 
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_ModelServiceItemChild (Integer, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
26.05.17         * add StorageLine
27.12.16         *
20.10.13         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ModelServiceItemChild (0, '1000', 5, 6, '2')
    