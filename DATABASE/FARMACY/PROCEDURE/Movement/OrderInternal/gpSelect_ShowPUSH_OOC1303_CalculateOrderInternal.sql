-- Function: gpSelect_ShowPUSH_OOC1303_CalculateOrderInternal(TVarChar)

DROP FUNCTION IF EXISTS gpSelect_ShowPUSH_OOC1303_CalculateOrderInternal(integer,TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_ShowPUSH_OOC1303_CalculateOrderInternal(
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
   DECLARE vbPartnerMedicalId Integer;
   DECLARE vbText      Text;
BEGIN

    vbUserId:= lpGetUserBySession (inSession);

    outShowMessage := False;
    
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
    
    IF COALESCE (vbPartnerMedicalId, 0) = 0
    THEN
      RETURN;
    END IF;
    
    WITH
        tmpMI_All AS (SELECT MovementItem.GoodsId,
                             MovementItem.CalcAmountAll, 
                             MovementItem.JuridicalId, 
                             MovementItem.PartionGoodsDate,
                             MovementItem.Comment,
                             MovementItem.ListDiffAmount
                      FROM gpSelect_MovementItem_OrderInternal_Master(inMovementId := inMovementID , inShowAll := 'False' , inIsErased := 'False' , inIsLink := 'False' ,  inSession := inSession) AS MovementItem 


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
      outShowMessage := True;
      outPUSHType := zc_TypePUSH_Confirmation();
      outText := 'Цена поставщика без НДС больше максимально допустимой:'||vbText;
    END IF;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.12.21                                                       *

*/

-- SELECT * FROM gpSelect_ShowPUSH_OOC1303_CalculateOrderInternal(22749117, '3')

select * from gpSelect_ShowPUSH_OOC1303_CalculateOrderInternal(inMovementID := 28758254 ,  inSession := '3');