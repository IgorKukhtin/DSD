-- Function: gpInsertUpdate_Object_ReceiptLevel()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptLevel(Integer, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptLevel(Integer, Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptLevel(
 INOUT ioId                  Integer   ,    -- ���� ������� <>
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� 
    IN inFromId              Integer   ,    -- 
    IN inToId                Integer   ,    --
    IN inDocumentKindId      Integer   ,    -- 
    IN inMovementDesc        TFloat   ,     -- 
    IN inComment             TVarChar  ,    -- ����������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_ReceiptLevel()); 

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptLevel(), inCode, inName);

   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_ReceiptLevel_Comment(), ioId, inComment);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReceiptLevel_From(), ioId, inFromId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReceiptLevel_To(), ioId, inToId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ReceiptLevel_DocumentKind(), ioId, inDocumentKindId);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_ReceiptLevel_MovementDesc(), ioId, inMovementDesc);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.06.23         *
 14.06.21         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ReceiptLevel()
