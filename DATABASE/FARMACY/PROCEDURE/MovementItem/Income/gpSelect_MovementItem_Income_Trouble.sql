-- Function: gpSelect_MovementItem_Income_Trouble()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Income_Trouble (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Income_Trouble(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , PartnerGoodsCode TVarChar, PartnerGoodsName TVarChar
             , Amount TFloat
             , AmountManual TFloat
             , PretensionAmount TFloat
             , AmountDiff TFloat
             , ReasonDifferencesId Integer
             , ReasonDifferencesName TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
    vbUserId := inSession;

    RETURN QUERY
    WITH
     tmpPretension AS (SELECT MIFloat_MovementItemId.ValueData::Integer    AS ID
                            , SUM(MI_Pretension.Amount)                    AS Amount
                       FROM MovementLinkMovement AS MLMovement_Pretension
                       
                            LEFT JOIN Movement AS Movement_Pretension
                                                ON Movement_Pretension.ID = MLMovement_Pretension.MovementId
                                               AND Movement_Pretension.DescId = zc_Movement_Pretension()
                                               AND Movement_Pretension.StatusId <> zc_Enum_Status_Erased()
                                                
                            LEFT JOIN MovementItem AS MI_Pretension
                                                    ON MI_Pretension.MovementId = Movement_Pretension.Id
                                                   AND MI_Pretension.isErased   = FALSE 
                                                   AND MI_Pretension.DescId     = zc_MI_Master()
    
                            LEFT JOIN MovementItemFloat AS MIFloat_MovementItemId
                                                        ON MIFloat_MovementItemId.MovementItemId = MI_Pretension.Id
                                                       AND MIFloat_MovementItemId.DescId = zc_MIFloat_MovementItemId()

                            LEFT JOIN MovementItemBoolean AS MIBoolean_Checked
                                                          ON MIBoolean_Checked.MovementItemId = MI_Pretension.Id
                                                         AND MIBoolean_Checked.DescId = zc_MIBoolean_Checked()
                                                         AND MIBoolean_Checked.ValueData = TRUE 

                       WHERE MLMovement_Pretension.MovementChildId = inMovementId
                         AND MLMovement_Pretension.DescId = zc_MovementLinkMovement_Income()
                       GROUP BY MIFloat_MovementItemId.ValueData)
    SELECT
        MovementItem.Id
      , MovementItem.GoodsId
      , MovementItem.GoodsCode
      , MovementItem.GoodsName
      , MovementItem.PartnerGoodsCode
      , MovementItem.PartnerGoodsName
      , MovementItem.Amount
      , MovementItem.AmountManual
      , COALESCE (tmpPretension.Amount,0)::TFloat  AS PretensionAmount
      , (COALESCE(MovementItem.AmountManual,0) - COALESCE(MovementItem.Amount,0))::TFloat as AmountDiff
      , MovementItem.ReasonDifferencesId
      , MovementItem.ReasonDifferencesName      
    FROM 
        MovementItem_Income_View AS MovementItem 
        LEFT JOIN tmpPretension ON tmpPretension.ID =  MovementItem.Id
    WHERE
        MovementItem.MovementId = inMovementId
        AND 
        MovementItem.isErased   = FALSE
        AND
        (COALESCE(MovementItem.AmountManual,0) - COALESCE(MovementItem.Amount,0)) <> 0
        AND
        (COALESCE(MovementItem.AmountManual,0) - COALESCE (tmpPretension.Amount,0) - COALESCE(MovementItem.Amount,0)) <> 0
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Income_Trouble (Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Воробкало А.А.
 18.11.15                                                                        *
*/

select * from gpSelect_MovementItem_Income_Trouble(inMovementId := 26028817 , inSession := '3997718');