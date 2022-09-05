-- Function: gpInsertUpdate_MovementSiteBonus()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementSiteBonus (Integer, Integer, TFloat, TFloat, TVarChar);
    
CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementSiteBonus(
    IN inMovementId        Integer   , -- ���� ������� <�������� ���>
    IN inBuyerForSiteCode  Integer   , -- ���������� ����� "�� �����"
    IN inBonus             TFloat    , -- ��������� �������
    IN inBonus_Used        TFloat    , -- ������������ �������
    IN inSession           TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
BEGIN

  IF EXISTS(SELECT 1 FROM MovementSiteBonus WHERE MovementSiteBonus.MovementId = inMovementId)
  THEN 
    UPDATE MovementSiteBonus SET BuyerForSiteCode = inBuyerForSiteCode, Bonus = inBonus, Bonus_Used = inBonus_Used
    WHERE MovementSiteBonus.MovementId = inMovementId;
  ELSE
    INSERT INTO MovementSiteBonus (MovementId, BuyerForSiteCode, Bonus, Bonus_Used)
    VALUES (inMovementId, inBuyerForSiteCode, inBonus, inBonus_Used);
  END IF;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 05.09.22                                                       *
*/

-- ����
--

SELECT * FROM gpInsertUpdate_MovementSiteBonus(inMovementId := 29173541, inBuyerForSiteCode := 73051, inBonus := 0.24, inBonus_Used := 0.0, inSession := '3')