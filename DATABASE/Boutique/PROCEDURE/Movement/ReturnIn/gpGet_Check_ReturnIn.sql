-- Function: gpGet_Check_ReturnIn()

DROP FUNCTION IF EXISTS gpGet_Check_ReturnIn (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Check_ReturnIn(
    IN inMovementId        Integer  ,  -- ���� ��������� �������
    IN inIsAmountPartner   Boolean  ,
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Sale());
     vbUserId := lpGetUserBySession (inSession);


     -- �������� ����� �� �������� ����� �������, ��� ������ ����
 
     IF inIsAmountPartner = FALSE AND 1=0
     AND EXISTS (SELECT 1
                 FROM MovementItem AS MI_Master
                      INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                   ON MIFloat_AmountPartner.MovementItemId = MI_Master.Id
                                                  AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                  AND MIFloat_AmountPartner.ValueData      > 0
                 WHERE MI_Master.MovementId = inMovementId
                   AND MI_Master.DescId = zc_MI_Master()
                   AND MI_Master.isErased = FALSE
                )
     THEN
         --������
         RAISE EXCEPTION '������.���� ���-�� ��� �������� � �������� � ����.';
     END IF;
     
     IF inIsAmountPartner = TRUE 
     AND NOT EXISTS (SELECT 1
                     FROM MovementItem AS MI_Master
                          INNER JOIN MovementItemFloat AS MIFloat_AmountPartner
                                                       ON MIFloat_AmountPartner.MovementItemId = MI_Master.Id
                                                      AND MIFloat_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                                                      AND MIFloat_AmountPartner.ValueData      > 0
                     WHERE MI_Master.MovementId = inMovementId
                       AND MI_Master.DescId = zc_MI_Master()
                       AND MI_Master.isErased = FALSE
                    )
     THEN
         --������
          RAISE EXCEPTION '������.��� ���-�� ��� �������� � �������� � ����.';
     END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.04.21         *
 */

-- ����
-- SELECT * FROM gpInsert_Movement_Sale_byReturnIn 
