-- Function: gpSelect_MovementItem_ReturnIn()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnIn(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , MI_Id_Check Integer, InvNumber_Check_Full TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summ TFloat
             , NDS TFloat
             , List_UID TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpReturnInRight (inSession, zc_Enum_Process_Select_MovementItem_ReturnIn());
     vbUserId := inSession;

     vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

    --Определили подразделение для розничной цены и дату для остатка
    SELECT 
        MovementLinkObject_Unit.ObjectId
    INTO 
        vbUnitId
    FROM Movement
        INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                      ON MovementLinkObject_Unit.MovementId = Movement.Id
                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
    WHERE Movement.Id = inMovementId;
    
    IF inShowAll THEN
     RETURN QUERY
     WITH 
        tmpGoods AS (SELECT ObjectLink_Goods_Object.ObjectId                 AS Id
                          , Object_Goods.ObjectCode                          AS GoodsCodeInt
                          , Object_Goods.ValueData                           AS GoodsName
                          , Object_Goods.isErased                            AS isErased
                      FROM ObjectLink AS ObjectLink_Goods_Object
                           LEFT JOIN Object AS Object_Goods 
                                            ON Object_Goods.Id = ObjectLink_Goods_Object.ObjectId 
               
                      WHERE ObjectLink_Goods_Object.DescId = zc_ObjectLink_Goods_Object()
                        AND ObjectLink_Goods_Object.ChildObjectId = vbObjectId
                        AND Object_Goods.isErased = FALSE
                     )

      , tmpPrice AS (SELECT Price_Goods.ChildObjectId               AS GoodsId
                          , ROUND(Price_Value.ValueData,2)::TFloat  AS Price 
                     FROM ObjectLink AS ObjectLink_Price_Unit
                        LEFT JOIN ObjectLink AS Price_Goods
                               ON Price_Goods.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_Goods.DescId = zc_ObjectLink_Price_Goods()
                        LEFT JOIN ObjectFloat AS Price_Value
                               ON Price_Value.ObjectId = ObjectLink_Price_Unit.ObjectId
                              AND Price_Value.DescId   = zc_ObjectFloat_Price_Value()
                     WHERE ObjectLink_Price_Unit.DescId = zc_ObjectLink_Price_Unit()
                       AND ObjectLink_Price_Unit.ChildObjectId = vbUnitId  
                    )
    
            -- результат
            SELECT 0                                     AS Id
                 , 0                                     AS MI_Id_Check
                 , NULL                     :: TVarChar  AS InvNumber_Check_Full
                 , tmpGoods.Id                           AS GoodsId
                 , tmpGoods.GoodsCodeInt                 AS GoodsCode
                 , tmpGoods.GoodsName                    AS GoodsName
                 , 0                        :: TFloat    AS Amount
                 , tmpPrice.Price                        AS Price
                 , 0                        :: TFloat    AS Summ
                 , ObjectFloat_NDSKind_NDS.ValueData     AS NDS
                 , NULL                     :: TVarChar  AS List_UID
                 , FALSE                                 AS isErased
            FROM tmpGoods
                LEFT OUTER JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.Id

                LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                     ON ObjectLink_Goods_NDSKind.ObjectId = tmpGoods.Id
                                    AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
    
                LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                      ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                     AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
            UNION 
            SELECT MovementItem.Id
                 , MovementItem_Check.Id      AS MI_Id_Check 
                 , ('№ ' || Movement_Check.InvNumber || ' от ' || Movement_Check.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Check_Full
                 , Object_Goods.Id            AS GoodsId
                 , Object_Goods.ObjectCode    AS GoodsCode
                 , Object_Goods.ValueData     AS GoodsName
                 , MovementItem.Amount        AS Amount
                 , MIFloat_Price.ValueData    AS Price
                 , (MIFloat_Price.ValueData * MovementItem.Amount) :: TFloat AS Summ
                 , ObjectFloat_NDSKind_NDS.ValueData  AS NDS
                 , MIString_UID.ValueData     AS List_UID
                 , MovementItem.isErased      AS isErased
                 
            FROM  MovementItem
                  LEFT JOIN MovementItemFloat AS MIFloat_Price
                                              ON MIFloat_Price.MovementItemId = MovementItem.Id
                                             AND MIFloat_Price.DescId = zc_MIFloat_Price()
      
                  LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                              ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                             AND MIFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                  LEFT JOIN MovementItem AS MovementItem_Check ON MovementItem_Check.Id = MIFloat_MovementItemId.ValueData :: Integer
                  LEFT JOIN Movement AS Movement_Check ON Movement_Check.Id = MovementItem_Check.MovementId
      
                  LEFT JOIN MovementItemString AS MIString_UID
                                               ON MIString_UID.MovementItemId = MovementItem.Id
                                              AND MIString_UID.DescId = zc_MIString_UID()
                 
                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
      
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                       ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
                  LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId
      
                  LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                        ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                       AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()
      
            WHERE MovementItem.MovementId = inMovementId
              AND MovementItem.DescId     = zc_MI_Master()
              AND (MovementItem.isErased = FALSE OR inIsErased = TRUE) 
         ;
     ELSE

     -- Результат
     RETURN QUERY
       SELECT
             MovementItem.Id
           , MovementItem_Check.Id      AS MI_Id_Check 
           , ('№ ' || Movement_Check.InvNumber || ' от ' || Movement_Check.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Check_Full
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , MovementItem.Amount        AS Amount
           , MIFloat_Price.ValueData    AS Price
           , (MIFloat_Price.ValueData * MovementItem.Amount) :: TFloat AS Summ
           , ObjectFloat_NDSKind_NDS.ValueData  AS NDS
           , MIString_UID.ValueData     AS List_UID
           , MovementItem.isErased      AS isErased
           
       FROM  MovementItem
            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                        ON MIFloat_MovementItemId.MovementItemId = MovementItem.Id
                                       AND MIFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
            LEFT JOIN MovementItem AS MovementItem_Check ON MovementItem_Check.Id = MIFloat_MovementItemId.ValueData :: Integer
            LEFT JOIN Movement AS Movement_Check ON Movement_Check.Id = MovementItem_Check.MovementId

            LEFT JOIN MovementItemString AS MIString_UID
                                         ON MIString_UID.MovementItemId = MovementItem.Id
                                        AND MIString_UID.DescId = zc_MIString_UID()
           
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Goods_NDSKind
                                 ON ObjectLink_Goods_NDSKind.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_NDSKind.DescId = zc_ObjectLink_Goods_NDSKind()
            LEFT JOIN Object AS Object_NDSKind ON Object_NDSKind.Id = ObjectLink_Goods_NDSKind.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_NDSKind_NDS
                                  ON ObjectFloat_NDSKind_NDS.ObjectId = ObjectLink_Goods_NDSKind.ChildObjectId 
                                 AND ObjectFloat_NDSKind_NDS.DescId = zc_ObjectFloat_NDSKind_NDS()

            -- получаем GoodsMainId
            /*LEFT JOIN  ObjectLink AS ObjectLink_Child 
                                  ON ObjectLink_Child.ChildObjectId = MovementItem.GoodsId
                                 AND ObjectLink_Child.DescId = zc_ObjectLink_LinkGoods_Goods()
            LEFT JOIN  ObjectLink AS ObjectLink_Main 
                                  ON ObjectLink_Main.ObjectId = ObjectLink_Child.ObjectId
                                 AND ObjectLink_Main.DescId = zc_ObjectLink_LinkGoods_GoodsMain()
            LEFT JOIN ObjectLink AS ObjectLink_Goods_IntenalSP
                                 ON ObjectLink_Goods_IntenalSP.ObjectId = ObjectLink_Main.ChildObjectId 
                                AND ObjectLink_Goods_IntenalSP.DescId = zc_ObjectLink_Goods_IntenalSP()
            LEFT JOIN Object AS Object_IntenalSP ON Object_IntenalSP.Id = ObjectLink_Goods_IntenalSP.ChildObjectId
            */
       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId     = zc_MI_Master()
         AND (MovementItem.isErased = FALSE OR inIsErased = TRUE) 
      ;
     END IF;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 19.01.19         *
*/

-- тест
-- select * from gpSelect_MovementItem_ReturnIn(inMovementId := 0 ,  inShowAll := TRUE, inIsErased := FALSE, inSession := '3');