-- Function: gpInsertUpdate_MI_ConvertRemains_From_Excel()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_ConvertRemains_From_Excel (Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_ConvertRemains_From_Excel(
    IN inMovementId               Integer   ,    -- ������������� ���������

    IN inNumber                   TVarChar  ,    -- � �� �������
    IN inGoodsCode                TVarChar  ,    -- ��� ������

    IN inAmount                   TVarChar  ,    -- ����������
    IN inPrice                    TVarChar  ,    -- ���� ��� ���
    IN inVAT                      TVarChar  ,    -- ���
    
    IN inGoodsName                TVarChar  ,    -- �������� ������
    IN inMeasure                  TVarChar  ,    -- ������� ���������
    IN inMeasureConv              TVarChar  ,    -- ������� ���������

    IN inSession                  TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbId Integer;
   DECLARE vbNumber Integer;
   DECLARE vbGoodsId Integer;

   DECLARE vbAmount TFloat;
   DECLARE vbPriceWithVAT TFloat;
   DECLARE vbVAT TFloat;

   DECLARE vbMeasure TVarChar;
   DECLARE text_var1 text;
BEGIN
  -- �������� ���� ������������ �� ����� ���������
  vbUserId:= lpGetUserBySession (inSession);
  
  -- ������������ <�������� ����>
  vbObjectId:= lpGet_DefaultValue ('zc_Object_Retail', ABS (vbUserId));
  
  IF COALESCE(inVAT, '') = '' OR COALESCE(inNumber, '') = ''
  THEN
    RETURN;
  END IF;
  
  -- ������ ����������
  BEGIN  
    vbNumber := REPLACE(REPLACE(inNumber, ' ', ''), ',', '.')::Integer;
  EXCEPTION WHEN others THEN 
    RETURN;
  END;
  
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
    inAmount := 0;
  END;

  -- ������ ���
  BEGIN  
    vbVAT := REPLACE(REPLACE(inVAT, ' ', ''), ',', '.')::TFloat;
  EXCEPTION WHEN others THEN 
    IF inVAT = '*'
    THEN
      vbVAT := 20;
    ELSE
      vbVAT := 7;
    END IF;
  END;

  -- ������ ���� � ������������ ���
  BEGIN  
    vbPriceWithVAT := Round(REPLACE(REPLACE(inPrice, ' ', ''), ',', '.')::TFloat * (100 + vbVAT) / 100, 2);
  EXCEPTION WHEN others THEN 
    vbPriceWithVAT := 0;
  END;
  
  vbMeasure := CASE WHEN inMeasure ILIKE '���%'
                    THEN '����'
                    WHEN inMeasure ILIKE '%����%'
                    THEN '����'
                    WHEN inMeasure ILIKE '%���%' OR inMeasure ILIKE '%��%'
                    THEN '�����'
                    WHEN inMeasure ILIKE '���%'
                    THEN '���'
                    WHEN inMeasure ILIKE '���%'
                    THEN '���'
                    WHEN inMeasure ILIKE '���%'
                    THEN '����'
                    WHEN inMeasure ILIKE '���%'
                    THEN '���'
                    WHEN inMeasure ILIKE '��%'
                    THEN '����'
                    WHEN inMeasure ILIKE '��%'
                    THEN '��'
                    END;
                    
  IF COALESCE (vbMeasure, '') = ''
  THEN
    vbMeasure := CASE WHEN inMeasureConv ILIKE '���%'
                      THEN '����'
                      WHEN inMeasureConv ILIKE '%����%'
                      THEN '����'
                      WHEN inMeasureConv ILIKE '%���%' OR inMeasure ILIKE '%��%'
                      THEN '�����'
                      WHEN inMeasureConv ILIKE '���%'
                      THEN '���'
                      WHEN inMeasureConv ILIKE '���%'
                      THEN '���'
                      WHEN inMeasureConv ILIKE '���%'
                      THEN '����'
                      WHEN inMeasureConv ILIKE '���%'
                      THEN '���'
                      WHEN inMeasureConv ILIKE '��%'
                      THEN '����'
                      WHEN inMeasureConv ILIKE '��%'
                      THEN '��'
                      END;  
  END IF;
       
  -- ���� ���� ��� �������
  SELECT MovementItem.Id
  INTO vbId
  FROM MovementItem

       INNER JOIN MovementItemFloat AS MIFloat_Number
                                    ON MIFloat_Number.MovementItemId = MovementItem.Id
                                   AND MIFloat_Number.DescId = zc_MIFloat_Number()  
                                   AND MIFloat_Number.ValueData = vbNumber
                                  
  WHERE MovementItem.MovementId = inMovementId
  ORDER BY MovementItem.Id
  Limit 1 -- �� ������ ������
  ;
  
  -- ���� �� ����� � ���� ������
  IF COALESCE (vbId, 0) = 0
  THEN
    SELECT MovementItem.Id
    INTO vbId
    FROM MovementItem

         LEFT JOIN MovementItemFloat AS MIFloat_Number
                                     ON MIFloat_Number.MovementItemId = MovementItem.Id
                                    AND MIFloat_Number.DescId = zc_MIFloat_Number()  
                                    
    WHERE MovementItem.MovementId = inMovementId
      AND COALESCE(MIFloat_Number.ValueData, 0) = 0
    ORDER BY MovementItem.Id
    Limit 1 -- �� ������ ������
    ;
  
  END IF;
                              
  IF EXISTS(SELECT MovementItem.ID FROM MovementItem WHERE MovementItem.ID = vbId AND MovementItem.isErased = True)
  THEN
    UPDATE MovementItem SET isErased = False  WHERE MovementItem.ID = vbId AND MovementItem.isErased = True;
  END IF;
                         
  --RAISE NOTICE  'Value 03: <%> <%> <%> <%> <%> <%>', vbId, vbGoodsId, vbAmount, vbPriceWithVAT, vbVAT, vbMeasure;

  -- ��������� ������
  PERFORM lpInsertUpdate_MovementItem_ConvertRemains (ioId                  := COALESCE(vbId, 0)
                                                    , inMovementId          := inMovementId
                                                    , inNumber              := vbNumber  
                                                    , inGoodsId             := vbGoodsId
                                                    , inAmount              := vbAmount
                                                    , inPriceWithVAT        := vbPriceWithVAT
                                                    , inVAT                 := vbVAT
                                                    , inGoodsName           := inGoodsName
                                                    , inMeasure             := vbMeasure
                                                    , inUserId              := vbUserId);

                                                          

  /*RAISE NOTICE  'Value 03: <%> <%> <%> <%>', 
                      vbId, vbGoodsId, vbOrderDateSP, vbOrderNumberSP;  */   
  

  -- RAISE EXCEPTION  'Value 03: <%> <%> <%> <%> <%> <%>', vbId, vbGoodsId, vbAmount, vbPriceWithVAT, vbVAT, vbMeasure;     
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 25.10.2023                                                     *
*/

-- ����

-- select * from gpInsertUpdate_MI_ConvertRemains_From_Excel(inMovementId := 33817411 , inNumber := '1' , inGoodsCode := '31561', inAmount := '1,00', inPrice := '36,29', inVAT := '*', inGoodsName := 'ACTIVE ORGANIC ���� ��������� ����������������� 280��  0523', inMeasure := '����.',  inSession := '3');