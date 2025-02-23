-- Function: gpInsertUpdate_MovementItem_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_TechnicalRediscount(Integer, Integer, Integer, TFloat, TFloat, TFloat, Integer, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_TechnicalRediscount(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPrice               TFloat    , --
    IN inRemains_Amount      TFloat    , --
    IN inCommentTRID         Integer   , -- �����������
    IN isExplanation         TVarChar  , -- ����������
    IN isComment             TVarChar  , -- ����������� 2
    IN inisDeferred          Boolean   , -- �������� � �����
   OUT outDiffSumm           TFloat    , --
   OUT outRemains_FactAmount TFloat    , --
   OUT outRemains_FactSumm   TFloat    , --
   OUT outDeficit            TFloat    , --
   OUT outDeficitSumm        TFloat    , --
   OUT outProficit           TFloat    , --
   OUT outProficitSumm       TFloat    , --
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementIncomeId Integer;
   DECLARE vbAmountIncome TFloat;
   DECLARE vbAmountOther TFloat;
   DECLARE vbOperDate TDateTime;
   DECLARE vbMISendId Integer;
   DECLARE vbCommentTRId Integer;
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_TechnicalRediscount());

     IF ROUND(COALESCE(inRemains_Amount, 0) + inAmount, 4) < 0
     THEN
       RAISE EXCEPTION '������.����������� ���������� �� ����� ���� ������ 0.';
     END IF;

     IF COALESCE(inAmount, 0) > 0 and COALESCE (inisDeferred, FALSE) = True
     THEN
       RAISE EXCEPTION '������. ������������� ������� <�������� � �����> ����� ������ ��� ���������.';
     END IF;
     
     IF EXISTS(SELECT 1 FROM MovementItemFloat
               WHERE MovementItemFloat.MovementItemId = ioId
                 AND MovementItemFloat.DescId = zc_MIFloat_MovementItemId())
     THEN

       SELECT MovementItemFloat.ValueData::Integer, MILinkObject_CommentTR.ObjectId
       INTO vbMISendId, vbCommentTRId
       FROM MovementItemFloat

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentTR
                                             ON MILinkObject_CommentTR.MovementItemId = MovementItemFloat.MovementItemId
                                            AND MILinkObject_CommentTR.DescId = zc_MILinkObject_CommentTR()

       WHERE MovementItemFloat.MovementItemId = ioId
                 AND MovementItemFloat.DescId = zc_MIFloat_MovementItemId();

       IF (COALESCE(inAmount, 0) <> COALESCE((SELECT MovementItem.Amount FROM MovementItem WHERE MovementItem.ID = ioId), 0) OR
           COALESCE(vbCommentTRId, 0) <> COALESCE(inCommentTRID, 0))
          AND NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
          AND vbUserId NOT IN (11263040, 8037524, 758920)
       THEN
         RAISE EXCEPTION '������.��������������� ���������� �� ������� �������������� �� ����������� �� ��� ���������.';
       END IF;
     END IF;

     IF EXISTS(SELECT 1 FROM MovementBoolean
               WHERE MovementBoolean.MovementId = inMovementId
                 AND MovementBoolean.DescId = zc_MovementBoolean_CorrectionSUN()
                 AND MovementBoolean.ValueData = TRUE)
        AND NOT EXISTS(SELECT 1 FROM MovementItemFloat
                       WHERE MovementItemFloat.MovementItemId = ioId
                         AND MovementItemFloat.DescId = zc_MIFloat_MovementItemId())
        AND COALESCE(inCommentTRID, 0) <> 13619611
     THEN
       RAISE EXCEPTION '������.� ����������� ��������� "��������� ���" ����� ��������� ������ ����� � ����������� "��������".';
     END IF;

/*     SELECT Movement.OperDate
     INTO vbOperDate
     FROM Movement
     WHERE Movement.ID = inMovementId;

     IF date_part('DAY',  vbOperDate)::Integer <= 15
     THEN
         vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '14 DAY';
     ELSE
         vbOperDate := date_trunc('month', vbOperDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY';
     END IF;

     -- ��� ���� "������" ��������� ������
     IF EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
               WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
        AND  vbOperDate < CURRENT_DATE
     THEN
         RAISE EXCEPTION '������. �� ��������� ����������� �������������� ����� ���� ������������� ��� �������� �����.';
     END IF;
*/
     IF COALESCE(inCommentTRID, 0) = 0
     THEN
         RAISE EXCEPTION '������. �� ������ <����������� � ������ ������������ ���������>.';
     END IF;

     IF COALESCE(isExplanation, '') = '' AND EXISTS (SELECT 1 FROM ObjectBoolean
                                                     WHERE ObjectBoolean.ObjectId = inCommentTRID
                                                       AND ObjectBoolean.DescId = zc_ObjectBoolean_CommentTR_Explanation()
                                                       AND ObjectBoolean.ValueData = TRUE)
     THEN
         IF EXISTS (SELECT 1 FROM ObjectBoolean
                    WHERE ObjectBoolean.ObjectId = inCommentTRID
                      AND ObjectBoolean.DescId = zc_ObjectBoolean_CommentTR_Resort()
                      AND ObjectBoolean.ValueData = TRUE)
         THEN
             RAISE EXCEPTION '������. ���������� ����� ��������� � ������� "���������" �� ������� � ��������� (1,2,3 � ��).';
         ELSE
             RAISE EXCEPTION '������. �� ��������� <���������>.';
         END IF;
     END IF;

     -- ��������� <�������� � �����>
     IF COALESCE (inisDeferred, False) = TRUE OR EXISTS (SELECT 1 FROM MovementItemBoolean 
                                                         WHERE MovementItemBoolean.DescId = zc_MIBoolean_Deferred() AND MovementItemBoolean.MovementItemId = ioId)
     THEN
       PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Deferred(), ioId, inisDeferred);
     END IF;

     ioId := lpInsertUpdate_MovementItem_TechnicalRediscount(ioId, inMovementId, inGoodsId, inAmount, inCommentTRID, isExplanation, isComment, inisDeferred, vbUserId);

     outDiffSumm           := inAmount * inPrice;
     outRemains_FactAmount := inRemains_Amount + inAmount;
     outRemains_FactSumm   := (inRemains_Amount + inAmount) * inPrice;
     outDeficit            := CASE WHEN inAmount < 0 THEN - inAmount ELSE 0 END;
     outDeficitSumm        := CASE WHEN inAmount < 0 THEN - inAmount * inPrice ELSE 0 END;
     outProficit           := CASE WHEN inAmount > 0 THEN inAmount ELSE 0 END;
     outProficitSumm       := CASE WHEN inAmount > 0 THEN inAmount * inPrice ELSE 0 END;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 10.02.15                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_TechnicalRediscount (ioId:= 0, inMovementId:= 10, inGoodsId:= 1, inAmount:= 0, inHeadCount:= 0, inPartionGoods:= '', inGoodsKindId:= 0, inSession:= '2')