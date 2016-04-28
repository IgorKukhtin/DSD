-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Tfloat, Tfloat, Integer, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Promo(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inStartPromo            TDateTime  , -- ���� ������ ���������
    IN inEndPromo              TDateTime  , -- ���� ��������� ���������
    IN inAmount                Tfloat     , -- 
    IN inChangePercent         Tfloat     , --
    IN inMakerId               Integer    , -- �������������
    IN inPersonalId            Integer    , -- ������������� ������������� �������������� ������
    IN inComment               TVarChar   , -- ����������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Promo (ioId            := ioId
                                         , inInvNumber     := inInvNumber
                                         , inOperDate      := inOperDate
                                         , inStartPromo    := inStartPromo
                                         , inEndPromo      := inEndPromo
                                         , inAmount        := inAmount
                                         , inChangePercent := inChangePercent
                                         , inMakerId       := inMakerId
                                         , inPersonalId    := inPersonalId
                                         , inComment       := inComment
                                         , inUserId        := vbUserId
                                         );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 24.04.16         *
*/