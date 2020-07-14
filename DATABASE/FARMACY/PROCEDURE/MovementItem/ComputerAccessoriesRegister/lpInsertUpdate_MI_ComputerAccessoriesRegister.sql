-- Function: lpInsertUpdate_MI_ComputerAccessoriesRegister()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_ComputerAccessoriesRegister (Integer, Integer, Integer, TFloat, TDateTime, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_ComputerAccessoriesRegister(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inComputerAccessoriesId Integer   , -- ������������ ���������
    IN inAmount                TFloat    , -- ����������
    IN inReplacementDate       TDateTime , -- ���� ������ 
    IN inComment               TVarChar  , -- �����������
    IN inUserId                Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;

          
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inComputerAccessoriesId, inMovementId, inAmount, NULL);
 
     -- ��������� <�������������>
     PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_ReplacementDate(), ioId, inReplacementDate);

     -- ��������� <�����������>
     PERFORM lpInsertUpdate_MovementString (zc_MIString_Comment(), ioId, inComment);
      
     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_ComputerAccessoriesRegister_TotalSumm (inMovementId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 14.07.20                                                                      * 
 */

-- ����
-- SELECT * FROM lpInsertUpdate_MI_ComputerAccessoriesRegister (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inSession:= '3')
