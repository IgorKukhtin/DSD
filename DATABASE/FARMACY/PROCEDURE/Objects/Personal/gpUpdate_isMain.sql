-- Function: gpUpdate_isDateOut ()

DROP FUNCTION IF EXISTS gpUpdate_isMain (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_isMain(
    IN inId                  Integer   , -- ���� ������� <����������>
 INOUT ioisMain              Boolean   , -- �������� ����� ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

    -- ��������
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������. ������� ����������� �� �������.';
     END IF;

   -- ���������� �������
   ioisMain:= NOT ioisMain;

   -- ��������� �������� <�������� ����� ������>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Personal_Main(), inId, ioisMain);
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpUpdate_isMain (Integer, Boolean, TVarChar) OWNER TO postgres;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   
 05.02.16         * 
*/

-- ����
-- SELECT * FROM gpUpdate_isDateOut (inId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')