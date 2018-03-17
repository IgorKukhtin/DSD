-- Function: gpInsertUpdate_Movement_ReturnIn()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ReturnIn (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ReturnIn(
 INOUT ioId                   Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber            TVarChar  , -- ����� ���������
    IN inOperDate             TDateTime , -- ���� ���������
    IN inFromId               Integer   , -- �� ���� (� ���������)
    IN inToId                 Integer   , -- ���� (� ���������)
    IN inComment              TVarChar  , -- ����������
    IN inSession              TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ReturnIn());
     vbUserId := lpGetUserBySession (inSession);


     -- ���������� ������� �� �������������� ������������ � ����������
     vbUnitId:= lpGetUnitBySession (inSession);

     -- ���� � ������������ = 0, ����� ����� �������� ����� �������, ����� ������ ����
     IF COALESCE (vbUnitId, 0 ) <> 0 AND COALESCE (vbUnitId) <> inToId
     THEN
         RAISE EXCEPTION '������.� ������������ <%> ��� ���� �� ������������� <%> .', lfGet_Object_ValueData (vbUserId), lfGet_Object_ValueData (inToId);
     END IF;
     

     -- ������������ ���������� � ���.
     IF COALESCE (ioId, 0) = 0 THEN
         ioInvNumber:= CAST (NEXTVAL ('Movement_ReturnIn_seq') AS TVarChar);  
     ELSEIF vbUserId = zc_User_Sybase() THEN
        ioInvNumber:= (SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = ioId);
     END IF;
     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_ReturnIn (ioId                := ioId
                                             , inInvNumber         := ioInvNumber
                                             , inOperDate          := inOperDate
                                             , inFromId            := inFromId
                                             , inToId              := inToId
                                             , inComment           := inComment
                                             , inUserId            := vbUserId
                                              );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 15.05.17         *
 */

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_ReturnIn (ioId := 7 , ioInvNumber := '4' , inOperDate := ('01.01.2017')::TDateTime , inFromId := 230 , inToId := 229, inComment := 'df' ,  inSession := '2');
