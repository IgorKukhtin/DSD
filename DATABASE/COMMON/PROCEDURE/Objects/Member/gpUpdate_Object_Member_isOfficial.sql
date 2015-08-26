-- Function: gpUpdate_Object_Member_isOfficial ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Member_isOfficial (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_isOfficial(
    IN inId                  Integer   , -- ���� �������
 INOUT ioIsOfficial          Boolean   , -- �������
    IN inSession             TVarChar    -- ������ ������������
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());

   -- ���������� �������
   ioIsOfficial:= NOT ioIsOfficial;

   -- ��������� �������� <�������� ����������>
   -- PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), inId, ioIsOfficial);

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Member_isOfficial(Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 13.09.14                                        * rename
 12.09.14                                                       *
*/

