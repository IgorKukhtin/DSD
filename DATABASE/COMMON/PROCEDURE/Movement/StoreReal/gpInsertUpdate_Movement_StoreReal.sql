-- Function: gpInsertUpdate_Movement_StoreReal()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_StoreReal (Integer, TVarChar, TDateTime, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_StoreReal(
 INOUT ioId           Integer   , -- ���� ������� <�������� �����������>
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
      vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_StoreReal());

      -- ����������
      ioId:= lpInsertUpdate_Movement_StoreReal (ioId        := ioId
                                              , inInvNumber := inInvNumber
                                              , inOperDate  := inOperDate
                                              , inUserId    := vbUserId
                                              , inPartnerId := inPartnerId
                                              , inGUID      := NULL
                                              , inComment   := inComment
                                               );

      SELECT ValueData INTO outPartnerName FROM Object WHERE Id = inPartnerId;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 16.02.17                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_StoreReal (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inPartnerId:= 0, inComment:= '�������� ����', inSession:= '5')
