-- Function: gpInsertUpdate_MovementItem_DistributionPromoSign()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_DistributionPromoSign (Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_DistributionPromoSign(
    IN inId                  Integer   , -- ���� ������� <�������� ������� ��������� ����������>
    IN inMovementId          Integer   , -- ���� ������� <�������� ���>
    IN isIssuedBy            Boolean   , -- ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    
    IF EXISTS(SELECT MI_Sign.Id
              FROM MovementItem AS MI_Sign
              WHERE MI_Sign.MovementId = inId
                AND MI_Sign.DescId = zc_MI_Sign()
                AND MI_Sign.Amount = inMovementId)
    THEN
      SELECT MI_Sign.Id
      INTO vbId
      FROM MovementItem AS MI_Sign
      WHERE MI_Sign.MovementId = inId
        AND MI_Sign.DescId = zc_MI_Sign()
        AND MI_Sign.Amount = inMovementId;
    ELSE
      vbId := 0;
    END IF;
  
     -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (vbId, 0) = 0;

    -- ��������� <������� ���������>
    vbId := lpInsertUpdate_MovementItem (vbId, zc_MI_Sign(), 0, inId, inMovementId, NULL, zc_Enum_Process_Auto_PartionClose());
         
    -- ��������� �������� <������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_isIssuedBy(), vbId, isIssuedBy);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.20                                                       *
*/


-- select * from gpInsertUpdate_MovementItem_DistributionPromoSign (inId := 1, inMovementId := 2, isIssuedBy := True, inSession := '3');