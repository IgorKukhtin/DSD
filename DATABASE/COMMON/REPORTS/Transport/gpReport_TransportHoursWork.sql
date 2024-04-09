-- Function: gpReport_TransportHoursWork()

-- DROP FUNCTION IF EXISTS gpReport_MovementTransport (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_TransportHoursWork (TDateTime, TDateTime, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_TransportHoursWork (TDateTime, TDateTime, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TransportHoursWork(
    IN inStartDate    TDateTime , -- 
    IN inEndDate      TDateTime , --
    IN inPersonalId   Integer   , -- водитель
    IN inBranchId     Integer   , -- филиал
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS TABLE (PersonalDriverName TVarChar
             , BranchName TVarChar
             , RouteName TVarChar
             , RouteKindName TVarChar
             , RouteKindFreightName TVarChar
             , Weight TFloat, HoursWork TFloat, HoursAdd TFloat
             , MovementId Integer, InvNumber Integer, OperDate TDateTime
             , Count_Movement  TFloat
             , TotalCountKg    TFloat
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Report_Transport());
     vbUserId:= lpGetUserBySession (inSession);
     
      -- !!!Только просмотр Аудитор!!!
      PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

      RETURN QUERY 
         WITH tmpPersonal AS (SELECT PersonalId
                              FROM Object_Personal_View
                              WHERE COALESCE (inPersonalId, 0) = 0
                             UNION
                              SELECT COALESCE (inPersonalId, 0) AS PersonalId
                             )
            , tmpMovement AS (SELECT Movement.Id, Movement.OperDate, Movement.InvNumber
                              FROM Movement
                              WHERE Movement.DescId = zc_Movement_Transport()
                                AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                              )

            , tmpReestr AS (SELECT tmpMovement.Id                     AS MovementId_Transport
                                 , COUNT (DISTINCT Movement_Sale.Id)  AS Count_Movement
                                 , SUM (COALESCE (MovementFloat_TotalCountKg.ValueData, 0)) AS TotalCountKg 
                            FROM tmpMovement
                                 -- привязка документа реестра
                                 INNER JOIN MovementLinkMovement AS MovementLinkMovement_Transport
                                                                 ON MovementLinkMovement_Transport.MovementChildId = tmpMovement.Id
                                                                AND MovementLinkMovement_Transport.DescId = zc_MovementLinkMovement_Transport()

                                 INNER JOIN Movement AS Movement_Reestr 
                                                     ON Movement_Reestr.Id = MovementLinkMovement_Transport.MovementId
                                                    AND Movement_Reestr.DescId = zc_Movement_Reestr()
                                                    AND Movement_Reestr.StatusId <> zc_Enum_Status_Erased()
                     
                                 -- строчная часть реестра
                                 INNER JOIN MovementItem ON MovementItem.MovementId = Movement_Reestr.Id
                                 -- док. продажи
                                 INNER JOIN MovementFloat AS MovementFloat_MovementItemId
                                                          ON MovementFloat_MovementItemId.ValueData ::integer = MovementItem.Id -- tmpMI.MovementItemId
                                                         AND MovementFloat_MovementItemId.DescId = zc_MovementFloat_MovementItemId()
                                 INNER JOIN Movement AS Movement_Sale 
                                                     ON Movement_Sale.Id = MovementFloat_MovementItemId.MovementId
                                                    AND Movement_Sale.StatusId <> zc_Enum_Status_Erased()
                     
                                 LEFT JOIN MovementFloat AS MovementFloat_TotalCountKg
                                                         ON MovementFloat_TotalCountKg.MovementId = Movement_Sale.Id
                                                        AND MovementFloat_TotalCountKg.DescId = zc_MovementFloat_TotalCountKg()
                            GROUP BY tmpMovement.Id
                            )

        --- результат
        SELECT View_PersonalDriver.PersonalName AS PersonalDriverName
   	     , ViewObject_Unit.BranchName  AS BranchName
             , Object_Route.ValueData      AS RouteName
             , Object_RouteKind.ValueData  AS RouteKindName
             , Object_RouteKindFreight.ValueData AS RouteKindFreightName

             , (CASE WHEN tmpMovementAll.DescId_Personal = zc_MovementLinkObject_PersonalDriver() THEN tmpMI.Weight ELSE 0 END) :: TFloat AS Weight
            
             , (COALESCE (MovementFloat_HoursWork.ValueData, 0) + COALESCE (MovementFloat_HoursAdd.ValueData, 0)) :: TFloat AS HoursWork
             , MovementFloat_HoursAdd.ValueData      AS HoursAdd

             , tmpMovementAll.Id                                   AS MovementId
             , zfConvert_StringToNumber (tmpMovementAll.InvNumber) AS InvNumber
             , tmpMovementAll.OperDate
             
             , COALESCE (tmpReestr.Count_Movement, 0) :: TFloat AS Count_Movement
             , COALESCE (tmpReestr.TotalCountKg, 0)   :: TFloat AS TotalCountKg

        FROM (SELECT tmpMovement.Id, tmpMovement.OperDate, tmpMovement.InvNumber, MovementLinkObject_PersonalDriver.DescId AS DescId_Personal, MovementLinkObject_PersonalDriver.ObjectId AS PersonalId
              FROM tmpMovement
                   LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalDriver ON MovementLinkObject_PersonalDriver.MovementId = tmpMovement.Id
                                                                                    AND MovementLinkObject_PersonalDriver.DescId = zc_MovementLinkObject_PersonalDriver()
                   -- JOIN tmpPersonal ON tmpPersonal.PersonalId = MovementLinkObject_PersonalDriver.ObjectId
             UNION ALL
              SELECT tmpMovement.Id, tmpMovement.OperDate, tmpMovement.InvNumber, MovementLinkObject_PersonalDriverMore.DescId AS DescId_Personal, MovementLinkObject_PersonalDriverMore.ObjectId AS PersonalId
              FROM tmpMovement
                   JOIN MovementLinkObject AS MovementLinkObject_PersonalDriverMore ON MovementLinkObject_PersonalDriverMore.MovementId = tmpMovement.Id
                                                                                   AND MovementLinkObject_PersonalDriverMore.DescId = zc_MovementLinkObject_PersonalDriverMore()
                                                                                   AND MovementLinkObject_PersonalDriverMore.ObjectId > 0
                   -- JOIN tmpPersonal ON tmpPersonal.PersonalId = MovementLinkObject_PersonalDriverMore.ObjectId
             ) AS tmpMovementAll

             LEFT JOIN (SELECT MIN (MovementItem.Id) AS MovementItemId
                             , SUM (MIFloat_Weight.ValueData) AS Weight
                             , MovementItem.MovementId
                        FROM tmpMovement
                             JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                              AND MovementItem.DescId = zc_MI_Master()
                                              AND MovementItem.isErased = FALSE
                             LEFT JOIN MovementItemFloat AS MIFloat_Weight ON MIFloat_Weight.MovementItemId = MovementItem.Id
                                                                          AND MIFloat_Weight.DescId = zc_MIFloat_Weight()
                        GROUP BY MovementItem.MovementId
                        ) AS tmpMI ON tmpMI.MovementId = tmpMovementAll.Id 

              LEFT JOIN MovementItem AS MI ON MI.Id = tmpMI.MovementItemId
              LEFT JOIN Object AS Object_Route ON Object_Route.Id = MI.ObjectId      
                  
              LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKind ON MILinkObject_RouteKind.MovementItemId = tmpMI.MovementItemId
                                                                        AND MILinkObject_RouteKind.DescId = zc_MILinkObject_RouteKind()
              LEFT JOIN Object AS Object_RouteKind ON Object_RouteKind.Id = MILinkObject_RouteKind.ObjectId

              LEFT JOIN MovementItemLinkObject AS MILinkObject_RouteKindFreight ON MILinkObject_RouteKindFreight.MovementItemId = tmpMI.MovementItemId
                                                                               AND MILinkObject_RouteKindFreight.DescId = zc_MILinkObject_RouteKindFreight()
              LEFT JOIN Object AS Object_RouteKindFreight ON Object_RouteKindFreight.Id = MILinkObject_RouteKindFreight.ObjectId
              

              LEFT JOIN Object_Personal_View AS View_PersonalDriver ON View_PersonalDriver.PersonalId = tmpMovementAll.PersonalId
              
              LEFT JOIN MovementFloat AS MovementFloat_HoursWork ON MovementFloat_HoursWork.MovementId =  tmpMovementAll.Id
                                                                AND MovementFloat_HoursWork.DescId = zc_MovementFloat_HoursWork()

              LEFT JOIN MovementFloat AS MovementFloat_HoursAdd ON MovementFloat_HoursAdd.MovementId =  tmpMovementAll.Id
                                                               AND MovementFloat_HoursAdd.DescId = zc_MovementFloat_HoursAdd()
              -- ограничиваем по Филиалу
              LEFT JOIN Object_Unit_View AS ViewObject_Unit ON ViewObject_Unit.Id = View_PersonalDriver.UnitId
                                  -- AND (ViewObject_Unit.BranchId = inBranchId OR inBranchId = 0)
              --
              LEFT JOIN tmpReestr ON tmpReestr.MovementId_Transport = tmpMovementAll.Id

        WHERE COALESCE (ViewObject_Unit.BranchId, 0) = inBranchId 
           OR inBranchId = 0 
           OR (inBranchId = zc_Branch_Basis() AND COALESCE (ViewObject_Unit.BranchId, 0) = 0)

;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 18.03.19         *
 10.02.14         * изменение условий ограничения филиала inBranchId 
 16.12.13         * add inBranchId             
 12.11.13                                        * add zc_MovementLinkObject_PersonalDriverMore
 27.10.13         *
*/

-- тест
--  SELECT * FROM gpReport_TransportHoursWork (inStartDate:= '01.01.2019' ::TDateTime, inEndDate:= '10.01.2019' ::TDateTime , inPersonalId:= 0, inBranchId:= 0, inSession:= '2') 
