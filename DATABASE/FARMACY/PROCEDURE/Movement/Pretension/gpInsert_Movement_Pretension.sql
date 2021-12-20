-- Function: gpInsert_Movement_Pretension()

DROP FUNCTION IF EXISTS gpInsert_Movement_Pretension (Integer, Integer, Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_Movement_Pretension(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inFromId              Integer   , -- �� ���� (� ���������)
    IN inToId                Integer   , -- ����
    IN inParentId            Integer   , -- ��������� ���������
    IN inComment             TBlob     , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     --vbUserId := inSession;
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Pretension());
     
     ioId := 0;
     
     IF COALESCE (inComment, '') = ''
     THEN
       RETURN;
     END IF;  
     
     ioId := lpInsertUpdate_Movement_Pretension(0
                                             , CAST (NEXTVAL ('movement_Pretension_seq') AS TVarChar) 
                                             , CURRENT_DATE
                                             , inFromId
                                             , inToId
                                             , inParentId
                                             , inComment
                                             , vbUserId);


END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.21                                                       *
*/

-- ����
-- SELECT * FROM gpInsert_Movement_Pretension (ioId:= 0, inSession:= '2')