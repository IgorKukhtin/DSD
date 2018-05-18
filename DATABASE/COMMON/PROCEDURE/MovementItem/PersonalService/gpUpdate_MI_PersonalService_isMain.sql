-- Function: gpUpdate_MI_PersonalService_isMain()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_isMain (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_PersonalService_isMain(
    IN inId                  Integer   , -- ���� ������� <������� ���������>
 INOUT ioIsMain              Boolean   , -- �������� ����� ������
    IN inSession             TVarChar    -- ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());


     -- ��������
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� ����� ����������.';
     END IF;


     -- ���������� �������
     ioIsMain:= NOT ioIsMain;

      -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Main(), inId, ioIsMain);

     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.10.14         *
*/

-- ����
-- SELECT * FROM gpUpdate_MI_PersonalService_isMain (inId:= 0, ioIsMain:= true, inSession:= '2')
