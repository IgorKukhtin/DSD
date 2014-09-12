DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member_isOfficial (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member_isOfficial(
    IN ioId                  Integer   , -- ���� �������
 INOUT inIsOfficial          Boolean   , -- �������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());

   -- �������� ���� ������������ �� ����� ���������
--     vbUserId:= inSession;

   -- ���������� �������
   inIsOfficial:= NOT inIsOfficial;

   -- ��������� �������� <�������� ����������>
--   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), ioId, inIsOfficial);
   -- ��������� ��������
--   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Member_isOfficial(Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 12.09.14                                                       *
*/

