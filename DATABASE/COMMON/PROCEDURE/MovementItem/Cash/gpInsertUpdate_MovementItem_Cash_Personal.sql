-- Function: gpInsertUpdate_MovementItem_Cash_Personal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalCash (Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Cash_Personal (Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Cash_Personal (Integer, Integer, Integer, TFloat, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Cash_Personal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- ����������
    IN inAmount              TFloat    , -- ����� � �������
 INOUT ioSummRemains         TFloat    , -- ������� � ������� 
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- ������ ����������
    IN inUnitId              Integer   , -- �������������
    IN inPositionId          Integer   , -- ���������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD AS  --Integer AS    --
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());
     
     ioSummRemains := ioSummRemains - inAmount;
     
     -- ���������
     SELECT tmp.ioId
       INTO ioId
     FROM lpInsertUpdate_MovementItem_Cash_Personal (ioId                   := ioId
                                                     , inMovementId         := inMovementId
                                                     , inPersonalId         := inPersonalId
                                                     , inAmount             := inAmount
                                                     , inComment            := inComment
                                                     , inInfoMoneyId        := inInfoMoneyId
                                                     , inUnitId             := inUnitId
                                                     , inPositionId         := inPositionId
                                                     , inUserId             := vbUserId
                                                      ) AS tmp;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.09.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Cash_Personal (ioId:= 0, inMovementId:= 258038 , inPersonalId:= 8473, inAmount:= 44, inSummService:= 20, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8426, inPositionId:=12431, inSession:= '2')

--select * from gpInsertUpdate_MovementItem_Cash_Personal(ioId := 11967862 , inMovementId := 1015917 , inPersonalId := 12627 , inAmount := 1000 , ioSummRemains := 12109.66 , inComment := '' , inInfoMoneyId := 273733 , inUnitId := 8386 , inPositionId := 12451 ,  inSession := '5');
