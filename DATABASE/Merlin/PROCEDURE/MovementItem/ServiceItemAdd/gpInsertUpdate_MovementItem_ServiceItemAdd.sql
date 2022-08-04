-- Function: gpInsertUpdate_MovementItem_ServiceItemAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ServiceItemAdd (Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);
 
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ServiceItemAdd(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inUnitId              Integer   , -- ����� 
    IN inInfoMoneyId         Integer   , -- 
    IN inCommentInfoMoneyId  Integer   , -- 
 INOUT ioNumStartDate        Integer , --
 INOUT ioNumEndDate          Integer , -- 
 INOUT ioNumYearStart        Integer , --
 INOUT ioNumYearEnd          Integer , -- 
    IN inAmount              TFloat    , --  
   OUT outDateStart          TDateTime , --
   OUT outDateEnd            TDateTime , --
   OUT outMonthNameStart     TDateTime
   OUT outMonthNameEnd       TDateTime
    IN inSession             TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean; 
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ServiceItemAdd());

     -- ���� ���������
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);
     
     -- �������� - �������� ������ ���� ��������
     IF COALESCE (ioNumYearStart, 0) > 100 OR COALESCE (ioNumYearStart, 0) < 10 THEN
        RAISE EXCEPTION '������.�������� <��� �...> �� �������� � �������� ������������ �����.';
     END IF;
     -- �������� - �������� ������ ���� ��������
     IF COALESCE (ioNumYearEnd, 0) > 100 OR COALESCE (ioNumYearEnd, 0) < 10 THEN
        RAISE EXCEPTION '������.�������� <��� ��...> �� �������� � �������� ������������ �����.';
     END IF;


     --���� �� ����� ���������� ��� �����
     IF COALESCE (ioNumStartDate,0) = 0
     THEN 
         ioNumStartDate := EXTRACT (MONTH FROM vbOperDate);
     END IF;
     IF COALESCE (ioNumEndDate,0) = 0
     THEN 
         ioNumEndDate := EXTRACT (MONTH FROM vbOperDate);
     END IF;     

     IF COALESCE (ioNumYearStart,0) = 0
     THEN 
         ioNumYearStart := EXTRACT (YEAR FROM vbOperDate);
     END IF;
     IF COALESCE (ioNumYearEnd,0) = 0
     THEN 
         ioNumYearEnd := EXTRACT (YEAR FROM vbOperDate);
     END IF;
        
     IF (ioNumStartDate > ioNumEndDate) AND (ioNumYearStart = ioNumYearEnd)          -- outDateStart �� ����� �� ���� ����� outEndDate
     THEN 
         ioNumYearEnd := ioNumYearStart +1;
     END IF;

     outDateStart:= ('01.'||ioNumStartDate||'.'||(2000 + ioNumYearStart)) ::TDateTime;
     outDateEnd  := ((('01.'||ioNumEndDate||'.'||(2000 + ioNumYearEnd)) ::TDateTime) + INTERVAL '1 MONTH' -  INTERVAL '1 Day');
     
     outMonthNameStart:= outDateStart;
     outMonthNameEnd  := outDateEnd;
     
     ioId:= lpInsertUpdate_MovementItem_ServiceItemAdd (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inUnitId             := inUnitId
                                                      , inInfoMoneyId        := inInfoMoneyId
                                                      , inCommentInfoMoneyId := inCommentInfoMoneyId
                                                      , inDateStart          := outDateStart  
                                                      , inDateEnd            := outDateEnd
                                                      , inAmount             := inAmount
                                                      , inUserId             := vbUserId
                                                       );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.08.22         *
*/

-- ����
--