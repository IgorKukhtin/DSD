-- Function: gpUpdate_Movement_Promo_Supplement()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Promo_Supplement (Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Movement_Promo_Supplement(
    IN inMovementId              Integer    , -- ���� ������� <��������>
    IN inisSupplement            Boolean    , -- ������������ ����� � ���������� ���
    IN inSession                 TVarChar     -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
           
    IF COALESCE (inMovementId, 0) = 0
    THEN
        RAISE EXCEPTION '������.������� ��������� �� ��������.';
    END IF;
    
    -- ��������� <������������ ����� � ���������� ���>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Supplement(), inMovementId, not inisSupplement);
    
    -- ��������� � ������ ����
    IF inisSupplement = FALSE
    THEN
      PERFORM gpUpdate_Goods_inSupplementSUN1(inGoodsMainId       := Object_Goods_Main.Id 
                                            , inisSupplementSUN1  := True
                                            , inSession           := inSession)
      FROM MovementItem
        
           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.ObjectId
                                         AND Object_Goods_Retail.RetailID = 4
           INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                       AND Object_Goods_Main.isSupplementSUN1 = False
                                       
      WHERE MovementItem.MovementID = inMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.isErased = FALSE;
        
    ELSE
      PERFORM gpUpdate_Goods_inSupplementSUN1(inGoodsMainId       := Object_Goods_Main.Id 
                                            , inisSupplementSUN1  := False
                                            , inSession           := inSession)
      FROM MovementItem
        
           INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.ObjectId
                                         AND Object_Goods_Retail.RetailID = 4
           INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                       AND Object_Goods_Main.isSupplementSUN1 = True
                                       
      WHERE MovementItem.MovementID = inMovementId
        AND MovementItem.DescId = zc_MI_Master()
        AND MovementItem.isErased = FALSE;

    END IF;
                    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 26.05.21                                                       *
*/

-- select * from gpUpdate_Movement_Promo_Supplement(inMovementId := 4193036 , inisSupplement := 'False' ,  inSession := '3');