DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Personal_Property (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Personal_Property(
 INOUT ioId                  Integer   , -- ���� ������� <����������>
    IN inPositionId          Integer   , -- ������ �� ���������
    IN inIsMain              Boolean   , -- �������� ����� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;
   DECLARE vbName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), ioId, inPositionId);
   -- ��������� �������� <�������� ����� ������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), ioId, inIsMain);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Personal_Property (Integer, Integer, Boolean, TVarChar) OWNER TO postgres;


/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 12.09.14                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Personal_Property (ioId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')
