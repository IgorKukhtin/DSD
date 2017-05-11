-- Function: gpInsertUpdate_MovementItem_Sale_Child()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Sale_Child (Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Sale_Child(
 INOUT ioId                   Integer   , -- ���� ������� <������� ���������>
    IN inMovementId            Integer   , -- ���� ������� <��������>
    IN inParentId              Integer   , -- ����
   -- IN inCurrencyId            Integer   , -- ������
    IN inAmount_GRN            TFloat    , -- ����� ������
    IN inAmount_DOL            TFloat    , -- ����� ������
    IN inAmount_EUR            TFloat    , -- ����� ������
    IN inAmount_Bank           TFloat    , -- ����� ������
    IN inSummChangePercent     TFloat    , -- ����� ������
   OUT outCurrencyValue         TFloat    , -- 
   OUT outParValue              TFloat    , -- 
    IN inSession               TVarChar    -- ������ ������������
)                              
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCashId_Exc Integer;
   DECLARE vbCashId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbCurrencyId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Sale());

     -- �������� - �������� ������ ���� ��������
     /*IF COALESCE (inMovementId, 0) = 0 THEN
        RAISE EXCEPTION '������.�������� �� ��������.';
     END IF;*/
    
     SELECT Movement.OperDate 
          , MovementLinkObject_From.ObjectId
    INTO vbOperDate, vbUnitId
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
     WHERE Movement.Id = inMovementId;

    CREATE TEMP TABLE _tmpPay (CurrencyId Integer, Amount TFloat) ON COMMIT DROP;
      INSERT INTO _tmpPay (CurrencyId, Amount)
            SELECT zc_Currency_GRN(), COALESCE(inAmount_GRN,0)
          UNION
            SELECT zc_Currency_DOL(), COALESCE(inAmount_DOL,0)
          UNION
            SELECT zc_Currency_EUR(), COALESCE(inAmount_EUR,0);
   

    CREATE TEMP TABLE _tmpCash (CashId Integer, CurrencyId Integer, Amount TFloat) ON COMMIT DROP;
      INSERT INTO _tmpCash (CashId, CurrencyId , Amount)
            SELECT tmp.CashId
                 , _tmpPay.CurrencyId
                 , _tmpPay.Amount
            FROM _tmpPay
                 LEFT JOIN (SELECT Object_Cash.Id               AS CashId
                                 , ObjectLink_Cash_Currency.ChildObjectId AS CurrencyId
                            FROM Object As Object_Cash
                              INNER JOIN ObjectLink AS ObjectLink_Cash_Unit
                                      ON ObjectLink_Cash_Unit.ObjectId = Object_Cash.Id
                                     AND ObjectLink_Cash_Unit.DescId = zc_ObjectLink_Cash_Unit()
                                     AND ObjectLink_Cash_Unit.ChildObjectId = inUnitId
                              LEFT JOIN ObjectLink AS ObjectLink_Cash_Currency
                                     ON ObjectLink_Cash_Currency.ObjectId = Object_Cash.Id
                                    AND ObjectLink_Cash_Currency.DescId = zc_ObjectLink_Cash_Currency()
                            WHERE Object_Cash.DescId = zc_Object_Cash()
                              AND Object_Cash.isErased = FALSE
                            ) AS tmp ON tmp.CurrencyId = _tmpPay.CurrencyId
            WHERE _tmpPay.Amount <> 0 ;
     
     outCurrencyValue := 1;
     outParValue := 0;

     -- ���������
     ioId:= lpInsertUpdate_MovementItem_Sale_Child
                                               (ioId                 := ioId
                                              , inMovementId         := inMovementId
                                              , inParentId           := inParentId
                                              , inGoodsId            := _tmpCash.CashId
                                              , inPartionId          := Null
                                              , inCurrencyId         := _tmpCash.CurrencyId
                                              , inCashId_Exc         := Null
                                              , inAmount             := _tmpCash.Amount
                                              , inCurrencyValue      := outCurrencyValue 
                                              , inParValue           := outParValue 
                                              , inUserId             := vbUserId
                                               )
      FROM _tmpCash;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 11.05.17         *
*/

-- ����
-- select * from gpInsertUpdate_MovementItem_Sale_Child(ioId := 0 , inMovementId := 8 , inGoodsId := 446 , inPartionId := 50 , inAmount := 4 , outOperPrice := 100 , ioCountForPrice := 1 ,  inSession := '2');