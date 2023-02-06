-- Function: gpReport_Check_TabletkiRecreate()

DROP FUNCTION IF EXISTS gpReport_Check_TabletkiRecreate (TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Check_TabletkiRecreate(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inUnitId        Integer,    -- Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, UnitName TVarChar, UserName TVarChar,
               TotalCount TFloat, TotalSumm TFloat,
               GoodsList TVarChar,
               IdCreate Integer, InvNumberCreate TVarChar, OperDateCreate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     raise notice 'Value 1: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMov ON COMMIT DROP AS 
     SELECT Movement.*
          , MovementLinkObject_Unit.ObjectId AS UnitId
          , MLO_Insert.ObjectId              AS UserId
          , COALESCE(MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0  AS isTabletki
     FROM Movement
          INNER JOIN MovementLinkObject AS MovementLinkObject_Unit
                                        ON MovementLinkObject_Unit.MovementId = Movement.Id
                                       AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                       AND (MovementLinkObject_Unit.ObjectId = inUnitId OR COALESCE(inUnitId, 0) = 0)
          LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                       ON MovementLinkObject_CheckSourceKind.MovementId = Movement.Id
                                      AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                                      AND MovementLinkObject_CheckSourceKind.ObjectId = zc_Enum_CheckSourceKind_Tabletki()  
          LEFT JOIN MovementLinkObject AS MLO_Insert
                                       ON MLO_Insert.MovementId = Movement.Id
                                      AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
                                   
     WHERE Movement.DescId = zc_Movement_Check()
       AND (Movement.StatusId = zc_Enum_Status_Complete() AND COALESCE(MovementLinkObject_CheckSourceKind.ObjectId, 0) = 0 OR
            Movement.StatusId = zc_Enum_Status_Erased() AND COALESCE(MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0)
       AND Movement.OperDate >= inStartDate
       AND Movement.OperDate < inEndDate + INTERVAL '1 DAY';
        
     ANALYSE tmpMov;
     
     raise notice 'Value 2: %', CLOCK_TIMESTAMP();
     
     CREATE TEMP TABLE tmpMIAll ON COMMIT DROP AS 
      SELECT DISTINCT MovementItem.MovementID               AS ID
                    , date_trunc('DAY', Movement.OperDate)  AS OperDate
                    , Movement.UnitId
                    , Movement.UserId
                    , Movement.isTabletki   
                    , MovementItem.ObjectId
                    , MovementItem.DescId
                    , MovementItem.isErased
               FROM tmpMov AS Movement

                    INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                            /*                            */
               ;
        
     ANALYSE tmpMIAll;


     raise notice 'Value 21: %', CLOCK_TIMESTAMP();

     CREATE TEMP TABLE tmpMI ON COMMIT DROP AS 
       SELECT MovementItem.ID
            , MovementItem.OperDate
            , MovementItem.UnitId
            , MovementItem.UserId
            , MovementItem.isTabletki   
            , string_agg(MovementItem.ObjectId::TVarChar, ',' ORDER BY MovementItem.ObjectId)::TVarChar AS GoodsList
       FROM tmpMIAll AS MovementItem
       WHERE MovementItem.DescId = zc_MI_Master()
         AND MovementItem.isErased = FALSE
       GROUP BY MovementItem.ID
              , MovementItem.OperDate
              , MovementItem.UnitId
              , MovementItem.UserId
              , MovementItem.isTabletki;
        
     ANALYSE tmpMI;
     
     raise notice 'Value 3: %', CLOCK_TIMESTAMP();
     
     CREATE TEMP TABLE tmpMovementProtocol ON COMMIT DROP AS 
      (SELECT MovementProtocol.MovementId
            , MovementProtocol.OperDate
            , MovementProtocol.UserId
            , ROW_NUMBER() OVER (Partition BY MovementProtocol.MovementId ORDER BY MovementProtocol.OperDate) AS ord
       FROM tmpMov AS Movement

            INNER JOIN MovementProtocol ON MovementProtocol.MovementId = Movement.ID
                                       AND COALESCE(MovementProtocol.UserId, 0) <> 0
                                       AND MovementProtocol.ProtocolData ILIKE '%Статус" FieldValue = "Удален%'
                                       
       WHERE Movement.isTabletki = True);
                                                                 
     ANALYSE tmpMovementProtocol;
     
     
     raise notice 'Value 4: %', CLOCK_TIMESTAMP();

     -- Результат
     RETURN QUERY
         SELECT       
             Movement_Check.Id
           , Movement_Check.InvNumber
           , Movement_Check.OperDate
           , Object_Unit.ValueData                              AS UnitName
           , Object_User.ValueData                              AS UserName
           , MovementFloat_TotalCount.ValueData                 AS TotalCount
           , MovementFloat_TotalSumm.ValueData                  AS TotalSumm
           , MITabletki.GoodsList                               AS GoodsList
           , tmpMov.Id
           , tmpMov.InvNumber
           , tmpMov.OperDate
        FROM tmpMov AS Movement_Check 
        
             INNER JOIN tmpMI AS MITabletki 
                              ON MITabletki.ID = Movement_Check.Id
                              
             INNER JOIN tmpMovementProtocol ON tmpMovementProtocol.MovementId = Movement_Check.Id
                                           AND tmpMovementProtocol.Ord = 1

             LEFT JOIN Object AS Object_User ON Object_User.Id = tmpMovementProtocol.UserId
              
             INNER JOIN tmpMI AS MI
                              ON MI.isTabletki = False
                             AND MI.GoodsList  = MITabletki.GoodsList 
                             AND MI.UnitId     = MITabletki.UnitId 
                             AND MI.UserId     = tmpMovementProtocol.UserId
                             
             LEFT JOIN tmpMov ON tmpMov.ID = MI.Id

             LEFT JOIN Object AS Object_Unit ON Object_Unit.ID = Movement_Check.UnitId

             LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                     ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                    AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
 
             LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                     ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                    AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
                                  
        WHERE Movement_Check.StatusId = zc_Enum_Status_Erased()
          AND Movement_Check.isTabletki = True
          AND date_trunc('DAY', tmpMovementProtocol.OperDate) = date_trunc('DAY', MI.OperDate)

      ;

         
END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpReport_Check_TabletkiRecreate (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
              Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Шаблий О.В.
 04.05.2                                                        * 
*/            

-- 
select * from gpReport_Check_TabletkiRecreate (('01.02.2023')::TDateTime , ('03.02.2023')::TDateTime, 0, '3');