-- Function: lpGet_MovementItem_PriceList()

DROP FUNCTION IF EXISTS lpGet_MovementItem_PriceList (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MovementItem_PriceList(
    IN inOperDate           TDateTime , -- Дата действия
    IN inGoodsId            Integer   , --
    IN inUserId             Integer     --
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , MovementItemId Integer, GoodsId Integer
             , ValuePrice TFloat
             , PartnerId Integer, PartnerName TVarChar
              )
AS
$BODY$
BEGIN

       -- Выбираем данные
       RETURN QUERY
         WITH tmpData AS (SELECT Movement.Id            AS MovementId
                               , Movement.InvNumber     AS InvNumber
                               , Movement.OperDate      AS OperDate
                               , MovementItem.Id        AS MovementItemId
                               , MovementItem.ObjectId  AS GoodsId
                               , MovementItem.Amount    AS ValuePrice
                               , MLO_Partner.ObjectId   AS PartnerId
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementLinkObject AS MLO_Partner
                                                             ON MLO_Partner.MovementId = Movement.Id
                                                            AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                                                      AND (MovementItem.ObjectId  = inGoodsId OR COALESCE (inGoodsId, 0) = 0)

                          WHERE Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '12 MONTH') AND inOperDate
                            AND Movement.DescId    = zc_Movement_PriceList()
                            AND Movement.StatusId  = zc_Enum_Status_Complete()
                         )
         -- Результат
         SELECT tmpData.MovementId
              , tmpData.InvNumber
              , tmpData.OperDate
              , tmpData.MovementItemId
              , tmpData.GoodsId
              , tmpData.ValuePrice
              , tmpData.PartnerId
              , Object_Partner.ValueData AS PartnerName
         FROM tmpData
              LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
         WHERE tmpData.Ord = 1
        ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 12.04.22                                        *
*/

-- тест
-- SELECT * FROM lpGet_MovementItem_PriceList (inOperDate:= CURRENT_TIMESTAMP, inGoodsId:= 1, inUserId:= 1)
