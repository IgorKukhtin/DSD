-- Function: gpInsertUpdate_Movement_PermanentDiscount()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PermanentDiscount (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PermanentDiscount(
 INOUT ioId                  Integer   , -- ���� ������� <�������� ��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inRetailId            Integer   , -- �������������
    IN inStartPromo          TDateTime , -- ���� ������ ���������
    IN inEndPromo            TDateTime , -- ���� ��������� ���������
    IN inChangePercent       TFloat    , -- ������� ������
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
     vbUserId := inSession;
 	 
     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_PermanentDiscount (ioId               := ioId
                                                      , inInvNumber        := inInvNumber
                                                      , inOperDate         := inOperDate
                                                      , inRetailId         := inRetailId
                                                      , inStartPromo       := inStartPromo
                                                      , inEndPromo         := inEndPromo
                                                      , inChangePercent    := inChangePercent
                                                      , inComment          := inComment
                                                      , inUserId           := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Movement_PermanentDiscount (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.12.19                                                       *
 */

-- ����
-- SELECT * FROM gpInsertUpdate_Movement_PermanentDiscount (ioId:= 0, inInvNumber:= '-1', inOperDate:= '01.01.2013', inUnitId:= 1, inArticlePermanentDiscountId = 1, inComment = '', inSession:= '3')
