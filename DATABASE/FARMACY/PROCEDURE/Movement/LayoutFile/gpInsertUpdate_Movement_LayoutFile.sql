-- Function: gpInsertUpdate_Movement_LayoutFile()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LayoutFile (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LayoutFile(
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
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_LayoutFile());
     vbUserId:= lpGetUserBySession (inSession);

     
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_LayoutFile (ioId              := ioId
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
 05.02.22                                                       *
 */

-- ����
--