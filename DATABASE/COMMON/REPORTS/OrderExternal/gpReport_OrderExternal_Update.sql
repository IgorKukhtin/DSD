-- Function: gpReport_OrderExternal_Update()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_Update (TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_Update(
    IN inOperDate          TDateTime , --
    IN inToId              Integer   , -- Кому (в документе)
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate        TDateTime
             , OperDatePartner TDateTime
             , RouteId Integer, RouteName TVarChar
             , RetailId Integer, RetailName TVarChar
             , PartnerTagName TVarChar
             , OperDate_CarInfo TDateTime
             , CarInfoId Integer, CarInfoName TVarChar, CarComment TVarChar 
             , ToId Integer, ToCode Integer, ToName TVarChar
             , Amount TFloat
             , AmountSh TFloat
             , AmountWeight TFloat
             , CountPartner TFloat
             )  

AS
$BODY$
   DECLARE vbUserId Integer; 

BEGIN


     RETURN QUERY
     WITH 
       tmpMovementAll AS (SELECT Movement.*
                               , MovementLinkObject_To.ObjectId AS ToId
                        FROM Movement
                            INNER JOIN MovementLinkObject AS MovementLinkObject_To
                                                          ON MovementLinkObject_To.MovementId = Movement.Id
                                                         AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                                                         AND (COALESCE (MovementLinkObject_To.ObjectId,0) = inToId OR inToId = 0)
                        WHERE Movement.OperDate = inOperDate
                          AND Movement.StatusId = zc_Enum_Status_Complete()
                          AND Movement.DescId = zc_Movement_OrderExternal()
                          )

     , tmpMovement AS (SELECT Movement.OperDate
                            , MovementDate_OperDatePartner.ValueData                   AS OperDatePartner
                            , Movement.ToId                                            AS ToId
                            , MovementLinkObject_Route.ObjectId                        AS RouteId
                            , CASE WHEN Object_From.DescId = zc_Object_Unit()
                                        THEN Object_From.Id
                                   -- временно
                                   WHEN Object_Route.ValueData ILIKE 'Маршрут №%'
                                     OR Object_Route.ValueData ILIKE 'Самов%'
                                           THEN 0
                                   ELSE ObjectLink_Juridical_Retail.ChildObjectId
                              END AS RetailId
                            , STRING_AGG (DISTINCT Object_PartnerTag.ValueData, '; ') ::TVarChar AS PartnerTagName
                            , MovementLinkObject_CarInfo.ObjectId                      AS CarInfoId
                            , MovementDate_CarInfo.ValueData               ::TDateTime AS OperDate_CarInfo 
                            , MovementString_CarComment.ValueData          ::TVarChar  AS CarComment
                            
                            --, SUM (COALESCE (MovementItem.Amount,0))                   AS Amount
                            --, SUM (COALESCE (MIFloat_AmountSecond.ValueData, 0) )      AS AmountSecond
                            , SUM (COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0)) AS Amount
                            , SUM (CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0) ELSE 0 END) AS AmountSh
                            , SUM ((COALESCE (MovementItem.Amount,0) + COALESCE (MIFloat_AmountSecond.ValueData, 0))
                                   * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) AS AmountWeight
                            , COUNT (DISTINCT Object_From.Id) AS CountPartner

                       FROM tmpMovementAll AS Movement
                            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

                            LEFT JOIN MovementDate AS MovementDate_CarInfo
                                                   ON MovementDate_CarInfo.MovementId = Movement.Id
                                                  AND MovementDate_CarInfo.DescId = zc_MovementDate_CarInfo()

                            LEFT JOIN MovementString AS MovementString_CarComment
                                                     ON MovementString_CarComment.MovementId = Movement.Id
                                                    AND MovementString_CarComment.DescId = zc_MovementString_CarComment()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_CarInfo
                                                         ON MovementLinkObject_CarInfo.MovementId = Movement.Id
                                                        AND MovementLinkObject_CarInfo.DescId = zc_MovementLinkObject_CarInfo()

                            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                            LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
                            LEFT JOIN MovementLinkObject AS MovementLinkObject_Route
                                                         ON MovementLinkObject_Route.MovementId = Movement.Id
                                                        AND MovementLinkObject_Route.DescId = zc_MovementLinkObject_Route()
                            LEFT JOIN Object AS Object_Route ON Object_Route.Id = MovementLinkObject_Route.ObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Partner_PartnerTag
                                                 ON ObjectLink_Partner_PartnerTag.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_Partner_PartnerTag.DescId = zc_ObjectLink_Partner_PartnerTag()
                            LEFT JOIN Object AS Object_PartnerTag ON Object_PartnerTag.Id = ObjectLink_Partner_PartnerTag.ChildObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementLinkObject_From.ObjectId
                                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
                            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                                 ON ObjectLink_Juridical_Retail.ObjectId = ObjectLink_Partner_Juridical.ChildObjectId
                                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
  
                            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                   AND MovementItem.DescId     = zc_MI_Master()
                                                   AND MovementItem.isErased   = FALSE
                 
                            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond() 

                            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                                  ON ObjectFloat_Weight.ObjectId = MovementItem.ObjectId
                                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

                        GROUP BY Movement.OperDate
                               , MovementDate_OperDatePartner.ValueData
                               , Movement.ToId
                               , MovementLinkObject_Route.ObjectId
                               , CASE WHEN Object_From.DescId = zc_Object_Unit()
                                           THEN Object_From.Id
                                      -- временно
                                      WHEN Object_Route.ValueData ILIKE 'Маршрут №%'
                                        OR Object_Route.ValueData ILIKE 'Самов%'
                                           THEN 0
                                      ELSE ObjectLink_Juridical_Retail.ChildObjectId
                                 END
                               , MovementLinkObject_CarInfo.ObjectId
                               , MovementDate_CarInfo.ValueData
                               , MovementString_CarComment.ValueData
                          )

 
       -- Результат
       SELECT
             tmpMovement.OperDate              AS OperDate
           , tmpMovement.OperDatePartner       AS OperDatePartner
           , Object_Route.Id                   AS RouteId 
           , Object_Route.ValueData            AS RouteName
           , Object_Retail.Id                  AS RetailId
           , Object_Retail.ValueData           AS RetailName
           , tmpMovement.PartnerTagName        AS PartnerTagName
           , tmpMovement.OperDate_CarInfo      ::TDateTime
           , Object_CarInfo.Id                 AS CarInfoId
           , Object_CarInfo.ValueData          AS CarInfoName
           , tmpMovement.CarComment ::TVarChar AS CarComment
           , Object_To.Id                      AS ToId
           , Object_To.ObjectCode              AS ToCode
           , Object_To.ValueData               AS ToName
          --
           , tmpMovement.Amount         :: TFloat AS Amount 
           , tmpMovement.AmountSh       :: TFloat AS AmountSh
           , tmpMovement.AmountWeight   :: TFloat AS AmountWeight
           , tmpMovement.CountPartner   :: TFloat AS CountPartner

      FROM tmpMovement
          LEFT JOIN Object AS Object_To ON Object_To.Id = tmpMovement.ToId
          LEFT JOIN Object AS Object_Route ON Object_Route.Id = tmpMovement.RouteId
          LEFT JOIN Object AS Object_CarInfo ON Object_CarInfo.Id = tmpMovement.CarInfoId
          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = tmpMovement.RetailId
         ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.06.22         *
*/

-- тест
-- SELECT * FROM gpReport_OrderExternal_Update(inOperDate := ('15.06.2022')::TDateTime , inToId := 346093 ,  inSession := '9457');
