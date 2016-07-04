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
   DECLARE vbToId Integer;
   DECLARE vbInvNumberPoint TVarChar;
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
            INNER JOIN Movement ON Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Income()
            INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                         AND MovementLinkObject_From.ObjectId = Object_MarginCategoryLink.JuridicalId
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
       WHERE MovementLinkObject_To.ObjectId = Object_MarginCategoryLink.UnitId OR COALESCE (Object_MarginCategoryLink.UnitId, 0) = 0;

            
     --
     SELECT ObjectFloat_Percent.valuedata INTO vbJuridicalPercent      
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                ON ObjectFloat_Percent.ObjectId = MovementLinkObject_From.ObjectId
                               AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
     WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Income();
            
            
     IF COALESCE(vbMarginCategoryId, 0) = 0
     THEN
         RAISE EXCEPTION '������. ��� �������� � ������������� �� ��������� � <%> �� ���������� ��������� �������', vbInvNumber;
     END IF;


    PERFORM (WITH DD AS (SELECT DISTINCT MarginPercent, MinPrice FROM Object_MarginCategoryItem_View 
                                                        WHERE MarginCategoryId = vbMarginCategoryId), 
         MarginCondition AS (SELECT MarginPercent, MinPrice, 
                                    COALESCE((SELECT MIN(FF.minprice) FROM DD AS FF WHERE FF.MinPrice > DD.MinPrice), 1000000) AS MaxPrice 
                               FROM DD),
         MovementItem_Income AS (SELECT SUM(PriceWithVAT * Amount) / SUM(Amount) AS PriceWithVAT, MovementItem_Income_View.GoodsId
                                  FROM MovementItem_Income_View WHERE MovementId = inMovementId
                               GROUP BY MovementItem_Income_View.GoodsId)
       
     SELECT COUNT(lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), MovementItem_Income_View.Id, 
                         zfCalc_SalePrice(MovementItem_Income.PriceWithVAT,                            -- ���� � ���
                                          MarginCondition.MarginPercent,                               -- % ������� � ���������
                                          COALESCE (Object_Price_View.isTop, Object_Goods_View.isTOP), -- ��� �������
                                          Object_Goods_View.PercentMarkup,                             -- % ������� � ������
                                          vbJuridicalPercent,                                          -- % ������������� � �� ���� ��� ����
                                          Object_Goods_View.Price )))                                  -- ���� � ������ (�������������)
         FROM MarginCondition, MovementItem_Income_View, MovementItem_Income
              LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = MovementItem_Income.GoodsId
              LEFT JOIN Object_Price_View ON Object_Price_View.GoodsId = MovementItem_Income.GoodsId
                                         AND Object_Price_View.UnitId  = vbToId
                                         AND Object_Price_View.isTop   = TRUE

         WHERE MarginCondition.MinPrice < MovementItem_Income.PriceWithVAT AND MovementItem_Income.PriceWithVAT <= MarginCondition.MaxPrice 
           AND MovementItem_Income.GoodsId = MovementItem_Income_View.GoodsId
           AND MovementItem_Income_View.MovementId = inMovementId);

     SELECT ToId, InvNumberBranch INTO vbToId, vbInvNumberPoint FROM Movement_Income_View WHERE Id = inMovementId;

     IF COALESCE(vbInvNumberPoint, '') = '' THEN 
        -- ����������, ��� ������ ���� �� ��������� ������������� � �����
        IF (SELECT Count(*) FROM Object_Unit_View WHERE ParentId = vbToId) = 0 THEN 
           -- ������� ����� ���������
           vbInvNumberPoint := COALESCE((SELECT MAX(zfConvert_StringToNumber(InvNumberBranch)) + 1
                                  FROM Movement_Income_View WHERE ToId = vbToId), 1);

           PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), inMovementId, vbInvNumberPoint::TVarChar);

           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, CURRENT_DATE);
        END IF; 
     END IF;


     PERFORM lpInsertUpdate_MovementFloat_TotalSummSale (inMovementId);

     -- ��������� ��������
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 13.05.15                        *   
 26.01.15                        *   
*/
-- select * from gpUpdate_MovementItem_Income_GoodsId(inMovementId := 12474 ,  inSession := '3');  
-- vbJuridicalId = 183312
