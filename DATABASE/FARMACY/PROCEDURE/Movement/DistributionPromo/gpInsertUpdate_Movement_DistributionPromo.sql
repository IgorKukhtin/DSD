-- Function: gpInsertUpdate_Movement_DistributionPromo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_DistributionPromo (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, Integer, TFloat, TVarChar, TBlob, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_DistributionPromo(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailID              Integer    , -- �������� ����
    IN inStartPromo            TDateTime  , -- ���� ������ ��������
    IN inEndPromo              TDateTime  , -- ���� ��������� ��������
    IN inAmount                Integer    , -- �������� �� ���������� ������
    IN inSummRepay             Tfloat     , -- �������� �� ����� ������ 
    IN inComment               TVarChar   , -- ����������
    IN inMessage               TBlob      , -- ���������
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
    ioId := lpInsertUpdate_Movement_DistributionPromo (ioId            := ioId
                                                     , inInvNumber     := inInvNumber
                                                     , inOperDate      := inOperDate
                                                     , inRetailID      := inRetailID
                                                     , inStartPromo    := inStartPromo
                                                     , inEndPromo      := inEndPromo
                                                     , inAmount        := inAmount                                       
                                                     , inSummRepay     := inSummRepay
                                                     , inComment       := inComment
                                                     , inMessage       := inMessage
                                                     , inUserId        := vbUserId
                                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.20                                                       *
*/