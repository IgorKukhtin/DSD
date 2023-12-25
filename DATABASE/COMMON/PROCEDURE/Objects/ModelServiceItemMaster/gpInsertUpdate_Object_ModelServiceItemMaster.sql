-- Function: gpInsertUpdate_Object_ModelServiceItemMaster(Integer,  TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemMaster(Integer,  TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemMaster(Integer,  TFloat, TFloat, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelServiceItemMaster(
 INOUT ioId                  Integer   , -- ���� ������� < ������� �������� ������ ����������>
    IN inMovementDescId      TFloat    , -- ��� ���������
    IN inRatio               TFloat    , -- ����������� ��� ������ ������
    IN inComment             TVarChar  , -- ����������
    IN inModelServiceId      Integer   , -- ������ ����������
    IN inFromId              Integer   , -- �������������(�� ����)
    IN inToId                Integer   , -- �������������(����)
    IN inSelectKindId        Integer   , -- ��� ������ ������
    IN inDocumentKindId      Integer   , -- ��� ������ ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ModelServiceItemMaster());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_ModelService())
      AND vbUserId <> 5
   THEN
        RAISE EXCEPTION '������.%��� ���� �������������� = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_ModelServiceItemMaster())
                       ;
   END IF;

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ModelServiceItemMaster(), 0, '');

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ModelServiceItemMaster_MovementDesc(), ioId, inMovementDescId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ModelServiceItemMaster_Ratio(), ioId, inRatio);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ModelServiceItemMaster_Comment(), ioId, inComment);

   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_ModelService(), ioId, inModelServiceId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_From(), ioId, inFromId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_To(), ioId, inToId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_SelectKind(), ioId, inSelectKindId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemMaster_DocumentKind(), ioId, inDocumentKindId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.06.16         * DocumentKind
 21.11.13                                        * inMovementDesc -> inMovementDescId
 19.10.13         *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ModelServiceItemMaster (0,  198, 2, 1000, 1, 5, 6, '2')
