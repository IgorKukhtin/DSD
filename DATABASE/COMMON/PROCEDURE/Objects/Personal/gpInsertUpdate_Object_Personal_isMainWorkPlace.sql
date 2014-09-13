DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal_isMain (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal_isMain(
    IN ioId                  Integer   , -- ���� �������
 INOUT inIsMain              Boolean   , -- �������
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- �������� ���� ������������ �� ����� ���������
--     vbUserId:= inSession;

   -- ���������� �������
   inIsMain:= NOT inIsMain;

   -- ��������� �������� <�������� ����������>
--   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Official(), ioId, inIsOfficial);
   -- ��������� ��������
--   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Personal_isMain(Integer, Boolean, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 12.09.14                                                       *
*/