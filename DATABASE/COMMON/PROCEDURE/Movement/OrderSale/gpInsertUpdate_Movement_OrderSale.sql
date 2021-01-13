-- Function: gpInsertUpdate_Movement_OrderSale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderSale (Integer, TVarChar, TDateTime, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderSale(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inInvNumber           TVarChar  , -- ����� ���������
    IN inOperDate            TDateTime , -- ���� ���������
    IN inPartnerId           Integer   , --
    IN inTotalCountKg        TFloat    , 
    IN inTotalSumm           TFloat    , 
    IN inComment             TVarChar   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderSale());
     --vbUserId := inSession;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_OrderSale (ioId           := ioId
                                              , inInvNumber    := inInvNumber
                                              , inOperDate     := inOperDate
                                              , inPartnerId    := inPartnerId
                                              , inTotalCountKg := inTotalCountKg
                                              , inTotalSumm    := inTotalSumm
                                              , inComment      := inComment
                                              , inUserId       := vbUserId
                                               );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.21         *
*/

-- ����
--