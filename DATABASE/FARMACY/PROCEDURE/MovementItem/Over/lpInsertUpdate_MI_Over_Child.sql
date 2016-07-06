 -- Function: lpInsertUpdate_MI_Over_Child()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_Over_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TDateTime, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_Over_Child(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inParentId            Integer   , -- ������� ������� ���������
    IN inUnitId              Integer   , -- 
    IN inAmount              TFloat    , -- ����������
    IN inRemains	     TFloat    , -- 
    IN inPrice	             TFloat    , -- 
    IN inMCS                 TFloat    , -- 
    IN inMinExpirationDate   TDateTime , -- 
    IN inComment             TVarChar  , --  
    IN inUserId              Integer     -- ������������
)                              
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
 
   -- ��������
   IF COALESCE (inUnitId, 0) = 0
   THEN 
       RAISE EXCEPTION '������.�� ���������� �������� ��������� <�������������>.';
   END IF;

   -- ��������
   IF COALESCE (inParentId, 0) = 0
   THEN
       RAISE EXCEPTION '������.�� �������� ������� �������.';
   END IF;

   -- ������������ ������� ��������/�������������
   vbIsInsert:= COALESCE (ioId, 0) = 0;
 
   -- ��������� <������� ���������>
   ioId := lpInsertUpdate_MovementItem (ioId           := ioId
                                      , inDescId       := zc_MI_Child()
                                      , inObjectId     := inUnitId
                                      , inMovementId   := inMovementId
                                      , inAmount       := inAmount
                                      , inParentId     := inParentId
                                      , inUserId       := inUserId
                                       );
  
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_MinExpirationDate(), ioId, inMinExpirationDate);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Price(), ioId, inPrice);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_MCS(), ioId, inMCS);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_MovementItemFloat(zc_MIFloat_Remains(), ioId, inRemains);

  
   -- ����������� �������� ����� �� ���������
   PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.07.16         *
 
*/

-- ����
-- 