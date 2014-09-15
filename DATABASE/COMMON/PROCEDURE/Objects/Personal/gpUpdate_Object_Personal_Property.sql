-- Function: gpUpdate_Object_Personal_Property ()

DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Personal_Property(
    IN inId                  Integer   , -- ���� ������� <����������>
    IN inPositionId          Integer   , -- ������ �� ���������
    IN inUnitId              Integer   , -- ������ �� �������������
    IN inIsMain              Boolean   , -- �������� ����� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;

   DECLARE vbCode Integer;
   DECLARE vbName TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

   -- ��������� ����� � <����������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Position(), inId, inPositionId);
   -- ��������� �������� <�������� ����� ������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), inId, inIsMain);
   -- ��������� ����� � <��������������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Personal_Unit(), inId, inUnitId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_Object_Personal_Property (Integer, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.A.
 15.09.14                                                       *
 12.09.14                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Personal_Property (inId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')