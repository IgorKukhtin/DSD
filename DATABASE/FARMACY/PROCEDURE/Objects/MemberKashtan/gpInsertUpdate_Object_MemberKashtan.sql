-- Function: gpInsertUpdate_Object_MemberKashtan()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberKashtan (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberKashtan(
 INOUT ioId	                 Integer   ,    -- ���� ������� <> 
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� ������� <>
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MemberKashtan(), inCode, inName);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.03.21                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MemberKashtan (324, 2, '17', '3');