-- Function: gpSelect_ShowPUSH_Calculate_OrderInternal(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_Calculate_OrderInternal(integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_Calculate_OrderInternal(
    IN inMovementID   integer,          -- Документ
    IN inSession      TVarChar          -- сессия пользователя
)
RETURNS TABLE (ShowMessage Boolean,          -- Показыват сообщение
               PUSHType    Integer,          -- Тип сообщения
               Text        Text              -- Текст сообщения
              )
AS
$BODY$
   DECLARE vbUserId    Integer;
   DECLARE vbStatusId  Integer;
   DECLARE vbUnitId    Integer;
   DECLARE vbPartnerMedicalId Integer;
   DECLARE vbText      Text;
   DECLARE vbDate180 TDateTime;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);

     -- ПАРАМЕТРЫ
    SELECT Movement.StatusId, MovementLinkObject_Unit.ObjectId, ObjectLink_Unit_PartnerMedical.ChildObjectId
    INTO vbStatusId, vbUnitId, vbPartnerMedicalId
    FROM Movement
         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
         LEFT JOIN ObjectLink AS ObjectLink_Unit_PartnerMedical
                              ON ObjectLink_Unit_PartnerMedical.ObjectId = MovementLinkObject_Unit.ObjectId
                             AND ObjectLink_Unit_PartnerMedical.DescId = zc_ObjectLink_Unit_PartnerMedical()
    WHERE Movement.Id = inMovementId;

    vbDate180 := CURRENT_DATE + zc_Interval_ExpirationDate()+ zc_Interval_ExpirationDate();   -- нужен 1 год (функция =6 мес.)
    
    CREATE TEMP TABLE tmpResult (ShowMessage Boolean, PUSHType Integer, Text Text) ON COMMIT DROP;
    
    CREATE TEMP TABLE _tmpMIOrderInternal ON COMMIT DROP AS (
        SELECT MovementItem.GoodsId,
               MovementItem.CalcAmountAll, 
               MovementItem.JuridicalId, 
               MovementItem.PartionGoodsDate,
               MovementItem.Comment,
               MovementItem.ListDiffAmount,
               MovementItem.DPriceOOC1303,
               MovementItem.DiscountName
        FROM gpSelect_MovementItem_OrderInternal_Master(inMovementId := inMovementID , inShowAll := 'False' , inIsErased := 'False' , inIsLink := 'False' ,  inSession := inSession) AS MovementItem);
    
    -- Для товаров дисконтных программ надо использовать поставщиков
    WITH
        tmpMI_All AS (SELECT MovementItem.GoodsId,
                             MovementItem.CalcAmountAll, 
                             MovementItem.JuridicalId
                      FROM _tmpMIOrderInternal AS MovementItem 
                      WHERE MovementItem.CalcAmountAll   > 0
                        AND COALESCE (MovementItem.DiscountName, '') <> ''
                        AND COALESCE (MovementItem.JuridicalId, 0) <> 0
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
                              
    SELECT string_agg(Object_Goods_Main.ObjectCode||' - '||Object_Goods_Main.Name||Chr(13)||'   НЕПРАВИЛЬНО ВЫБРАН: '||COALESCE (Object_Juridical.ValueData, '')||'. НУЖНО ИСПРАВИТЬ  НА: '||COALESCE (tmpGoodsDiscount.DiscountJuridical, ''), Chr(13))
    INTO vbText
    FROM tmpMI_All

         INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmpMI_All.GoodsId
         
         INNER JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId

         INNER JOIN tmpGoodsDiscount ON tmpGoodsDiscount.GoodsMainId = Object_Goods_Main.Id

         LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = tmpMI_All.JuridicalId
         
    WHERE ','||tmpGoodsDiscount.JuridicalId||',' NOT LIKE '%,'||COALESCE(tmpMI_All.JuridicalId, 0)||',%';
    
    IF COALESCE (vbText, '') > ''
    THEN
      INSERT INTO  tmpResult (ShowMessage, PUSHType, Text)
      SELECT True, zc_TypePUSH_Confirmation(), 'Для товаров дисконтных программ надо использовать поставщиков:'||Chr(13)||Chr(13)||vbText;
    END IF;
    
    -- У товаров срок годности менее 1 года

    WITH
        tmpMI_All AS (SELECT MovementItem.GoodsId,
                             MovementItem.CalcAmountAll, 
                             MovementItem.JuridicalId, 
                             MovementItem.PartionGoodsDate,
                             MovementItem.Comment,
                             MovementItem.ListDiffAmount
                      FROM _tmpMIOrderInternal AS MovementItem 
                      WHERE MovementItem.CalcAmountAll > 0
                      ORDER BY MovementItem.PartionGoodsDate
                      ),
        tmpNTZ AS (SELECT string_agg(zfConvert_DateShortToString (tmpMI_All.PartionGoodsDate)||' '|| COALESCE(tmpMI_All.Comment, '')||
                                     ' '||Object_Goods_Main.ObjectCode||' - '||Object_Goods_Main.Name, Chr(13)||Chr(13)) AS Goods
                   FROM tmpMI_All

                        INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmpMI_All.GoodsId
                         
                        INNER JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                         
                   WHERE tmpMI_All.PartionGoodsDate < vbDate180
                     AND COALESCE (tmpMI_All.ListDiffAmount, 0) = 0),
        tmpListDiff AS (SELECT string_agg(zfConvert_DateShortToString (tmpMI_All.PartionGoodsDate)||' '|| COALESCE(tmpMI_All.Comment, '')||
                                     ' '||Object_Goods_Main.ObjectCode||' - '||Object_Goods_Main.Name, Chr(13)||Chr(13)) AS Goods
                        FROM tmpMI_All

                             INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmpMI_All.GoodsId
                               
                             INNER JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                               
                        WHERE tmpMI_All.PartionGoodsDate < vbDate180
                          AND COALESCE (tmpMI_All.ListDiffAmount, 0) > 0)
                          
    SELECT COALESCE (Chr(13)||Chr(13)||'Из АВТОЗАКАЗА по НТЗ:'||Chr(13)||tmpNTZ.Goods, '')||
           COALESCE (Chr(13)||Chr(13)||'Из  ЛИСТА ОТКАЗА:'||Chr(13)||tmpListDiff.Goods, '')
    INTO vbText
    FROM tmpNTZ
         
         FULL JOIN tmpListDiff ON 1 = 1;
         
         
    --raise notice 'Value: %', vbText;
    
    IF COALESCE (vbText, '') > ''
    THEN
      INSERT INTO  tmpResult (ShowMessage, PUSHType, Text)
      SELECT True, zc_TypePUSH_Confirmation(), 'У товаров срок годности менее 1 года:'||vbText;
    END IF;

    -- Цена поставщика без НДС больше максимально допустимой
    
    IF COALESCE (vbPartnerMedicalId, 0) <> 0
    THEN    
      WITH
          tmpMI_All AS (SELECT MovementItem.GoodsId,
                               MovementItem.CalcAmountAll, 
                               MovementItem.JuridicalId, 
                               MovementItem.PartionGoodsDate,
                               MovementItem.Comment,
                               MovementItem.ListDiffAmount
                        FROM _tmpMIOrderInternal AS MovementItem 
                        WHERE MovementItem.Comment ILIKE '%1303%'
                          AND MovementItem.DPriceOOC1303 < 0

                        
                        ORDER BY MovementItem.PartionGoodsDate
                        ),
          tmpGROUP AS (SELECT string_agg(COALESCE(tmpMI_All.Comment, '')||
                                         ' '||Object_Goods_Main.ObjectCode||' - '||Object_Goods_Main.Name, Chr(13)||Chr(13)) AS Goods
                       FROM tmpMI_All

                            INNER JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = tmpMI_All.GoodsId
                             
                            INNER JOIN Object_Goods_Main AS Object_Goods_Main ON Object_Goods_Main.Id = Object_Goods_Retail.GoodsMainId
                             
                       )
                            
      SELECT COALESCE (Chr(13)||Chr(13)||tmpGROUP.Goods, '')
      INTO vbText
      FROM tmpGROUP;
                    
      --raise notice 'Value: %', vbText;
      
      IF COALESCE (vbText, '') > ''
      THEN
        INSERT INTO  tmpResult (ShowMessage, PUSHType, Text)
        SELECT True, zc_TypePUSH_Confirmation(), 'Цена поставщика без НДС больше максимально допустимой:'||vbText;
      END IF;
    END IF;
    
    -- Результат
    RETURN QUERY
    SELECT tmpResult.ShowMessage, tmpResult.PUSHType, tmpResult.Text
    FROM tmpResult;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.12.21                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_OOC1303_CalculateOrderInternal(22749117, '3')

select * from gpSelect_ShowPUSH_Calculate_OrderInternal(inMovementID := 22824229 ,  inSession := '3');