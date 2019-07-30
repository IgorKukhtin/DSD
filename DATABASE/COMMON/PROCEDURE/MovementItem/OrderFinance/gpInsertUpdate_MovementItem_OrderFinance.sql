-- Function: gpInsertUpdate_MovementItem_OrderFinance()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_OrderFinance (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_OrderFinance(
 INOUT ioId                    Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inJuridicalId           Integer   , -- 
    IN inContractId            Integer   , -- 
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

     -- ���������
     SELECT tmp.ioId
            INTO ioId
     FROM lpInsertUpdate_MovementItem_OrderFinance (ioId                  := ioId
                                                  , inMovementId          := inMovementId
                                                  , inJuridicalId         := inJuridicalId
                                                  , inContractId          := inContractId
                                                  , inAmount              := inAmount
                                                  , inComment             := inComment
                                                  , inUserId              := vbUserId
                                                   ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.07.19         *
*/

-- ����
--