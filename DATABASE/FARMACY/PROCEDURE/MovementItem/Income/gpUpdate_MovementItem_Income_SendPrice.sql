DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_SendPrice 
          (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_SendPrice(
    IN inMovementId          Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
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
     
     -- определяем <Статус>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = inMovementId;

     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- определяем Категорию расчета

     SELECT Object_MarginCategoryLink.MarginCategoryId  INTO vbMarginCategoryId
       FROM Object_MarginCategoryLink_View AS Object_MarginCategoryLink 
                          JOIN Movement_Income_View ON Movement_Income_View.Id = inMovementId
                                                   AND Movement_Income_View.FromId = Object_MarginCategoryLink.JuridicalId
                                                   AND ((Movement_Income_View.ToId = Object_MarginCategoryLink.UnitId) OR ( COALESCE(Object_MarginCategoryLink.UnitId, 0) = 0 ));
            
      SELECT ObjectFloat_Percent.valuedata INTO vbJuridicalPercent      
            FROM Movement_Income_View 
                     LEFT JOIN ObjectFloat AS ObjectFloat_Percent
                                           ON ObjectFloat_Percent.ObjectId = Movement_Income_View.FromId
                                          AND ObjectFloat_Percent.DescId = zc_ObjectFloat_Juridical_Percent()
           WHERE Movement_Income_View.Id = inMovementId;
            
            
     IF COALESCE(vbMarginCategoryId, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка. Для продавца и подразделения из документа № <%> не определена категория наценки', vbInvNumber;
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
                         zfCalc_SalePrice(MovementItem_Income.PriceWithVAT, -- Цена С НДС
                                          MarginCondition.MarginPercent, -- % наценки
                                          Object_Goods_View.isTOP, -- ТОП позиция
                                          Object_Goods_View.PercentMarkup, -- % наценки у товара
                                          vbJuridicalPercent)))
         FROM MarginCondition, MovementItem_Income_View, MovementItem_Income
                    LEFT JOIN Object_Goods_View ON Object_Goods_View.Id = MovementItem_Income.GoodsId
         WHERE MarginCondition.MinPrice < MovementItem_Income.PriceWithVAT AND MovementItem_Income.PriceWithVAT <= MarginCondition.MaxPrice 
           AND MovementItem_Income.GoodsId = MovementItem_Income_View.GoodsId
           AND MovementItem_Income_View.MovementId = inMovementId);

     PERFORM lpInsertUpdate_MovementFloat_TotalSummSale (inMovementId);
     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 13.05.15                        *   
 26.01.15                        *   
*/
-- select * from gpUpdate_MovementItem_Income_GoodsId(inMovementId := 12474 ,  inSession := '3');  
-- vbJuridicalId = 183312

        
