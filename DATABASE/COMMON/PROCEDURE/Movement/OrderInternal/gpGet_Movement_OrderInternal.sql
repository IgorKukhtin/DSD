-- Function: gpGet_Movement_OrderInternal()

-- DROP FUNCTION gpGet_Movement_OrderInternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderInternal (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderInternal (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderInternal (Integer, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_OrderInternal (Integer, TDateTime, Boolean, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_OrderInternal(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inIsPack            Boolean  , -- 
    IN inFromId            Integer ,   -- от кого
    IN inToId              Integer ,   -- кому
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, IdBarCode TVarChar , InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, OperDateStart TDateTime, OperDateEnd TDateTime
             , FromId Integer, FromName TVarChar, ToId Integer, ToName TVarChar
             , DayCount TFloat
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) < 0
     THEN
         RAISE EXCEPTION 'Ошибка.Документ Заказ не выбран.';
     END IF;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         WITH tmpGoodsReportSaleInf AS (SELECT gpGet.StartDate, gpGet.EndDate FROM gpGet_Object_GoodsReportSaleInf (inSession) AS gpGet
                                        WHERE (inFromId <> 8451 AND inToId <> 8455)
                                       UNION
                                      SELECT (inOperDate - INTERVAL '28 DAY')::TDateTime AS StartDate
                                           , (inOperDate - INTERVAL '1 DAY') ::TDateTime AS EndDate
                                        WHERE inFromId = 8451 AND inToId = 8455
                                        )
         SELECT
               0 AS Id  
             , ''::TVarChar AS IdBarCode
             , CAST (NEXTVAL ('movement_orderinternal_seq') AS TVarChar) AS InvNumber
             , inOperDate                                       AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             
             , (CASE WHEN inIsPack = TRUE THEN inOperDate ELSE inOperDate + INTERVAL '1 DAY' END) :: TDateTime     AS OperDatePartner
             -- , (inOperDate - INTERVAL '56 DAY') ::TDateTime     AS OperDateStart
             -- , (inOperDate - INTERVAL '1 DAY') ::TDateTime      AS OperDateEnd  
             , tmpGoodsReportSaleInf.StartDate                   AS OperDateStart
             , tmpGoodsReportSaleInf.EndDate                     AS OperDateEnd  
                          
             , Object_From.Id                                     AS FromId
             , Object_From.ValueData                              AS FromName
             , Object_To.Id                                       AS ToId
             , Object_To.ValueData                                AS ToName
             -- , (1 + EXTRACT (DAY FROM ((inOperDate - INTERVAL '1 DAY') - (inOperDate - INTERVAL '56 DAY')))) :: TFloat AS DayCount
             , (1 + EXTRACT (DAY FROM (zfConvert_DateTimeWithOutTZ (tmpGoodsReportSaleInf.EndDate) - zfConvert_DateTimeWithOutTZ (tmpGoodsReportSaleInf.StartDate)))) :: TFloat AS DayCount
             , CAST ('' as TVarChar) 		                  AS Comment

          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN tmpGoodsReportSaleInf ON 1=1
               LEFT JOIN Object AS Object_From ON Object_From.Id = CASE WHEN inFromId <> 0 
                                                                             THEN inFromId 
                                                                        ELSE 8457 -- Склады База + Реализации
                                                                   END
               LEFT JOIN Object AS Object_To ON Object_To.Id = CASE WHEN inToId = 0
                                                                     AND inFromId  > 0
                                                                         THEN inFromId
                                                                    WHEN inIsPack = TRUE AND inToId = 0
                                                                         THEN 8451 -- Цех Упаковки
                                                                    ELSE CASE WHEN inToId <> 0 
                                                                                   THEN inToId
                                                                              ELSE 8446 -- ЦЕХ колбаса+дел-сы
                                                                         END
                                                               END
         ;

     ELSE

     RETURN QUERY
       WITH tmpGoodsReportSaleInf AS (SELECT gpGet.StartDate, gpGet.EndDate FROM gpGet_Object_GoodsReportSaleInf (inSession) AS gpGet
                                      WHERE (inFromId <> 8451 AND inToId <> 8455)
                                     UNION
                                      SELECT (inOperDate - INTERVAL '28 DAY')::TDateTime AS StartDate
                                           , (inOperDate - INTERVAL '1 DAY') ::TDateTime AS EndDate
                                      WHERE inFromId = 8451 AND inToId = 8455
                                      )
       SELECT
             Movement.Id                                        AS Id 
           , zfFormat_BarCode (zc_BarCodePref_Movement(), Movement.Id) ::TVarChar AS IdBarCode
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName

           , MovementDate_OperDatePartner.ValueData     AS OperDatePartner
           , COALESCE (MovementDate_OperDateStart.ValueData, tmpGoodsReportSaleInf.StartDate) :: TDateTime AS OperDateStart
           , COALESCE (MovementDate_OperDateEnd.ValueData, tmpGoodsReportSaleInf.EndDate)     :: TDateTime AS OperDateEnd                      
           
           , Object_From.Id                                     AS FromId
           , Object_From.ValueData                              AS FromName
           , Object_To.Id                                       AS ToId
           , Object_To.ValueData                                AS ToName

           , (1 + EXTRACT (DAY FROM (COALESCE (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateEnd.ValueData),   zfConvert_DateTimeWithOutTZ (tmpGoodsReportSaleInf.EndDate))
                                   - COALESCE (zfConvert_DateTimeWithOutTZ (MovementDate_OperDateStart.ValueData), zfConvert_DateTimeWithOutTZ (tmpGoodsReportSaleInf.StartDate)))
                          )) :: TFloat AS DayCount
           , MovementString_Comment.ValueData       AS Comment
            
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN tmpGoodsReportSaleInf ON 1=1


            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId =  Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementDate AS MovementDate_OperDateStart
                                   ON MovementDate_OperDateStart.MovementId =  Movement.Id
                                  AND MovementDate_OperDateStart.DescId = zc_MovementDate_OperDateStart()
            LEFT JOIN MovementDate AS MovementDate_OperDateEnd
                                   ON MovementDate_OperDateEnd.MovementId =  Movement.Id
                                  AND MovementDate_OperDateEnd.DescId = zc_MovementDate_OperDateEnd()

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment() 

            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId


       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_OrderInternal();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_OrderInternal (Integer, TDateTime, Boolean, Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 10.01.20         *
 27.06.15                                        * all
 02.03.15         * add OperDatePartner, OperDateStart, OperDateEnd, DayCount               
 06.06.14                                                        *
*/

-- тест
-- SELECT * FROM gpGet_Movement_OrderInternal (inMovementId:= 1, inOperDate:= NULL, inIsPack:= FALSE, inFromId:= 0, inToId:= 0 ,inSession:= zfCalc_UserAdmin())
