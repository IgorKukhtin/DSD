-- Function: lpSelect_MovementItem_PriceList()

DROP FUNCTION IF EXISTS lpSelect_MovementItem_PriceList (TDateTime, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_MovementItem_PriceList(
    IN inOperDate           TDateTime , -- Дата действия
    IN inPartnerId          Integer   , --
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

       RAISE EXCEPTION 'Ошибка.Так нельзя.Т.к. у  одного inPartnerId - разные загрузки по товарам. т.е. не все товары в одном прайсе.';


       -- Выбираем данные
       RETURN QUERY
         WITH tmpData AS (SELECT Movement.Id            AS MovementId
                               , Movement.InvNumber     AS InvNumber
                               , Movement.OperDate      AS OperDate
                               , MLO_Partner.ObjectId   AS PartnerId
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MLO_Partner.ObjectId ORDER BY Movement.OperDate DESC, Movement.Id DESC) AS Ord
                          FROM Movement
                               INNER JOIN MovementLinkObject AS MLO_Partner
                                                             ON MLO_Partner.MovementId = Movement.Id
                                                            AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                                                            AND (MLO_Partner.ObjectId  = inPartnerId OR COALESCE (inPartnerId, 0) = 0)
                          WHERE Movement.OperDate BETWEEN DATE_TRUNC ('MONTH', CURRENT_DATE - INTERVAL '12 MONTH') AND inOperDate
                            AND Movement.DescId    = zc_Movement_PriceList()
                            AND Movement.StatusId  = zc_Enum_Status_Complete()
                         )
        , tmpData_all AS (SELECT tmpData.MovementId
                               , tmpData.InvNumber
                               , tmpData.OperDate
                               , MovementItem.Id        AS MovementItemId
                               , MovementItem.ObjectId  AS GoodsId
                               , MovementItem.Amount    AS ValuePrice
                               , tmpData.PartnerId
                                 -- № п/п
                               , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId ORDER BY tmpData.OperDate DESC, tmpData.MovementId DESC) AS Ord
                          FROM tmpData
                               INNER JOIN MovementItem ON MovementItem.MovementId = tmpData.MovementId
                                                      AND MovementItem.DescId     = zc_MI_Master()
                                                      AND MovementItem.isErased   = FALSE
                          WHERE tmpData.Ord = 1
                         )
         -- Результат
         SELECT tmpData_all.MovementId
              , tmpData_all.InvNumber
              , tmpData_all.OperDate
              , tmpData_all.MovementItemId
              , tmpData_all.GoodsId
              , tmpData_all.ValuePrice
              , tmpData_all.PartnerId
              , Object_Partner.ValueData AS PartnerName
         FROM tmpData_all
              LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData_all.PartnerId
         WHERE tmpData_all.Ord = 1
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
-- SELECT * FROM lpSelect_MovementItem_PriceList (inOperDate:= CURRENT_TIMESTAMP, inPartnerId:= 0, inUserId:= 1)
