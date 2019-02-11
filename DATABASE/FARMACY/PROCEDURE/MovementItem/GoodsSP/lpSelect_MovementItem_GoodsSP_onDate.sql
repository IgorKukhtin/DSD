--- Function: lpSelect_MovementItem_GoodsSP_onDate()


DROP FUNCTION IF EXISTS lpSelect_MovementItem_GoodsSP_onDate (TDateTime, TDateTime);

CREATE OR REPLACE FUNCTION lpSelect_MovementItem_GoodsSP_onDate(
    IN inStartDate    TDateTime,     -- 
    IN inEndDate      TDateTime     -- 
)    
RETURNS TABLE (MovementId Integer, OperDate TDateTime, InvNumber TVarChar
             , MovementItemId Integer
             , GoodsId Integer
             , OperDateStart TDateTime
             , OperDateEnd TDateTime
              )
AS
$BODY$
BEGIN
           -- Результат
           RETURN QUERY
           SELECT Movement.Id            AS MovementId
                , Movement.OperDate      AS OperDate
                , Movement.InvNumber     AS InvNumber
                , MovementItem.Id        AS MovementItemId
                , MovementItem.ObjectId  AS GoodsId
                , MovementDate_OperDateStart.ValueData AS OperDateStart
                , MovementDate_OperDateEnd.ValueData   AS OperDateEnd
           FROM Movement
                 INNER JOIN MovementDate AS MovementDate_OperDateStart
                                         ON MovementDate_OperDateStart.MovementId = Movement.Id
                                        AND MovementDate_OperDateStart.DescId     = zc_MovementDate_OperDateStart()
                                        AND MovementDate_OperDateStart.ValueData  <= inEndDate
        
                 INNER JOIN MovementDate AS MovementDate_OperDateEnd
                                         ON MovementDate_OperDateEnd.MovementId = Movement.Id
                                        AND MovementDate_OperDateEnd.DescId     = zc_MovementDate_OperDateEnd()
                                        AND MovementDate_OperDateEnd.ValueData  >= inStartDate

                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                        AND MovementItem.DescId = zc_MI_Master()
                                        AND MovementItem.isErased = FALSE

           WHERE Movement.StatusId = zc_Enum_Status_Complete()
             AND Movement.DescId = zc_Movement_GoodsSP()
           ;
  
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.02.19         *
*/

-- SELECT * FROM lpSelect_MovementItem_GoodsSP_onDate (inStartDate:= CURRENT_DATE, inEndDate:= CURRENT_DATE);