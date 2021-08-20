-- Function: gpSelect_MovementItem_ListDiffFormVIPSend()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_ListDiffFormVIPSend (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ListDiffFormVIPSend(
    IN inUnitId     Integer      , -- Подразделение
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , MovementId Integer
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , DiffKindId Integer, DiffKindName TVarChar
             , Amount TFloat
             , Price TFloat
             , Summa TFloat
             , Comment    TVarChar
             , UnitSendId Integer, UnitSendCode Integer, UnitSendName TVarChar
             , AmountSend TFloat
             , isUrgently Boolean, isOrder Boolean
             , isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbObjectId Integer;
  DECLARE vbUnitId Integer;
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());
   vbUserId := inSession;
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   RETURN QUERY
   WITH
        -- документы отказа
        tmpListDiff AS (SELECT Movement.*
                             , MovementLinkObject_Unit.ObjectId AS UnitId
                        FROM Movement
                             INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                           ON MovementLinkObject_Unit.MovementId = Movement.Id
                                                          AND MovementLinkObject_UNit.DescId = zc_MovementLinkObject_Unit()
                                                          AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                        WHERE Movement.DescId = zc_Movement_ListDiff() 
                          AND Movement.StatusId = zc_Enum_Status_UnComplete()
                          AND Movement.OperDate >= '17.08.2021'
                       )
        -- строки документа отказ
      , tmpListDiff_MI_All AS (SELECT MovementItem.*
                                    , Object_DiffKind.ValueData ::TVarChar AS DiffKindName
                               FROM tmpListDiff
                                    INNER JOIN MovementItem ON MovementItem.MovementId = tmpListDiff.Id
                                                           AND MovementItem.DescId     = zc_MI_Master()
                                                           AND MovementItem.isErased   = FALSE
                                    INNER JOIN MovementItemBoolean AS MIBoolean_VIPSend
                                                                   ON MIBoolean_VIPSend.MovementItemId = MovementItem.Id
                                                                  AND MIBoolean_VIPSend.DescId = zc_MIBoolean_VIPSend()
                                                                  AND MIBoolean_VIPSend.ValueData = TRUE
                                    LEFT JOIN MovementItemLinkObject AS MILO_DiffKind
                                                                     ON MILO_DiffKind.MovementItemId = MovementItem.Id
                                                                    AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()
                                    LEFT JOIN Object AS Object_DiffKind ON Object_DiffKind.Id = MILO_DiffKind.ObjectId

                                    LEFT JOIN ObjectBoolean AS ObjectBoolean_DiffKind_Close
                                                            ON ObjectBoolean_DiffKind_Close.ObjectId = MILO_DiffKind.ObjectId
                                                           AND ObjectBoolean_DiffKind_Close.DescId = zc_ObjectBoolean_DiffKind_Close()
                               WHERE COALESCE (ObjectBoolean_DiffKind_Close.ValueData, FALSE) = FALSE                         -- берем все строки кроме закрытых для заказа (св-во вид отказа)
                           )
        -- свойство строк <Id док. заказа>
      , tmpMI_MovementId AS (SELECT MovementItemFloat.*
                             FROM MovementItemFloat
                             WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpListDiff_MI_All.Id FROM tmpListDiff_MI_All)
                               AND MovementItemFloat.DescId = zc_MIFloat_MovementId()
                               AND COALESCE (MovementItemFloat.ValueData, 0) <> 0 
                            )
      , tmpMI_Comment AS (SELECT MovementItemString.*
                          FROM MovementItemString
                          WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpListDiff_MI_All.Id FROM tmpListDiff_MI_All)
                            AND MovementItemString.DescId = zc_MIString_Comment()
                          )
                                                 
      SELECT tmpListDiff_MI_All.Id                             AS Id
           , tmpListDiff_MI_All.MovementId                     AS MovementId
           
           , Object_Unit.Id                                    AS UnitId
           , Object_Unit.ObjectCode                            AS UnitCode
           , Object_Unit.ValueData                             AS UnitName
           
           , tmpListDiff_MI_All.ObjectId                       AS GoodsId
           , Object_Goods.ObjectCode                           AS GoodsCode
           , Object_Goods.ValueData                            AS GoodsName

           , Object_DiffKind.Id                                AS DiffKindId
           , Object_DiffKind.ValueData                         AS DiffKindName
           
           , tmpListDiff_MI_All.Amount                         AS Amount
           , MIFloat_Price.ValueData     ::TFloat              AS Price
           , (tmpListDiff_MI_All.Amount * MIFloat_Price.ValueData) ::TFloat AS Summa
           , COALESCE (tmpMI_Comment.ValueData, '') ::TVarChar AS Comment
           
           , Null::Integer AS UnitSendId, Null::Integer AS UnitSendCode, Null::TVarChar AS UnitSendName
           , Null::TFloat AS AmountSend
           , False AS isUrgently, False AS isOrder
           , False isErased 
      FROM tmpListDiff_MI_All

           LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = tmpListDiff_MI_All.MovementId  
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
           LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                                       
           LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpListDiff_MI_All.ObjectId 

           LEFT JOIN tmpMI_MovementId ON tmpMI_MovementId.MovementItemId = tmpListDiff_MI_All.Id
           LEFT JOIN tmpMI_Comment    ON tmpMI_Comment.MovementItemId    = tmpListDiff_MI_All.Id

           LEFT JOIN MovementItemLinkObject AS MILO_DiffKind
                                            ON MILO_DiffKind.MovementItemId = tmpListDiff_MI_All.Id
                                           AND MILO_DiffKind.DescId = zc_MILinkObject_DiffKind()
           LEFT JOIN Object AS Object_DiffKind ON Object_DiffKind.Id = MILO_DiffKind.ObjectId 

           LEFT JOIN MovementItemFloat AS MIFloat_Price
                                       ON MIFloat_Price.MovementItemId = tmpListDiff_MI_All.Id
                                      AND MIFloat_Price.DescId = zc_MIFloat_Price()
                                
      WHERE tmpMI_MovementId.ValueData IS NULL;
           
               
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 18.08.21                                                       *
*/

-- тест
-- 

select * from gpSelect_MovementItem_ListDiffFormVIPSend(inUnitId := 16001195 ,  inSession := '3');