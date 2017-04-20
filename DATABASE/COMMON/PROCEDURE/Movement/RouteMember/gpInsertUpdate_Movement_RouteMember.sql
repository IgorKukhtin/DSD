-- Function: gpInsertUpdate_Movement_RouteMember()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_RouteMember (Integer, TVarChar, TDateTime, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_RouteMember(
 INOUT ioId           Integer   , -- ���� ������� <��������>
    IN inInvNumber    TVarChar  , -- ����� ���������
    IN inOperDate     TDateTime , -- ���� ���������
    IN inGPSN         TFloat    , -- GPS ���������� �������� (������)
    IN inGPSE         TFloat    , -- GPS ���������� �������� (�������)
    IN inSession      TVarChar    -- ������ ������������
)
RETURNS Integer 
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
      -- �������� ���� ������������ �� ����� ���������
      -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_RouteMember());
      vbUserId:= lpGetUserBySession (inSession);

      -- ����������
      ioId:= lpInsertUpdate_Movement_RouteMember (ioId        := ioId
                                                , inInvNumber := inInvNumber
                                                , inOperDate  := inOperDate
                                                , inGPSN      := inGPSN
                                                , inGPSE      := inGPSE
                                                , inUserId    := vbUserId
                                               );
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 27.03.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_RouteMember (ioId:= 0, inInvNumber:= '-1', inOperDate:= CURRENT_DATE, inPartnerId:= 0, inComment:= '�������� ����', inSession:= '5')
