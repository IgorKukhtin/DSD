-- Function: lpReComplete_Movement_PromoCode_All (Integer)

DROP FUNCTION IF EXISTS lpReComplete_Movement_PromoCode_All (Integer, Integer);

CREATE OR REPLACE FUNCTION lpReComplete_Movement_PromoCode_All(
    IN inMovementId        Integer  , -- ���� ���������
    IN inUserId            Integer    -- ������������
)                              
RETURNS VOID
AS
$BODY$
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate   TDateTime;
BEGIN

    
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ��������� �.�.
 14.12.17         * 
*/