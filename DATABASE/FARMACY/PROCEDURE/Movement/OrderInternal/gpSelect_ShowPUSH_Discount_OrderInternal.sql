-- Function: gpSelect_ShowPUSH_Discount_OrderInternal(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_Discount_OrderInternal(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_Discount_OrderInternal(
    IN inMovementID   integer,          -- Документ
   OUT outShowMessage Boolean,          -- Показыват сообщение
   OUT outPUSHType    Integer,          -- Тип сообщения
   OUT outText        Text,             -- Текст сообщения
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStatusId  Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbText      Text;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);

    outShowMessage := False;

     -- ПАРАМЕТРЫ
    SELECT Movement.StatusId, MovementLinkObject_Unit.ObjectId
    INTO vbStatusId, vbUnitId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;

    WITH
        tmpMI_All AS (SELECT MovementItem.*,
                             CEIL (( CASE WHEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >= (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))
                                          THEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- Спецзаказ + Количество дополнительное
                                          ELSE (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))     -- кол-во отказов + СУА
                                     END
                                     ) / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)
                                   ) * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)                     AS CalcAmountAll, 
                             MILinkObject_Juridical.ObjectId                                                   AS JuridicalId 
                      FROM MovementItem 

                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                                               AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond() 
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountManual ON MIFloat_AmountManual.MovementItemId = MovementItem.Id
                                                                               AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual() 
                            LEFT JOIN MovementItemFloat     AS MIFloat_ListDiff ON MIFloat_ListDiff.MovementItemId    = MovementItem.Id
                                                                               AND MIFloat_ListDiff.DescId = zc_MIFloat_ListDiff() 
                            LEFT JOIN MovementItemFloat    AS MIFloat_AmountSUA ON MIFloat_AmountSUA.MovementItemId    = MovementItem.Id
                                                                               AND MIFloat_AmountSUA.DescId = zc_MIFloat_AmountSUA() 
                                                                               
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical ON MILinkObject_Juridical.MovementItemId    = MovementItem.Id
                                                                                      AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
                            LEFT JOIN ObjectFloat  AS ObjectFloat_Goods_MinimumLot
                                                   ON ObjectFloat_Goods_MinimumLot.ObjectId = MovementItem.ObjectId
                                                  AND ObjectFloat_Goods_MinimumLot.DescId = zc_ObjectFloat_Goods_MinimumLot()
                                                  AND ObjectFloat_Goods_MinimumLot.ValueData <> 0

                      WHERE MovementItem.MovementId = inMovementId
                        AND MovementItem.DescId     = zc_MI_Master()
                        AND CEIL (( CASE WHEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) >= (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))
                                         THEN (COALESCE (MovementItem.Amount, 0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))         -- Спецзаказ + Количество дополнительное
                                         ELSE (COALESCE (MIFloat_ListDiff.ValueData, 0) + COALESCE (MIFloat_AmountSUA.ValueData, 0))     -- кол-во отказов + СУА
                                    END
                                    ) / COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)
                                  ) * COALESCE(ObjectFloat_Goods_MinimumLot.ValueData, 1)     > 0
                        AND MovementItem.isErased   = False
                      )
      -- Дисконтные программы подразделения
      , tmpDiscountJuridical AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                      , STRING_AGG(CASE WHEN ObjectLink_Juridical.ChildObjectId = 59611 
                                                        THEN 'Оптима' 
                                                        ELSE Object_Juridical.ValueData END, ', ')  AS JuridicalName
                                      , STRING_AGG(Object_Juridical.ID::TVarChar, ',')             AS JuridicalId
                                 FROM Object AS Object_DiscountExternalSupplier
                                      LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                           ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalSupplier.Id
                                                          AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalSupplier_DiscountExternal()

                                       LEFT JOIN ObjectLink AS ObjectLink_Juridical
                                                            ON ObjectLink_Juridical.ObjectId = Object_DiscountExternalSupplier.Id
                                                           AND ObjectLink_Juridical.DescId = zc_ObjectLink_DiscountExternalSupplier_Juridical()
                                       LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Juridical.ChildObjectId

                                  WHERE Object_DiscountExternalSupplier.DescId = zc_Object_DiscountExternalSupplier()
                                    AND Object_DiscountExternalSupplier.isErased = FALSE
                                  GROUP BY ObjectLink_DiscountExternal.ChildObjectId )
      -- Дисконтные программы подразделения
      , tmpUnitDiscount AS (SELECT ObjectLink_DiscountExternal.ChildObjectId     AS DiscountExternalId
                                 , tmpDiscountJuridical.JuridicalName::TVarChar  AS JuridicalName
                                 , tmpDiscountJuridical.JuridicalId::TVarChar    AS JuridicalId
                            FROM Object AS Object_DiscountExternalTools
                                  LEFT JOIN ObjectLink AS ObjectLink_DiscountExternal
                                                       ON ObjectLink_DiscountExternal.ObjectId = Object_DiscountExternalTools.Id
                                                      AND ObjectLink_DiscountExternal.DescId = zc_ObjectLink_DiscountExternalTools_DiscountExternal()
                                  LEFT JOIN ObjectLink AS ObjectLink_Unit
                                                       ON ObjectLink_Unit.ObjectId = Object_DiscountExternalTools.Id
                                                      AND ObjectLink_Unit.DescId = zc_ObjectLink_DiscountExternalTools_Unit()
                                  LEFT JOIN tmpDiscountJuridical ON tmpDiscountJuridical.DiscountExternalId = ObjectLink_DiscountExternal.ChildObjectId
                             WHERE Object_DiscountExternalTools.DescId = zc_Object_DiscountExternalTools()
                               AND ObjectLink_Unit.ChildObjectId = vbUnitId
                               AND Object_DiscountExternalTools.isErased = False
                             )
      -- Товары дисконтной программы
      , tmpGoodsDiscount AS (SELECT 
                                   Object_Goods_Retail.GoodsMainId
                                           
                                 , Object_Object.Id                AS ObjectId
                                 , Object_Object.ValueData         AS DiscountName 
                                 , tmpUnitDiscount.JuridicalName   AS DiscountJuridical
                                 , tmpUnitDiscount.JuridicalId     AS JuridicalId
                                 
                             FROM Object AS Object_BarCode
                                 LEFT JOIN ObjectLink AS ObjectLink_BarCode_Goods
                                                      ON ObjectLink_BarCode_Goods.ObjectId = Object_BarCode.Id
                                                     AND ObjectLink_BarCode_Goods.DescId = zc_ObjectLink_BarCode_Goods()
                                 LEFT JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = ObjectLink_BarCode_Goods.ChildObjectId
                                 
                                 LEFT JOIN ObjectLink AS ObjectLink_BarCode_Object
                                                      ON ObjectLink_BarCode_Object.ObjectId = Object_BarCode.Id
                                                     AND ObjectLink_BarCode_Object.DescId = zc_ObjectLink_BarCode_Object()
                                 LEFT JOIN Object AS Object_Object ON Object_Object.Id = ObjectLink_BarCode_Object.ChildObjectId           

                                 LEFT JOIN tmpUnitDiscount ON tmpUnitDiscount.DiscountExternalId = ObjectLink_BarCode_Object.ChildObjectId 

                             WHERE Object_BarCode.DescId = zc_Object_BarCode()
                               AND Object_BarCode.isErased = False
                               AND Object_Object.isErased = False
                               AND COALESCE (tmpUnitDiscount.DiscountExternalId, 0) <> 0
                      )
                              
    SELECT string_agg(Object_Goods_Main.ObjectCode||' - '||Object_Goods_Main.Name||Chr(13)||'   Выбран: '||COALESCE (Object_Juridical.ValueData, '')||'. По программе: '||COALESCE (tmpGoodsDiscount.DiscountJuridical, ''), Chr(13))
    INTO vbText
    FROM tmpMI_All

         INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmpMI_All.ObjectId
         
         INNER JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

         INNER JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Object_Goods_Main.Id

         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpMI_All.JuridicalId
         
    WHERE ','||tmpGoodsDiscount.JuridicalId||',' NOT LIKE '%,'||COALESCE(tmpMI_All.JuridicalId, 0)||',%';
    
    IF COALESCE (vbText, '') > ''
    THEN
      outShowMessage := True;
      outPUSHType := 3;
      outText := 'Для товаров дисконтных программ надо использовать поставщиков:'||Chr(13)||Chr(13)||vbText;
    END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.04.21                                                       *

*/

--
SELECT * FROM gpSelect_ShowPUSH_Discount_OrderInternal(22749117, '3')