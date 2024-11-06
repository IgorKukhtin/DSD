-- Function: gpInsertUpdate_Movement_PromoTradeCondition()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTradeCondition (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoTradeCondition(
    IN inMovementId            Integer    , -- ���� ������� <�������� ����� ���������>
    IN inOrd                   Integer    , -- ����� ������, �� ��� ��������� ����� ��������
    IN inValue                 TVarChar   , -- �������� 
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementId_PromoTradeCondition Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());

    --�������� ������ �� ����� �� ��������������
    IF inOrd <= 3
    THEN 
      RAISE EXCEPTION '������. ��������� �������� �� ��������, � ������� �� ��������.';
    END IF;


    vbMovementId_PromoTradeCondition := (SELECT Movement.Id
                                         FROM Movement
                                         WHERE Movement.DescId = zc_Movement_PromoTradeCondition()
                                           AND Movement.ParentId =  inMovementId
                                         );

    IF COALESCE (vbMovementId_PromoTradeCondition,0) = 0 
    THEN
        --������� ��������
        SELECT lpInsertUpdate_Movement (0, zc_Movement_PromoTradeCondition(), Movement.InvNumber, Movement.OperDate, Movement.Id, 0) 
      INTO vbMovementId_PromoTradeCondition
        FROM Movement
        WHERE Movement.Id = inMovementId;
    END IF;
    

    IF inOrd = 4
    THEN 
        --������
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --RetroBonus
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_RetroBonus(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;

    IF inOrd = 5
    THEN 
        --������
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --Market
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Market(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;
    
    IF inOrd = 6
    THEN 
        --������
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --ReturnIn
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ReturnIn(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;
    
    IF inOrd = 7
    THEN 
        --������
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --Logist
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Logist(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;

    IF inOrd = 8
    THEN 
        --������
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --Logist
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Report(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;   

    IF inOrd = 9
    THEN 
        --������
        inValue:= REPLACE (TRIM (inValue), ',', '.');
        --Logist
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MarketSumm(), vbMovementId_PromoTradeCondition, zfConvert_StringToFloat(inValue)::TFloat);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.08.24         *
*/