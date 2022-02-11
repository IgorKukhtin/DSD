-- Function: gpInsertUpdate_Object_Unit_Position (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit_Position (Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit_Position(
    IN inId                  Integer   ,    -- ���� ������� <�������������> 
    IN inLeft                Integer   ,    -- ���� ������� <�����> 
    IN inTop                 Integer   ,    -- ���� ������� <�����> 
    IN inWidth               Integer   ,    -- ���� ������� <�����> 
    IN inHeight              Integer   ,    -- ���� ������� <�����> 
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGroupNameFull TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF COALESCE (inId, 0) = 0
   THEN
     RETURN;
   END IF;
   

   -- ��������� 	��������� �������������
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PositionFixed(), inId, True);
   -- ��������� ��������� ������������ ������ ����
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_Left(), inId, inLeft);
   -- ��������� ��������� ������������ �������� ����
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_Top(), inId, inTop);
   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_Width(), inId, inWidth);
   -- ��������� ������
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Unit_Height(), inId, inHeight);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 11.02.22                                                       *
*/

-- ����
--