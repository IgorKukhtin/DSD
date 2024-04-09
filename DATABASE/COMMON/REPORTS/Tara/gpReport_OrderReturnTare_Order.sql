-- Function: gpReport_OrderReturnTare_Order()

DROP FUNCTION IF EXISTS gpReport_OrderReturnTare_Order (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderReturnTare_Order(
    IN inStartDate      TDateTime, -- дата начала периода
    IN inEndDate        TDateTime, -- дата окончания периода
    IN inMovementId     Integer  , -- путевой 
    IN inPartnerId      Integer  , -- контрагент
    IN inGoodsId        Integer  , -- тара 
    IN inisAll          Boolean  , -- показать все заявки на возврат за период
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE(MovementId Integer, OperDate TDateTime, InvNumber TVarChar
            , InvNumber_Transport TVarChar
            , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar
			, Amount TFloat
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
    WITH
     -- находим сколько заявок сформировано
     tmpMovementOrderReturnTare AS (SELECT Movement.*
                                         , MovementLinkMovement_Transport.MovementChildId AS MovementId_Transport
                                    FROM Movement
                                         LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                                        ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                                                       AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                                    WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                      AND Movement.DescId = zc_Movement_OrderReturnTare()
                                      AND Movement.StatusId = zc_Enum_Status_Complete()
                                      AND (MovementLinkMovement_Transport.MovementChildId = inMovementId OR inisAll = TRUE)
                                    )
    -- строки заявок
   , tmpMI AS (SELECT MovementItem.*
               FROM MovementItem
               WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovementOrderReturnTare.Id FROM tmpMovementOrderReturnTare)
                 AND MovementItem.DescId = zc_MI_Master()
                 AND MovementItem.isErased = FALSE
                 AND MovementItem.ObjectId = inGoodsId
               )
   , tmpMILO_Partner AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                           AND MovementItemLinkObject.DescId = zc_MILinkObject_Partner()
                           AND MovementItemLinkObject.ObjectId = inPartnerId
                         )
     -- собираем все данные заявок на возврат
   , tmpOrderReturnTare AS (SELECT tmpMI.MovementId       AS MovementId_order
                                 , tmpMovementOrderReturnTare.MovementId_Transport
                                 , MILinkObject_Partner.ObjectId AS PartnerId
                                 , SUM (tmpMI.Amount)     AS Amount
                            FROM tmpMovementOrderReturnTare
                                 INNER JOIN tmpMI ON tmpMI.MovementId = tmpMovementOrderReturnTare.Id
  
                                 INNER JOIN tmpMILO_Partner AS MILinkObject_Partner
                                                            ON MILinkObject_Partner.MovementItemId = tmpMI.Id 
                            GROUP BY tmpMI.MovementId
                                   , tmpMovementOrderReturnTare.MovementId_Transport
                                   , MILinkObject_Partner.ObjectId
                           )                  
           --
           SELECT Movement.Id                      AS MovementId
                , Movement.OperDate   ::TDateTime  AS OperDate
                , Movement.InvNumber  ::TVarChar   AS InvNumber 
                , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport
                , Object_Partner.Id                AS PartnerId
                , Object_Partner.ObjectCode        AS PartnerCode
                , Object_Partner.ValueData         AS PartnerName
                , tmpOrderReturnTare.Amount ::TFloat AS Amount                
           FROM tmpOrderReturnTare
                LEFT JOIN Movement ON Movement.Id = tmpOrderReturnTare.MovementId_order

                LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpOrderReturnTare.PartnerId

                LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = tmpOrderReturnTare.MovementId_Transport

           ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
01.05.22         *
*/

-- тест
--SELECT * FROM gpReport_OrderReturnTare_Order (inStartDate := '01.04.2022'::TDatetime, inEndDate := '30.04.2022'::TDatetime, inMovementId:=0, inPartnerId:=877320 , inGoodsId:=18400 , inisAll:= TRUE, inSession:='5'::TVarChar);
