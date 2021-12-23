 -- Function: gpInsertUpdate_MovementItem_Check_VIPforSales()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Check_VIPforSales (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Check_VIPforSales(
    IN inUnitId              Integer   , -- �������������
    IN inGoodsId             Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbId         Integer;
   DECLARE vbMovementId Integer;
   DECLARE vbAmount     TFloat;  
   DECLARE vbUnitId     Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
    vbUserId := lpGetUserBySession (inSession);
 
    IF COALESCE (inAmount, 0) = 0
    THEN
      RETURN;
    END IF;
    
    SELECT MovementBoolean_AutoVIPforSales.MovementId
    INTO vbMovementId
    FROM MovementBoolean AS MovementBoolean_AutoVIPforSales
                              
         INNER JOIN Movement ON Movement.ID = MovementBoolean_AutoVIPforSales.MovementId
                            AND Movement.DescId = zc_Movement_Check()
                            AND Movement.StatusId = zc_Enum_Status_UnComplete()
                             AND Movement.OperDate >= DATE_TRUNC ('MONTH', CURRENT_DATE)

         INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                       ON MovementLinkObject_Unit.MovementId = Movement.Id
                                      AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()  
                                      AND MovementLinkObject_Unit.ObjectId = inUnitId
                                                                                       
    WHERE MovementBoolean_AutoVIPforSales.DescId = zc_MovementBoolean_AutoVIPforSales();    
    
    IF COALESCE (vbMovementId, 0) = 0
    THEN
      IF inAmount < 0 
      THEN
        RAISE EXCEPTION '������. �� ������ �� ������ ��� ��� ��� ������� ��� �������.';
      ELSE
        RETURN;
      END IF;
    END IF;

    -- ������� ������� �� ��������� � ������
    SELECT MovementItem.Id, MovementItem.Amount
    INTO vbId, vbAmount
    FROM MovementItem
    WHERE MovementItem.MovementId = vbMovementId
      AND MovementItem.ObjectId   = inGoodsId
      AND MovementItem.DescId     = zc_MI_Master()
      AND MovementItem.isErased   = FALSE
    LIMIT 1;

    IF COALESCE (vbId, 0) = 0
    THEN
      IF inAmount < 0 
      THEN
        RAISE EXCEPTION '������. B ��� ���� ��� ������� ��� ������� �� ������ ����� % - %.',
          (SELECT OBJECT.ObjectCode FROM OBJECT WHERE OBJECT.Id = inGoodsId),
          (SELECT OBJECT.ValueData FROM OBJECT WHERE OBJECT.Id = inGoodsId);
      ELSE
        RETURN;
      END IF;
    END IF;

    IF vbAmount + inAmount < 0
    THEN
      RAISE EXCEPTION '������. B ��� ���� ��� ������� ��� ������� ��� ������% % - %.%��������������� %, �� ���������� %', Chr(13)||Chr(13),
        (SELECT OBJECT.ObjectCode FROM OBJECT WHERE OBJECT.Id = inGoodsId),
        (SELECT OBJECT.ValueData FROM OBJECT WHERE OBJECT.Id = inGoodsId),
        Chr(13)||Chr(13), vbAmount, Abs(inAmount);
    END IF;      

    -- ��������� <������� ���������>
    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Master(), inGoodsId, vbMovementId, vbAmount + inAmount, NULL);


    -- ����������� �������� �����
    PERFORM lpInsertUpdate_MovementFloat_TotalSummCheck (vbMovementId);

    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, False);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Check_VIPforSales (Integer, Integer, TFloat, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 23.12.21                                                       *
*/