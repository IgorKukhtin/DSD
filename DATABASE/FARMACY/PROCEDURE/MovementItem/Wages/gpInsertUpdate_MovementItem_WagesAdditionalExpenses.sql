-- Function: gpInsertUpdate_MovementItem_WagesAdditionalExpenses()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_WagesAdditionalExpenses(Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_WagesAdditionalExpenses(
 INOUT ioId                       Integer   , -- ���� ������� <������� ���������>
    IN inMovementId               Integer   , -- ���� ������� <��������>
    IN inUnitID                   Integer   , -- �������������
    IN inSummaCleaning            TFloat    , -- ������
    IN inSummaSP                  TFloat    , -- ��
    IN inSummaOther               TFloat    , -- ������
    IN inSummaValidationResults   TFloat    , -- ���������� ��������
    IN inSummaIntentionalPeresort TFloat    , -- ����� �� ���������� ��������
    IN inSummaFullChargeFact      TFloat    , -- ������ �������� ����
    IN inSummaIC                  TFloat    , -- ����� �� ������� ��������� ���������
    IN inisIssuedBy               Boolean   , -- ������
    IN inComment                  TVarChar  , -- ����������
   OUT outSummaTotal              TFloat    , -- �����
   OUT outSummaFullChargeFact     TFloat    , -- ������ �������� ����
   OUT outSummaMoneyBoxUsed       TFloat    , -- ������������ �� ��������
   OUT outSummaMoneyBoxResidual   TFloat    , -- ������� �� �������
    IN inSession                  TVarChar    -- ������ ������������
)
RETURNS Record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   
   DECLARE vbSummaCleaning            TFloat;
   DECLARE vbSummaSP                  TFloat;
   DECLARE vbSummaOther               TFloat;
   DECLARE vbSummaValidationResults   TFloat;
   DECLARE vbSummaIntentionalPeresort TFloat;
   DECLARE vbSummaFullChargeFact      TFloat;
   DECLARE vbSummaIC                  TFloat;
   DECLARE vbisIssuedBy               Boolean;
   DECLARE vbComment                  TVarChar;
   
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());
    vbUserId:= lpGetUserBySession (inSession);

    -- ���������� <������>
    vbStatusId := (SELECT StatusId FROM Movement WHERE Id = inMovementId);
    -- �������� - �����������/��������� ��������� �������� ������
    IF vbStatusId <> zc_Enum_Status_UnComplete()
    THEN
        RAISE EXCEPTION '������.��������� ��������� � ������� <%> �� ��������.', lfGet_Object_ValueData (vbStatusId);
    END IF;
    
    IF inSummaFullChargeFact = 1.0
    THEN
        inSummaFullChargeFact :=  COALESCE((SELECT SUM(MovementItemFloat.ValueData)
                                            FROM MovementItemFloat
                                            WHERE MovementItemFloat.MovementItemId = ioId
                                              AND MovementItemFloat.DescId in (zc_MIFloat_SummaFullChargeMonth(), zc_MIFloat_SummaFullCharge())), 0);
    ELSEIF inSummaFullChargeFact > 0
    THEN
        RAISE EXCEPTION '������.����� ������� �������� ���� ������ ���� ������ ��� ����� 0';
    END IF;

    IF COALESCE (ioId, 0) = 0
    THEN
      
      IF EXISTS(SELECT 1  FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUnitID
                  AND MovementItem.DescId = zc_MI_Sign())
      THEN
        SELECT MovementItem.ID
        INTO ioId
        FROM MovementItem
        WHERE MovementItem.MovementID = inMovementId
          AND MovementItem.ObjectID = inUnitID
          AND MovementItem.DescId = zc_MI_Sign();
      END IF;

      vbSummaCleaning            := 0;
      vbSummaSP                  := 0;
      vbSummaOther               := 0;
      vbSummaValidationResults   := 0;
      vbSummaIntentionalPeresort := 0;
      vbSummaFullChargeFact      := 0;
      vbSummaIC                  := 0;
      vbisIssuedBy               := False;
      vbComment                  := 0;
    ELSE
      IF EXISTS(SELECT 1 FROM MovementItem
                WHERE MovementItem.MovementID = inMovementId
                  AND MovementItem.ObjectID = inUnitID
                  AND MovementItem.ID <> ioId
                  AND MovementItem.DescId = zc_MI_Sign())
      THEN
        RAISE EXCEPTION '������. ������������ ������������� ���������.';
      END IF;
      
      SELECT 
             COALESCE (MIFloat_SummaCleaning.ValueData, 0),
             COALESCE (MIFloat_SummaSP.ValueData, 0),
             COALESCE (MIFloat_SummaOther.ValueData, 0),
             COALESCE (MIFloat_ValidationResults.ValueData, 0),
             COALESCE (MIFloat_IntentionalPeresort.ValueData, 0),
             COALESCE (MIFloat_SummaFullChargeFact.ValueData, COALESCE(MIFloat_SummaFullCharge.ValueData, 0) + 
                                                              COALESCE(MIFloat_SummaFullChargeMonth.ValueData, 0)),
             COALESCE (MIFloat_SummaIC.ValueData, 0),
             COALESCE (MIB_isIssuedBy.ValueData, FALSE),
             COALESCE (MIS_Comment.ValueData, '')
      INTO vbSummaCleaning,
           vbSummaSP,
           vbSummaOther,
           vbSummaValidationResults,
           vbSummaIntentionalPeresort,
           vbSummaFullChargeFact,
           vbSummaIC,
           vbisIssuedBy,
           vbComment  
      FROM  MovementItem

            LEFT JOIN MovementItemFloat AS MIFloat_SummaCleaning
                                        ON MIFloat_SummaCleaning.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummaCleaning.DescId = zc_MIFloat_SummaCleaning()

            LEFT JOIN MovementItemFloat AS MIFloat_SummaSP
                                        ON MIFloat_SummaSP.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummaSP.DescId = zc_MIFloat_SummaSP()

            LEFT JOIN MovementItemFloat AS MIFloat_SummaOther
                                        ON MIFloat_SummaOther.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummaOther.DescId = zc_MIFloat_SummaOther()

            LEFT JOIN MovementItemFloat AS MIFloat_ValidationResults
                                        ON MIFloat_ValidationResults.MovementItemId = MovementItem.Id
                                       AND MIFloat_ValidationResults.DescId = zc_MIFloat_ValidationResults()
            LEFT JOIN MovementItemFloat AS MIFloat_IntentionalPeresort
                                        ON MIFloat_IntentionalPeresort.MovementItemId = MovementItem.Id
                                       AND MIFloat_IntentionalPeresort.DescId = zc_MIFloat_IntentionalPeresort()

            LEFT JOIN MovementItemFloat AS MIFloat_SummaFullChargeMonth
                                        ON MIFloat_SummaFullChargeMonth.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummaFullChargeMonth.DescId = zc_MIFloat_SummaFullChargeMonth()
            LEFT JOIN MovementItemFloat AS MIFloat_SummaFullCharge
                                        ON MIFloat_SummaFullCharge.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummaFullCharge.DescId = zc_MIFloat_SummaFullCharge()
            LEFT JOIN MovementItemFloat AS MIFloat_SummaFullChargeFact
                                        ON MIFloat_SummaFullChargeFact.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummaFullChargeFact.DescId = zc_MIFloat_SummaFullChargeFact()

            LEFT JOIN MovementItemFloat AS MIFloat_SummaIC
                                        ON MIFloat_SummaIC.MovementItemId = MovementItem.Id
                                       AND MIFloat_SummaIC.DescId = zc_MIFloat_SummaIC()

            LEFT JOIN MovementItemBoolean AS MIB_isIssuedBy
                                          ON MIB_isIssuedBy.MovementItemId = MovementItem.Id
                                         AND MIB_isIssuedBy.DescId = zc_MIBoolean_isIssuedBy()

            LEFT JOIN MovementItemString AS MIS_Comment
                                         ON MIS_Comment.MovementItemId = MovementItem.Id
                                        AND MIS_Comment.DescId = zc_MIString_Comment()

      WHERE MovementItem.Id = ioId;
            
      IF vbisIssuedBy = True
         AND (vbSummaCleaning <> COALESCE (inSummaCleaning, 0)
           OR vbSummaSP <> COALESCE (inSummaSP, 0)
           OR vbSummaOther <>  COALESCE (inSummaOther, 0)
           OR vbSummaValidationResults <>  COALESCE (inSummaValidationResults, 0)
           OR vbSummaIntentionalPeresort <>  COALESCE (inSummaIntentionalPeresort, 0)
           OR vbSummaFullChargeFact <> COALESCE (inSummaFullChargeFact, 0)
           OR vbSummaIC <> COALESCE (inSummaIC, 0))
         AND COALESCE (inisIssuedBy, FALSE) = TRUE
      THEN
        RAISE EXCEPTION '������. �������������� ������� ������. ��������� ���� ���������.';            
      END IF;
      
      IF EXISTS( SELECT 1
        FROM  MovementItem

              LEFT JOIN MovementItemFloat AS MIFloat_SummaFullChargeMonth
                                          ON MIFloat_SummaFullChargeMonth.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaFullChargeMonth.DescId = zc_MIFloat_SummaFullChargeMonth()
              LEFT JOIN MovementItemFloat AS MIFloat_SummaFullCharge
                                          ON MIFloat_SummaFullCharge.MovementItemId = MovementItem.Id
                                         AND MIFloat_SummaFullCharge.DescId = zc_MIFloat_SummaFullCharge()

        WHERE MovementItem.Id = ioId 
          AND COALESCE(inSummaFullChargeFact, 0)::TFloat < (COALESCE(MIFloat_SummaFullCharge.ValueData, 0) + COALESCE(MIFloat_SummaFullChargeMonth.ValueData, 0))::TFloat)
      THEN
        RAISE EXCEPTION '������. ����� ������� �������� ���� ������ ������ ����� ������� ��������.';            
      END IF;
      
    END IF;

    IF vbSummaCleaning <> COALESCE (inSummaCleaning, 0)
    OR vbSummaSP <> COALESCE (inSummaSP, 0)
    OR vbSummaOther <>  COALESCE (inSummaOther, 0)
    OR vbSummaValidationResults <>  COALESCE (inSummaValidationResults, 0)
    OR vbSummaIntentionalPeresort <>  COALESCE (inSummaIntentionalPeresort, 0) AND (vbUserId <> 11263040)
    OR vbSummaFullChargeFact <> COALESCE (inSummaFullChargeFact, 0)
    OR vbSummaIC <> COALESCE (inSummaIC, 0)
    THEN
      PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Wages());
    END IF;

    -- ���������
    ioId := lpInsertUpdate_MovementItem_WagesAdditionalExpenses (ioId                       := ioId                  -- ���� ������� <������� ���������>
                                                               , inMovementId               := inMovementId          -- ���� ���������
                                                               , inUnitID                   := inUnitID              -- �������������
                                                               , inSummaCleaning            := inSummaCleaning       -- ������
                                                               , inSummaSP                  := inSummaSP             -- ��
                                                               , inSummaOther               := inSummaOther          -- ������
                                                               , inSummaValidationResults   := inSummaValidationResults   -- ���������� ��������
                                                               , inSummaIntentionalPeresort := inSummaIntentionalPeresort -- ����� �� ���������� ��������
                                                               , inSummaFullChargeFact      := inSummaFullChargeFact -- ������ �������� ���� 
                                                               , inSummaIC                  := inSummaIC             -- ����� �� ������� ��������� ��������� 
                                                               , inisIssuedBy               := inisIssuedBy          -- ������
                                                               , inComment                  := inComment             -- ����������
                                                               , inUserId                   := vbUserId              -- ������������
                                                                 );

   outSummaTotal := COALESCE((SELECT Amount FROM MovementItem WHERE MovementItem.ID = ioId), 0);
   outSummaFullChargeFact := COALESCE((SELECT ValueData FROM MovementItemFloat WHERE DescID = zc_MIFloat_SummaFullChargeFact() AND MovementItemID = ioId), 0);
   outSummaMoneyBoxUsed := COALESCE((SELECT ValueData FROM MovementItemFloat WHERE DescID = zc_MIFloat_SummaMoneyBoxUsed() AND MovementItemID = ioId), 0);
   outSummaMoneyBoxResidual := COALESCE((SELECT Sum(ValueData) FROM MovementItemFloat WHERE DescID IN (zc_MIFloat_SummaMoneyBox(), zc_MIFloat_SummaMoneyBoxMonth()) AND MovementItemID = ioId), 0)
                             - COALESCE((SELECT ValueData FROM MovementItemFloat WHERE DescID = zc_MIFloat_SummaMoneyBoxUsed() AND MovementItemID = ioId), 0);
   IF outSummaMoneyBoxResidual < 0 THEN outSummaMoneyBoxResidual := 0; END IF;
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
                ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.10.19                                                        *
 01.09.19                                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_MovementItem_WagesAdditionalExpenses (, inSession:= '2')

--select * from gpInsertUpdate_MovementItem_WagesAdditionalExpenses(ioId := 381370414 , inMovementId := 19723487 , inUnitID := 1781716 , inSummaCleaning := 2000 , inSummaSP := 28.27 , inSummaOther := 0 , inSummaValidationResults := 0 , inSummaFullChargeFact := 0 , inisIssuedBy := 'False' , inComment := '' ,  inSession := '3');