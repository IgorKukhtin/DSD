-- Function: gpInsertUpdate_MI_Loss_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_Loss_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_Loss_From_Excel(
    IN inMovementId               Integer   ,    -- ������������� ���������

    IN inGoodsCode                TVarChar  ,    -- ��� ������

    IN inAmount                   TVarChar  ,    -- ����������
    IN inPriceIn                  TVarChar  ,    -- ���� ������� (� ���)

    IN inPriceSale                TVarChar  ,    -- ���� ����������
    
    IN inSession                  TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbGoodsId Integer;
   DECLARE vbMovementItemId Integer;
   
   DECLARE vbAmount TFloat;
   DECLARE vbPriceIn TFloat;
   DECLARE vbPriceSale TFloat;

   DECLARE vbIsInsert Boolean;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId:= lpGetUserBySession (inSession);
  
  -- ������������ <�������� ����>
  vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));
  
  IF COALESCE(inGoodsCode, '') = ''
  THEN
    RETURN;
  END IF;
    
  -- ��������� ID ������  
  BEGIN  
    SELECT Object_Goods_Retail.Id
    INTO vbGoodsId
    FROM Object_Goods_Main AS Object_Goods_Main 
    
         LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.GoodsMainId  = Object_Goods_Main.Id
                                      AND Object_Goods_Retail.RetailId     = vbObjectId
               
    WHERE Object_Goods_Main.ObjectCode = inGoodsCode::Integer;
  EXCEPTION WHEN others THEN 
    vbGoodsId := Null;
  END;
  
  -- ������ ����������
  BEGIN  
    vbAmount := REPLACE(REPLACE(inAmount, ' ', ''), ',', '.')::TFloat;
  EXCEPTION WHEN others THEN 
    vbAmount := 0;
  END;

  -- ������ ����
  IF vbUserId IN (3, 59591, 183242, 4183126)
  THEN
    BEGIN  
      vbPriceIn := REPLACE(REPLACE(inPriceIn, ' ', ''), ',', '.')::TFloat;
    EXCEPTION WHEN others THEN 
      vbPriceIn := 0;
    END;
  ELSE
    vbPriceIn := 0;
  END IF;
  
  -- ������ ����
  IF vbUserId IN (3, 59591, 183242, 4183126)
  THEN
    BEGIN  
      vbPriceSale := REPLACE(REPLACE(inPriceSale, ' ', ''), ',', '.')::TFloat;
    EXCEPTION WHEN others THEN 
      vbPriceSale := 0;
    END;
  ELSE
    vbPriceSale := 0;
  END IF;
  
  SELECT MovementItem.Id
  INTO vbMovementItemId 
  FROM MovementItem
  WHERE MovementItem.MovementId = inMovementId
    AND MovementItem.ObjectId = vbGoodsId;

  -- ������������ ������� ��������/�������������
  vbIsInsert:= COALESCE (vbMovementItemId, 0) = 0;
  

  -- ��������� <������� ���������>
  vbMovementItemId := lpInsertUpdate_MovementItem_Loss (vbMovementItemId, inMovementId, vbGoodsId, vbAmount, vbUserId);

  -- ��������� �������� <���� ���������>
  IF COALESCE (vbPriceSale, 0) > 0
  THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_Price(), vbMovementItemId, vbPriceSale);  
  END IF;


  -- ��������� �������� <���� ������� (� ���)>
  IF COALESCE (vbPriceIn, 0) > 0
  THEN
      PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceIn(), vbMovementItemId, vbPriceIn);  
  END IF;

  -- ��������� ��������
  PERFORM lpInsert_MovementItemProtocol (vbMovementItemId, vbUserId, vbIsInsert);

                                                          
  /*RAISE EXCEPTION  'Value 03: <%> <%> <%> <%>', vbGoodsId, vbAmount, vbPrice, vbPriceSale;     
  
   IF inSession = '3'
   THEN
      RAISE EXCEPTION '������.';
   END IF;*/
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.11.2023                                                     *
*/

-- ����

-- select * from gpInsertUpdate_MI_Loss_From_Excel(inMovementId := 34111475 , inGoodsCode := '42645' , inAmount := '1' , inPriceIn := '358.8' , inPriceSale := '' ,  inSession := '3');
