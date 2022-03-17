-- Function: gpSelect_SendToSendPDChange_PUSH_Cash()

DROP FUNCTION IF EXISTS gpSelect_SendToSendPDChange_PUSH_Cash (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_SendToSendPDChange_PUSH_Cash(
    IN inMovementID    Integer    , -- Movement PUSH
    IN inUnitID        Integer    , -- Подразделение
    IN inUserId        Integer      -- Мотрудник
)
RETURNS TABLE (Message TBlob
             , FormName TVarChar
             , Button TVarChar
             , Params TVarChar
             , TypeParams TVarChar
             , ValueParams TVarChar)

AS
$BODY$
  DECLARE vbDateViewed TDateTime;
BEGIN

    RETURN QUERY
    WITH tmpMI AS (SELECT MovementItem.Id
                        , MovementItem.ObjectId
                        , MovementItem.Amount
                        , Object_CommentSun.ValueData       AS CommentSunName
                   FROM ObjectBoolean AS ObjectBoolean_CommentSun_SendPartionDate

                        INNER JOIN Object AS Object_CommentSun
                                          ON Object_CommentSun.Id = ObjectBoolean_CommentSun_SendPartionDate.ObjectId
                                         AND Object_CommentSun.isErased = FALSE

                        INNER JOIN MovementItemLinkObject AS MILinkObject_CommentSend
                                                          ON MILinkObject_CommentSend.ObjectId = Object_CommentSun.Id
                                                         AND MILinkObject_CommentSend.DescId = zc_MILinkObject_CommentSend()

                        INNER JOIN MovementItem ON MovementItem.ID = MILinkObject_CommentSend.MovementItemId

                        LEFT JOIN MovementItemFloat AS MIFloat_MISendPDChangeId
                                                    ON MIFloat_MISendPDChangeId.MovementItemId = MovementItem.ID
                                                   AND MIFloat_MISendPDChangeId.DescId = zc_MIFloat_MISendPDChangeId()

                        LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                     ON MovementLinkObject_From.MovementId = MovementItem.MovementId
                                                    AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()

                        LEFT JOIN MovementDate AS MovementDate_Insert
                                               ON MovementDate_Insert.MovementId = MovementItem.MovementId
                                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                                              
                   WHERE ObjectBoolean_CommentSun_SendPartionDate.DescId = zc_ObjectBoolean_CommentSun_SendPartionDate()
                     AND ObjectBoolean_CommentSun_SendPartionDate.ValueData = TRUE
                     AND COALESCE(MIFloat_MISendPDChangeId.ValueData, 0) = 0
                     AND MovementLinkObject_From.ObjectId = inUnitID
                     AND MovementDate_Insert.ValueData >= CURRENT_DATE - INTERVAL '30 DAY')
       , tmpProtocolAll AS (SELECT  MovementItem.Id
                                  , SUBSTRING(MovementItemProtocol.ProtocolData, POSITION('Значение' IN MovementItemProtocol.ProtocolData) + 24, 50) AS ProtocolData
                                  , ROW_NUMBER() OVER (PARTITION BY MovementItemProtocol.MovementItemId ORDER BY MovementItemProtocol.Id) AS Ord
                             FROM tmpMI AS MovementItem
                                  INNER JOIN Object_Goods_Retail ON Object_Goods_Retail.ID = MovementItem.objectid
                                  INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                                              AND Object_Goods_Main.isInvisibleSUN = False

                                  INNER JOIN MovementItemProtocol ON MovementItemProtocol.MovementItemId = MovementItem.Id
                                                                 AND MovementItemProtocol.ProtocolData ILIKE '%Значение%'
                                                                 AND MovementItemProtocol.UserId = zfCalc_UserAdmin()::Integer
                             )
        , tmpProtocol AS (SELECT tmpProtocolAll.Id
                               , SUBSTRING(tmpProtocolAll.ProtocolData, 1, POSITION('"' IN tmpProtocolAll.ProtocolData) - 1)::TFloat AS AmountAuto
                          FROM tmpProtocolAll
                          WHERE tmpProtocolAll.Ord = 1)
        , tmpMIAll AS (SELECT MovementItem.Id
                            , MovementItem.ObjectId
                            , COALESCE (tmpProtocol.AmountAuto, 0) - MovementItem.Amount  AS Amount
                            , MovementItem.CommentSunName
                       FROM tmpMI AS MovementItem
                            INNER JOIN tmpProtocol ON tmpProtocol.ID = MovementItem.Id
                       --WHERE COALESCE (tmpProtocol.AmountAuto, 0) - MovementItem.Amount > 0
                       )
        , tmpData AS (SELECT string_agg(MovementItem.Id::TVarChar, ';')       AS ID
                           , MovementItem.ObjectId
                           , SUM(MovementItem.Amount)                         AS Amount
                           , string_agg(MovementItem.CommentSunName, ';')     AS CommentSunName
                      FROM tmpMIAll AS MovementItem
                      GROUP BY MovementItem.ObjectId)

    SELECT ('Для товар <'||Object_Goods.ObjectCode::TVarChar||'> <'||Object_Goods.ValueData||'> из перемещения СУН с комментарием <'||SPLIT_PART (MovementItem.CommentSunName, ';', 1)||'> необходимо создать заявку на изменения срока годности.')::TBlob AS Message,
           'TOverdueChangeCashPUSHSendForm'::TVarChar                           AS FormName,
           'Добавить товар в заявку'::TVarChar                                  AS Button,
           'GoodsId,GoodsCode,GoodsName,MISendId,Amount'::TVarChar              AS Params,
           'ftInteger,ftInteger,ftString,ftString,ftFloat'::TVarChar            AS TypeParams,
           (Object_Goods.Id::TVarChar||','||Object_Goods.ObjectCode::TVarChar||','||REPLACE(Object_Goods.ValueData, ',', '.')||','||MovementItem.ID::TVarChar||','||MovementItem.Amount::TVarChar)::TVarChar   AS ValueParams

    FROM tmpData AS MovementItem

         INNER JOIN Object AS Object_Goods
                           ON Object_Goods.Id = MovementItem.ObjectId
    LIMIT 1

    ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.08.20                                                       *
*/

-- 
SELECT * FROM gpSelect_SendToSendPDChange_PUSH_Cash(1, 12607257  , '3');