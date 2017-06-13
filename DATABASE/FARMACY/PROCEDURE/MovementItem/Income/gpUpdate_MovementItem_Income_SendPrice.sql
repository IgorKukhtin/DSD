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
     SELECT CASE WHEN COALESCE (ObjectFloat_Contract_Percent.ValueData,0) <> 0 
                      THEN COALESCE (ObjectFloat_Contract_Percent.ValueData,0)
                 ELSE COALESCE (ObjectFloat_Juridical_Percent.ValueData,0)
            END
     INTO vbJuridicalPercent      
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                        ON MovementLinkObject_From.MovementId = Movement.Id
                                       AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN ObjectFloat AS ObjectFloat_Juridical_Percent
                                ON ObjectFloat_Juridical_Percent.ObjectId = MovementLinkObject_From.ObjectId
                               AND ObjectFloat_Juridical_Percent.DescId = zc_ObjectFloat_Juridical_Percent()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN ObjectFloat AS ObjectFloat_Contract_Percent
                                ON ObjectFloat_Contract_Percent.ObjectId = MovementLinkObject_Contract.ObjectId
                               AND ObjectFloat_Contract_Percent.DescId = zc_ObjectFloat_Contract_Percent()

     WHERE Movement.Id = inMovementId AND Movement.DescId = zc_Movement_Income();
            
            
     IF COALESCE(vbMarginCategoryId, 0) = 0
     THEN
         RAISE EXCEPTION '������. ��� �������� � ������������� �� ��������� � <%> �� ���������� ��������� �������', vbInvNumber;
     END IF;


     -- ��������� �� ���������
     SELECT ToId, InvNumberBranch INTO vbToId, vbInvNumberPoint FROM Movement_Income_View WHERE Id = inMovementId;


    -- ��������� ����� ����
    PERFORM (WITH DD AS (SELECT DISTINCT MarginPercent, MinPrice
                         FROM Object_MarginCategoryItem_View 
                              INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                             AND Object_MarginCategoryItem.isErased = FALSE
                        WHERE MarginCategoryId = vbMarginCategoryId), 
         MarginCondition AS (SELECT MarginPercent, MinPrice, 
                                    COALESCE((SELECT MIN(FF.minprice) FROM DD AS FF WHERE FF.MinPrice > DD.MinPrice), 1000000) AS MaxPrice 
                               FROM DD),
         MovementItem_Income AS (SELECT SUM(PriceWithVAT * Amount) / SUM(Amount) AS PriceWithVAT, MovementItem_Income_View.GoodsId
                                  FROM MovementItem_Income_View WHERE MovementId = inMovementId
                               GROUP BY MovementItem_Income_View.GoodsId),

         tmpPrice_View AS (SELECT ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                                , Price_Goods.ChildObjectId               AS GoodsId
                                , COALESCE(Price_Fix.ValueData,False)     AS Fix 
                                , COALESCE(Price_Top.ValueData,False)     AS isTop   
                                , COALESCE(Price_PercentMarkup.ValueData, 0) ::TFloat AS PercentMarkup 
                           FROM ObjectLink        AS ObjectLink_Price_Unit
                                LEFT JOIN ObjectLink       AS Price_Goods
                                       ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                                      AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                                LEFT JOIN ObjectFloat       AS Price_Value
                                       ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                                LEFT JOIN ObjectBoolean     AS Price_Fix
                                        ON Price_Fix.ObjectId = ObjectLink_Price_Unit.ObjectId
                                       AND Price_Fix.DescId = zc_ObjectBoolean_Price_Fix()
                                LEFT JOIN ObjectBoolean     AS Price_Top
                                        ON Price_Top.ObjectId = ObjectLink_Price_Unit.ObjectId
                                       AND Price_Top.DescId = zc_ObjectBoolean_Price_Top()
                                LEFT JOIN ObjectFloat       AS Price_PercentMarkup
                                        ON Price_PercentMarkup.ObjectId = ObjectLink_Price_Unit.ObjectId
                                       AND Price_PercentMarkup.DescId = zc_ObjectFloat_Price_PercentMarkup()
                           WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                             AND ObjectLink_Price_Unit.ChildObjectId = vbToId -- 183292 --inUnitId
                             AND (COALESCE(Price_Fix.ValueData,False) = True
                                  OR COALESCE(Price_Top.ValueData,False) = True
                                  OR COALESCE(Price_PercentMarkup.ValueData, 0) <> 0)
                           )
       
     SELECT COUNT(lpInsertUpdate_MovementItemFloat (zc_MIFloat_PriceSale(), MovementItem_Income_View.Id, 
                         zfCalc_SalePrice(MovementItem_Income.PriceWithVAT                            -- ���� � ���
                                        , MarginCondition.MarginPercent                               -- % ������� � ���������
                                        , COALESCE (NULLIF (View_Price.isTop, FALSE), Object_Goods_View.isTOP)             -- ��� �������
                                        , COALESCE (NULLIF (View_Price.PercentMarkup, 0), Object_Goods_View.PercentMarkup) -- % ������� � ������
                                        , vbJuridicalPercent                                          -- % ������������� � �� ���� ��� ����
                                        , CASE WHEN View_Price.Fix = TRUE AND View_Price.Price <> 0 /*AND COALESCE (Object_Goods_View.Price, 0) = 0*/ THEN View_Price.Price ELSE Object_Goods_View.Price END))) -- ���� � ������ (�������������)
         FROM MarginCondition, MovementItem_Income_View, MovementItem_Income
              LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = MovementItem_Income.GoodsId
              LEFT JOIN tmpPrice_View AS View_Price
                                      ON View_Price.GoodsId = MovementItem_Income.GoodsId
                         --            AND View_Price.UnitId  = vbToId
                         --            AND (View_Price.isTop  = TRUE OR View_Price.Fix = TRUE OR View_Price.PercentMarkup <> 0)

         WHERE MarginCondition.MinPrice < MovementItem_Income.PriceWithVAT AND MovementItem_Income.PriceWithVAT <= MarginCondition.MaxPrice 
           AND MovementItem_Income.GoodsId = MovementItem_Income_View.GoodsId
           AND MovementItem_Income_View.MovementId = inMovementId);


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
 12.06.17         *
 09.12.16         * add ObjectFloat_Contract_Percent
 13.05.15                        *   
 26.01.15                        *   
*/
-- select * from gpUpdate_MovementItem_Income_SendPrice (inMovementId := 2524720 ,  inSession := '3');  
-- vbJuridicalId = 183312
