-- Function: lpInsertUpdate_Movement_OrderGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderGoodsDetail (Integer, Integer, TDateTime, TDateTime, TDateTime, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderGoodsDetail(
 INOUT ioId                  Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ���� ��������� OrderGoods
    IN inOperDate            TDateTime , -- ���� ���������
    IN inOperDateStart       TDateTime , -- 
    IN inOperDateEnd         TDateTime , -- 
    IN inUserId              Integer     -- ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN

     -- ���������� ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

     -- !!! 5 ������  �� ���������� ��� ���� ������.!!!
     vbStartDate := (DATE_TRUNC ('MONTH',inOperDate) - ((5 * 7) :: TVarChar || ' DAY') :: INTERVAL) ::TDateTime;
     vbEndDate   := (DATE_TRUNC ('MONTH',inOperDate) - INTERVAL '1 DAY')  ::TDateTime;

     -- ��������
     IF (inOperDateStart + (((5 * 7 - 1) :: Integer) :: TVarChar || ' DAY') :: INTERVAL) <> inOperDateEnd
     THEN
         RAISE EXCEPTION '������ � <%> �� <%> ������ ���� ������ 5 ������. ( c <%> �� <%>)'
                                                                                          , zfConvert_DateToString (inOperDateStart)
                                                                                          , zfConvert_DateToString (inOperDateEnd)
                                                                                          , zfConvert_DateToString (vbStartDate)
                                                                                          , zfConvert_DateToString (vbEndDate)
                        ;
         -- '��������� �������� ����� 3 ���.'
     END IF;


     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement (ioId
                                    , zc_Movement_OrderGoodsDetail()
                                    , '*' || COALESCE ((SELECT Movement.InvNumber FROM Movement WHERE Movement.Id = inParentId), '')
                                    , inOperDate
                                    , inParentId
                                     );

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);


     -- ��������� ��������
     --PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.09.21         *
*/

-- ����
-- 