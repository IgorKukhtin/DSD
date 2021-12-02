-- Function: gpInsertUpdate_Movement_Pretension()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Pretension
   (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Pretension(
 INOUT ioId                  Integer   , -- ���� ������� <�������� �����������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
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

     ioId := lpInsertUpdate_Movement_Pretension(ioId
                                             , inInvNumber
                                             , inOperDate
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
-- SELECT * FROM gpInsertUpdate_Movement_Pretension (ioId:= 0, inSession:= '2')
