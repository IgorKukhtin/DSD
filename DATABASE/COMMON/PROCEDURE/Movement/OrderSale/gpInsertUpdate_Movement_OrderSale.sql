-- Function: gpInsertUpdate_Movement_OrderSale()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderSale (Integer, TVarChar, TDateTime, Integer, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_OrderSale (Integer, TVarChar, TDateTime, TDateTime, Integer, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_OrderSale(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
 INOUT ioInvNumber           TVarChar  , -- ����� ���������
 INOUT ioOperDate            TDateTime , -- ���� ���������
    IN inOperDate_top        TDateTime ,
    IN inPartnerId           Integer   , --
    IN inTotalCountKg        TFloat    , 
    IN inTotalSumm           TFloat    , 
    IN inComment             TVarChar   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderSale());


     -- ���� �� ������ ���� ��������� ����� ���� �� �������
     IF COALESCE (ioOperDate, zc_DateStart()) = zc_DateStart()
     THEN
         ioOperDate := inOperDate_top;
     END IF;
     
     -- ��������� <��������>
      SELECT tmp.ioId, tmp.ioInvNumber
    INTO ioId, ioInvNumber
      FROM lpInsertUpdate_Movement_OrderSale (ioId           := ioId
                                            , ioInvNumber    := ioInvNumber
                                            , inOperDate     := ioOperDate
                                            , inPartnerId    := inPartnerId
                                            , inTotalCountKg := inTotalCountKg
                                            , inTotalSumm    := inTotalSumm
                                            , inComment      := inComment
                                            , inUserId       := vbUserId
                                             ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 13.01.21         *
*/

-- ����
-- select * from gpInsertUpdate_Movement_OrderSale(ioId := 18775751 , ioInvNumber := '2' , ioOperDate := ('13.01.2021')::TDateTime , inOperDate_top := ('31.01.2021')::TDateTime , inPartnerId := 4126219 , inTotalCountKg := 222 , inTotalSumm := 22222 , inComment := '' ,  inSession := '5');
