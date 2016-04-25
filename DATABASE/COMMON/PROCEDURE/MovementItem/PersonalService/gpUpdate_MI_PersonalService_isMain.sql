-- Function: gpUpdate_MI_PersonalService_isMain()

DROP FUNCTION IF EXISTS gpUpdate_MI_PersonalService_isMain (Integer, Boolean, Integer);

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

     -- ��������
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������.�� ������� �����.';
     END IF;
     
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalService());


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
-- SELECT * FROM gpUpdate_MI_PersonalService_isMain (inId:= 0, inisMain:= true, inSession:= '2')

--select * from gpUpdate_MI_PersonalService_isMain(inId := 4771714 , ioIsMain := 'false' ,  inSession := '5');