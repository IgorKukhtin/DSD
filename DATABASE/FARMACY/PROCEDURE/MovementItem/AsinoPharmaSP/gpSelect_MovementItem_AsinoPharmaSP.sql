 -- Function: gpSelect_MovementItem_AsinoPharmaSP()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_AsinoPharmaSP (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_AsinoPharmaSP(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id                Integer
             , Queue             Integer
             , GoodsName         TBlob
             , Amount            TBlob
             , GoodsNamePresent  TBlob
             , AmountPresent     TBlob
             , isErased          Boolean
             )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_AsinoPharmaSP());
    vbUserId:= lpGetUserBySession (inSession);

    
    RETURN QUERY
    WITH
         tmpMIChild AS (SELECT MovementItem.ParentId
                             , string_agg(Object_Goods.Name, chr(13)) AS Name
                             , string_agg(zfConvert_FloatToString(MovementItem.Amount), ' + ') AS Amount
                        FROM MovementItem

                             LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                        WHERE MovementItem.DescId = zc_MI_Child()
                          AND MovementItem.MovementId = inMovementId
                          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                        GROUP BY MovementItem.ParentId
                        )
      ,  tmpMISecond AS (SELECT MovementItem.ParentId
                             , string_agg(Object_Goods.Name, chr(13)) AS Name
                             , string_agg(zfConvert_FloatToString(MovementItem.Amount), ' + ') AS Amount
                         FROM MovementItem

                              LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                         WHERE MovementItem.DescId = zc_MI_Second()
                           AND MovementItem.MovementId = inMovementId
                           AND (MovementItem.isErased = FALSE OR inIsErased = TRUE)
                         GROUP BY MovementItem.ParentId
                        )

        SELECT MovementItem.Id                                        AS Id
             , MovementItem.Amount::Integer                           AS Queue
             , COALESCE(tmpMIChild.Name, 'Не определено')::TBlob      AS GoodsName 
             , COALESCE(tmpMIChild.Amount, '')::TBlob                 AS Amount 
             , COALESCE(tmpMISecond.Name, 'Не определено')::TBlob     AS GoodsNamePresent 
             , COALESCE(tmpMISecond.Amount, '')::TBlob                AS AmountPresent 

             , MovementItem.isErased                                  AS isErased

        FROM MovementItem
        
             LEFT JOIN tmpMIChild ON tmpMIChild.ParentId = MovementItem.Id

             LEFT JOIN tmpMISecond ON tmpMISecond.ParentId = MovementItem.Id


        WHERE MovementItem.DescId = zc_MI_Master()
          AND MovementItem.MovementId = inMovementId
          AND (MovementItem.isErased = FALSE OR inIsErased = TRUE);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 07.04.22                                                       *
*/

--ТЕСТ
-- 

select * from gpSelect_MovementItem_AsinoPharmaSP(inMovementId := 27423073 , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
