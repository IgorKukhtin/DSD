-- Function: gpUpdate_Object_Personal_isMain ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_isMain (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_isMain(
    IN inId                  Integer   , -- ���� �������
 INOUT ioIsMain              Boolean   , -- �������� ����� ������
    IN inSession             TVarChar    -- ������ ������������
)
  RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- ���������� �������
   ioIsMain:= NOT ioIsMain;

   -- ��������� �������� <�������� ����� ������>
   -- PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Member_Main(), inId, ioIsMain);

   -- ��������� ��������
   -- PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Personal_isMain (Integer, Boolean, TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 13.09.14                                        * rename
 12.09.14                                                       *
*/