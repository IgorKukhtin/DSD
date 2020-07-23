-- Function: gpInsert_MovementItem_Loyalty_PromoCodeScales()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Loyalty_PromoCodeScales (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_Loyalty_PromoCodeScales(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inCount               Integer   , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
   DECLARE vbId Integer;
   DECLARE vbisElectron Boolean;
   DECLARE vbCount Integer;
   DECLARE vbOrder Integer;
   DECLARE vbCountLine Integer;
BEGIN

      -- �������� ���� ������������ �� ����� ���������
      -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Income());
    vbUserId:= lpGetUserBySession (inSession);

    IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId = zc_Enum_Role_Admin())
    THEN
      RAISE EXCEPTION '��������� �������� ��� ���������, ���������� � ���������� ��������������';
    END IF;

    SELECT COALESCE(MovementBoolean_Electron.ValueData, FALSE) ::Boolean
    INTO vbisElectron
    FROM Movement
         LEFT JOIN MovementBoolean AS MovementBoolean_Electron
                                   ON MovementBoolean_Electron.MovementId =  Movement.Id
                                  AND MovementBoolean_Electron.DescId = zc_MovementBoolean_Electron()
    WHERE Movement.ID = inMovementId;

    -- ���� �������� �� ��� ����� �� �����������
    IF vbisElectron <> TRUE
    THEN
      RAISE EXCEPTION '��������� �������� ��������� ������ � ���������� ���������� ��� �����';
    END IF;

    CREATE TEMP TABLE tmpCalculation ON COMMIT DROP AS
    SELECT MIFloat_Count.ValueData::Integer  AS Count
         , MI_Loyalty.Amount
         , MIFloat_Count.ValueData::Integer  AS CountAdd
         , ROW_NUMBER() OVER (ORDER BY MIFloat_Count.ValueData DESC) AS Ord
    FROM MovementItem AS MI_Loyalty

         LEFT JOIN MovementItemFloat AS MIFloat_Count
                                     ON MIFloat_Count.MovementItemId = MI_Loyalty.Id
                                    AND MIFloat_Count.DescId = zc_MIFloat_Count()

    WHERE MI_Loyalty.MovementId = inMovementId
      AND MI_Loyalty.DescId = zc_MI_Master()
      AND MI_Loyalty.isErased = FALSE
    ORDER BY Amount;

    vbCount := ceil(inCount / (SELECT SUM(tmpCalculation.CountAdd) FROM tmpCalculation));

    UPDATE tmpCalculation SET CountAdd = Count * vbCount;

    vbOrder := 1;
    vbCountLine := (SELECT MAX(tmpCalculation.Ord) FROM tmpCalculation);
    vbCount := (SELECT SUM(tmpCalculation.CountAdd) FROM tmpCalculation);
    WHILE (vbCount < inCount) AND (vbOrder <= vbCountLine) LOOP

      UPDATE tmpCalculation SET CountAdd = CountAdd + CASE WHEN Count < (inCount - vbCount) THEN Count ELSE (inCount - vbCount) END WHERE Ord = vbOrder;
      vbCount := (SELECT SUM(tmpCalculation.CountAdd) FROM tmpCalculation);

      vbOrder := vbOrder + 1;
    END LOOP;

    PERFORM gpInsert_MovementItem_Loyalty_PromoCode(inMovementId  := inMovementId,
                                                    inCount       := tmpCalculation.CountAdd,
                                                    inAmount      := tmpCalculation.Amount,
                                                    inSession     := inSession
                                                    )
    FROM tmpCalculation
    ORDER BY tmpCalculation.Ord;

/*    IF inSession = '3'
    THEN
      RAISE EXCEPTION '������. ������ % ...', (SELECT SUM(tmpCalculation.CountAdd) FROM tmpCalculation);
    END IF;
*/
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 22.07.20                                                       *
 */

-- SELECT * FROM gpInsert_MovementItem_Loyalty_PromoCodeScales (19620044 , 500, '3');