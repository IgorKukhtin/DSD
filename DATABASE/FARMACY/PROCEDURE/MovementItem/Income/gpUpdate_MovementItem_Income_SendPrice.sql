DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_SendPrice 
          (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_SendPrice(
    IN inMovementId          Integer   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbInvNumber TVarChar;
   DECLARE vbMarginCategoryId Integer;
   DECLARE vbJuridicalPercent TFloat;
BEGIN
     
     -- ���������� <������>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = inMovementId;

     -- �������� - �����������/��������� ��������� �������� ������
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION '������.��������� ��������� � <%> � ������� <%> �� ��������.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- ���������� ��������� �������

     SELECT Object_MarginCategoryLink.MarginCategoryId  INTO vbMarginCategoryId
       FROM Object_MarginCategoryLink_View AS Object_MarginCategoryLink 
                          JOIN Movement_Income_View ON Movement_Income_View.Id = inMovementId
                                                   AND Movement_Income_View.FromId = Object_MarginCategoryLink.JuridicalId
                                                   AND Movement_Income_View.ToId = Object_MarginCategoryLink.UnitId;
            
      SELECT ObjectFloat_Percent.valuedata INTO vbJuridicalPercent      
            FROM Movement_Income_View 
                     LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                           ON ObjectFloat_Percent.ObjectId = Movement_Income_View.FromId
                                          AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
           WHERE Movement_Income_View.Id = inMovementId;
            
            
     IF COALESCE(vbMarginCategoryId, 0) = 0
     THEN
         RAISE EXCEPTION '������. ��� �������� � ������������� �� ��������� � <%> �� ���������� ��������� �������', vbInvNumber;
     END IF;


    PERFORM (WITH DD AS (SELECT DISTINCT MarginPercent, MinPrice FROM Object_MarginCategoryItem_View 
                                                        WHERE MarginCategoryId = vbMarginCategoryId), 
         MarginCondition AS (SELECT MarginPercent, MinPrice, 
                                    COALESCE((SELECT MIN(FF.minprice) FROM DD AS FF WHERE FF.MinPrice > DD.MinPrice), 1000000) AS MaxPrice 
                               FROM DD)
       
     SELECT COUNT(lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), MovementItem_Income_View.Id, 
                         zfCalc_SalePrice(PriceWithVAT, -- ���� � ���
                                          MarginCondition.MarginPercent, -- % �������
                                          Object_Goods_View.isTOP, -- ��� �������
                                          Object_Goods_View.PercentMarkup, -- % ������� � ������
                                          vbJuridicalPercent)))
         FROM MarginCondition, MovementItem_Income_View 
                    LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = MovementItem_Income_View.GoodsId
         WHERE MovementId = inMovementId  AND MarginCondition.MinPrice < PriceWithVAT AND PriceWithVAT <= MarginCondition.MaxPrice);

     PERFORM lpInsertUpdate_MovementFloat_TotalSummSale (inMovementId);
     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 26.01.15                        *   
*/
-- select * from gpUpdate_MovementItem_Income_GoodsId(inMovementId := 12474 ,  inSession := '3');  
-- vbJuridicalId = 183312

        
