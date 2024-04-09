-- Function: gpReport_OrderReturnTare_ReturnIn()

--DROP FUNCTION IF EXISTS gpReport_OrderReturnTare_ReturnIn (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderReturnTare_ReturnIn (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderReturnTare_ReturnIn(
    IN inStartDate      TDateTime, -- дата начала периода
    IN inEndDate        TDateTime, -- дата окончания периода
    IN inMovementId     Integer  , -- путевой 
    IN inPartnerId      Integer  , -- контрагент
    IN inGoodsId        Integer  , -- тара
    IN inisAll          Boolean  , -- показать все возвраты за период
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE(MovementId Integer, OperDate TDateTime, InvNumber TVarChar
            , InvNumber_OrderReturnTare TVarChar
            , FromId Integer, FromCode Integer, FromName TVarChar
            , ToId Integer, ToName TVarChar
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
      tmpOrderReturnTare AS (WITH
                             -- все сфорированніе заявки
                             tmpMovementOrderReturnTare AS (SELECT Movement.*
                                                            FROM Movement
                                                            WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                                                              AND Movement.DescId = zc_Movement_OrderReturnTare()
                                                              AND Movement.StatusId = zc_Enum_Status_Complete()
                                                            )
                             -- путевые
                           , tmpMovementLinkMovement AS (SELECT MovementLinkMovement.MovementId
                                                         FROM MovementLinkMovement
                                                         WHERE MovementLinkMovement.DescId = zc_MovementLinkMovement_Transport()
                                                           AND MovementLinkMovement.MovementChildId = inMovementId --путевой
                                                         )
                            -- 
                           SELECT DISTINCT Movement.MovementId AS MovementId_order
                           FROM (--если путевой <> 0 получаем заявку по путевому
                                 SELECT tmp.MovementId
                                 FROM tmpMovementLinkMovement AS tmp
                                 WHERE COALESCE (inMovementId,0) <> 0
                                UNION 
                                 SELECT tmp.Id AS MovementId 
                                 FROM tmpMovementOrderReturnTare AS tmp
                                 WHERE COALESCE (inMovementId,0) = 0
                                 ) AS Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.MovementId
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE
                                                       AND MovementItem.ObjectId = inGoodsId
                                INNER JOIN MovementItemLinkObject AS MILinkObject_Partner
                                                                  ON MILinkObject_Partner.MovementItemId = MovementItem.Id  
                                                                 AND MILinkObject_Partner.DescId = zc_MILinkObject_Partner()
                                                                 AND MILinkObject_Partner.ObjectId = inPartnerId
                               )

      -- Данные из док. возврата 
    , tmpReturn AS (SELECT MovementLinkMovement_OrderReturnTare.MovementId AS MovementId_Return
                         , MovementLinkObject_From.ObjectId AS PartnerId
                         , SUM (MovementItem.Amount)        AS Amount
                    FROM MovementLinkMovement AS MovementLinkMovement_OrderReturnTare  
                         INNER JOIN Movement ON Movement.Id = MovementLinkMovement_OrderReturnTare.MovementId
                                            AND Movement.DescId = zc_Movement_ReturnIn() 
                                            AND Movement.StatusId <> zc_Enum_Status_Erased()

                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId = zc_MI_Master()
                                                AND MovementItem.isErased = FALSE
                                                AND MovementItem.ObjectId = inGoodsId 

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                      ON MovementLinkObject_From.MovementId = Movement.Id
                                                     AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                                                     AND MovementLinkObject_From.ObjectId = inPartnerId

                    WHERE MovementLinkMovement_OrderReturnTare.MovementChildId IN (SELECT DISTINCT tmpOrderReturnTare.MovementId_order FROM tmpOrderReturnTare)
                      AND MovementLinkMovement_OrderReturnTare.DescId = zc_MovementLinkMovement_OrderReturnTare()
                      AND inisAll = FALSE
                    GROUP BY MovementLinkMovement_OrderReturnTare.MovementId
                           , MovementLinkObject_From.ObjectId
                    ) 

     -- ФАКТ из док. возврата -- для информации  все возвраты тары без учета есть или нет заявки на возврат
   , tmpReturn_fact AS (SELECT Movement.Id AS MovementId_Return
                             , MovementLinkObject_From.ObjectId AS PartnerId
                             , SUM (MovementItem.Amount)        AS Amount
                        FROM Movement  
                             INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                    AND MovementItem.DescId = zc_MI_Master()
                                                    AND MovementItem.isErased = FALSE 
                                                    AND MovementItem.ObjectId = inGoodsId

                             LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                          ON MovementLinkObject_From.MovementId = Movement.Id
                                                         AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From() 
                                                         AND MovementLinkObject_From.ObjectId = inPartnerId

                        WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                          AND Movement.DescId = zc_Movement_ReturnIn()
                          AND inisAll = TRUE 
                        GROUP BY MovementLinkObject_From.ObjectId
                               , Movement.Id
                        )

    
    
    
         -- все док. возврата 
         , tmpMovement AS (SELECT tmp.*
                           FROM tmpReturn AS tmp
                         UNION
                           SELECT tmp.*
                           FROM tmpReturn_fact AS tmp
                           )


         
           --
           SELECT Movement.Id                      AS MovementId
                , Movement.OperDate   ::TDateTime  AS OperDate
                , Movement.InvNumber  ::TVarChar   AS InvNumber 
                , ('№ ' || Movement_OrderReturnTare.InvNumber || ' от ' || Movement_OrderReturnTare.OperDate  :: Date :: TVarChar ) :: TVarChar  AS InvNumber_OrderReturnTare
                , Object_From.Id                      AS FromId
                , Object_From.ObjectCode              AS FromCode
                , Object_From.ValueData               AS FromName
                , Object_To.Id                        AS ToId
                , Object_To.ValueData                 AS ToName
                , tmpMovement.Amount     ::TFloat     AS Amount                
           FROM tmpMovement
                LEFT JOIN Movement ON Movement.Id = tmpMovement.MovementId_Return

                LEFT JOIN Object AS Object_From ON Object_From.Id = tmpMovement.PartnerId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = Movement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId  

                LEFT JOIN MovementLinkMovement AS MovementLinkMovement_OrderReturnTare
                                               ON MovementLinkMovement_OrderReturnTare.MovementId = Movement.Id
                                              AND MovementLinkMovement_OrderReturnTare.DescId = zc_MovementLinkMovement_OrderReturnTare()
                LEFT JOIN Movement AS Movement_OrderReturnTare ON Movement_OrderReturnTare.Id = MovementLinkMovement_OrderReturnTare.MovementChildId

           ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.04.22         *
 11.01.22         *
*/

-- тест
-- SELECT * FROM gpReport_OrderReturnTare_ReturnIn (inStartDate := '01.01.2022'::TDatetime, inMovementId:=0, inPartnerId:=0,inGoodsId:=0,inisAll:=true,inEndDate:='08.01.2022'::TDatetime, inSession:='5'::TVarChar);
