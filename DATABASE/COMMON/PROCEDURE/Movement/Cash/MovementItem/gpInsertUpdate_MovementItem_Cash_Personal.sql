-- Function: gpInsertUpdate_MovementItem_Cash_Personal()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Cash_Personal (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Cash_Personal (Integer, Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Cash_Personal(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inMovementId_Parent   Integer   , -- ���� ������� <��������>
    IN inPersonalId          Integer   , -- ����������
    IN inAmount              TFloat    , -- �����
   OUT outSummRemains        TFloat    , -- ������� � ������� 
    IN inComment             TVarChar  , -- 
    IN inInfoMoneyId         Integer   , -- ������ ����������
    IN inUnitId              Integer   , -- �������������
    IN inPositionId          Integer   , -- ���������
    IN inIsCalculated        Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Cash());

     -- ��������
     IF inAmount < 0 AND 1=0
     THEN
        RAISE EXCEPTION '������.��� <%> ����� ������� <%> �� ����� ���� �������������.', lfGet_Object_ValueData (inPersonalId), zfConvert_FloatToString (inAmount);
     END IF;


     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Cash_Personal (ioId                 := ioId
                                                     , inMovementId         := inMovementId
                                                     , inPersonalId         := inPersonalId
                                                     , inAmount             := inAmount
                                                     , inComment            := inComment
                                                     , inInfoMoneyId        := inInfoMoneyId
                                                     , inUnitId             := inUnitId
                                                     , inPositionId         := inPositionId
                                                     , inIsCalculated       := CASE WHEN inAmount < 0 THEN TRUE ELSE inIsCalculated END
                                                     , inUserId             := vbUserId
                                                      );
     -- ������� <������� � �������>
     outSummRemains:= (SELECT tmp.SummRemains
                       FROM gpSelect_MovementItem_Cash_Personal (inMovementId     := inMovementId
                                                               , inParentId       := inMovementId_Parent
                                                               , inMovementItemId := ioId
                                                               , inShowAll        := FALSE
                                                               , inIsErased       := FALSE
                                                               , inSession        := inSession
                                                                )  AS tmp
                      );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.04.15                                        * all
 16.09.14         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_Cash_Personal (ioId:= 0, inMovementId:= 258038 , inPersonalId:= 8473, inAmount:= 44, inSummService:= 20, inComment:= 'inComment', inInfoMoneyId:= 8994, inUnitId:= 8426, inPositionId:=12431, inSession:= '2')
