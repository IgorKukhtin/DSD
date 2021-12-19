-- Function: lpInsertUpdate_MovementFloat_TotalSumm_Pretension (Integer)

DROP FUNCTION IF EXISTS lpInsertUpdate_MovementFloat_TotalSumm_Pretension (Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_MovementFloat_TotalSumm_Pretension(
    IN inMovementId Integer -- ���� ������� <��������>
)
  RETURNS VOID AS
$BODY$

  DECLARE vbTotalDeficit      TFloat;
  DECLARE vbTotalProficit     TFloat;
  DECLARE vbTotalSubstandard  TFloat;

BEGIN
     IF COALESCE (inMovementId, 0) = 0
     THEN
         RAISE EXCEPTION '������.������� ��������� �� ��������.';
     END IF;

     SELECT SUM(CASE WHEN COALESCE (PriceSite_Deficit.ValueData, FALSE) = TRUE THEN - COALESCE(MI_Pretension.Amount,0) END)
          , SUM(CASE WHEN COALESCE (PriceSite_Surplus.ValueData, FALSE) = TRUE THEN COALESCE(MI_Pretension.Amount,0) END)
          , SUM(CASE WHEN COALESCE (PriceSite_Deficit.ValueData, FALSE) = FALSE AND COALESCE (PriceSite_Surplus.ValueData, FALSE) = FALSE THEN COALESCE(MI_Pretension.Amount,0) END)
     INTO vbTotalDeficit, vbTotalProficit, vbTotalSubstandard
     FROM MovementItem AS MI_Pretension
     
          LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                        ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                       AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                       
          LEFT JOIN MovementItemLinkObject AS MILinkObject_ReasonDifferences
                                           ON MILinkObject_ReasonDifferences.MovementItemId = MI_Pretension.Id
                                          AND MILinkObject_ReasonDifferences.DescId = zc_MILinkObject_ReasonDifferences()

          LEFT JOIN ObjectBoolean AS PriceSite_Deficit
                                  ON PriceSite_Deficit.ObjectId = MILinkObject_ReasonDifferences.ObjectId
                                 AND PriceSite_Deficit.DescId = zc_ObjectBoolean_ReasonDifferences_Deficit()
                                                   
          LEFT JOIN ObjectBoolean AS PriceSite_Surplus
                                  ON PriceSite_Surplus.ObjectId = MILinkObject_ReasonDifferences.ObjectId
                                 AND PriceSite_Surplus.DescId = zc_ObjectBoolean_ReasonDifferences_Surplus()

     WHERE MI_Pretension.MovementId = inMovementId 
       AND MI_Pretension.isErased   = false
       AND MI_Pretension.DescId     = zc_MI_Master()
       AND COALESCE(MIBoolean_Checked.ValueData, FALSE) = True;


      -- ��������� �������� <����� ����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalDeficit(), inMovementId, vbTotalDeficit);

      -- ��������� �������� <����� ����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalProficit(), inMovementId, vbTotalProficit);

      -- ��������� �������� <����� ����� ����������>
      PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_TotalSubstandard(), inMovementId, vbTotalSubstandard);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_MovementFloat_TotalSumm_Pretension (Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.04.15                         * 
*/
-- ����
--