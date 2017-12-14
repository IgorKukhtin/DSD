-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoCode (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Tfloat, Boolean, Boolean, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoCode(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inStartPromo            TDateTime  , -- ���� ������ ���������
    IN inEndPromo              TDateTime  , -- ���� ��������� ���������
    IN inChangePercent         Tfloat     , --
    IN inIsElectron            Boolean    , 
    IN inIsOne                 Boolean    , 
    IN inPromoCodeId           Integer    , --
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
    ioId := lpInsertUpdate_Movement_PromoCode (ioId            := ioId
                                             , inInvNumber     := inInvNumber
                                             , inOperDate      := inOperDate
                                             , inStartPromo    := inStartPromo
                                             , inEndPromo      := inEndPromo
                                             , inChangePercent := inChangePercent
                                             , inIsElectron    := inIsElectron
                                             , inIsOne         := inIsOne                                         
                                             , inPromoCodeId   := inPromoCodeId
                                             , inComment       := inComment
                                             , inUserId        := vbUserId
                                             );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 13.12.17         *
*/