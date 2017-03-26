-- Function: gpInsertUpdate_Movement_Visit()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Visit (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Visit(
 INOUT ioId           Integer   , -- ���� ������� <��������>
    IN inInvNumber    TVarChar  , -- ����� ���������
    IN inOperDate     TDateTime , -- ���� ���������
    IN inPartnerId    Integer   , -- ����������
   OUT outPartnerName TVarChar  , -- ����������
    IN inComment      TVarChar  , -- ����������
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS RECORD 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Visit());

      -- ����������
      ioId:= lpInsertUpdate_Movement_Visit (ioId        := ioId
                                              , inInvNumber := inInvNumber
                                              , inOperDate  := inOperDate
                                              , inPartnerId := inPartnerId
                                              , inComment   := inComment
                                              , inUserId    := vbUserId
                                               );

      SELECT ValueData INTO outPartnerName FROM Object WHERE Id = inPartnerId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 26.03.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_Visit (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inPartnerId:= 0, inComment:= '�������� ����', inSession:= '5')
