-- Function: gpReport_OrderReturnTare_ReturnIn()

DROP FUNCTION IF EXISTS gpReport_OrderReturnTare_ReturnIn (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderReturnTare_ReturnIn(
    IN inStartDate      TDateTime, -- дата начала периода
    IN inEndDate        TDateTime, -- дата окончания периода
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE(MovementId Integer, OperDate TDateTime, InvNumber TVarChar
            , FromId Integer, FromCode Integer, FromName TVarChar
            , ToId Integer, ToName TVarChar
    )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

    -- Результат
    RETURN QUERY
    WITH
         --получаем оборотную тару
           tmpInfoMoneyDestination_20500 AS (SELECT Object_InfoMoney_View.*
                                             FROM Object_InfoMoney_View
                                             WHERE Object_InfoMoney_View.InfoMoneyDestinationId = zc_Enum_InfoMoneyDestination_20500()
                                             )
         --оборотная тара
         , tmpGoods AS (SELECT ObjectLink.ObjectId AS GoodsId
                        FROM ObjectLink
                        WHERE ObjectLink.DescId = zc_ObjectLink_Goods_InfoMoney()
                          AND ObjectLink.ChildObjectId IN (SELECT DISTINCT tmpInfoMoneyDestination_20500.InfoMoneyId FROM tmpInfoMoneyDestination_20500)
                        )

         -- док. возврата 
         , tmpMovement AS (SELECT Movement.*
                           FROM Movement
                                INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()
                                                       AND MovementItem.isErased = FALSE
                                INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId

                           WHERE Movement.OperDate BETWEEN inStartDate AND inEndDate
                             AND Movement.DescId = zc_Movement_ReturnIn()
                           )


         
           --
           SELECT tmpMovement.Id                      AS MovementId
                , tmpMovement.OperDate   ::TDateTime  AS OperDate
                , tmpMovement.InvNumber  ::TVarChar   AS InvNumber
                , Object_From.Id                      AS FromId
                , Object_From.ObjectCode              AS FromCode
                , Object_From.ValueData               AS FromName
                , Object_To.Id                        AS ToId
                , Object_To.ValueData                 AS ToName                
           FROM tmpMovement
                LEFT JOIN MovementDesc ON MovementDesc.Id = tmpMovement.Id

                LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                             ON MovementLinkObject_From.MovementId = tmpMovement.Id
                                            AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                             ON MovementLinkObject_To.MovementId = tmpMovement.Id
                                            AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
           ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.01.22         *
*/

-- тест
-- SELECT * FROM gpReport_OrderReturnTare_ReturnIn (inStartDate := '01.01.2022'::TDatetime, inEndDate:='08.01.2022'::TDatetime, inSession:='5'::TVarChar);
