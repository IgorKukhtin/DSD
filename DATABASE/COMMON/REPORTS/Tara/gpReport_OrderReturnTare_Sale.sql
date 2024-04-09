-- Function: gpReport_OrderReturnTare_Sale()

DROP FUNCTION IF EXISTS gpReport_OrderReturnTare_Sale (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderReturnTare_Sale (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderReturnTare_Sale(
    IN inStartDate      TDateTime, -- дата начала периода
    IN inEndDate        TDateTime, -- дата окончания периода
    IN inMovementId     Integer  , -- путевой 
    IN inPartnerId      Integer  , -- контрагент
    IN inGoodsId        Integer  , -- тара 
    IN inisAll          Boolean  , -- показать все возвраты за период
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE(MovementId Integer, OperDate TDateTime, InvNumber TVarChar
            , InvNumber_Transport TVarChar
            , FromId Integer, FromCode Integer, FromName TVarChar
            , ToId Integer, ToCode Integer, ToName TVarChar
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
    --данные продаж из реестра         
    WITH
      -- документы реестра
      tmpMovementReestr AS (SELECT Movement.*
                                 , MovementLinkMovement_Transport.MovementChildId AS MovementId_Transport
                            FROM Movement
                                 LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                                 ON MovementLinkMovement_Transport.MovementId = Movement.Id
                                                                AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()  
                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                              AND Movement.DescId = zc_Movement_Reestr()
                              AND Movement.StatusId <> zc_Enum_Status_Erased()
						      AND (MovementLinkMovement_Transport.MovementChildId = inMovementId OR inisAll = True)
                           )
      -- строчная часть реестра
    , tmpMI_Reestr AS (SELECT MovementItem.*
                            , Movement.MovementId_Transport
                       FROM tmpMovementReestr AS Movement
                            -- строчная часть реестра
                            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId     = zc_MI_Master()
                                                  AND MovementItem.isErased   = FALSE
                       )
      -- док продаж
    , tmpMF AS (SELECT MovementFloat.ValueData  :: Integer AS MovementItemId_reestr
                     , MovementFloat.MovementId            AS MovementId_Sale
                FROM MovementFloat
                WHERE MovementFloat.DescId = zc_MovementFloat_MovementItemId()
                  AND MovementFloat.ValueData IN (SELECT DISTINCT tmpMI_Reestr.Id :: TFloat FROM tmpMI_Reestr)
               )
    , tmpMovement_Sale AS (SELECT DISTINCT
                                  MovementFloat_MovementItemId.MovementId_Sale
                                , tmpMI_Reestr.MovementId_Transport
                                , MovementLinkObject_To.ObjectId AS PartnerId
                           FROM tmpMI_Reestr
                                INNER JOIN tmpMF AS MovementFloat_MovementItemId
                                                 ON MovementFloat_MovementItemId.MovementItemId_reestr = tmpMI_Reestr.Id 
                                INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                              ON MovementLinkObject_To.MovementId = MovementFloat_MovementItemId.MovementId_Sale
                                                             AND MovementLinkObject_To.DescId     = zc_MovementLinkObject_To()
                                                             AND MovementLinkObject_To.ObjectId   = inPartnerId 
                                -- путевой из реестра
                                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                               ON MovementLinkMovement_Transport.MovementId = tmpMI_Reestr.MovementId
                                                              AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()
                          )
    
   --строки док. продаж оборотной тары
   , tmpMI_Sale AS (SELECT MovementItem.*
                    FROM MovementItem
                         INNER JOIN Movement ON Movement.Id     = MovementItem.MovementId
                                            AND Movement.DescId = zc_Movement_Sale()
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_Sale.MovementId_Sale FROM tmpMovement_Sale)
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE 
                      AND MovementItem.ObjectId = inGoodsId
                   )
 
    , tmpSale AS (SELECT tmpMovement_Sale.MovementId_Transport
                       , tmpMovement_Sale.MovementId_Sale
                       , tmpMovement_Sale.PartnerId 
                       , SUM (tmpMI_sale.Amount)        AS Amount
                  FROM tmpMovement_Sale
                       INNER JOIN tmpMI_sale ON tmpMI_sale.MovementId = tmpMovement_Sale.MovementId_Sale
                  GROUP BY tmpMovement_Sale.MovementId_Transport
                         , tmpMovement_Sale.MovementId_Sale
                         , tmpMovement_Sale.PartnerId
                  )

           --
           SELECT Movement.Id                      AS MovementId
                , Movement.OperDate   ::TDateTime  AS OperDate
                , Movement.InvNumber  ::TVarChar   AS InvNumber 
                , ('№ ' || Movement_Transport.InvNumber || ' от ' || Movement_Transport.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_Transport
                , Object_From.Id                      AS FromId
                , Object_From.ObjectCode              AS FromCode
                , Object_From.ValueData               AS FromName
                , Object_To.Id                        AS ToId
                , Object_To.ObjectCode                AS ToCode
                , Object_To.ValueData                 AS ToName
                , tmpSale.Amount         ::TFloat     AS Amount                
           FROM tmpSale
                LEFT JOIN Movement ON Movement.Id = tmpSale.MovementId_Sale

                LEFT JOIN Object AS Object_To ON Object_To.Id = tmpSale.PartnerId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = Movement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId  

                LEFT JOIN Movement AS Movement_Transport ON Movement_Transport.Id = tmpSale.MovementId_Transport

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
--SELECT * FROM gpReport_OrderReturnTare_Sale (inStartDate := '08.04.2022'::TDatetime, inEndDate := '08.04.2022'::TDatetime, inMovementId:=0, inPartnerId:=3452432 , inGoodsId:=18400 , inisAll:=TRUE, inSession:='5'::TVarChar);
