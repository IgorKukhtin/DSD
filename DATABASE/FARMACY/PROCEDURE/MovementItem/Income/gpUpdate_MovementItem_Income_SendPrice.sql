DROP FUNCTION IF EXISTS gpUpdate_MovementItem_Income_SendPrice (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MovementItem_Income_SendPrice(
    IN inMovementId          Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId           Integer;
   DECLARE vbObjectId         Integer;
   DECLARE vbStatusId         Integer;
   DECLARE vbGoodsId          Integer;
   DECLARE vbNDSKindId        Integer;
   DECLARE vbInvNumber        TVarChar;
   DECLARE vbMarginCategoryId Integer;
   DECLARE vbJuridicalPercent TFloat;
   DECLARE vbToId             Integer;
   DECLARE vbInvNumberPoint   TVarChar;
   DECLARE vbRetailId         Integer;
   DECLARE vbisTopNo_Unit     Boolean;
BEGIN
     
     -- определяем <Статус>
     SELECT StatusId, InvNumber INTO vbStatusId, vbInvNumber FROM Movement WHERE Id = inMovementId;

     -- проверка - проведенные/удаленные документы Изменять нельзя
     IF vbStatusId <> zc_Enum_Status_UnComplete()
     THEN
         RAISE EXCEPTION 'Ошибка.Изменение документа № <%> в статусе <%> не возможно.', vbInvNumber, lfGet_Object_ValueData (vbStatusId);
     END IF;

     -- находим вид НДС. 
     SELECT ObjectId INTO vbNDSKindId
     FROM MovementLinkObject AS MovementLinkObject_NDSKind
     WHERE MovementLinkObject_NDSKind.MovementId = inMovementId
       AND MovementLinkObject_NDSKind.DescId = zc_MovementLinkObject_NDSKind();
       
     -- Проверяем у всех ли товаров совпадает НДС. 
     vbGoodsId:= (SELECT MovementItem.ObjectId
                  FROM MovementItem
                      JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                      ON ObjectLink_Goods_NDSKind.ObjectId      = MovementItem.ObjectId
                                     AND ObjectLink_Goods_NDSKind.ChildObjectId <> vbNDSKindId
                                     AND ObjectLink_Goods_NDSKind.DescId        = zc_ObjectLink_Goods_NDSKind()
                  WHERE MovementItem.MovementId = inMovementId
                    AND MovementItem.DescId     = zc_MI_Master()
                    AND MovementItem.IsErased   = FALSE
                  LIMIT 1);
     IF vbGoodsId <> 0
     THEN 
         RAISE EXCEPTION 'У "%" не совпадает тип НДС с документом', lfGet_Object_ValueData (vbGoodsId);
     END IF;

     -- определяем Категорию расчета
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
       WHERE MovementLinkObject_To.ObjectId = Object_MarginCategoryLink.UnitId OR COALESCE (Object_MarginCategoryLink.UnitId, 0) = 0
         AND Object_MarginCategoryLink.isErased = False;
            
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
         RAISE EXCEPTION 'Ошибка. Для продавца и подразделения из документа № <%> не определена категория наценки', vbInvNumber;
     END IF;


     -- Параметры из Документа
     SELECT ToId, InvNumberBranch INTO vbToId, vbInvNumberPoint FROM Movement_Income_View WHERE Id = inMovementId;

     --свойство Аптеки isTopNo
     vbisTopNo_Unit := COALESCE ( (SELECT COALESCE (ObjectBoolean_TopNo.ValueData, FALSE) :: Boolean AS isTopNo
                                   FROM ObjectBoolean AS ObjectBoolean_TopNo
                                   WHERE ObjectBoolean_TopNo.ObjectId = vbToId
                                     AND ObjectBoolean_TopNo.DescId = zc_ObjectBoolean_Unit_TopNo()
                                    ), FALSE) :: Boolean;


    -- Сохранили новую цену
    PERFORM (WITH DD AS (SELECT DISTINCT MarginPercent, MinPrice
                         FROM Object_MarginCategoryItem_View 
                              INNER JOIN Object AS Object_MarginCategoryItem ON Object_MarginCategoryItem.Id = Object_MarginCategoryItem_View.Id
                                                                             AND Object_MarginCategoryItem.isErased = FALSE
                        WHERE MarginCategoryId = vbMarginCategoryId), 
         MarginCondition AS (SELECT MarginPercent, MinPrice, 
                                    COALESCE((SELECT MIN(FF.minprice) FROM DD AS FF WHERE FF.MinPrice > DD.MinPrice), 1000000) AS MaxPrice 
                               FROM DD),
         MovementItem_Income AS (SELECT SUM (CASE WHEN PriceSampleWithVAT > 0 THEN PriceSampleWithVAT ELSE PriceWithVAT END * Amount) / SUM (Amount) AS PriceWithVAT
                                      , MovementItem_Income_View.GoodsId
                                 FROM MovementItem_Income_View WHERE MovementId = inMovementId
                                 GROUP BY MovementItem_Income_View.GoodsId
                                ),

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
                                      AND Price_Value.DescId   = zc_ObjectFloat_Price_Value()
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
     --  если стоит свойство подразделнеия не учитывать ТОП , тогда при расчете цены берем обычную наценку!!! 05,09,2019
     SELECT COUNT(lpInsertUpdate_MovementItemFloat 
                        (zc_MIFloat_PriceSale(), MovementItem_Income_View.Id, 
                         zfCalc_SalePrice(MovementItem_Income.PriceWithVAT                            -- Цена С НДС
                                        , MarginCondition.MarginPercent                               -- % наценки в КАТЕГОРИИ
                                        , CASE WHEN vbisTopNo_Unit = TRUE THEN FALSE ELSE COALESCE (NULLIF (View_Price.isTop, FALSE), Object_Goods_Retail.isTOP) END             -- ТОП позиция
                                        , CASE WHEN vbisTopNo_Unit = TRUE THEN 0     ELSE COALESCE (NULLIF (View_Price.PercentMarkup, 0), Object_Goods_Retail.PercentMarkup) END -- % наценки у товара
                                        , vbJuridicalPercent                                          -- % корректировки у Юр Лица для ТОПа
                                        , CASE WHEN vbisTopNo_Unit = TRUE THEN 0     
                                               ELSE CASE WHEN View_Price.Fix = TRUE AND View_Price.Price <> 0 
                                                         THEN View_Price.Price ELSE Object_Goods_Retail.Price 
                                                    END
                                          END)                                                        -- Цена у товара (фиксированная)
                         )) 
         FROM MarginCondition, MovementItem_Income_View, MovementItem_Income
              LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem_Income.GoodsId
              LEFT JOIN tmpPrice_View AS View_Price
                                      ON View_Price.GoodsId = MovementItem_Income.GoodsId
                         --            AND View_Price.UnitId  = vbToId
                         --            AND (View_Price.isTop  = TRUE OR View_Price.Fix = TRUE OR View_Price.PercentMarkup <> 0)

         WHERE MarginCondition.MinPrice < MovementItem_Income.PriceWithVAT AND MovementItem_Income.PriceWithVAT <= MarginCondition.MaxPrice 
           AND MovementItem_Income.GoodsId = MovementItem_Income_View.GoodsId
           AND MovementItem_Income_View.MovementId = inMovementId);


     IF COALESCE(vbInvNumberPoint, '') = '' THEN 
        -- Определяем, что приход идет на последнее подразделение в ветке
        IF (SELECT Count(*) FROM Object_Unit_View WHERE ParentId = vbToId) = 0 THEN 
           -- считаем номер документа
           vbInvNumberPoint := COALESCE( (WITH tmpMovement AS (SELECT Movement.Id
                                                               FROM Movement
                                                                    INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                                                                  ON MovementLinkObject_To.MovementId = Movement.Id
                                                                                                 AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                                                                 and MovementLinkObject_To.ObjectId = vbToId
                                                               WHERE Movement.DescId = zc_Movement_Income()
                                                               )
                                             , tmpSTR AS (SELECT *
                                                          FROM MovementString  AS MovementString_InvNumberBranch
                                                          WHERE MovementString_InvNumberBranch.MovementId IN ( SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                                            AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()
                                                            AND COALESCE (MovementString_InvNumberBranch.ValueData ,'') <>''
                                                          )
                                             SELECT MAX(zfConvert_StringToNumber(MovementString_InvNumberBranch.ValueData)) + 1 
                                             FROM tmpMovement
                                                  INNER JOIN tmpSTR AS MovementString_InvNumberBranch
                                                                    ON MovementString_InvNumberBranch.MovementId = tmpMovement.Id
                                                                   AND MovementString_InvNumberBranch.DescId = zc_MovementString_InvNumberBranch()
                                          )
           
           /*SELECT MAX(zfConvert_StringToNumber(InvNumberBranch)) + 1 FROM Movement_Income_View WHERE ToId = vbToId*/
                                       , 1);

           PERFORM lpInsertUpdate_MovementString (zc_MovementString_InvNumberBranch(), inMovementId, vbInvNumberPoint::TVarChar);

           PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Branch(), inMovementId, CURRENT_DATE);
        END IF; 
     END IF;


     PERFORM lpInsertUpdate_MovementFloat_TotalSummSale (inMovementId);

     -- сохранили протокол
     -- PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 05.09.19         * учет нового св-ва подразделения TopNo
 29.10.18         * перенесла проверку привязки товара поставщика к товару сети в др. процку
 25.10.18         * проверка привязки товара поставщика к товару сети
 12.06.17         *
 09.12.16         * add ObjectFloat_Contract_Percent
 13.05.15                        *   
 26.01.15                        *   
*/
-- select * from gpUpdate_MovementItem_Income_SendPrice (inMovementId := 11459485  ,  inSession := '3');  
-- vbJuridicalId = 183312