-- Function: lpGet_MovementItem_PriceList()

DROP FUNCTION IF EXISTS lpGet_MovementItem_PriceList (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpGet_MovementItem_PriceList(
    IN inOperDate           TDateTime , -- Дата действия
    IN inGoodsId            Integer   , --
    IN inUserId             Integer     --
)
RETURNS TABLE (MovementId Integer, InvNumber TVarChar, OperDate TDateTime
             , MovementItemId Integer, GoodsId Integer
             , ValuePrice          TFloat --  Цена без ндс
             , ValuePrice_parent   TFloat --  Цена без ндс (упакови)
             , EmpfPrice           TFloat --  Рекомендованная Цена без ндс
             , EmpfPrice_parent    TFloat --  Рекомендованная Цена без ндс (упакови)
             , MinCount            TFloat --  мин кол-во закупки
             , MinCountMult        TFloat --  рекомендуемое кол-во закупки
             , MeasureMult         TFloat --  Вложенность
             , PartnerId   Integer
             , PartnerName TVarChar
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

                                 -- Цена без ндс
                               , MovementItem.Amount            AS ValuePrice
                                 -- Цена без ндс (упакови)
                               , MIF_PriceParent.ValueData      AS ValuePrice_parent
                                 -- Рекомендованная Цена без ндс
                               , CASE WHEN MIF_MeasureMult.ValueData > 0 THEN CAST (MIF_EmpfPriceParent.ValueData / MIF_MeasureMult.ValueData AS NUMERIC (16, 2)) ELSE MIF_EmpfPriceParent.ValueData END  :: TFloat AS EmpfPrice
                                 -- Рекомендованная Цена без ндс (упакови)
                               , MIF_EmpfPriceParent.ValueData  AS EmpfPrice_parent
                                 -- мин кол-во закупки
                               , MIF_MinCount.ValueData         AS MinCount
                                 -- рекомендуемое кол-во закупки
                               , MIF_MinCountMult.ValueData     AS MinCountMult
                                 -- Вложенность
                               , MIF_MeasureMult.ValueData      AS MeasureMult

                                 --
                               , MLO_Partner.ObjectId   AS PartnerId
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementLinkObject AS MLO_Partner
                                                             ON MLO_Partner.MovementId = Movement.Id
                                                            AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                               -- Цена без ндс
                               INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                                                      AND (MovementItem.ObjectId  = inGoodsId OR COALESCE (inGoodsId, 0) = 0)
                               -- Цена без ндс (упакови)
                               LEFT JOIN MovementItemFloat AS MIF_PriceParent
                                                           ON MIF_PriceParent.MovementItemId = MovementItem.Id
                                                          AND MIF_PriceParent.DescId         = zc_MIFloat_PriceParent()
                               -- Рекомендованная цена без ндс (упакови)
                               LEFT JOIN MovementItemFloat AS MIF_EmpfPriceParent
                                                           ON MIF_EmpfPriceParent.MovementItemId = MovementItem.Id
                                                          AND MIF_EmpfPriceParent.DescId         = zc_MIFloat_EmpfPriceParent()
                               -- мин кол-во закупки
                               LEFT JOIN MovementItemFloat AS MIF_MinCount
                                                           ON MIF_MinCount.MovementItemId = MovementItem.Id
                                                          AND MIF_MinCount.DescId         = zc_MIFloat_MinCount()
                               -- рекомендуемое кол-во закупки
                               LEFT JOIN MovementItemFloat AS MIF_MinCountMult
                                                           ON MIF_MinCountMult.MovementItemId = MovementItem.Id
                                                          AND MIF_MinCountMult.DescId         = zc_MIFloat_MinCountMult()
                               -- Вложенность
                               LEFT JOIN MovementItemFloat AS MIF_MeasureMult
                                                           ON MIF_MeasureMult.MovementItemId = MovementItem.Id
                                                          AND MIF_MeasureMult.DescId         = zc_MIFloat_MeasureMult()

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
              , tmpData.ValuePrice_parent
              , tmpData.EmpfPrice
              , tmpData.EmpfPrice_parent
              , tmpData.MinCount
              , tmpData.MinCountMult
              , tmpData.MeasureMult
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
