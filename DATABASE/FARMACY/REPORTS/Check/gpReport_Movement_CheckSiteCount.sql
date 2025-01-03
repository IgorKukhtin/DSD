-- Function: gpReport_Movement_CheckSiteCount()

DROP FUNCTION IF EXISTS gpReport_Movement_CheckSiteCount (TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_Movement_CheckSiteCount(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inSession       TVarChar    -- ������ ������������
)
RETURNS TABLE (CheckSourceKindName TVarChar
             , CountPrev Integer
             , SummPrev TFloat
             , DeliveryCheckPrev Integer
             , DeliveryCountPrev Integer
             , DeliverySummPrev TFloat
             , DeliveryPayCheckPrev Integer
             , DeliveryPayCountPrev Integer
             , DeliveryPaySummPrev TFloat
             , DeliveryPaySummDeliveryPrev TFloat
             , CountCurr Integer
             , SummCurr TFloat
             , DeliveryCheckCurr Integer
             , DeliveryCountCurr Integer
             , DeliverySummCurr TFloat
             , DeliveryPayCheckCurr Integer
             , DeliveryPayCountCurr Integer
             , DeliveryPaySummCurr TFloat
             , DeliveryPaySummDeliveryCurr TFloat
             , CountDiff TFloat
             , SummDiff TFloat
             
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStartDate TDateTime;
   DECLARE vbEndDate TDateTime;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);
     
     IF DATE_TRUNC ('DAY', inStartDate) + INTERVAL '1 MONTH' = DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY' 
     THEN
       vbEndDate := inStartDate - INTERVAL '1 DAY';
       vbStartDate := DATE_TRUNC ('MONTH', vbEndDate);     
     ELSE
       vbEndDate := inStartDate - INTERVAL '1 DAY';
       vbStartDate := vbEndDate - ((inEndDate::Date - inStartDate::Date)::TVarChar||' day')::Interval;
     END IF;

     raise notice 'Value 0: %', CLOCK_TIMESTAMP();     

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('Movement_CheckAll'))
     THEN
       DROP TABLE Movement_CheckAll;
     END IF;
              
     CREATE TEMP TABLE Movement_CheckAll ON COMMIT DROP AS 
        SELECT Movement.Id
             , Movement.OperDate 
             , Movement.StatusId
        FROM Movement

             INNER JOIN MovementBoolean AS MovementBoolean_Deferred
                                        ON MovementBoolean_Deferred.MovementId = Movement.Id
                                       AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
                                       AND MovementBoolean_Deferred.ValueData = TRUE
                                                                                
        WHERE Movement.OperDate >= DATE_TRUNC ('DAY', vbStartDate) - INTERVAL '10 DAY' 
          AND Movement.OperDate <= DATE_TRUNC ('DAY', inEndDate) + INTERVAL '10 DAY' 
          AND Movement.DescId = zc_Movement_Check()
          AND Movement.StatusId <> zc_Enum_Status_Erased();     
          
     ANALYSE Movement_CheckAll;

     raise notice 'Value 1: %', CLOCK_TIMESTAMP();     

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('Movement_Check'))
     THEN
       DROP TABLE Movement_Check;
     END IF;
              
     CREATE TEMP TABLE Movement_Check ON COMMIT DROP AS 
        SELECT Movement.Id
             , Movement.OperDate 
             , MovementLinkObject_Unit.ObjectId                    AS UnitId
        FROM Movement_CheckAll AS Movement

             INNER JOIN MovementLinkObject AS MovementLinkObject_ConfirmedKind
                                           ON MovementLinkObject_ConfirmedKind.MovementId = Movement.Id
                                          AND MovementLinkObject_ConfirmedKind.DescId = zc_MovementLinkObject_ConfirmedKind()
                                          AND MovementLinkObject_ConfirmedKind.ObjectId = zc_Enum_ConfirmedKind_Complete()

             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                          ON MovementLinkObject_Unit.MovementId = Movement.Id
                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                                                                                
        WHERE (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.OperDate < '01.12.2022');     
          
     ANALYSE Movement_Check;
     
     raise notice 'Value 2: %', CLOCK_TIMESTAMP();

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMovement'))
     THEN
       DROP TABLE tmpMovement;
     END IF;
     
     CREATE TEMP TABLE tmpMovement ON COMMIT DROP AS 
     
      SELECT Movement_Check.Id                                       AS Id
           , Movement_Check.OperDate                                 AS OperDate
           , COALESCE(Object_CheckSourceKind.ValueData, 
             CASE WHEN COALESCE(MovementBoolean_MobileApplication.ValueData, False) = False 
                  THEN '�� �����' ELSE '���. ����������' END)  AS CheckSourceKindName
           , MovementFloat_TotalCount.ValueData                      AS TotalCount
           , MovementFloat_TotalSumm.ValueData                       AS TotalSumm
           , COALESCE(MovementBoolean_DeliverySite.ValueData, False) AS isDeliverySite
           , MovementFloat_SummaDelivery.ValueData                   AS SummaDelivery
           , COALESCE(MovementBoolean_MobileApplication.ValueData, False)::Boolean   AS isMobileApplication
      FROM Movement_Check

           LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                   ON MovementFloat_TotalCount.MovementId = Movement_Check.Id
                                  AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

           LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                   ON MovementFloat_TotalSumm.MovementId =  Movement_Check.Id
                                  AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

           LEFT JOIN MovementString AS MovementString_InvNumberOrder
                                    ON MovementString_InvNumberOrder.MovementId = Movement_Check.Id
                                   AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder()


          LEFT JOIN MovementLinkObject AS MovementLinkObject_CheckSourceKind
                                       ON MovementLinkObject_CheckSourceKind.MovementId =  Movement_Check.Id
                                      AND MovementLinkObject_CheckSourceKind.DescId = zc_MovementLinkObject_CheckSourceKind()
                                                            
          LEFT JOIN MovementDate AS MovementDate_Insert
                                 ON MovementDate_Insert.MovementId = Movement_Check.Id
                                AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
                                                            
          LEFT JOIN MovementBoolean AS MovementBoolean_DeliverySite
                                    ON MovementBoolean_DeliverySite.MovementId = Movement_Check.Id
                                   AND MovementBoolean_DeliverySite.DescId = zc_MovementBoolean_DeliverySite()

          LEFT JOIN MovementFloat AS MovementFloat_SummaDelivery
                                  ON MovementFloat_SummaDelivery.MovementId =  Movement_Check.Id
                                 AND MovementFloat_SummaDelivery.DescId = zc_MovementFloat_SummaDelivery()

          LEFT JOIN MovementBoolean AS MovementBoolean_MobileApplication
                                    ON MovementBoolean_MobileApplication.MovementId = Movement_Check.Id
                                   AND MovementBoolean_MobileApplication.DescId = zc_MovementBoolean_MobileApplication()

          LEFT JOIN Object AS Object_CheckSourceKind ON Object_CheckSourceKind.Id = MovementLinkObject_CheckSourceKind.ObjectId
      WHERE COALESCE (MovementLinkObject_CheckSourceKind.ObjectId, 0) <> 0
         OR COALESCE (MovementString_InvNumberOrder.ValueData, '') <> '';
                            
     ANALYZE tmpMovement;

     raise notice 'Value 3: %', CLOCK_TIMESTAMP();     

     IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.tables WHERE TABLE_NAME = LOWER ('tmpMovementProtocol'))
     THEN
       DROP TABLE tmpMovementProtocol;
     END IF;
     
     CREATE TEMP TABLE tmpMovementProtocol ON COMMIT DROP AS 
      SELECT MovementProtocol.MovementId     AS Id
           , MIN(MovementProtocol.OperDate)  AS OperDate
      FROM MovementProtocol 
      WHERE MovementProtocol.OperDate >= DATE_TRUNC ('DAY', vbStartDate) - INTERVAL '10 DAY' 
        AND MovementProtocol.OperDate <= DATE_TRUNC ('DAY', inEndDate) + INTERVAL '10 DAY' 
        AND MovementProtocol.OperDate <= '01.12.2022'
      GROUP BY MovementProtocol.MovementId;
                        
     ANALYZE tmpMovementProtocol;

     raise notice 'Value 4: %', CLOCK_TIMESTAMP();     
                        
     -- ���������
     RETURN QUERY
     WITH
          tmpMovementCurr AS (SELECT Movement.CheckSourceKindName
                                   , Movement.isMobileApplication
                                   , Count(*)                    AS CountCheck
                                   , Sum(Movement.TotalCount)    AS TotalCount
                                   , Sum(Movement.TotalSumm)     AS TotalSumm
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) = 0 
                                              THEN 1 ELSE 0 END)               AS TotalDeliveryCheck
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) = 0 
                                              THEN Movement.TotalCount END)    AS TotalDeliveryCount
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) = 0  
                                              THEN Movement.TotalSumm END)     AS TotalDeliverySumm
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) <> 0 
                                              THEN 1 ELSE 0 END)               AS TotalDeliveryPayCheck
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) <> 0 
                                              THEN Movement.TotalCount END)    AS TotalDeliveryPayCount
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) <> 0  
                                              THEN Movement.TotalSumm END)     AS TotalDeliveryPaySumm
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) <> 0  
                                              THEN Movement.SummaDelivery END) AS TotalDeliveryPaySummDelivery
                              FROM tmpMovement AS Movement
                              
                                   LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.Id = Movement.Id
                              
                              WHERE tmpMovementProtocol.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                AND tmpMovementProtocol.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY' AND Movement.OperDate < '01.12.2022'
                                 OR Movement.OperDate >= DATE_TRUNC ('DAY', inStartDate)
                                AND Movement.OperDate < DATE_TRUNC ('DAY', inEndDate) + INTERVAL '1 DAY' AND Movement.OperDate >= '01.12.2022'
                              GROUP BY Movement.CheckSourceKindName, Movement.isMobileApplication) 
        , tmpMovementPrev AS (SELECT Movement.CheckSourceKindName
                                   , Movement.isMobileApplication
                                   , Count(*)                    AS CountCheck
                                   , Sum(Movement.TotalCount)    AS TotalCount
                                   , Sum(Movement.TotalSumm)     AS TotalSumm
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) = 0 
                                              THEN 1 ELSE 0 END)               AS TotalDeliveryCheck
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) = 0 
                                              THEN Movement.TotalCount END)    AS TotalDeliveryCount
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) = 0  
                                              THEN Movement.TotalSumm END)     AS TotalDeliverySumm
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) <> 0 
                                              THEN 1 ELSE 0 END)               AS TotalDeliveryPayCheck
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) <> 0 
                                              THEN Movement.TotalCount END)    AS TotalDeliveryPayCount
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) <> 0  
                                              THEN Movement.TotalSumm END)     AS TotalDeliveryPaySumm
                                   , Sum(CASE WHEN COALESCE(Movement.isDeliverySite) = TRUE AND COALESCE(Movement.SummaDelivery, 0) <> 0  
                                              THEN Movement.SummaDelivery END) AS TotalDeliveryPaySummDelivery
                              FROM tmpMovement AS Movement

                                   LEFT JOIN tmpMovementProtocol ON tmpMovementProtocol.Id = Movement.Id

                              WHERE tmpMovementProtocol.OperDate >=  DATE_TRUNC ('DAY', vbStartDate) 
                                AND tmpMovementProtocol.OperDate <  DATE_TRUNC ('DAY', vbEndDate) + INTERVAL '1 DAY' AND Movement.OperDate < '01.12.2022'
                                 OR Movement.OperDate >=  DATE_TRUNC ('DAY', vbStartDate)
                                AND Movement.OperDate <  DATE_TRUNC ('DAY', vbEndDate) + INTERVAL '1 DAY' AND Movement.OperDate >= '01.12.2022'
                              GROUP BY Movement.CheckSourceKindName, Movement.isMobileApplication) 

        SELECT COALESCE(Movement.CheckSourceKindName, tmpMovementPrev.CheckSourceKindName)::TVarChar
             , tmpMovementPrev.CountCheck::Integer
             , tmpMovementPrev.TotalSumm::TFloat   
             , tmpMovementPrev.TotalDeliveryCheck::Integer   
             , tmpMovementPrev.TotalDeliveryCount::Integer
             , tmpMovementPrev.TotalDeliverySumm::TFloat 
             , tmpMovementPrev.TotalDeliveryPayCheck::Integer   
             , tmpMovementPrev.TotalDeliveryPayCount::Integer
             , tmpMovementPrev.TotalDeliveryPaySumm::TFloat 
             , tmpMovementPrev.TotalDeliveryPaySummDelivery::TFloat 
             , Movement.CountCheck::Integer   
             , Movement.TotalSumm::TFloat  
             , Movement.TotalDeliveryCheck::Integer   
             , Movement.TotalDeliveryCount::Integer
             , Movement.TotalDeliverySumm::TFloat 
             , Movement.TotalDeliveryPayCheck::Integer   
             , Movement.TotalDeliveryPayCount::Integer
             , Movement.TotalDeliveryPaySumm::TFloat 
             , Movement.TotalDeliveryPaySummDelivery::TFloat 
             , CASE WHEN COALESCE(Movement.CountCheck, 0) = 0 THEN 0 ELSE Movement.CountCheck:: TFloat / tmpMovementPrev.CountCheck:: TFloat * 100 - 100 END :: TFloat
             , CASE WHEN COALESCE(Movement.TotalSumm, 0) = 0 THEN 0 ELSE Movement.TotalSumm / tmpMovementPrev.TotalSumm * 100 - 100 END :: TFloat

        FROM tmpMovementCurr AS Movement
        
             FULL JOIN tmpMovementPrev ON Movement.CheckSourceKindName = tmpMovementPrev.CheckSourceKindName
        
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpSelect_Movement_Check (TDateTime, TDateTime, Boolean, Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 17.06.21                                                       * 
*/

-- ����

--select * from gpReport_Movement_CheckSiteCount(inStartDate := ('16.06.2021')::TDateTime , inEndDate := ('16.06.2021')::TDateTime , inSession := '3');

--

select * FROM gpReport_Movement_CheckSiteCount(inStartDate := DATE_TRUNC ('month', DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY') , inEndDate := DATE_TRUNC ('month', CURRENT_DATE) - INTERVAL '1 DAY', inSession := '3');     
