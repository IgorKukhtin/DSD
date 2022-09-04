-- Function: gpInsertUpdate_Movement_FilesToCheck()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_FilesToCheck (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_FilesToCheck(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inStartPromo          TDateTime , -- ���� ������ ������
    IN inEndPromo            TDateTime , -- ���� ��������� ������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_FilesToCheck());
     vbUserId:= lpGetUserBySession (inSession);

     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_FilesToCheck (ioId              := ioId
                                               , inInvNumber       := inInvNumber
                                               , inOperDate        := inOperDate
                                               , inStartPromo      := inStartPromo
                                               , inEndPromo        := inEndPromo
                                               , inComment         := inComment
                                               , inUserId          := vbUserId
                                                );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.22                                                       *
 */

-- ����
--