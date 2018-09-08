-- Function: gpSelect_MovementItem_Income()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Check (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Check(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , IntenalSPName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , NDS TFloat
             , PriceSale TFloat
             , SummSale TFloat
             , ChangePercent TFloat
             , SummChangePercent TFloat
             , AmountOrder TFloat
             -- , DiscountCardId Integer
             -- , DiscountCardName TVarChar
             , List_UID TVarChar
             , isErased Boolean
             , isSp Boolean
             , Remains TFloat
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId_SP Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
     vbUserId := inSession;

     vbMovementId_SP := (SELECT Movement.Id
                         FROM Movement 
                              LEFT JOIN MovementString AS MovementString_InvNumberSP
                                     ON MovementString_InvNumberSP.MovementId = Movement.Id
                                    AND MovementString_InvNumberSP.DescId = zc_MovementString_InvNumberSP()
                              LEFT JOIN MovementString AS MovementString_MedicSP
                                     ON MovementString_MedicSP.MovementId = Movement.Id
                                    AND MovementString_MedicSP.DescId = zc_MovementString_MedicSP()
                              LEFT JOIN MovementString AS MovementString_Ambulance
                                     ON MovementString_Ambulance.MovementId = Movement.Id
                                    AND MovementString_Ambulance.DescId = zc_MovementString_Ambulance()
                              LEFT JOIN MovementLinkObject AS MovementLinkObject_PartnerMedical
                                         ON MovementLinkObject_PartnerMedical.MovementId = Movement.Id
                                        AND MovementLinkObject_PartnerMedical.DescId = zc_MovementLinkObject_PartnerMedical()
                          WHERE Movement.Id = inMovementId
                            AND Movement.DescId = zc_Movement_Check()
                            AND ( COALESCE(MovementString_InvNumberSP.ValueData,'') <> '' 
                               OR COALESCE(MovementString_MedicSP.ValueData,'') <> '' 
                               OR COALESCE(MovementString_Ambulance.ValueData,'') <> '' 
                               OR COALESCE(MovementLinkObject_PartnerMedical.ObjectId,0) <> 0)  
                          );   

     RETURN QUERY
       SELECT
             MovementItem.Id
           , MovementItem.ParentId  
           , MovementItem.GoodsId
           , MovementItem.GoodsCode
           , MovementItem.GoodsName
           , Object_IntenalSP.ValueData AS IntenalSPName
           , MovementItem.Amount
           , MovementItem.Price
           , MovementItem.AmountSumm
           , MovementItem.NDS
           , MovementItem.PriceSale
           , (MovementItem.PriceSale * MovementItem.Amount) :: TFloat AS SummSale
           , MovementItem.ChangePercent
           , MovementItem.SummChangePercent
           , MovementItem.AmountOrder
           -- , MovementItem.DiscountCardId
           -- , MovementItem.DiscountCardName
           , MovementItem.List_UID
           , MovementItem.isErased
           , CASE WHEN COALESCE (vbMovementId_SP,0) = 0 THEN False ELSE TRUE END AS isSp
           , MovementItem.Amount
       FROM MovementItem_Check_View AS MovementItem 
            -- получаем GoodsMainId
            LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                  ON ObjectLink_Child.ChildObjectId = MovementItem.GoodsId
                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                  ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                 ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
            LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId

       WHERE MovementItem.MovementId = inMovementId
         -- AND MovementItem.isErased   = FALSE
      ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Check (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А. Воробкало А.А
 21.04.17         *
 10.08.16                                                                      * + MovementItem.LIST_UID
 03.08.16         *
 03.07.15                                                                       * Добавлен НДС
 25.05.15                         *
*/

-- тест
-- select * from gpSelect_MovementItem_Check(inMovementId := 3959328 ,  inSession := '3');